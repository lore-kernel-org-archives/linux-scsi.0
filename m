Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E42C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 10:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C9E164E28
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 10:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhCKKA0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 05:00:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52573 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbhCKKAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 05:00:23 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lKI7C-0004di-0C; Thu, 11 Mar 2021 10:00:22 +0000
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: scsi: sg: NO_DXFER move to/from kernel buffers
Message-ID: <4375985d-7e0e-b76c-9fdf-5430d2951d51@canonical.com>
Date:   Thu, 11 Mar 2021 10:00:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Static analysis on linux-next with Coverity has detected an issue in
drivers/scsi/sg.c with the following recent commit:

commit b32ac463cb59e758b4560260fd168a2b4ea6e81a
Author: Douglas Gilbert <dgilbert@interlog.com>
Date:   Fri Feb 19 21:00:54 2021 -0500

    scsi: sg: NO_DXFER move to/from kernel buffers

The analysis is as follows:

2973 sg_rq_map_kern(struct sg_request *srp, struct request_queue *q,
struct request *rqq, int rw_ind)
2974 {
2975        struct sg_scatter_hold *schp = &srp->sgat_h;
2976        struct bio *bio;

    1. var_decl: Declaring variable k without initializer.

2977        int k, ln;
2978        int op_flags = 0;
2979        int num_sgat = schp->num_sgat;
2980        int dlen = schp->dlen;
2981        int pg_sz = 1 << (PAGE_SHIFT + schp->page_order);
2982        int num_segs = (1 << schp->page_order) * num_sgat;
2983        int res = 0;
2984

    2. Condition _sdp, taking true branch.
    3. Condition _sdp->disk, taking true branch.
    4. Condition !!(_sdp && _sdp->disk), taking true branch.
    5. Condition !!(((scsi_logging_level >> 3) & 7U /* (1 << 3) - 1 */)
> 4), taking true branch.
    6. Condition !!(((scsi_logging_level >> 3) & 7U /* (1 << 3) - 1 */)
> 4), taking true branch.
    7. Falling through to end of if statement.

2985        SG_LOG(4, srp->parentfp, "%s: dlen=%d, pg_sz=%d\n",
__func__, dlen, pg_sz);

    8. Condition num_sgat <= 0, taking false branch.

2986        if (num_sgat <= 0)
2987                return 0;

    9. Condition rw_ind == 1, taking true branch.

2988        if (rw_ind == WRITE)
2989                op_flags = REQ_SYNC | REQ_IDLE;
    Uninitialized scalar variable
    10. uninit_use: Using uninitialized value k.

2990        bio = sg_mk_kern_bio(num_sgat - k);
2991        if (!bio)

Variable k is not initialized, however it is being read when it contains
a garbage value.

Colin
