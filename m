Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE7DC2BB40
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 00:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB84F2226A
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 00:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgLOAct (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 19:32:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41927 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgLOAcf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 19:32:35 -0500
Received: from cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net ([80.193.200.194] helo=[192.168.0.209])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1koyFt-0006Ai-Ls; Tue, 15 Dec 2020 00:31:53 +0000
To:     Can Guo <cang@codeaurora.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: scsi: ufs: Serialize eh_work with system PM events and async scan
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <491799be-ea2e-5b60-b14b-bbdfd516d7ac@canonical.com>
Date:   Tue, 15 Dec 2020 00:31:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Static analysis on linux-next with Coverity had found a potential null
pointer dereference issue in the following commit:

commit 88a92d6ae4fe09b2b27781178c5c9432d27b1ffb
Author: Can Guo <cang@codeaurora.org>
Date:   Wed Dec 2 04:04:01 2020 -0800

    scsi: ufs: Serialize eh_work with system PM events and async scan

The analysis by Coverity is as follows:

8929 int ufshcd_system_suspend(struct ufs_hba *hba)
8930 {
8931        int ret = 0;
8932        ktime_t start = ktime_get();
8933
    deref_ptr_in_call: Dereferencing pointer hba.

8934        down(&hba->eh_sem);

    Dereference before null check (REVERSE_INULL)

check_after_deref: Null-checking hba suggests that it may be null, but
it has already been dereferenced on all paths leading to the check.

8935        if (!hba || !hba->is_powered)
8936                return 0;

Seeing that the down lock has been added by the commit it suggests the
commit overlooks the fact that hba may potentially be null. Not sure if
hba can be null, so I'm not sure if this is a real bug or a false positive.

Colin

