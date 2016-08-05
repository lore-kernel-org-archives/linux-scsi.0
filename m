From: Chaitra Basappa <chaitra.basappa@broadcom.com>
Subject: RE: [PATCH 2/3] mpt3sas: Eliminate dead sleep_flag code
Date: Fri, 5 Aug 2016 09:59:18 +0530
Message-ID: <16cfbf4bd766f084719823ce91ec94b1@mail.gmail.com>
References: <7afa9136f4edf40e29fddf4fcfbc9694724472f2.1469766027.git.calvinowens@fb.com>
 <88ad14a793c1703e6511a95e0b261b6f8bf25ef0.1469766027.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:32779 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbcHEE3X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2016 00:29:23 -0400
Received: by mail-qk0-f173.google.com with SMTP id p74so253113213qka.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2016 21:29:23 -0700 (PDT)
In-Reply-To: <88ad14a793c1703e6511a95e0b261b6f8bf25ef0.1469766027.git.calvinowens@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hi,
 Please consider this patch as Acked-by: Chaitra P B
<chaitra.basappa@broadcom.com>


Thanks,
 Chaitra

-----Original Message-----
From: Calvin Owens [mailto:calvinowens@fb.com]
Sent: Friday, July 29, 2016 10:08 AM
To: Sathya Prakash; Chaitra P B; Suganath Prabu Subramani; James E.J.
Bottomley; Martin K. Petersen
Cc: MPT-FusionLinux.pdl@broadcom.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; kernel-team@fb.com; Calvin Owens
Subject: [PATCH 2/3] mpt3sas: Eliminate dead sleep_flag code

With the exception of a single call to wait_for_doorbell_int(), all this
conditional sleeping code is dead. So delete it.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 241
+++++++++++++------------------
 drivers/scsi/mpt3sas/mpt3sas_base.h      |   6 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c    |   3 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  15 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     |  21 +--
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  12 +-
 6 files changed, 120 insertions(+), 178 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 751f13e..0956183 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -98,7 +98,7 @@ MODULE_PARM_DESC(mpt3sas_fwfault_debug,
 	" enable detection of firmware fault and halt firmware -
(default=0)");

 static int
-_base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc, int sleep_flag);
+_base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc);

 /**
  * _scsih_set_fwfault_debug - global setting of ioc->fwfault_debug.
@@ -218,8 +218,7 @@ _base_fault_reset_work(struct work_struct *work)
 	ioc->non_operational_loop = 0;

 	if ((doorbell & MPI2_IOC_STATE_MASK) !=
MPI2_IOC_STATE_OPERATIONAL) {
-		rc = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		rc = mpt3sas_base_hard_reset_handler(ioc,
FORCE_BIG_HAMMER);
 		pr_warn(MPT3SAS_FMT "%s: hard reset: %s\n", ioc->name,
 		    __func__, (rc == 0) ? "success" : "failed");
 		doorbell = mpt3sas_base_get_iocstate(ioc, 0); @@ -2145,7
+2144,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)

 	_base_mask_interrupts(ioc);

-	r = _base_get_ioc_facts(ioc, CAN_SLEEP);
+	r = _base_get_ioc_facts(ioc);
 	if (r)
 		goto out_fail;

@@ -3172,12 +3171,11 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER
*ioc)
 /**
  * _base_allocate_memory_pools - allocate start of day memory pools
  * @ioc: per adapter object
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 success, anything else error
  */
 static int
-_base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
+_base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct mpt3sas_facts *facts;
 	u16 max_sge_elements;
@@ -3647,29 +3645,25 @@ mpt3sas_base_get_iocstate(struct MPT3SAS_ADAPTER
*ioc, int cooked)
  * _base_wait_on_iocstate - waiting on a particular ioc state
  * @ioc_state: controller state { READY, OPERATIONAL, or RESET }
  * @timeout: timeout in second
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_wait_on_iocstate(struct MPT3SAS_ADAPTER *ioc, u32 ioc_state, int
timeout,
-	int sleep_flag)
+_base_wait_on_iocstate(struct MPT3SAS_ADAPTER *ioc, u32 ioc_state, int
+timeout)
 {
 	u32 count, cntdn;
 	u32 current_state;

 	count = 0;
-	cntdn = (sleep_flag == CAN_SLEEP) ? 1000*timeout : 2000*timeout;
+	cntdn = 1000 * timeout;
 	do {
 		current_state = mpt3sas_base_get_iocstate(ioc, 1);
 		if (current_state == ioc_state)
 			return 0;
 		if (count && current_state == MPI2_IOC_STATE_FAULT)
 			break;
-		if (sleep_flag == CAN_SLEEP)
-			usleep_range(1000, 1500);
-		else
-			udelay(500);
+
+		usleep_range(1000, 1500);
 		count++;
 	} while (--cntdn);

@@ -3681,24 +3675,22 @@ _base_wait_on_iocstate(struct MPT3SAS_ADAPTER
*ioc, u32 ioc_state, int timeout,
  * a write to the doorbell)
  * @ioc: per adapter object
  * @timeout: timeout in second
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  *
  * Notes: MPI2_HIS_IOC2SYS_DB_STATUS - set to one when IOC writes to
doorbell.
  */
 static int
-_base_diag_reset(struct MPT3SAS_ADAPTER *ioc, int sleep_flag);
+_base_diag_reset(struct MPT3SAS_ADAPTER *ioc);

 static int
-_base_wait_for_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int timeout,
-	int sleep_flag)
+_base_wait_for_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int timeout)
 {
 	u32 cntdn, count;
 	u32 int_status;

 	count = 0;
-	cntdn = (sleep_flag == CAN_SLEEP) ? 1000*timeout : 2000*timeout;
+	cntdn = 1000 * timeout;
 	do {
 		int_status = readl(&ioc->chip->HostInterruptStatus);
 		if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) { @@ -3707,10
+3699,35 @@ _base_wait_for_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int
timeout,
 				ioc->name, __func__, count, timeout));
 			return 0;
 		}
