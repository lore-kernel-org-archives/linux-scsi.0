From: Karen Higgins <karen.higgins@qlogic.com>
Subject: [PATCH 2/2] qla4xxx: Driver Fault Recovery
Date: Fri, 24 Apr 2009 09:24:38 -0700
Message-ID: <DBF768B1A111084580554DADE800BF9D72EA041EFD@AVEXMB2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6721 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbZDXQY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2009 12:24:57 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Driver Fault Recovery

=46ixed driver bug where adapter recovery did not complete if there wer=
e
outstanding commands detected on that host adapter.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
---
=A0drivers/scsi/qla4xxx/ql4_os.c | =A0=A019 +++++++++----------
=A01 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_o=
s.c
index eb3a414..fcc65a5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -904,18 +904,17 @@ static int qla4xxx_recover_adapter(struct scsi_ql=
a_host *ha,
=A0=A0=A0=A0=A0/* Flush any pending ddb changed AENs */
=A0=A0=A0=A0=A0qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
=A0
+ =A0=A0=A0qla4xxx_flush_active_srbs(ha);
+
=A0=A0=A0=A0=A0/* Reset the firmware. =A0=A0=A0If successful, function
=A0=A0=A0=A0=A0=A0* returns with ISP interrupts enabled.
=A0=A0=A0=A0=A0=A0*/
- =A0=A0=A0if (status =3D=3D QLA_SUCCESS) {
- =A0=A0=A0=A0=A0=A0=A0DEBUG2(printk("scsi%ld: %s - Performing soft res=
et..\n",
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ha->host_no, __fun=
c__));
- =A0=A0=A0=A0=A0=A0=A0qla4xxx_flush_active_srbs(ha);
- =A0=A0=A0=A0=A0=A0=A0if (ql4xxx_lock_drvr_wait(ha) =3D=3D QLA_SUCCESS=
)
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0status =3D qla4xxx_soft_reset(ha);
- =A0=A0=A0=A0=A0=A0=A0else
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0status =3D QLA_ERROR;
- =A0=A0=A0}
+ =A0=A0=A0DEBUG2(printk("scsi%ld: %s - Performing soft reset..\n",
+ =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ha->host_no, __func__));
+ =A0=A0=A0if (ql4xxx_lock_drvr_wait(ha) =3D=3D QLA_SUCCESS)
+ =A0=A0=A0=A0=A0=A0=A0status =3D qla4xxx_soft_reset(ha);
+ =A0=A0=A0else
+ =A0=A0=A0=A0=A0=A0=A0status =3D QLA_ERROR;
=A0
=A0=A0=A0=A0=A0/* Flush any pending ddb changed AENs */
=A0=A0=A0=A0=A0qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
@@ -1644,7 +1643,7 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd=
 *cmd)
=A0=A0=A0=A0=A0ha =3D (struct scsi_qla_host *) cmd->device->host->hostd=
ata;
=A0
=A0=A0=A0=A0=A0dev_info(&ha->pdev->dev,
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"scsi(%ld:%d:%d:%d): ADAPTER RESET ISSU=
ED.\n", ha->host_no,
+ =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"scsi(%ld:%d:%d:%d): HOST RESET ISSUED.=
\n", ha->host_no,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cmd->device->channel, cmd->device->=
id, cmd->device->lun);
=A0
=A0=A0=A0=A0=A0if (qla4xxx_wait_for_hba_online(ha) !=3D QLA_SUCCESS) {
--=20
1.5.6
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
