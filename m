From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 1/4] scsi: scsi_dh_alua: allow I/O in the target port unavailable state
Date: Mon, 10 Apr 2017 22:17:58 -0300
Message-ID: <1491873481-23900-2-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46891 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752546AbdDKBSO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Apr 2017 21:18:14 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3B1HJRN022716
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 21:18:13 -0400
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29r99u8kh2-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 21:18:13 -0400
Received: from localhost
        by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 10 Apr 2017 22:18:11 -0300
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v3B1I9Ug26804286
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 22:18:09 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v3B1I8QV017580
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 22:18:08 -0300
In-Reply-To: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com

According to SPC-4 (5.15.2.4.5 Unavailable state), the unavailable
state may (or may not) transition to other states (e.g., microcode
downloading or hardware error, which may be temporary or permanent
conditions, respectively).

But, scsi_dh_alua currently fails the I/O requests early once that
state is established (in alua_prep_fn()), which provides no chance
for path checkers going through that function path to really check
whether the path actually still fails I/O requests or recovered to
an active state.

This might cause device-mapper multipath to fail all paths to some
storage system that moves the controllers to the unavailable state
for firmware upgrades, and never recover regardless of the storage
system doing upgrades one controller at a time and get them online.

Then I/O requests are blocked indefinitely due to queue_if_no_path
but the underlying individual paths are fully operational, and can
be verified as such through other function paths (e.g., SG_IO):

    # multipath -l
    mpatha (360050764008100dac000000000000100) dm-0 IBM,2145
    size=40G features='2 queue_if_no_path retain_attached_hw_handler'
    hwhandler='1 alua' wp=rw
    |-+- policy='service-time 0' prio=0 status=enabled
    | |- 1:0:1:0 sdf 8:80  failed undef running
    | `- 2:0:1:0 sdn 8:208 failed undef running
    `-+- policy='service-time 0' prio=0 status=enabled
      |- 1:0:0:0 sdb 8:16  failed undef running
      `- 2:0:0:0 sdj 8:144 failed undef running

    # strace -e read \
        sg_dd if=/dev/sdj of=/dev/null bs=512 count=1 iflag=direct \
        2>&1 | grep 512
    read(3, 0x3fff7ba80000, 512) = -1 EIO (Input/output error)

    # strace -e ioctl \
        sg_dd if=/dev/sdj of=/dev/null bs=512 count=1 iflag=direct \
        blk_sgio=1 \
        2>&1 | grep 512
    ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[10]=[28, 00, 00, 00,
    00, 00, 00, 00, 01, 00], <...>) = 0

So, allow I/O to target port (groups) in the unavailable state, so the
path checkers can actually check them, and schedule a recheck whenever
the unavailable state is detected so pg->state can be updated properly
(and further SCSI IO error messages then silenced through alua_prep_fn()).

Once a path checker eventually detects an active state again, the port
group state will be updated by the path activation call, alua_activate(),
as it schedules an alua_rtpg() check.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index c01b47e5b55a..5e5a33cac951 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -431,6 +431,20 @@ static int alua_check_sense(struct scsi_device *sdev,
 			alua_check(sdev, false);
 			return NEEDS_RETRY;
 		}
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0c) {
+			/*
+			 * LUN Not Accessible - target port in unavailable state.
+			 *
+			 * It may (not) be possible to transition to other states;
+			 * the transition might take a while or not happen at all,
+			 * depending on the storage system model, error type, etc.
+			 *
+			 * Do not retry, so failover to another target port occur.
+			 * Schedule a recheck to update state for other functions.
+			 */
+			alua_check(sdev, true);
+			return SUCCESS;
+		}
 		break;
 	case UNIT_ATTENTION:
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
@@ -1057,6 +1071,8 @@ static void alua_check(struct scsi_device *sdev, bool force)
  *
  * Fail I/O to all paths not in state
  * active/optimized or active/non-optimized.
+ * Allow I/O to all paths in state unavailable
+ * so path checkers can actually check them.
  */
 static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 {
@@ -1072,6 +1088,8 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 	rcu_read_unlock();
 	if (state == SCSI_ACCESS_STATE_TRANSITIONING)
 		ret = BLKPREP_DEFER;
+	else if (state == SCSI_ACCESS_STATE_UNAVAILABLE)
+		req->rq_flags |= RQF_QUIET;
 	else if (state != SCSI_ACCESS_STATE_OPTIMAL &&
 		 state != SCSI_ACCESS_STATE_ACTIVE &&
 		 state != SCSI_ACCESS_STATE_LBA) {
-- 
1.8.3.1