-		if (sleep_flag == CAN_SLEEP)
-			usleep_range(1000, 1500);
-		else
-			udelay(500);
+
+		usleep_range(1000, 1500);
+		count++;
+	} while (--cntdn);
+
+	pr_err(MPT3SAS_FMT
+		"%s: failed due to timeout count(%d), int_status(%x)!\n",
+		ioc->name, __func__, count, int_status);
+	return -EFAULT;
+}
+
+static int
+_base_spin_on_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int timeout) {
+	u32 cntdn, count;
+	u32 int_status;
+
+	count = 0;
+	cntdn = 2000 * timeout;
+	do {
+		int_status = readl(&ioc->chip->HostInterruptStatus);
+		if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) {
+			dhsprintk(ioc, pr_info(MPT3SAS_FMT
+				"%s: successful count(%d), timeout(%d)\n",
+				ioc->name, __func__, count, timeout));
+			return 0;
+		}
+
+		udelay(500);
 		count++;
 	} while (--cntdn);

@@ -3718,13 +3735,13 @@ _base_wait_for_doorbell_int(struct MPT3SAS_ADAPTER
*ioc, int timeout,
 		"%s: failed due to timeout count(%d), int_status(%x)!\n",
 		ioc->name, __func__, count, int_status);
 	return -EFAULT;
+
 }

 /**
  * _base_wait_for_doorbell_ack - waiting for controller to read the
doorbell.
  * @ioc: per adapter object
  * @timeout: timeout in second
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  *
@@ -3732,15 +3749,14 @@ _base_wait_for_doorbell_int(struct MPT3SAS_ADAPTER
*ioc, int timeout,
  * doorbell.
  */
 static int
