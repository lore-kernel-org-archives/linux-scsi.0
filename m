Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B9CC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 23:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A76B61076
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 23:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhCaXoD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 19:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229486AbhCaXng (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 19:43:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BBB760C3E;
        Wed, 31 Mar 2021 23:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617234216;
        bh=y9REhSnSTBr9I8rgkZ3Ma5J00fwbHmJxEfLgak8mJKU=;
        h=Date:From:To:Cc:Subject:From;
        b=QGejDCJapO204hq/HX5MNq1WHOclMyy6AqHcLAu74CLi816sbHVUXKGEW543lmu3s
         CwFGh/wK1737ywIRXHSdQTV7RtxZX87I+r2lpHhAHk2yR03t6wd894lMFwiman1+AD
         x/3uPUCM9z/7oRVGvxA4KuilfLQEW01bQXojpsJ83GuksxOUd77O1C84pZiquJ7HIj
         FG/8q4agFMCKzW3BBK0SZ7eZkDz7gCdwQyFznt9CAtPRkghK2Y+TMa3Czai5e8R41O
         OXwmWBDXzrbY3zn+2BZ/w4Ei9K2DwlE8T6y5Vlgye3vEW2r3+cvXT/DDeFqFYD6+RN
         ZRluM44BFaWzA==
Date:   Wed, 31 Mar 2021 17:43:38 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: ufs: Fix out-of-bounds warnings in
 ufshcd_exec_raw_upiu_cmd
Message-ID: <20210331224338.GA347171@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following out-of-bounds warnings by enclosing
some structure members into new structure objects upiu_req
and upiu_rsp:

include/linux/fortify-string.h:20:29: warning: '__builtin_memcpy' offset [29, 48] from the object at 'treq' is out of the bounds of referenced subobject 'req_header' with type 'struct utp_upiu_header' at offset 16 [-Warray-bounds]
include/linux/fortify-string.h:20:29: warning: '__builtin_memcpy' offset [61, 80] from the object at 'treq' is out of the bounds of referenced subobject 'rsp_header' with type 'struct utp_upiu_header' at offset 48 [-Warray-bounds]
arch/m68k/include/asm/string.h:72:25: warning: '__builtin_memcpy' offset [29, 48] from the object at 'treq' is out of the bounds of referenced subobject 'req_header' with type 'struct utp_upiu_header' at offset 16 [-Warray-bounds]
arch/m68k/include/asm/string.h:72:25: warning: '__builtin_memcpy' offset [61, 80] from the object at 'treq' is out of the bounds of referenced subobject 'rsp_header' with type 'struct utp_upiu_header' at offset 48 [-Warray-bounds]

Refactor the code by making it more structured.

The problem is that the original code is trying to copy data into a
bunch of struct members adjacent to each other in a single call to
memcpy(). Now that a new struct _upiu_req_ enclosing all those adjacent
members is introduced, memcpy() doesn't overrun the length of
&treq.req_header, because the address of the new struct object
_upiu_req_ is used as the destination, instead. The same problem
is present when memcpy() overruns the length of the source
&treq.rsp_header; in this case the address of the new struct
object _upiu_rsp_ is used, instead.

Also, this helps with the ongoing efforts to enable -Warray-bounds
and avoid confusing the compiler.

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Build-tested-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/60640558.lsAxiK6otPwTo9rv%25lkp@intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 28 ++++++++++++++++------------
 drivers/scsi/ufs/ufshci.h | 22 +++++++++++++---------
 2 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7539a4ee9494..324eb641e66f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -336,11 +336,15 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 		return;
 
 	if (str_t == UFS_TM_SEND)
-		trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->req_header,
-				  &descp->input_param1, UFS_TSF_TM_INPUT);
+		trace_ufshcd_upiu(dev_name(hba->dev), str_t,
+				  &descp->upiu_req.req_header,
+				  &descp->upiu_req.input_param1,
+				  UFS_TSF_TM_INPUT);
 	else
