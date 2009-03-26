From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 14/26] qla2xxx: Add reset capabilities for application
	support.
Date: Thu, 26 Mar 2009 08:49:17 -0700
Message-ID: <20090326154917.GB2547@plap4-2.local>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com> <1237910900-30817-15-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8174 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbZCZPtT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 11:49:19 -0400
Content-Disposition: inline
In-Reply-To: <1237910900-30817-15-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>

On Tue, 24 Mar 2009, Andrew Vasquez wrote:

> From: Lalit Chandivade <lalit.chandivade@qlogic.com>
> 
> Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
> Additional cleanups and
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c |   56 +++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_fw.h   |    1 +
>  drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
>  drivers/scsi/qla2xxx/qla_mbx.c  |   26 ++++++++++++++++++
>  4 files changed, 84 insertions(+), 0 deletions(-)

James,

There's a small typo with this commit, the parse base of '16' should
really be '10':

	> -+	type = simple_strtol(buf, NULL, 16);
	> ++	type = simple_strtol(buf, NULL, 10);

It doesn't look like you've added this to scsi-misc yet.  If so,
please disgard the previous one and add the following.  I can add a
fix-it patch to my next-patch-queue, if needed...

Thanks, AV

---

>From 60a75d6e4e1d1a4eb653cd5ee4aca7beb5fa7873 Mon Sep 17 00:00:00 2001
From: Lalit Chandivade <lalit.chandivade@qlogic.com>
Date: Mon, 16 Mar 2009 04:29:04 -0700
Subject: [PATCH 14/26] qla2xxx: Add reset capabilities for application support.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Additional cleanups and
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   56 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_fw.h   |    1 +
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_mbx.c  |   26 ++++++++++++++++++
 4 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 117517d..be552ac 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -479,6 +479,61 @@ static struct bin_attribute sysfs_sfp_attr = {
 	.read = qla2x00_sysfs_read_sfp,
 };
 
+static ssize_t
+qla2x00_sysfs_write_reset(struct kobject *kobj,
+			struct bin_attribute *bin_attr,
+			char *buf, loff_t off, size_t count)
+{
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
+	int type;
+
+	if (off != 0)
+		return 0;
+
+	type = simple_strtol(buf, NULL, 10);
+	switch (type) {
+	case 0x2025c:
+		qla_printk(KERN_INFO, ha,
+		    "Issuing ISP reset on (%ld).\n", vha->host_no);
+
+		scsi_block_requests(vha->host);
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
+		qla2x00_wait_for_chip_reset(vha);
+		scsi_unblock_requests(vha->host);
+		break;
+	case 0x2025d:
+		if (!IS_QLA81XX(ha))
+			break;
+
+		qla_printk(KERN_INFO, ha,
+		    "Issuing MPI reset on (%ld).\n", vha->host_no);
+
+		/* Make sure FC side is not in reset */
+		qla2x00_wait_for_hba_online(vha);
+
+		/* Issue MPI reset */
+		scsi_block_requests(vha->host);
+		if (qla81xx_restart_mpi_firmware(vha) != QLA_SUCCESS)
+			qla_printk(KERN_WARNING, ha,
+			    "MPI reset failed on (%ld).\n", vha->host_no);
+		scsi_unblock_requests(vha->host);
+		break;
+	}
+	return count;
+}
+
+static struct bin_attribute sysfs_reset_attr = {
+	.attr = {
+		.name = "reset",
+		.mode = S_IWUSR,
+	},
+	.size = 0,
+	.write = qla2x00_sysfs_write_reset,
+};
+
 static struct sysfs_entry {
 	char *name;
 	struct bin_attribute *attr;
@@ -490,6 +545,7 @@ static struct sysfs_entry {
 	{ "optrom_ctl", &sysfs_optrom_ctl_attr, },
 	{ "vpd", &sysfs_vpd_attr, 1 },
 	{ "sfp", &sysfs_sfp_attr, 1 },
+	{ "reset", &sysfs_reset_attr, },
 	{ NULL },
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 9830193..e47c4c3 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1403,6 +1403,7 @@ struct access_chip_rsp_84xx {
 #define MBA_IDC_TIME_EXT	0x8102
 
 #define MBC_IDC_ACK		0x101
+#define MBC_RESTART_MPI_FW	0x3d
 #define MBC_FLASH_ACCESS_CTRL	0x3e	/* Control flash access. */
 
 /* Flash access control option field bit definitions */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index c75e7f9..41c3f41 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -73,6 +73,7 @@ extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
 extern int qla2x00_post_aen_work(struct scsi_qla_host *, enum
     fc_host_event_code, u32);
 extern int qla2x00_post_idc_ack_work(struct scsi_qla_host *, uint16_t *);
+extern int qla81xx_restart_mpi_firmware(scsi_qla_host_t *);
 
 extern void qla2x00_abort_fcport_cmds(fc_port_t *);
 extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2bc08d3..dc5e5d9 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3325,3 +3325,29 @@ qla81xx_fac_erase_sector(scsi_qla_host_t *vha, uint32_t start, uint32_t finish)
 
 	return rval;
 }
+
+int
+qla81xx_restart_mpi_firmware(scsi_qla_host_t *vha)
+{
+	int rval = 0;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+
+	mcp->mb[0] = MBC_RESTART_MPI_FW;
+	mcp->out_mb = MBX_0;
+	mcp->in_mb = MBX_0|MBX_1;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=0x%x mb[1]=0x%x.\n",
+		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+	}
+
+	return rval;
+}
-- 
1.6.2.rc0.55.g30aa4f

