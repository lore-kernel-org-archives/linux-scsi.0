From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 11/12] qla2xxx: Add an 'Issue LIP' device attribute.
Date: Thu, 27 Oct 2005 16:03:37 -0700
Message-ID: <20051027230337.GE7889@plap.qlogic.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231724.27191.33356.sendpatchset@plap.qlogic.com> <20051014094843.GB22347@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:40599 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932679AbVJ0XDm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2005 19:03:42 -0400
Content-Disposition: inline
In-Reply-To: <20051014094843.GB22347@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>

On Fri, 14 Oct 2005, Christoph Hellwig wrote:

> On Thu, Oct 13, 2005 at 04:17:24PM -0700, Andrew Vasquez wrote:
> > Subject: Add an 'Issue LIP' device attribute.
> > 
> > Add a scsi_host device attribute to allow a user to initiate
> > a LIP.
> 
> This kind of thing belongs into the transport class so that we have
> a common API over all HBA drivers.

Ok, here's a patch to add such a common API for fc transport users.
Relevant LLD changes (lpfc and qla2xxx) also present.

Reasonable?

--
AV

---

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2cab556..0467422 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -222,7 +222,7 @@ static void fc_rport_terminate(struct fc
  */
 #define FC_STARGET_NUM_ATTRS 	3
 #define FC_RPORT_NUM_ATTRS	9
-#define FC_HOST_NUM_ATTRS	15
+#define FC_HOST_NUM_ATTRS	16
 
 struct fc_internal {
 	struct scsi_transport_template t;
@@ -715,9 +715,11 @@ static FC_CLASS_DEVICE_ATTR(host, field,
 	count++
 
 #define SETUP_PRIVATE_HOST_ATTRIBUTE_RW(field)			\
+{									\
 	i->private_host_attrs[count] = class_device_attr_host_##field;	\
 	i->host_attrs[count] = &i->private_host_attrs[count];		\
-	count++
+	count++;							\
+}
 
 
 /* Fixed Host Attributes */
@@ -848,6 +850,26 @@ static FC_CLASS_DEVICE_ATTR(host, tgtid_
 			show_fc_private_host_tgtid_bind_type,
 			store_fc_private_host_tgtid_bind_type);
 
+static ssize_t
+store_fc_private_host_issue_lip(struct class_device *cdev,
+	const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	int ret;
+
+	/* ignore any data value written to the attribute */
+	if (i->f->issue_fc_host_lip) {
+		ret = i->f->issue_fc_host_lip(shost);
+		return ret ? ret: count;
+	}
+
+	return -ENOENT;
+}
+
+static FC_CLASS_DEVICE_ATTR(host, issue_lip, S_IWUSR, NULL,
+			store_fc_private_host_issue_lip);
+
 /*
  * Host Statistics Management
  */
@@ -1114,6 +1136,8 @@ fc_attach_transport(struct fc_function_t
 
 	/* Transport-managed attributes */
 	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(tgtid_bind_type);
+	if (ft->issue_fc_host_lip)
+		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(issue_lip);
 
 	BUG_ON(count > FC_HOST_NUM_ATTRS);
 
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index b0d4454..4496b32 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -384,6 +384,8 @@ struct fc_function_template {
 	struct fc_host_statistics * (*get_fc_host_stats)(struct Scsi_Host *);
 	void	(*reset_fc_host_stats)(struct Scsi_Host *);
 
+	int	(*issue_fc_host_lip)(struct Scsi_Host *);
+
 	/* allocation lengths for host-specific data */
 	u32	 			dd_fcrport_size;
 
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index acae7c4..445da1d 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -200,19 +200,13 @@ lpfc_num_discovered_ports_show(struct cl
 }
 
 
-static ssize_t
-lpfc_issue_lip (struct class_device *cdev, const char *buf, size_t count)
+static int
+lpfc_issue_lip(struct Scsi_Host *host)
 {
-	struct Scsi_Host *host = class_to_shost(cdev);
 	struct lpfc_hba *phba = (struct lpfc_hba *) host->hostdata[0];
-	int val = 0;
 	LPFC_MBOXQ_t *pmboxq;
 	int mbxstatus = MBXERR_ERROR;
 
-	if ((sscanf(buf, "%d", &val) != 1) ||
-	    (val != 1))
-		return -EINVAL;
-
 	if ((phba->fc_flag & FC_OFFLINE_MODE) ||
 	    (phba->hba_state != LPFC_HBA_READY))
 		return -EPERM;
@@ -234,7 +228,7 @@ lpfc_issue_lip (struct class_device *cde
 	if (mbxstatus == MBXERR_ERROR)
 		return -EIO;
 
-	return strlen(buf);
+	return 0;
 }
 
 static ssize_t
@@ -364,7 +358,6 @@ static CLASS_DEVICE_ATTR(lpfc_drvr_versi
 			 NULL);
 static CLASS_DEVICE_ATTR(management_version, S_IRUGO, management_version_show,
 			 NULL);
-static CLASS_DEVICE_ATTR(issue_lip, S_IWUSR, NULL, lpfc_issue_lip);
 static CLASS_DEVICE_ATTR(board_online, S_IRUGO | S_IWUSR,
 			 lpfc_board_online_show, lpfc_board_online_store);
 
@@ -537,7 +530,6 @@ struct class_device_attribute *lpfc_host
 	&class_device_attr_lpfc_max_luns,
 	&class_device_attr_nport_evt_cnt,
 	&class_device_attr_management_version,
-	&class_device_attr_issue_lip,
 	&class_device_attr_board_online,
 	NULL,
 };
@@ -1234,6 +1226,8 @@ struct fc_function_template lpfc_transpo
 
 	.get_starget_port_name = lpfc_get_starget_port_name,
 	.show_starget_port_name = 1,
+
+	.issue_fc_host_lip = lpfc_issue_lip,
 };
 
 void
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fc25cd8..d921725 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -432,6 +432,15 @@ qla2x00_set_rport_loss_tmo(struct fc_rpo
 	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
 }
 
+static int
+qla2x00_issue_lip(struct Scsi_Host *shost)
+{
+	scsi_qla_host_t *ha = to_qla_host(shost);
+
+	set_bit(LOOP_RESET_NEEDED, &ha->dpc_flags);
+	return 0;
+}
+
 struct fc_function_template qla2xxx_transport_functions = {
 
 	.show_host_node_name = 1,
@@ -455,6 +464,7 @@ struct fc_function_template qla2xxx_tran
 	.set_rport_dev_loss_tmo = qla2x00_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
 
+	.issue_fc_host_lip = qla2x00_issue_lip,
 };
 
 void
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8982978..9d90558 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2186,6 +2186,12 @@ qla2x00_do_dpc(void *data)
 			    ha->host_no));
 		}
 
+		if (test_and_clear_bit(LOOP_RESET_NEEDED, &ha->dpc_flags)) {
+			DEBUG(printk("scsi(%ld): dpc: sched loop_reset()\n",
+			    ha->host_no));
+			qla2x00_loop_reset(ha);
+		}
+
 		if (test_and_clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) &&
 		    (!(test_and_set_bit(RESET_ACTIVE, &ha->dpc_flags)))) {
 
@@ -2487,6 +2493,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	/* Schedule the DPC routine if needed */
 	if ((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) ||
 	    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) ||
+	    test_bit(LOOP_RESET_NEEDED, &ha->dpc_flags) ||
 	    start_dpc ||
 	    test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags) ||
 	    test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) ||
