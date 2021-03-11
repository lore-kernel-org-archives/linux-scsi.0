Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56721C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 11:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07DEB64FCD
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 11:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhCKLIT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 06:08:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54443 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbhCKLH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 06:07:57 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lKJAa-0000wv-C4; Thu, 11 Mar 2021 11:07:56 +0000
From:   Colin Ian King <colin.king@canonical.com>
To:     Doug Gilbert <dgilbert@interlog.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: re: scsi: sg: Replace sg_allow_access()
Message-ID: <1f63da00-ef1e-25c9-1494-61ad43135f9e@canonical.com>
Date:   Thu, 11 Mar 2021 11:07:55 +0000
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
drivers/scsi/sg.c in function sg_remove_sfp_usercontext with the
following recent commit:

commit 0c32296d73ec5dec64729eb555f1a29ded8a7272
Author: Douglas Gilbert <dgilbert@interlog.com>
Date:   Fri Feb 19 21:00:28 2021 -0500

    scsi: sg: Replace sg_allow_access()

The analysis is as follows:

3913        if (unlikely(sfp != e_sfp))
3914                SG_LOG(1, sfp, "%s: xa_erase() return unexpected\n",
3915                       __func__);

    deref_ptr_in_call: Dereferencing pointer sdp.

3916        o_count = atomic_dec_return(&sdp->open_cnt);
3917        SG_LOG(3, sfp, "%s: dev o_count after=%d: sfp=0x%pK --\n",
__func__,
3918               o_count, sfp);
3919        kfree(sfp);
3920

Dereference before null check (REVERSE_INULL)
    check_after_deref: Null-checking sdp suggests that it may be null,
but it has already been dereferenced on all paths leading to the check.

3921        if (sdp) {
3922                scsi_device_put(sdp->device);
3923                kref_put(&sdp->d_ref, sg_device_destroy);
3924        }

Line 3916 dereferences pointer sdp with &sdp->open_cnt, however later on
in line 3921 sdp is being null checked.  Either the null check is
redundant if sdp is never null or there is a potential null pointer
dereference on line 3916.

Colin

