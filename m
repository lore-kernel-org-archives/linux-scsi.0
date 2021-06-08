Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C13C2C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 15:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9513660698
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 15:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhFHPqU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 11:46:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38912 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbhFHPqS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 11:46:18 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lqdtu-00075J-TS; Tue, 08 Jun 2021 15:44:22 +0000
From:   Colin Ian King <colin.king@canonical.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: re: scsi: ufs: Optimize host lock on transfer requests send/compl
 paths (uninitialized pointer error)
Message-ID: <fa66c94c-3df6-3813-dc2d-572cee16071b@canonical.com>
Date:   Tue, 8 Jun 2021 16:44:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

static analysis with Coverity on linux-next has found an issue in
drivers/scsi/ufs/ufshcd.c introduced by the following commit:

commit a45f937110fa6b0c2c06a5d3ef026963a5759050
Author: Can Guo <cang@codeaurora.org>
Date:   Mon May 24 01:36:57 2021 -0700

    scsi: ufs: Optimize host lock on transfer requests send/compl paths

The analysis is as follows:


2948 static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
2949                enum dev_cmd_type cmd_type, int timeout)
2950 {
2951        struct request_queue *q = hba->cmd_queue;
2952        struct request *req;

    1. var_decl: Declaring variable lrbp without initializer.

2953        struct ufshcd_lrb *lrbp;
2954        int err;
2955        int tag;
2956        struct completion wait;
2957
2958        down_read(&hba->clk_scaling_lock);
2959
2960        /*
2961         * Get free slot, sleep if slots are unavailable.
2962         * Even though we use wait_event() which sleeps indefinitely,
2963         * the maximum wait time is bounded by SCSI request timeout.
2964         */
2965        req = blk_get_request(q, REQ_OP_DRV_OUT, 0);

    2. Condition IS_ERR(req), taking false branch.

2966        if (IS_ERR(req)) {
2967                err = PTR_ERR(req);
2968                goto out_unlock;
2969        }
2970        tag = req->tag;

    3. Condition !!__ret_warn_on, taking false branch.
    4. Condition !!__ret_warn_on, taking false branch.

2971        WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
2972        /* Set the timeout such that the SCSI error handler is not
activated. */
2973        req->timeout = msecs_to_jiffies(2 * timeout);
2974        blk_mq_start_request(req);
2975

    5. Condition !!test_bit(tag, &hba->outstanding_reqs), taking true
branch.

2976        if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
2977                err = -EBUSY;

    6. Jumping to label out.

2978                goto out;
2979        }
2980
2981        init_completion(&wait);
2982        lrbp = &hba->lrb[tag];
2983        WARN_ON(lrbp->cmd);
2984        err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
2985        if (unlikely(err))
2986                goto out_put_tag;
2987
2988        hba->dev_cmd.complete = &wait;
2989
2990        ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND,
lrbp->ucd_req_ptr);
2991        /* Make sure descriptors are ready before ringing the
doorbell */
2992        wmb();
2993
2994        ufshcd_send_command(hba, tag);
2995        err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
2996 out:

    7. Condition err, taking true branch.

    Uninitialized pointer read (UNINIT)
    8. uninit_use: Using uninitialized value lrbp.

2997        ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR :
UFS_QUERY_COMP,
2998                                    (struct utp_upiu_req
*)lrbp->ucd_rsp_ptr);
2999
3000 out_put_tag:
3001        blk_put_request(req);
3002 out_unlock:
3003        up_read(&hba->clk_scaling_lock);
3004        return err;
3005 }

Pointer lrbp is being accessed on the error exit path on line 2989
because it is no longer being initialized early, the pointer assignment
was moved to a later point (line 2982) by the commit referenced in the
top of the email.

Colin
