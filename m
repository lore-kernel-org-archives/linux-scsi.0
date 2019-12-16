Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216D6C2D0BF
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 05:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC51D2075A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 05:46:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Gs8rQLRp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfLPFqE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 00:46:04 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:19776 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726438AbfLPFqD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Dec 2019 00:46:03 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576475163; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=qg/crsYJ805SaB7SnWEp5NQgL9nFr3ZPMXuozq5iHo0=;
 b=Gs8rQLRpp82+wvxPfLSxG/qpGj4ZPsOoEJvjvosMlUNgzoL6LMFp/mBSu+f8mRBt9MWKRcGd
 IcNBdvCDCBR94xLfwUzQnna1C5O6R5O4fVXuYzx/UhfmYK8UV4xr7xU2MNqhFvNxUUFJQuC8
 Cdht0rnVEb4Tkl4/1zh0hShvTg8=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df71a19.7f0224643bc8-smtp-out-n02;
 Mon, 16 Dec 2019 05:46:01 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1F4F9C447B3; Mon, 16 Dec 2019 05:46:01 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2E280C447A3;
        Mon, 16 Dec 2019 05:46:00 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 16 Dec 2019 13:46:00 +0800
From:   cang@codeaurora.org
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: ufs: Put SCSI host after remove it
In-Reply-To: <0419d33a1ea98a2da9263131aba2ca71@codeaurora.org>
References: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
 <1576328616-30404-2-git-send-email-cang@codeaurora.org>
 <85475247-efd5-732e-ae74-6d9a11e1bdf2@acm.org>
 <5aa3a266e3db3403e663b36ddfdc4d60@codeaurora.org>
 <2956b9c7-b019-e2b3-7a1b-7b796b724add@acm.org>
 <3afbe71cc9f0626edf66f7bc13b331f4@codeaurora.org>
 <5b77c25f-3cc7-f90b-fcd7-dd4c1e2f46d2@acm.org>
 <0419d33a1ea98a2da9263131aba2ca71@codeaurora.org>
Message-ID: <3c289f786dd09d84bc1a8b0b3d855784@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-16 11:12, cang@codeaurora.org wrote:
> On 2019-12-16 10:39, Bart Van Assche wrote:
>> On 2019-12-15 17:34, cang@codeaurora.org wrote:
>>> This is applied to 5.5/scsi-queue. The two changes I patsed from you 
>>> are
>>> not merged yet, I am still doing code review to them, so there is no
>>> blk_cleanup_queue() calls in my code base. I am just saying you may 
>>> move
>>> your blk_cleanup_queue() calls below cancel_work_sync(&hba->eh_work) 
>>> if
>>> my change applies. How do you think?
>>> 
>>> scsi_host_put() was there before but explicitly removed by
>>> afa3dfd42d205b106787476647735aa1de1a5d02. I agree with you, without 
>>> this
>>> change, there is memory leak.
>> 
>> Hi Can,
>> 
>> Since your patch restores a call that was removed earlier, please
>> consider adding a Fixes: tag to your patch.
>> 
>> Please also have a look at
>> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=5.6/scsi-queue.
>> As one can see my patches that introduce blk_cleanup_queue() and
>> blk_mq_free_tag_set() calls have already been queued on Martin's
>> 5.6/scsi-queue branch.
>> 
>> Bart.
> 
> Hi Bart,
> 
> Sure, I will add the Fixes tag and rebase my changes. How about the 
> logic
> part of this change? Does it look good to you?
> 
> Sorry I was not aware of that your changes have been applied to 
> 5.6/scsi-queue.
> I am still trying to get it tested on my setups...
> Anyways, aside of hba->cmd_queue, tearing down hba->tmf_queue before
> scsi_remove_host() may be problem too. Requests can still be
> sent before and during scsi_remove_host(). If a request timed out,
> task abort will be invoked to abort the request, during which
> hba->tmf_queue is expected to be present. Please correct me if I am 
> wrong.
> 
> Thanks,
> 
> Can Guo.

Hi Bart

Just found that I should also remove the ufshcd_dealloc_host() called
in ufshcd_pci_remove() to make sure the deallocation is only handled by
ufshcd_remove().

Thanks,

Can Guo.
