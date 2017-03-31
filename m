From: Joe Jin <joe.jin@oracle.com>
Subject: commit 1b6ac5e3f "fnic: Using rport->dd_data to check rport online
 instead of rport_lookup."
Date: Fri, 31 Mar 2017 08:36:43 +0800
Message-ID: <58DDA49B.6000300@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41039 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933345AbdCaAgn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2017 20:36:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: satishkh@cisco.com
Cc: linux-scsi@vger.kernel.org

Hi Satish,

My customer hit below error when issue LIP to fnic controller:

[94702.898408] sd 2:0:4:1: [sdx] tag#1 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[94702.898416] sd 2:0:4:1: [sdx] tag#1 CDB: Write(10) 2a 00 04 56 c0 08 00 00 08 00
[94702.898420] blk_update_request: I/O error, dev sdx, sector 72794120
[94702.898455] sd 2:0:4:10: [sdy] tag#2 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[94702.898459] sd 2:0:4:10: [sdy] tag#2 CDB: Read(10) 28 00 00 00 08 a8 00 00 02 00
[94702.898462] blk_update_request: I/O error, dev sdy, sector 2216

Looked at all changes of fnic I found it caused by commit 1b6ac5e3f "fnic: 
Using rport->dd_data to check rport online instead of rport_lookup.", a 
question is why changed state check from RPORT_ST_DELETE to RPORT_ST_READY
here?

-       if (!rdata || (rdata->rp_state == RPORT_ST_DELETE)) { 
-               FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-                       "returning IO as rport is removed\n");
-               atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
-               sc->result = DID_NO_CONNECT;
-               done(sc);
-               return 0;
+       if (rport) {
+               struct fc_rport_libfc_priv *rp = rport->dd_data;
+
+               if (!rp || rp->rp_state != RPORT_ST_READY) {
+                       FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+                               "returning DID_NO_CONNECT for IO as rport is removed\n");


Thanks,
Joe
