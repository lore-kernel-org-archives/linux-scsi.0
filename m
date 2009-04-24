From: Karen Higgins <karen.higgins@qlogic.com>
Subject: [PATCH 1/2] qla4xxx: Correct Extended Sense Data Errors
Date: Fri, 24 Apr 2009 09:24:36 -0700
Message-ID: <DBF768B1A111084580554DADE800BF9D72EA041EFC@AVEXMB2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6719 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZDXQY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2009 12:24:56 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Correct Extended Sense Data Errors

=46ixed sense data errors occurring above the first 32 bytes,
as required by some third party applications. =A0Sense data
in the first 32 bytes has always been correct.

Also, corrected debug print alignment bug in dump_buffer routine.
Removed KERN_DEBUG from printk statements in this routine,
as loglevel #defines only get interpreted if the previous
print statement ends with a newline character. =A0This prevents
<7> from being displayed throughout the buffer.

Changed version number to 5.01.00-k9

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
---
=A0drivers/scsi/qla4xxx/ql4_dbg.c =A0=A0=A0=A0| =A0=A015 ++--
=A0drivers/scsi/qla4xxx/ql4_def.h =A0=A0=A0=A0| =A0=A0=A02 +
=A0drivers/scsi/qla4xxx/ql4_fw.h =A0=A0=A0=A0=A0| =A0=A0=A07 ++
=A0drivers/scsi/qla4xxx/ql4_isr.c =A0=A0=A0=A0| =A0147 ++++++++++++++++=
+++++++++-----------
=A0drivers/scsi/qla4xxx/ql4_version.h | =A0=A0=A02 +-
=A05 files changed, 119 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_dbg.c b/drivers/scsi/qla4xxx/ql4_=
dbg.c
index fcc184c..b538f1d 100644
--- a/drivers/scsi/qla4xxx/ql4_dbg.c
+++ b/drivers/scsi/qla4xxx/ql4_dbg.c
@@ -15,19 +15,18 @@ void qla4xxx_dump_buffer(void *b, uint32_t size)
=A0=A0=A0=A0=A0uint32_t cnt;
=A0=A0=A0=A0=A0uint8_t *c =3D b;
=A0
- =A0=A0=A0printk(" 0 =A0=A01 =A0=A0=A0=A02 =A0=A03 =A0=A0=A0=A04 =A0=A0=
5 =A0=A0=A0=A06 =A0=A07 =A0=A0=A0=A08 =A0=A09 =A0=A0=A0Ah =A0Bh =A0=A0=A0=
Ch =A0Dh =A0=A0=A0Eh =A0"
+ =A0=A0=A0printk(" 0 =A0=A01 =A0=A02 =A0=A03 =A0=A04 =A0=A05 =A0=A06 =A0=
=A07 =A0=A08 =A0=A09 =A0Ah =A0Bh =A0Ch =A0Dh =A0Eh =A0"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"Fh\n");
=A0=A0=A0=A0=A0printk("------------------------------------------------=
------------"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"--\n");
- =A0=A0=A0for (cnt =3D 0; cnt < size; cnt++, c++) {
- =A0=A0=A0=A0=A0=A0=A0printk(KERN_DEBUG "%02x", *c);
- =A0=A0=A0=A0=A0=A0=A0if (!(cnt % 16))
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0printk(KERN_DEBUG "\n");
+ =A0=A0=A0for (cnt =3D 0; cnt < size; c++) {
+ =A0=A0=A0=A0=A0=A0=A0printk("%02x", *c);
+ =A0=A0=A0=A0=A0=A0=A0if (!(++cnt % 16))
+ =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0printk("\n");
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0else
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0printk(KERN_DEBUG " =A0");
+ =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0printk(" =A0");
=A0=A0=A0=A0=A0}
- =A0=A0=A0if (cnt % 16)
- =A0=A0=A0=A0=A0=A0=A0printk(KERN_DEBUG "\n");
+ =A0=A0=A0printk("\n");
=A0}
=A0
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_=
def.h
index b586f27..93bdc20 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -436,6 +436,8 @@ struct scsi_qla_host {
=A0=A0=A0=A0=A0/* Map ddb_list entry by FW ddb index */
=A0=A0=A0=A0=A0struct ddb_entry *fw_ddb_index_map[MAX_DDB_ENTRIES];
=A0
+ =A0=A0=A0=A0=A0=A0=A0/* Saved srb for status continuation entry proce=
ssing */
+ =A0=A0=A0struct srb *status_srb;
=A0};
=A0
=A0static inline int is_qla4010(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_f=
w.h
index 1b667a7..06ef262 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -572,6 +572,7 @@ struct conn_event_log_entry {
=A0=A0*****************************************************************=
********/
=A0#define IOCB_MAX_CDB_LEN =A0=A0=A0=A0=A0=A0=A016 =A0=A0=A0/* Bytes i=
n a CBD */
=A0#define IOCB_MAX_SENSEDATA_LEN =A0=A0=A0=A0=A0=A0=A032 =A0=A0=A0/* B=
ytes of sense data */
+#define IOCB_MAX_EXT_SENSEDATA_LEN =A060 =A0/* Bytes of extended sense=
 data */
=A0
=A0/* IOCB header structure */
=A0struct qla4_header {
@@ -733,6 +734,12 @@ struct status_entry {
=A0
=A0};
=A0
+/* Status Continuation entry */
+struct status_cont_entry {
+ =A0=A0=A0=A0=A0=A0struct qla4_header hdr; /* 00-03 */
+ =A0=A0=A0=A0=A0=A0uint8_t extSenseData[IOCB_MAX_EXT_SENSEDATA_LEN]; /=
* 04-63 */
+};
+
=A0struct passthru0 {
=A0=A0=A0=A0=A0struct qla4_header hdr; =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0/* 00-03 */
=A0=A0=A0=A0=A0uint32_t handle; =A0=A0=A0/* 04-07 */
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_=
isr.c
index 799120f..6888b84 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -11,6 +11,100 @@
=A0#include "ql4_inline.h"
=A0
=A0/**
+ * qla4xxx_copy_sense - copy sense data =A0=A0=A0into cmd sense buffer
+ * @ha: Pointer to host adapter structure.
+ * @sts_entry: Pointer to status entry structure.
+ * @srb: Pointer to srb structure.
+ **/
+static void qla4xxx_copy_sense(struct scsi_qla_host *ha,
+ =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0struct status_entry *sts_entry,
+ =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0struct srb *srb)
+{
+ =A0=A0=A0struct scsi_cmnd *cmd =3D srb->cmd;
+ =A0=A0=A0uint16_t sense_len;
+
+ =A0=A0=A0memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+ =A0=A0=A0sense_len =3D le16_to_cpu(sts_entry->senseDataByteCnt);
+ =A0=A0=A0if (sense_len =3D=3D 0)
+ =A0=A0=A0=A0=A0=A0=A0return;
+
+ =A0=A0=A0/* Save total available sense length,
+ =A0=A0=A0=A0* not to exceed cmd's sense buffer size */
+ =A0=A0=A0sense_len =3D min_t(uint16_t, sense_len, SCSI_SENSE_BUFFERSI=
ZE);
+ =A0=A0=A0cmd->SCp.ptr =3D cmd->sense_buffer;
+ =A0=A0=A0cmd->SCp.this_residual =3D sense_len;
+
+ =A0=A0=A0/* Copy sense from sts_entry pkt */
+ =A0=A0=A0sense_len =3D min_t(uint16_t, sense_len, IOCB_MAX_SENSEDATA_=
LEN);
+ =A0=A0=A0memcpy(cmd->sense_buffer, sts_entry->senseData, sense_len);
+
+ =A0=A0=A0DEBUG2(printk("scsi%ld:%d:%d:%d: %s: sense key =3D %x, "
+ =A0=A0=A0=A0=A0=A0=A0"Addl.SenseLen - %02x, "
+ =A0=A0=A0=A0=A0=A0=A0"ASC/ASCQ =3D %02x/%02x\n", ha->host_no,
+ =A0=A0=A0=A0=A0=A0=A0cmd->device->channel, cmd->device->id,
+ =A0=A0=A0=A0=A0=A0=A0cmd->device->lun, __func__,
+ =A0=A0=A0=A0=A0=A0=A0sts_entry->senseData[2] & 0x0f,
+ =A0=A0=A0=A0=A0=A0=A0sts_entry->senseData[7],
+ =A0=A0=A0=A0=A0=A0=A0sts_entry->senseData[12],
+ =A0=A0=A0=A0=A0=A0=A0sts_entry->senseData[13]));
+
+ =A0=A0=A0DEBUG5(qla4xxx_dump_buffer(cmd->SCp.ptr, sense_len));
+ =A0=A0=A0srb->flags |=3D SRB_GOT_SENSE;
+
+ =A0=A0=A0/* Update srb, in case a sts_cont pkt follows */
+ =A0=A0=A0cmd->SCp.ptr +=3D sense_len;
+ =A0=A0=A0cmd->SCp.this_residual -=3D sense_len;
+ =A0=A0=A0if (cmd->SCp.this_residual !=3D 0)
+ =A0=A0=A0=A0=A0=A0=A0ha->status_srb =3D srb;
+ =A0=A0=A0else
+ =A0=A0=A0=A0=A0=A0=A0ha->status_srb =3D NULL;
+}
+
+/**
+ * qla4xxx_status_cont_entry() - Process a Status Continuations entry.
+ * @ha: SCSI driver HA context
+ * @sts_cont: Entry pointer
+ *
+ * Extended sense data.
+ */
+static void
+qla4xxx_status_cont_entry(struct scsi_qla_host *ha,
+ =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct status_cont_entry *sts_=
cont)
+{
+ =A0=A0=A0struct srb *srb =3D ha->status_srb;
+ =A0=A0=A0struct scsi_cmnd *cmd;
+ =A0=A0=A0uint8_t sense_len;
+
+ =A0=A0=A0if (srb =3D=3D NULL) {
+ =A0=A0=A0=A0=A0=A0=A0DEBUG2(printk("scsi%ld: %s: Throw away extra STA=
TUS CONTINUATION\n",
+ =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ha->host_no, __func__));
+ =A0=A0=A0=A0=A0=A0=A0return;
+ =A0=A0=A0}
+
+ =A0=A0=A0cmd =3D srb->cmd;
+ =A0=A0=A0if (cmd =3D=3D NULL) {
+ =A0=A0=A0=A0=A0=A0=A0DEBUG2(printk("scsi%ld: %s: Cmd already returned=
 back to OS "
+ =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"srb=3D%p srb->state:%d\n", ha->host=
_no, __func__, srb, srb->state));
+ =A0=A0=A0=A0=A0=A0=A0ha->status_srb =3D NULL;
+ =A0=A0=A0=A0=A0=A0=A0return;
+ =A0=A0=A0}
+
+ =A0=A0=A0/* Copy sense data. */
+ =A0=A0=A0sense_len =3D min(cmd->SCp.this_residual, IOCB_MAX_EXT_SENSE=
DATA_LEN);
+ =A0=A0=A0memcpy(cmd->SCp.ptr, sts_cont->extSenseData, sense_len);
+ =A0=A0=A0DEBUG5(qla4xxx_dump_buffer(cmd->SCp.ptr, sense_len));
+
+ =A0=A0=A0cmd->SCp.ptr +=3D sense_len;
+ =A0=A0=A0cmd->SCp.this_residual -=3D sense_len;
+
+ =A0=A0=A0/* Place command on done queue. */
+ =A0=A0=A0if (cmd->SCp.this_residual =3D=3D 0) {
+ =A0=A0=A0=A0=A0=A0=A0qla4xxx_srb_compl(ha, srb);
+ =A0=A0=A0=A0=A0=A0=A0ha->status_srb =3D NULL;
+ =A0=A0=A0}
+}
+
+/**
=A0=A0* qla4xxx_status_entry - processes status IOCBs
=A0=A0* @ha: Pointer to host adapter structure.
=A0=A0* @sts_entry: Pointer to status entry structure.
@@ -23,7 +117,6 @@ static void qla4xxx_status_entry(struct scsi_qla_hos=
t *ha,
=A0=A0=A0=A0=A0struct srb *srb;
=A0=A0=A0=A0=A0struct ddb_entry *ddb_entry;
=A0=A0=A0=A0=A0uint32_t residual;
- =A0=A0=A0uint16_t sensebytecnt;
=A0
=A0=A0=A0=A0=A0srb =3D qla4xxx_del_from_active_array(ha, le32_to_cpu(st=
s_entry->handle));
=A0=A0=A0=A0=A0if (!srb) {
@@ -92,24 +185,7 @@ static void qla4xxx_status_entry(struct scsi_qla_ho=
st *ha,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Copy Sense Data into sense buffer. */
- =A0=A0=A0=A0=A0=A0=A0memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSI=
ZE);
-
- =A0=A0=A0=A0=A0=A0=A0sensebytecnt =3D le16_to_cpu(sts_entry->senseDat=
aByteCnt);
- =A0=A0=A0=A0=A0=A0=A0if (sensebytecnt =3D=3D 0)
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
-
- =A0=A0=A0=A0=A0=A0=A0memcpy(cmd->sense_buffer, sts_entry->senseData,
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0min_t(uint16_t, sensebytecn=
t, SCSI_SENSE_BUFFERSIZE));
-
- =A0=A0=A0=A0=A0=A0=A0DEBUG2(printk("scsi%ld:%d:%d:%d: %s: sense key =3D=
 %x, "
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"ASC/ASCQ =3D %02x=
/%02x\n", ha->host_no,
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cmd->device->chann=
el, cmd->device->id,
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cmd->device->lun, =
__func__,
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sts_entry->senseDa=
ta[2] & 0x0f,
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sts_entry->senseDa=
ta[12],
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sts_entry->senseDa=
ta[13]));
-
- =A0=A0=A0=A0=A0=A0=A0srb->flags |=3D SRB_GOT_SENSE;
+ =A0=A0=A0=A0=A0=A0=A0qla4xxx_copy_sense(ha, sts_entry, srb);
=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
=A0
=A0=A0=A0=A0=A0case SCS_INCOMPLETE:
@@ -176,23 +252,7 @@ static void qla4xxx_status_entry(struct scsi_qla_h=
ost *ha,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Copy Sense Data into sense bu=
ffer. */
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0memset(cmd->sense_buffer, 0, SCSI_SE=
NSE_BUFFERSIZE);
-
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sensebytecnt =3D
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0le16_to_cpu(sts_entry->s=
enseDataByteCnt);
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (sensebytecnt =3D=3D 0)
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
-
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0memcpy(cmd->sense_buffer, sts_entry-=
>senseData,
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0min_t(uint16_t,=
 sensebytecnt, SCSI_SENSE_BUFFERSIZE));
-
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0DEBUG2(printk("scsi%ld:%d:%d:%d: %s:=
 sense key =3D %x, "
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"ASC/A=
SCQ =3D %02x/%02x\n", ha->host_no,
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cmd->d=
evice->channel, cmd->device->id,
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cmd->d=
evice->lun, __func__,
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sts_en=
try->senseData[2] & 0x0f,
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sts_en=
try->senseData[12],
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sts_en=
try->senseData[13]));
+ =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0qla4xxx_copy_sense(ha, sts_entry, sr=
b);
=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0* If RISC reports underrun an=
d target does not
@@ -268,9 +328,10 @@ static void qla4xxx_status_entry(struct scsi_qla_h=
ost *ha,
=A0
=A0status_entry_exit:
=A0
- =A0=A0=A0/* complete the request */
+ =A0=A0=A0/* complete the request, if not waiting for status_continuat=
ion pkt */
=A0=A0=A0=A0=A0srb->cc_stat =3D sts_entry->completionStatus;
- =A0=A0=A0qla4xxx_srb_compl(ha, srb);
+ =A0=A0=A0if (ha->status_srb =3D=3D NULL)
+ =A0=A0=A0=A0=A0=A0=A0qla4xxx_srb_compl(ha, srb);
=A0}
=A0
=A0/**
@@ -305,10 +366,7 @@ static void qla4xxx_process_response_queue(struct =
scsi_qla_host * ha)
=A0=A0=A0=A0=A0=A0=A0=A0=A0/* process entry */
=A0=A0=A0=A0=A0=A0=A0=A0=A0switch (sts_entry->hdr.entryType) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0case ET_STATUS:
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0* Common status - Single completi=
on posted in single
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0* IOSB.
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*/
+ =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Common status */
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0qla4xxx_status_entry(ha, sts_ent=
ry);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
=A0
@@ -316,9 +374,8 @@ static void qla4xxx_process_response_queue(struct s=
csi_qla_host * ha)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0case ET_STATUS_CONTINUATION:
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Just throw away the status contin=
uation entries */
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0DEBUG2(printk("scsi%ld: %s: Status C=
ontinuation entry "
- =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"- ign=
oring\n", ha->host_no, __func__));
+ =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0qla4xxx_status_cont_entry(ha,
+ =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(struct status_cont_entr=
y *) sts_entry);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0case ET_COMMAND:
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/=
ql4_version.h
index ab984cb..6980cb2 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,5 +5,5 @@
=A0=A0* See LICENSE.qla4xxx for copyright and licensing details.
=A0=A0*/
=A0
-#define QLA4XXX_DRIVER_VERSION =A0=A0=A0"5.01.00-k8"
+#define QLA4XXX_DRIVER_VERSION =A0=A0=A0"5.01.00-k9"
=A0
--=20
1.5.6
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
