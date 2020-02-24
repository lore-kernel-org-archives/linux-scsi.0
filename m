Return-Path: <SRS0=fKRq=4M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974C1C35641
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 04:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69BC220656
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 04:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="s372z7mH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgBXExb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Feb 2020 23:53:31 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:26524 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727218AbgBXExa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Feb 2020 23:53:30 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1582520010; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=GKF6gMAvq1n6K8Hw8rqRR5F497xlyJWX7uFbKRVBgJc=;
 b=s372z7mH2NDi1mxGdq9PQPbmivbfp4KAQf/GNJlLvzhYUP7pX1QtYiCmelOuG8oCqrijUEwl
 ra0iaNAUxY6IZLIXigOSS8GNv527QQWlkjiS052tjPiNh4NwPDBadGQYXTR1DuR7/EBPZdGV
 gm3hZxqPtTxGmdMipytr4d/o45g=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e5356ca.7f74d0375730-smtp-out-n01;
 Mon, 24 Feb 2020 04:53:30 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 01A9DC447A5; Mon, 24 Feb 2020 04:53:27 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C3B89C43383;
        Mon, 24 Feb 2020 04:53:26 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 24 Feb 2020 12:53:26 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Allow vendor apply device quirks in
 advance
In-Reply-To: <1582519179.26304.72.camel@mtksdccf07>
References: <1582517363-11536-1-git-send-email-cang@codeaurora.org>
 <1582517363-11536-2-git-send-email-cang@codeaurora.org>
 <1582519179.26304.72.camel@mtksdccf07>
Message-ID: <f37bf56d4283624a5bb3b2854e841ae8@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-02-24 12:39, Stanley Chu wrote:
> Hi Can,
> 
> On Sun, 2020-02-23 at 20:09 -0800, Can Guo wrote:
>> Currently ufshcd_vops_apply_dev_quirks() comes after all UniPro 
>> parameters
>> have been tuned. Move it up so that vendors have a chance to apply 
>> device
>> quirks in advance.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
> 
> As discussed, ufs-mediatek needs to do corresponding patch and I will
> submit it once this commit is merged.
> 
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>

Yes, sure, thanks for your cooperation. :)

Best Regards,
Can Guo.
