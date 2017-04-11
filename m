From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH] ipr: do not set DID_PASSTHROUGH on CHECK CONDITION
Date: Tue, 11 Apr 2017 11:46:04 -0300
Message-ID: <1491921964-11077-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42054 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751047AbdDKOqM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Apr 2017 10:46:12 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3BEdCh1130402
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 10:46:11 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29rn507tct-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 10:46:11 -0400
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Tue, 11 Apr 2017 11:46:08 -0300
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v3BEk5lv3080634
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 11:46:05 -0300
Received: from d24av05.br.ibm.com (localhost [127.0.0.1])
        by d24av05.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v3BEk7Mv001781
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 11:46:07 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, brking@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com

On a dual controller setup with multipath enabled, some MEDIUM ERRORs
caused both paths to be failed, thus I/O got queued/blocked since the
'queue_if_no_path' feature is enabled by default on IPR controllers.

This example disabled 'queue_if_no_path' so the I/O failure is seen at
the sg_dd program.  Notice that after the sg_dd test-case, both paths
are in 'failed' state, and both path/priority groups are in 'enabled'
state (not 'active') -- which would block I/O with 'queue_if_no_path'.

    # sg_dd if=/dev/dm-2 bs=4096 count=1 dio=1 verbose=4 blk_sgio=0
    <...>
    read(unix): count=4096, res=-1
    sg_dd: reading, skip=0 : Input/output error
    <...>

    # dmesg
    [...] sd 2:2:16:0: [sds] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
    [...] sd 2:2:16:0: [sds] Sense Key : Medium Error [current]
    [...] sd 2:2:16:0: [sds] Add. Sense: Unrecovered read error - recommend rewrite the data
    [...] sd 2:2:16:0: [sds] CDB: Read(10) 28 00 00 00 00 00 00 00 20 00
    [...] blk_update_request: I/O error, dev sds, sector 0
    [...] device-mapper: multipath: Failing path 65:32.
    <...>
    [...] device-mapper: multipath: Failing path 65:224.

    # multipath -l
    1IBM_IPR-0_59C2AE0000001F80 dm-2 IBM     ,IPR-0   59C2AE00
    size=5.2T features='0' hwhandler='1 alua' wp=rw
    |-+- policy='service-time 0' prio=0 status=enabled
    | `- 2:2:16:0 sds  65:32  failed undef running
    `-+- policy='service-time 0' prio=0 status=enabled
      `- 1:2:7:0  sdae 65:224 failed undef running

This is not the desired behavior. The dm-multipath explicitly checks
for the MEDIUM ERROR case (and a few others) so not to fail the path
(e.g., I/O to other sectors could potentially happen without problems).
See dm-mpath.c :: do_end_io_bio() -> noretry_error() !->! fail_path().

The problem trace is:

1) ipr_scsi_done()  // SENSE KEY/CHECK CONDITION detected, go to..
2) ipr_erp_start()  // ipr_is_gscsi() and masked_ioasc OK, go to..
3) ipr_gen_sense()  // masked_ioasc is IPR_IOASC_MED_DO_NOT_REALLOC,
                    // so set DID_PASSTHROUGH.

4) scsi_decide_disposition()  // check for DID_PASSTHROUGH and return
                              // early on, faking a DID_OK.. *instead*
                              // of reaching scsi_check_sense().

                              // Had it reached the latter, that would
                              // set host_byte to DID_MEDIUM_ERROR.

5) scsi_finish_command()
6) scsi_io_completion()
7) __scsi_error_from_host_byte()  // That would be converted to -ENODATA
<...>
8) dm_softirq_done()
9) multipath_end_io()
10) do_end_io()
11) noretry_error()  // And that is checked in dm-mpath :: noretry_error()
                     // which would cause fail_path() not to be called.

With this patch applied, the I/O is failed but the paths are not.  This
multipath device continues accepting more I/O requests without blocking.
(and notice the different host byte/driver byte handling per SCSI layer).

    # dmesg
    [...] sd 2:2:7:0: [sdaf] Done: SUCCESS Result: hostbyte=0x13 driverbyte=DRIVER_OK
    [...] sd 2:2:7:0: [sdaf] CDB: Read(10) 28 00 00 00 00 00 00 00 40 00
    [...] sd 2:2:7:0: [sdaf] Sense Key : Medium Error [current]
    [...] sd 2:2:7:0: [sdaf] Add. Sense: Unrecovered read error - recommend rewrite the data
    [...] blk_update_request: critical medium error, dev sdaf, sector 0
    [...] blk_update_request: critical medium error, dev dm-6, sector 0
    [...] sd 2:2:7:0: [sdaf] Done: SUCCESS Result: hostbyte=0x13 driverbyte=DRIVER_OK
    [...] sd 2:2:7:0: [sdaf] CDB: Read(10) 28 00 00 00 00 00 00 00 10 00
    [...] sd 2:2:7:0: [sdaf] Sense Key : Medium Error [current]
    [...] sd 2:2:7:0: [sdaf] Add. Sense: Unrecovered read error - recommend rewrite the data
    [...] blk_update_request: critical medium error, dev sdaf, sector 0
    [...] blk_update_request: critical medium error, dev dm-6, sector 0
    [...] Buffer I/O error on dev dm-6, logical block 0, async page read

    # multipath -l 1IBM_IPR-0_59C2AE0000001F80
    1IBM_IPR-0_59C2AE0000001F80 dm-6 IBM     ,IPR-0   59C2AE00
    size=5.2T features='1 queue_if_no_path' hwhandler='1 alua' wp=rw
    |-+- policy='service-time 0' prio=0 status=active
    | `- 2:2:7:0  sdaf 65:240 active undef running
    `-+- policy='service-time 0' prio=0 status=enabled
      `- 1:2:7:0  sdh  8:112  active undef running

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
---
v2:
 - use the scsi_cmd local variable rather than ipr_cmd->scsi_cmd dereference.
 - add Acked-by: Brian King.

 drivers/scsi/ipr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b29afafc2885..5d5e272fd815 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6293,7 +6293,12 @@ static void ipr_erp_start(struct ipr_ioa_cfg *ioa_cfg,
 		break;
 	case IPR_IOASC_MED_DO_NOT_REALLOC: /* prevent retries */
 	case IPR_IOASA_IR_DUAL_IOA_DISABLED:
-		scsi_cmd->result |= (DID_PASSTHROUGH << 16);
+		/*
+		 * exception: do not set DID_PASSTHROUGH on CHECK CONDITION
+		 * so SCSI mid-layer and upper layers handle it accordingly.
+		 */
+		if (scsi_cmd->result != SAM_STAT_CHECK_CONDITION)
+			scsi_cmd->result |= (DID_PASSTHROUGH << 16);
 		break;
 	case IPR_IOASC_BUS_WAS_RESET:
 	case IPR_IOASC_BUS_WAS_RESET_BY_OTHER:
-- 
1.8.3.1