-_base_wait_for_doorbell_ack(struct MPT3SAS_ADAPTER *ioc, int timeout,
-	int sleep_flag)
+_base_wait_for_doorbell_ack(struct MPT3SAS_ADAPTER *ioc, int timeout)
 {
 	u32 cntdn, count;
 	u32 int_status;
 	u32 doorbell;

 	count = 0;
-	cntdn = (sleep_flag == CAN_SLEEP) ? 1000*timeout : 2000*timeout;
+	cntdn = 1000 * timeout;
 	do {
 		int_status = readl(&ioc->chip->HostInterruptStatus);
 		if (!(int_status & MPI2_HIS_SYS2IOC_DB_STATUS)) { @@
-3758,10 +3774,7 @@ _base_wait_for_doorbell_ack(struct MPT3SAS_ADAPTER
*ioc, int timeout,
 		} else if (int_status == 0xFFFFFFFF)
 			goto out;

-		if (sleep_flag == CAN_SLEEP)
-			usleep_range(1000, 1500);
-		else
-			udelay(500);
+		usleep_range(1000, 1500);
 		count++;
 	} while (--cntdn);

@@ -3776,20 +3789,18 @@ _base_wait_for_doorbell_ack(struct MPT3SAS_ADAPTER
*ioc, int timeout,
  * _base_wait_for_doorbell_not_used - waiting for doorbell to not be in
use
  * @ioc: per adapter object
  * @timeout: timeout in second
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  *
  */
 static int
-_base_wait_for_doorbell_not_used(struct MPT3SAS_ADAPTER *ioc, int
timeout,
-	int sleep_flag)
+_base_wait_for_doorbell_not_used(struct MPT3SAS_ADAPTER *ioc, int
+timeout)
 {
 	u32 cntdn, count;
 	u32 doorbell_reg;

 	count = 0;
-	cntdn = (sleep_flag == CAN_SLEEP) ? 1000*timeout : 2000*timeout;
+	cntdn = 1000 * timeout;
 	do {
 		doorbell_reg = readl(&ioc->chip->Doorbell);
 		if (!(doorbell_reg & MPI2_DOORBELL_USED)) { @@ -3798,10
+3809,8 @@ _base_wait_for_doorbell_not_used(struct MPT3SAS_ADAPTER *ioc,
int timeout,
 				ioc->name, __func__, count, timeout));
 			return 0;
 		}
-		if (sleep_flag == CAN_SLEEP)
-			usleep_range(1000, 1500);
-		else
-			udelay(500);
+
+		usleep_range(1000, 1500);
 		count++;
 	} while (--cntdn);

@@ -3816,13 +3825,11 @@ _base_wait_for_doorbell_not_used(struct
MPT3SAS_ADAPTER *ioc, int timeout,
  * @ioc: per adapter object
  * @reset_type: currently only supports:
MPI2_FUNCTION_IOC_MESSAGE_UNIT_RESET
  * @timeout: timeout in second
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_send_ioc_reset(struct MPT3SAS_ADAPTER *ioc, u8 reset_type, int
timeout,
-	int sleep_flag)
+_base_send_ioc_reset(struct MPT3SAS_ADAPTER *ioc, u8 reset_type, int
+timeout)
 {
 	u32 ioc_state;
 	int r = 0;
@@ -3841,12 +3848,11 @@ _base_send_ioc_reset(struct MPT3SAS_ADAPTER *ioc,
u8 reset_type, int timeout,

 	writel(reset_type << MPI2_DOORBELL_FUNCTION_SHIFT,
 	    &ioc->chip->Doorbell);
-	if ((_base_wait_for_doorbell_ack(ioc, 15, sleep_flag))) {
+	if ((_base_wait_for_doorbell_ack(ioc, 15))) {
 		r = -EFAULT;
 		goto out;
 	}
-	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY,
-	    timeout, sleep_flag);
+	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY,
+timeout);
 	if (ioc_state) {
 		pr_err(MPT3SAS_FMT
 			"%s: failed going to ready state
(ioc_state=0x%x)\n", @@ -3868,13 +3874,12 @@ _base_send_ioc_reset(struct
MPT3SAS_ADAPTER *ioc, u8 reset_type, int timeout,
  * @reply_bytes: reply length
  * @reply: pointer to reply payload
  * @timeout: timeout in second
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
 _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int
request_bytes,
-	u32 *request, int reply_bytes, u16 *reply, int timeout, int
sleep_flag)
+	u32 *request, int reply_bytes, u16 *reply, int timeout)
 {
 	MPI2DefaultReply_t *default_reply = (MPI2DefaultReply_t *)reply;
 	int i;
@@ -3900,7 +3905,7 @@ _base_handshake_req_reply_wait(struct
MPT3SAS_ADAPTER *ioc, int request_bytes,
 	    ((request_bytes/4)<<MPI2_DOORBELL_ADD_DWORDS_SHIFT)),
 	    &ioc->chip->Doorbell);

-	if ((_base_wait_for_doorbell_int(ioc, 5, NO_SLEEP))) {
+	if ((_base_spin_on_doorbell_int(ioc, 5))) {
 		pr_err(MPT3SAS_FMT
 			"doorbell handshake int failed (line=%d)\n",
 			ioc->name, __LINE__);
@@ -3908,7 +3913,7 @@ _base_handshake_req_reply_wait(struct
MPT3SAS_ADAPTER *ioc, int request_bytes,
 	}
 	writel(0, &ioc->chip->HostInterruptStatus);

-	if ((_base_wait_for_doorbell_ack(ioc, 5, sleep_flag))) {
+	if ((_base_wait_for_doorbell_ack(ioc, 5))) {
 		pr_err(MPT3SAS_FMT
 			"doorbell handshake ack failed (line=%d)\n",
 			ioc->name, __LINE__);
@@ -3918,7 +3923,7 @@ _base_handshake_req_reply_wait(struct
MPT3SAS_ADAPTER *ioc, int request_bytes,
 	/* send message 32-bits at a time */
 	for (i = 0, failed = 0; i < request_bytes/4 && !failed; i++) {
 		writel(cpu_to_le32(request[i]), &ioc->chip->Doorbell);
-		if ((_base_wait_for_doorbell_ack(ioc, 5, sleep_flag)))
+		if ((_base_wait_for_doorbell_ack(ioc, 5)))
 			failed = 1;
 	}

@@ -3930,7 +3935,7 @@ _base_handshake_req_reply_wait(struct
MPT3SAS_ADAPTER *ioc, int request_bytes,
 	}

 	/* now wait for the reply */
-	if ((_base_wait_for_doorbell_int(ioc, timeout, sleep_flag))) {
+	if ((_base_wait_for_doorbell_int(ioc, timeout))) {
 		pr_err(MPT3SAS_FMT
 			"doorbell handshake int failed (line=%d)\n",
 			ioc->name, __LINE__);
@@ -3941,7 +3946,7 @@ _base_handshake_req_reply_wait(struct
MPT3SAS_ADAPTER *ioc, int request_bytes,
 	reply[0] = le16_to_cpu(readl(&ioc->chip->Doorbell)
 	    & MPI2_DOORBELL_DATA_MASK);
 	writel(0, &ioc->chip->HostInterruptStatus);
-	if ((_base_wait_for_doorbell_int(ioc, 5, sleep_flag))) {
+	if ((_base_wait_for_doorbell_int(ioc, 5))) {
 		pr_err(MPT3SAS_FMT
 			"doorbell handshake int failed (line=%d)\n",
 			ioc->name, __LINE__);
@@ -3952,7 +3957,7 @@ _base_handshake_req_reply_wait(struct
MPT3SAS_ADAPTER *ioc, int request_bytes,
 	writel(0, &ioc->chip->HostInterruptStatus);

 	for (i = 2; i < default_reply->MsgLength * 2; i++)  {
-		if ((_base_wait_for_doorbell_int(ioc, 5, sleep_flag))) {
+		if ((_base_wait_for_doorbell_int(ioc, 5))) {
 			pr_err(MPT3SAS_FMT
 				"doorbell handshake int failed
(line=%d)\n",
 				ioc->name, __LINE__);
@@ -3966,8 +3971,8 @@ _base_handshake_req_reply_wait(struct
MPT3SAS_ADAPTER *ioc, int request_bytes,
 		writel(0, &ioc->chip->HostInterruptStatus);
 	}

-	_base_wait_for_doorbell_int(ioc, 5, sleep_flag);
-	if (_base_wait_for_doorbell_not_used(ioc, 5, sleep_flag) != 0) {
+	_base_wait_for_doorbell_int(ioc, 5);
+	if (_base_wait_for_doorbell_not_used(ioc, 5) != 0) {
 		dhsprintk(ioc, pr_info(MPT3SAS_FMT
 			"doorbell is in use (line=%d)\n", ioc->name,
__LINE__));
 	}
@@ -4082,8 +4087,7 @@ mpt3sas_base_sas_iounit_control(struct
MPT3SAS_ADAPTER *ioc,

  issue_host_reset:
 	if (issue_reset)
-		mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	ioc->base_cmds.status = MPT3_CMD_NOT_USED;
 	rc = -EFAULT;
  out:
@@ -4180,8 +4184,7 @@ mpt3sas_base_scsi_enclosure_processor(struct
MPT3SAS_ADAPTER *ioc,

  issue_host_reset:
 	if (issue_reset)
-		mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	ioc->base_cmds.status = MPT3_CMD_NOT_USED;
 	rc = -EFAULT;
  out:
@@ -4192,12 +4195,11 @@ mpt3sas_base_scsi_enclosure_processor(struct
MPT3SAS_ADAPTER *ioc,
 /**
  * _base_get_port_facts - obtain port facts reply and save in ioc
  * @ioc: per adapter object
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_get_port_facts(struct MPT3SAS_ADAPTER *ioc, int port, int
sleep_flag)
+_base_get_port_facts(struct MPT3SAS_ADAPTER *ioc, int port)
 {
 	Mpi2PortFactsRequest_t mpi_request;
 	Mpi2PortFactsReply_t mpi_reply;
@@ -4213,7 +4215,7 @@ _base_get_port_facts(struct MPT3SAS_ADAPTER *ioc,
int port, int sleep_flag)
 	mpi_request.Function = MPI2_FUNCTION_PORT_FACTS;
 	mpi_request.PortNumber = port;
 	r = _base_handshake_req_reply_wait(ioc, mpi_request_sz,
-	    (u32 *)&mpi_request, mpi_reply_sz, (u16 *)&mpi_reply, 5,
CAN_SLEEP);
+	    (u32 *)&mpi_request, mpi_reply_sz, (u16 *)&mpi_reply, 5);

 	if (r != 0) {
 		pr_err(MPT3SAS_FMT "%s: handshake failed (r=%d)\n", @@
-4236,13 +4238,11 @@ _base_get_port_facts(struct MPT3SAS_ADAPTER *ioc, int
port, int sleep_flag)
  * _base_wait_for_iocstate - Wait until the card is in READY or
OPERATIONAL
  * @ioc: per adapter object
  * @timeout:
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_wait_for_iocstate(struct MPT3SAS_ADAPTER *ioc, int timeout,
-	int sleep_flag)
+_base_wait_for_iocstate(struct MPT3SAS_ADAPTER *ioc, int timeout)
 {
 	u32 ioc_state;
 	int rc;
@@ -4276,8 +4276,7 @@ _base_wait_for_iocstate(struct MPT3SAS_ADAPTER *ioc,
int timeout,
 		goto issue_diag_reset;
 	}

-	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY,
-	    timeout, sleep_flag);
+	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY,
+timeout);
 	if (ioc_state) {
 		dfailprintk(ioc, printk(MPT3SAS_FMT
 		    "%s: failed going to ready state (ioc_state=0x%x)\n",
@@ -4286,19 +4285,18 @@ _base_wait_for_iocstate(struct MPT3SAS_ADAPTER
*ioc, int timeout,
 	}

  issue_diag_reset:
-	rc = _base_diag_reset(ioc, sleep_flag);
+	rc = _base_diag_reset(ioc);
 	return rc;
 }

 /**
  * _base_get_ioc_facts - obtain ioc facts reply and save in ioc
  * @ioc: per adapter object
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
+_base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi2IOCFactsRequest_t mpi_request;
 	Mpi2IOCFactsReply_t mpi_reply;
@@ -4308,7 +4306,7 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc, int
sleep_flag)
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));

-	r = _base_wait_for_iocstate(ioc, 10, sleep_flag);
+	r = _base_wait_for_iocstate(ioc, 10);
 	if (r) {
 		dfailprintk(ioc, printk(MPT3SAS_FMT
 		    "%s: failed getting to correct state\n", @@ -4320,7
+4318,7 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc, int
sleep_flag)
 	memset(&mpi_request, 0, mpi_request_sz);
 	mpi_request.Function = MPI2_FUNCTION_IOC_FACTS;
 	r = _base_handshake_req_reply_wait(ioc, mpi_request_sz,
-	    (u32 *)&mpi_request, mpi_reply_sz, (u16 *)&mpi_reply, 5,
CAN_SLEEP);
+	    (u32 *)&mpi_request, mpi_reply_sz, (u16 *)&mpi_reply, 5);

 	if (r != 0) {
 		pr_err(MPT3SAS_FMT "%s: handshake failed (r=%d)\n", @@
-4380,12 +4378,11 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc, int
sleep_flag)
 /**
  * _base_send_ioc_init - send ioc_init to firmware
  * @ioc: per adapter object
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
+_base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi2IOCInitRequest_t mpi_request;
 	Mpi2IOCInitReply_t mpi_reply;
@@ -4468,8 +4465,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc, int
sleep_flag)

 	r = _base_handshake_req_reply_wait(ioc,
 	    sizeof(Mpi2IOCInitRequest_t), (u32 *)&mpi_request,
-	    sizeof(Mpi2IOCInitReply_t), (u16 *)&mpi_reply, 10,
-	    sleep_flag);
+	    sizeof(Mpi2IOCInitReply_t), (u16 *)&mpi_reply, 10);

 	if (r != 0) {
 		pr_err(MPT3SAS_FMT "%s: handshake failed (r=%d)\n", @@
-4544,12 +4540,11 @@ mpt3sas_port_enable_done(struct MPT3SAS_ADAPTER *ioc,
u16 smid, u8 msix_index,
 /**
  * _base_send_port_enable - send port_enable(discovery stuff) to firmware
  * @ioc: per adapter object
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_send_port_enable(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
+_base_send_port_enable(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi2PortEnableRequest_t *mpi_request;
 	Mpi2PortEnableReply_t *mpi_reply;
@@ -4726,12 +4721,11 @@ _base_unmask_events(struct MPT3SAS_ADAPTER *ioc,
u16 event)
 /**
  * _base_event_notification - send event notification
  * @ioc: per adapter object
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_event_notification(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
+_base_event_notification(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi2EventNotificationRequest_t *mpi_request;
 	unsigned long timeleft;
@@ -4816,19 +4810,18 @@ mpt3sas_base_validate_event_type(struct
MPT3SAS_ADAPTER *ioc, u32 *event_type)
 		return;

 	mutex_lock(&ioc->base_cmds.mutex);
-	_base_event_notification(ioc, CAN_SLEEP);
+	_base_event_notification(ioc);
 	mutex_unlock(&ioc->base_cmds.mutex);
 }

 /**
  * _base_diag_reset - the "big hammer" start of day reset
  * @ioc: per adapter object
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_diag_reset(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
+_base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 host_diagnostic;
 	u32 ioc_state;
@@ -4856,10 +4849,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc, int
sleep_flag)
 		writel(MPI2_WRSEQ_6TH_KEY_VALUE,
&ioc->chip->WriteSequence);

 		/* wait 100 msec */
-		if (sleep_flag == CAN_SLEEP)
-			msleep(100);
-		else
-			mdelay(100);
+		msleep(100);

 		if (count++ > 20)
 			goto out;
@@ -4879,10 +4869,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc, int
sleep_flag)
 	     &ioc->chip->HostDiagnostic);

 	/*This delay allows the chip PCIe hardware time to finish reset
tasks*/
-	if (sleep_flag == CAN_SLEEP)
-
msleep(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);
-	else
-
mdelay(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);
+	msleep(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);

 	/* Approximately 300 second max wait */
 	for (count = 0; count < (300000000 /
@@ -4895,13 +4882,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc, int
sleep_flag)
 		if (!(host_diagnostic & MPI2_DIAG_RESET_ADAPTER))
 			break;

-		/* Wait to pass the second read delay window */
-		if (sleep_flag == CAN_SLEEP)
-
msleep(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC
-								/ 1000);
-		else
-
mdelay(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC
-								/ 1000);
+		msleep(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC /
1000);
 	}

 	if (host_diagnostic & MPI2_DIAG_HCB_MODE) { @@ -4930,8 +4911,7 @@
_base_diag_reset(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)

 	drsprintk(ioc, pr_info(MPT3SAS_FMT
 		"Wait for FW to go to the READY state\n", ioc->name));
-	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY, 20,
-	    sleep_flag);
+	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY, 20);
 	if (ioc_state) {
 		pr_err(MPT3SAS_FMT
 			"%s: failed going to ready state
(ioc_state=0x%x)\n", @@ -4950,14 +4930,12 @@ _base_diag_reset(struct
MPT3SAS_ADAPTER *ioc, int sleep_flag)
 /**
  * _base_make_ioc_ready - put controller in READY state
  * @ioc: per adapter object
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  * @type: FORCE_BIG_HAMMER or SOFT_RESET
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, int sleep_flag,
-	enum reset_type type)
+_base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
 {
 	u32 ioc_state;
 	int rc;
@@ -4984,10 +4962,7 @@ _base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc,
int sleep_flag,
 				    ioc->name, __func__, ioc_state);
 				return -EFAULT;
 			}
-			if (sleep_flag == CAN_SLEEP)
-				ssleep(1);
-			else
-				mdelay(1000);
+			ssleep(1);
 			ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
 		}
 	}
@@ -5013,24 +4988,23 @@ _base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc,
int sleep_flag,

 	if ((ioc_state & MPI2_IOC_STATE_MASK) ==
MPI2_IOC_STATE_OPERATIONAL)
 		if (!(_base_send_ioc_reset(ioc,
-		    MPI2_FUNCTION_IOC_MESSAGE_UNIT_RESET, 15, CAN_SLEEP)))
{
+		    MPI2_FUNCTION_IOC_MESSAGE_UNIT_RESET, 15))) {
 			return 0;
 	}

  issue_diag_reset:
-	rc = _base_diag_reset(ioc, CAN_SLEEP);
+	rc = _base_diag_reset(ioc);
 	return rc;
 }

 /**
  * _base_make_ioc_operational - put controller in OPERATIONAL state
  * @ioc: per adapter object
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
+_base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
 {
 	int r, i, index;
 	unsigned long	flags;
@@ -5149,7 +5123,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER
*ioc, int sleep_flag)
 	}
  skip_init_reply_post_free_queue:

-	r = _base_send_ioc_init(ioc, sleep_flag);
+	r = _base_send_ioc_init(ioc);
 	if (r)
 		return r;

@@ -5175,13 +5149,11 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER
*ioc, int sleep_flag)
  skip_init_reply_post_host_index:

 	_base_unmask_interrupts(ioc);
-	r = _base_event_notification(ioc, sleep_flag);
+	r = _base_event_notification(ioc);
 	if (r)
 		return r;

-	if (sleep_flag == CAN_SLEEP)
-		_base_static_config_pages(ioc);
-
+	_base_static_config_pages(ioc);

 	if (ioc->is_driver_loading) {

@@ -5200,7 +5172,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER
*ioc, int sleep_flag)
 		return r; /* scan_start and scan_finished support */
 	}

-	r = _base_send_port_enable(ioc, sleep_flag);
+	r = _base_send_port_enable(ioc);
 	if (r)
 		return r;

@@ -5224,7 +5196,7 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER
*ioc)
 	if (ioc->chip_phys && ioc->chip) {
 		_base_mask_interrupts(ioc);
 		ioc->shost_recovery = 1;
-		_base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
+		_base_make_ioc_ready(ioc, SOFT_RESET);
 		ioc->shost_recovery = 0;
 	}

@@ -5292,7 +5264,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	}

 	pci_set_drvdata(ioc->pdev, ioc->shost);
-	r = _base_get_ioc_facts(ioc, CAN_SLEEP);
+	r = _base_get_ioc_facts(ioc);
 	if (r)
 		goto out_free_resources;

@@ -5326,7 +5298,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->build_sg_mpi = &_base_build_sg;
 	ioc->build_zero_len_sge_mpi = &_base_build_zero_len_sge;

-	r = _base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
+	r = _base_make_ioc_ready(ioc, SOFT_RESET);
 	if (r)
 		goto out_free_resources;

@@ -5338,12 +5310,12 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	}

 	for (i = 0 ; i < ioc->facts.NumberOfPorts; i++) {
-		r = _base_get_port_facts(ioc, i, CAN_SLEEP);
+		r = _base_get_port_facts(ioc, i);
 		if (r)
 			goto out_free_resources;
 	}

-	r = _base_allocate_memory_pools(ioc, CAN_SLEEP);
+	r = _base_allocate_memory_pools(ioc);
 	if (r)
 		goto out_free_resources;

@@ -5429,7 +5401,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	if (ioc->hba_mpi_version_belonged == MPI26_VERSION)
 		_base_unmask_events(ioc,
MPI2_EVENT_ACTIVE_CABLE_EXCEPTION);

-	r = _base_make_ioc_operational(ioc, CAN_SLEEP);
+	r = _base_make_ioc_operational(ioc);
 	if (r)
 		goto out_free_resources;

@@ -5565,21 +5537,18 @@ _base_reset_handler(struct MPT3SAS_ADAPTER *ioc,
int reset_phase)
 /**
  * _wait_for_commands_to_complete - reset controller
  * @ioc: Pointer to MPT_ADAPTER structure
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * This function waiting(3s) for all pending commands to complete
  * prior to putting controller in reset.
  */
 static void
-_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc, int
sleep_flag)
+_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 ioc_state;
 	unsigned long flags;
 	u16 i;

 	ioc->pending_io_count = 0;
-	if (sleep_flag != CAN_SLEEP)
-		return;

 	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
 	if ((ioc_state & MPI2_IOC_STATE_MASK) !=
MPI2_IOC_STATE_OPERATIONAL) @@ -5602,13 +5571,12 @@
_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc, int
sleep_flag)
 /**
  * mpt3sas_base_hard_reset_handler - reset controller
  * @ioc: Pointer to MPT_ADAPTER structure
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
  * @type: FORCE_BIG_HAMMER or SOFT_RESET
  *
  * Returns 0 for success, non-zero for failure.
  */
 int
-mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc, int
sleep_flag,
+mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 	enum reset_type type)
 {
 	int r;
@@ -5629,13 +5597,6 @@ mpt3sas_base_hard_reset_handler(struct
MPT3SAS_ADAPTER *ioc, int sleep_flag,
 	if (mpt3sas_fwfault_debug)
 		mpt3sas_halt_firmware(ioc);

-	/* TODO - What we really should be doing is pulling
-	 * out all the code associated with NO_SLEEP; its never used.
-	 * That is legacy code from mpt fusion driver, ported over.
-	 * I will leave this BUG_ON here for now till its been resolved.
-	 */
-	BUG_ON(sleep_flag == NO_SLEEP);
-
 	/* wait for an active reset in progress to complete */
 	if (!mutex_trylock(&ioc->reset_in_progress_mutex)) {
 		do {
@@ -5660,9 +5621,9 @@ mpt3sas_base_hard_reset_handler(struct
MPT3SAS_ADAPTER *ioc, int sleep_flag,
 			is_fault = 1;
 	}
 	_base_reset_handler(ioc, MPT3_IOC_PRE_RESET);
-	_wait_for_commands_to_complete(ioc, sleep_flag);
+	_wait_for_commands_to_complete(ioc);
 	_base_mask_interrupts(ioc);
-	r = _base_make_ioc_ready(ioc, sleep_flag, type);
+	r = _base_make_ioc_ready(ioc, type);
 	if (r)
 		goto out;
 	_base_reset_handler(ioc, MPT3_IOC_AFTER_RESET); @@ -5675,7 +5636,7
@@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc, int
sleep_flag,
 		r = -EFAULT;
 		goto out;
 	}
-	r = _base_get_ioc_facts(ioc, CAN_SLEEP);
+	r = _base_get_ioc_facts(ioc);
 	if (r)
 		goto out;

@@ -5684,7 +5645,7 @@ mpt3sas_base_hard_reset_handler(struct
MPT3SAS_ADAPTER *ioc, int sleep_flag,
 		      "Please reboot the system and ensure that the
correct"
 		      " firmware version is running\n", ioc->name);

-	r = _base_make_ioc_operational(ioc, sleep_flag);
+	r = _base_make_ioc_operational(ioc);
 	if (!r)
 		_base_reset_handler(ioc, MPT3_IOC_DONE_RESET);

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h
b/drivers/scsi/mpt3sas/mpt3sas_base.h
index f0baafd..3e71bc1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -119,10 +119,6 @@

 #define MPT_MAX_CALLBACKS		32

-
-#define	 CAN_SLEEP			1
-#define  NO_SLEEP			0
-
 #define INTERNAL_CMDS_COUNT		10	/* reserved cmds */
 /* reserved for issuing internally framed scsi io cmds */
 #define INTERNAL_SCSIIO_CMDS_COUNT	3
@@ -1219,7 +1215,7 @@ int mpt3sas_base_attach(struct MPT3SAS_ADAPTER
*ioc);  void mpt3sas_base_detach(struct MPT3SAS_ADAPTER *ioc);  int
mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc);  void
mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc); -int
mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc, int
sleep_flag,
+int mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 	enum reset_type type);

 void *mpt3sas_base_get_msg_frame(struct MPT3SAS_ADAPTER *ioc, u16 smid);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c
b/drivers/scsi/mpt3sas/mpt3sas_config.c
index a6914ec..022f27f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -491,8 +491,7 @@ _config_request(struct MPT3SAS_ADAPTER *ioc,
Mpi2ConfigRequest_t
 	mutex_unlock(&ioc->config_cmds.mutex);

 	if (issue_host_reset)
-		mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	return r;
 }

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 75ae533..c924012 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1005,8 +1005,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc,
struct mpt3_ioctl_command karg,
 			    le16_to_cpu(mpi_request->FunctionDependent1),
0, 0,
 			    0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
30);
 		} else
-			mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-			    FORCE_BIG_HAMMER);
+			mpt3sas_base_hard_reset_handler(ioc,
FORCE_BIG_HAMMER);
 	}

  out:
@@ -1219,8 +1218,7 @@ _ctl_do_reset(struct MPT3SAS_ADAPTER *ioc, void
__user *arg)
 	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s: enter\n", ioc->name,
 	    __func__));

-	retval = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-	    FORCE_BIG_HAMMER);
+	retval = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	pr_info(MPT3SAS_FMT "host reset: %s\n",
 	    ioc->name, ((!retval) ? "SUCCESS" : "FAILED"));
 	return 0;
@@ -1537,8 +1535,7 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,

  issue_host_reset:
 	if (issue_reset)
-		mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);

  out:

@@ -1973,8 +1970,7 @@ _ctl_diag_release(struct MPT3SAS_ADAPTER *ioc, void
__user *arg)
 	rc = mpt3sas_send_diag_release(ioc, buffer_type, &issue_reset);

 	if (issue_reset)
-		mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);

 	return rc;
 }
@@ -2154,8 +2150,7 @@ _ctl_diag_read_buffer(struct MPT3SAS_ADAPTER *ioc,
void __user *arg)

  issue_host_reset:
 	if (issue_reset)
-		mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);

  out:

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c93a7ba..22d75a2a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2241,16 +2241,14 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER
*ioc, u16 handle, uint channel,
 	if (ioc_state & MPI2_DOORBELL_USED) {
 		dhsprintk(ioc, pr_info(MPT3SAS_FMT
 			"unexpected doorbell active!\n", ioc->name));
-		rc = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		rc = mpt3sas_base_hard_reset_handler(ioc,
FORCE_BIG_HAMMER);
 		return (!rc) ? SUCCESS : FAILED;
 	}

 	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
 		mpt3sas_base_fault_info(ioc, ioc_state &
 		    MPI2_DOORBELL_DATA_MASK);
-		rc = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		rc = mpt3sas_base_hard_reset_handler(ioc,
FORCE_BIG_HAMMER);
 		return (!rc) ? SUCCESS : FAILED;
 	}

@@ -2292,8 +2290,8 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc,
u16 handle, uint channel,
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2SCSITaskManagementRequest_t)/4);
 		if (!(ioc->tm_cmds.status & MPT3_CMD_RESET)) {
-			rc = mpt3sas_base_hard_reset_handler(ioc,
CAN_SLEEP,
-			    FORCE_BIG_HAMMER);
+			rc = mpt3sas_base_hard_reset_handler(ioc,
+					FORCE_BIG_HAMMER);
 			rc = (!rc) ? SUCCESS : FAILED;
 			goto out;
 		}
