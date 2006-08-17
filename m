From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] fc transport: add fc_host system_hostname attribute and
	u64_to_wwn()
Date: Thu, 17 Aug 2006 08:00:43 -0400
Message-ID: <1155816043.24351.1.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:4486 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1751233AbWHQMAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 08:00:50 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k7HC0mLa004670
	for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2006 05:00:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch updates the fc transport for the following:

- Addition of a new attribute "system_hostname" which can be
  used to set the fully qualified hostname that the fc_host
  is attached to. The fc_host can then register this string
  as the FDMI-based host name attribute.
  Note: for NPIV, a fc_host could be associated with a system which
    is not the local system.

- Add the inline function u64_to_wwn(), which is the inverse of the
  existing wwn_to_u64() function.

- Slight reorg, just to keep dynamic attributes with each other, etc


Note: This patch assumes that the prior transport patch, which makes
  the symbolic_name attribute dynamic, has been installed:
http://marc.theaimsgroup.com/?l=linux-scsi&m=115555807316329&w=2

-- james s


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2006-08-14 08:13:09.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2006-08-17 07:42:16.000000000 -0400
@@ -301,8 +301,6 @@ static int fc_host_setup(struct transpor
 	fc_host->supported_classes = FC_COS_UNSPECIFIED;
 	memset(fc_host->supported_fc4s, 0,
 		sizeof(fc_host->supported_fc4s));
-	memset(fc_host->symbolic_name, 0,
-		sizeof(fc_host->symbolic_name));
 	fc_host->supported_speeds = FC_PORTSPEED_UNKNOWN;
 	fc_host->maxframe_size = -1;
 	memset(fc_host->serial_number, 0,
@@ -315,6 +313,8 @@ static int fc_host_setup(struct transpor
 		sizeof(fc_host->active_fc4s));
 	fc_host->speed = FC_PORTSPEED_UNKNOWN;
 	fc_host->fabric_name = -1;
+	memset(fc_host->symbolic_name, 0, sizeof(fc_host->symbolic_name));
+	memset(fc_host->system_hostname, 0, sizeof(fc_host->system_hostname));
 
 	fc_host->tgtid_bind_type = FC_TGTID_BIND_BY_WWPN;
 
@@ -688,6 +688,25 @@ store_fc_host_##field(struct class_devic
 	return count;							\
 }
 
+#define fc_host_store_str_function(field, slen)				\
+static ssize_t								\
+store_fc_host_##field(struct class_device *cdev, const char *buf,	\
+			   size_t count)				\
+{									\
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);	\
+	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+	unsigned int cnt=count;						\
+									\
+	/* count may include a LF at end of string */			\
+	if (buf[cnt-1] == '\n')						\
+		cnt--;							\
+	if (cnt > ((slen) - 1))						\
+		return -EINVAL;						\
+	memcpy(fc_host_##field(shost), buf, cnt);			\
+	i->f->set_host_##field(shost);					\
+	return count;							\
+}
+
 #define fc_host_rd_attr(field, format_string, sz)			\
 	fc_host_show_function(field, format_string, sz, )		\
 static FC_CLASS_DEVICE_ATTR(host, field, S_IRUGO,			\
@@ -859,6 +878,12 @@ fc_host_rd_enum_attr(port_state, FC_PORT
 fc_host_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
 fc_host_rd_attr(symbolic_name, "%s\n", FC_SYMBOLIC_NAME_SIZE + 1);
 
+fc_private_host_show_function(system_hostname, "%s\n",
+		FC_SYMBOLIC_NAME_SIZE + 1, )
+fc_host_store_str_function(system_hostname, FC_SYMBOLIC_NAME_SIZE)
+static FC_CLASS_DEVICE_ATTR(host, system_hostname, S_IRUGO | S_IWUSR,
+		show_fc_host_system_hostname, store_fc_host_system_hostname);
+
 
 /* Private Host Attributes */
 
@@ -1234,6 +1259,7 @@ fc_attach_transport(struct fc_function_t
 	SETUP_HOST_ATTRIBUTE_RD(speed);
 	SETUP_HOST_ATTRIBUTE_RD(fabric_name);
 	SETUP_HOST_ATTRIBUTE_RD(symbolic_name);
+	SETUP_HOST_ATTRIBUTE_RW(system_hostname);
 
 	/* Transport-managed attributes */
 	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(tgtid_bind_type);
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2006-08-14 08:13:09.000000000 -0400
+++ b/include/scsi/scsi_transport_fc.h	2006-08-17 07:41:13.000000000 -0400
@@ -312,7 +312,6 @@ struct fc_host_attrs {
 	u64 permanent_port_name;
 	u32 supported_classes;
 	u8  supported_fc4s[FC_FC4_LIST_SIZE];
-	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
 	u32 supported_speeds;
 	u32 maxframe_size;
 	char serial_number[FC_SERIAL_NUMBER_SIZE];
@@ -324,6 +323,8 @@ struct fc_host_attrs {
 	u8  active_fc4s[FC_FC4_LIST_SIZE];
 	u32 speed;
 	u64 fabric_name;
+	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
+	char system_hostname[FC_SYMBOLIC_NAME_SIZE];
 
 	/* Private (Transport-managed) Attributes */
 	enum fc_tgtid_binding_type  tgtid_bind_type;
@@ -354,8 +355,6 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->supported_classes)
 #define fc_host_supported_fc4s(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->supported_fc4s)
-#define fc_host_symbolic_name(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->symbolic_name)
 #define fc_host_supported_speeds(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->supported_speeds)
 #define fc_host_maxframe_size(x)	\
@@ -374,6 +373,10 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->speed)
 #define fc_host_fabric_name(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->fabric_name)
+#define fc_host_symbolic_name(x)	\
+	(((struct fc_host_attrs *)(x)->shost_data)->symbolic_name)
+#define fc_host_system_hostname(x)	\
+	(((struct fc_host_attrs *)(x)->shost_data)->system_hostname)
 #define fc_host_tgtid_bind_type(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->tgtid_bind_type)
 #define fc_host_rports(x) \
@@ -410,6 +413,7 @@ struct fc_function_template {
 	void	(*get_host_speed)(struct Scsi_Host *);
 	void	(*get_host_fabric_name)(struct Scsi_Host *);
 	void	(*get_host_symbolic_name)(struct Scsi_Host *);
+	void	(*set_host_system_hostname)(struct Scsi_Host *);
 
 	struct fc_host_statistics * (*get_fc_host_stats)(struct Scsi_Host *);
 	void	(*reset_fc_host_stats)(struct Scsi_Host *);
@@ -457,6 +461,7 @@ struct fc_function_template {
 	unsigned long	show_host_speed:1;
 	unsigned long	show_host_fabric_name:1;
 	unsigned long	show_host_symbolic_name:1;
+	unsigned long	show_host_system_hostname:1;
 };
 
 
@@ -492,6 +497,25 @@ fc_remote_port_chkready(struct fc_rport 
 	return result;
 }
 
+static inline u64 wwn_to_u64(u8 *wwn)
+{
+	return (u64)wwn[0] << 56 | (u64)wwn[1] << 48 |
+	    (u64)wwn[2] << 40 | (u64)wwn[3] << 32 |
+	    (u64)wwn[4] << 24 | (u64)wwn[5] << 16 |
+	    (u64)wwn[6] <<  8 | (u64)wwn[7];
+}
+
+static inline void u64_to_wwn(u64 inm, u8 *wwn)
+{
+	wwn[0] = (inm >> 56) & 0xff;
+	wwn[1] = (inm >> 48) & 0xff;
+	wwn[2] = (inm >> 40) & 0xff;
+	wwn[3] = (inm >> 32) & 0xff;
+	wwn[4] = (inm >> 24) & 0xff;
+	wwn[5] = (inm >> 16) & 0xff;
+	wwn[6] = (inm >> 8) & 0xff;
+	wwn[7] = inm & 0xff;
+}
 
 struct scsi_transport_template *fc_attach_transport(
 			struct fc_function_template *);
@@ -503,12 +527,4 @@ void fc_remote_port_delete(struct fc_rpo
 void fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles);
 int scsi_is_fc_rport(const struct device *);
 
-static inline u64 wwn_to_u64(u8 *wwn)
-{
-	return (u64)wwn[0] << 56 | (u64)wwn[1] << 48 |
-	    (u64)wwn[2] << 40 | (u64)wwn[3] << 32 |
-	    (u64)wwn[4] << 24 | (u64)wwn[5] << 16 |
-	    (u64)wwn[6] <<  8 | (u64)wwn[7];
-}
-
 #endif /* SCSI_TRANSPORT_FC_H */


