From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/2] zfcp: sysfs attributes for fabric and channel latencies
Date: Tue, 06 May 2008 11:00:06 +0200
Message-ID: <20080506090458.565034000@de.ibm.com>
References: <20080506090004.922666000@de.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:47868 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764432AbYEFJFX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2008 05:05:23 -0400
Content-Disposition: inline; filename=latencies-2.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

The latency information is provided on a SCSI device level (LUN)
which can be found at the following location

=C2=A0/sys/class/scsi_device/<H:C:T:L>/device/cmd_latency
=C2=A0/sys/class/scsi_device/<H:C:T:L>/device/read_latency
=C2=A0/sys/class/scsi_device/<H:C:T:L>/device/write_latency

Each sysfs attribute provides the available data: min, max and sum for
fabric and channel latency and the number of requests processed.

An overrun of the variables is neither detected nor treated.  The file
has to be read twice to make a meaningful statement, because only the
differences of the values between the two reads can be used.  A reset
of the values can be achieved by writing to the attribute.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-05-06 10:08:46.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-05-06 10:09:12.000000000 +0200
@@ -778,6 +778,68 @@ struct fc_function_template zfcp_transpo
 	.disable_target_scan =3D 1,
 };
=20
+#define ZFCP_DEFINE_LATENCY_ATTR(_name) 				\
+static ssize_t								\
+zfcp_sysfs_unit_##_name##_latency_show(struct device *dev,		\
+				       struct device_attribute *attr,	\
+				       char *buf) {			\
+	struct scsi_device *sdev =3D to_scsi_device(dev);			\
+	struct zfcp_unit *unit =3D sdev->hostdata;			\
+	struct zfcp_latencies *lat =3D &unit->latencies;			\
+	struct zfcp_adapter *adapter =3D unit->port->adapter;		\
+	unsigned long flags;						\
+	unsigned long long fsum, fmin, fmax, csum, cmin, cmax, cc;	\
+									\
+	spin_lock_irqsave(&lat->lock, flags);				\
+	fsum =3D lat->_name.fabric.sum * adapter->timer_ticks;		\
+	fmin =3D lat->_name.fabric.min * adapter->timer_ticks;		\
+	fmax =3D lat->_name.fabric.max * adapter->timer_ticks;		\
+	csum =3D lat->_name.channel.sum * adapter->timer_ticks;		\
+	cmin =3D lat->_name.channel.min * adapter->timer_ticks;		\
+	cmax =3D lat->_name.channel.max * adapter->timer_ticks;		\
+	cc  =3D lat->_name.counter;					\
+	spin_unlock_irqrestore(&lat->lock, flags);			\
+									\
+	do_div(fsum, 1000);						\
+	do_div(fmin, 1000);						\
+	do_div(fmax, 1000);						\
+	do_div(csum, 1000);						\
+	do_div(cmin, 1000);						\
+	do_div(cmax, 1000);						\
+									\
+	return sprintf(buf, "%llu %llu %llu %llu %llu %llu %llu\n",	\
+		       fmin, fmax, fsum, cmin, cmax, csum, cc); 	\
+}									\
+static ssize_t								\
+zfcp_sysfs_unit_##_name##_latency_store(struct device *dev,		\
+					struct device_attribute *attr,	\
+					const char *buf, size_t count)	\
+{									\
+	struct scsi_device *sdev =3D to_scsi_device(dev);			\
+	struct zfcp_unit *unit =3D sdev->hostdata;			\
+	struct zfcp_latencies *lat =3D &unit->latencies;			\
+	unsigned long flags;						\
+									\
+	spin_lock_irqsave(&lat->lock, flags);				\
+	lat->_name.fabric.sum =3D 0;					\
+	lat->_name.fabric.min =3D 0xFFFFFFFF;				\
+	lat->_name.fabric.max =3D 0;					\
+	lat->_name.channel.sum =3D 0;					\
+	lat->_name.channel.min =3D 0xFFFFFFFF;				\
+	lat->_name.channel.max =3D 0;					\
+	lat->_name.counter =3D 0;						\
+	spin_unlock_irqrestore(&lat->lock, flags);			\
+									\
+	return (ssize_t) count;						\
+}									\
+static DEVICE_ATTR(_name##_latency, S_IWUSR | S_IRUGO,			\
+		   zfcp_sysfs_unit_##_name##_latency_show,		\
+		   zfcp_sysfs_unit_##_name##_latency_store);
+
+ZFCP_DEFINE_LATENCY_ATTR(read);
+ZFCP_DEFINE_LATENCY_ATTR(write);
+ZFCP_DEFINE_LATENCY_ATTR(cmd);
+
 /**
  * ZFCP_DEFINE_SCSI_ATTR
  * @_name:   name of show attribute
@@ -808,6 +870,9 @@ static struct device_attribute *zfcp_sys
 	&dev_attr_fcp_lun,
 	&dev_attr_wwpn,
 	&dev_attr_hba_id,
+	&dev_attr_read_latency,
+	&dev_attr_write_latency,
+	&dev_attr_cmd_latency,
 	NULL
 };
=20

--=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