@@ -2638,8 +2636,7 @@ scsih_host_reset(struct scsi_cmnd *scmd)
 		goto out;
 	}

-	retval = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-	    FORCE_BIG_HAMMER);
+	retval = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	r = (retval < 0) ? FAILED : SUCCESS;
 out:
 	pr_info(MPT3SAS_FMT "host reset: %s scmd(%p)\n", @@ -6295,8
+6292,7 @@ _scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8
phys_disk_num)
 	mutex_unlock(&ioc->scsih_cmds.mutex);

 	if (issue_reset)
-		mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	return rc;
 }

@@ -8914,7 +8910,7 @@ scsih_resume(struct pci_dev *pdev)
 	if (r)
 		return r;

-	mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP, SOFT_RESET);
+	mpt3sas_base_hard_reset_handler(ioc, SOFT_RESET);
 	scsi_unblock_requests(shost);
 	mpt3sas_base_start_watchdog(ioc);
 	return 0;
@@ -8985,8 +8981,7 @@ scsih_pci_slot_reset(struct pci_dev *pdev)
 	if (rc)
 		return PCI_ERS_RESULT_DISCONNECT;

-	rc = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-	    FORCE_BIG_HAMMER);
+	rc = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);

 	pr_warn(MPT3SAS_FMT "hard reset: %s\n", ioc->name,
 	    (rc == 0) ? "success" : "failed"); diff --git