-		trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->rsp_header,
-				  &descp->output_param1, UFS_TSF_TM_OUTPUT);
+		trace_ufshcd_upiu(dev_name(hba->dev), str_t,
+				  &descp->upiu_rsp.rsp_header,
+				  &descp->upiu_rsp.output_param1,
+				  UFS_TSF_TM_OUTPUT);
 }
 
 static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
@@ -6420,7 +6424,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	spin_lock_irqsave(host->host_lock, flags);
 	task_tag = hba->nutrs + free_slot;
 
-	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
+	treq->upiu_req.req_header.dword_0 |= cpu_to_be32(task_tag);
 
 	memcpy(hba->utmrdl_base_addr + free_slot, treq, sizeof(*treq));
 	ufshcd_vops_setup_task_mgmt(hba, free_slot, tm_function);
@@ -6493,16 +6497,16 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	treq.header.dword_2 = cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
 
 	/* Configure task request UPIU */
-	treq.req_header.dword_0 = cpu_to_be32(lun_id << 8) |
+	treq.upiu_req.req_header.dword_0 = cpu_to_be32(lun_id << 8) |
 				  cpu_to_be32(UPIU_TRANSACTION_TASK_REQ << 24);
-	treq.req_header.dword_1 = cpu_to_be32(tm_function << 16);
+	treq.upiu_req.req_header.dword_1 = cpu_to_be32(tm_function << 16);
 
 	/*
 	 * The host shall provide the same value for LUN field in the basic
 	 * header and for Input Parameter.
 	 */
-	treq.input_param1 = cpu_to_be32(lun_id);
-	treq.input_param2 = cpu_to_be32(task_id);
+	treq.upiu_req.input_param1 = cpu_to_be32(lun_id);
+	treq.upiu_req.input_param2 = cpu_to_be32(task_id);
 
 	err = __ufshcd_issue_tm_cmd(hba, &treq, tm_function);
 	if (err == -ETIMEDOUT)
@@ -6513,7 +6517,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 		dev_err(hba->dev, "%s: failed, ocs = 0x%x\n",
 				__func__, ocs_value);
 	else if (tm_response)
-		*tm_response = be32_to_cpu(treq.output_param1) &
+		*tm_response = be32_to_cpu(treq.upiu_rsp.output_param1) &
 				MASK_TM_SERVICE_RESP;
 	return err;
 }
@@ -6693,7 +6697,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 		treq.header.dword_0 = cpu_to_le32(UTP_REQ_DESC_INT_CMD);
 		treq.header.dword_2 = cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
 
-		memcpy(&treq.req_header, req_upiu, sizeof(*req_upiu));
+		memcpy(&treq.upiu_req, req_upiu, sizeof(*req_upiu));
 
 		err = __ufshcd_issue_tm_cmd(hba, &treq, tm_f);
 		if (err == -ETIMEDOUT)
@@ -6706,7 +6710,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			break;
 		}
 
-		memcpy(rsp_upiu, &treq.rsp_header, sizeof(*rsp_upiu));
+		memcpy(rsp_upiu, &treq.upiu_rsp, sizeof(*rsp_upiu));
 
 		break;
 	default:
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 6795e1f0e8f8..235236859285 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -482,17 +482,21 @@ struct utp_task_req_desc {
 	struct request_desc_header header;
 
 	/* DW 4-11 - Task request UPIU structure */
-	struct utp_upiu_header	req_header;
-	__be32			input_param1;
-	__be32			input_param2;
-	__be32			input_param3;
-	__be32			__reserved1[2];
+	struct {
+		struct utp_upiu_header	req_header;
+		__be32			input_param1;
+		__be32			input_param2;
+		__be32			input_param3;
+		__be32			__reserved1[2];
+	} upiu_req;
 
 	/* DW 12-19 - Task Management Response UPIU structure */
-	struct utp_upiu_header	rsp_header;
-	__be32			output_param1;
-	__be32			output_param2;
-	__be32			__reserved2[3];
+	struct {
+		struct utp_upiu_header	rsp_header;
+		__be32			output_param1;
+		__be32			output_param2;
+		__be32			__reserved2[3];
+	} upiu_rsp;
 };
 
 #endif /* End of Header */
-- 
2.27.0