a/drivers/scsi/mpt3sas/mpt3sas_transport.c
b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index ff93286..f58a8c6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -446,8 +446,7 @@ _transport_expander_report_manufacture(struct
MPT3SAS_ADAPTER *ioc,

  issue_host_reset:
 	if (issue_reset)
-		mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
  out:
 	ioc->transport_cmds.status = MPT3_CMD_NOT_USED;
 	if (data_out)
@@ -1253,8 +1252,7 @@ _transport_get_expander_phy_error_log(struct
MPT3SAS_ADAPTER *ioc,

  issue_host_reset:
 	if (issue_reset)
-		mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
  out:
 	ioc->transport_cmds.status = MPT3_CMD_NOT_USED;
 	if (data_out)
@@ -1564,8 +1562,7 @@ _transport_expander_phy_control(struct
MPT3SAS_ADAPTER *ioc,

  issue_host_reset:
 	if (issue_reset)
-		mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
  out:
 	ioc->transport_cmds.status = MPT3_CMD_NOT_USED;
 	if (data_out)
@@ -2103,8 +2100,7 @@ _transport_smp_handler(struct Scsi_Host *shost,
struct sas_rphy *rphy,

  issue_host_reset:
 	if (issue_reset) {
-		mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 		rc = -ETIMEDOUT;
 	}

--
2.8.0.rc2
