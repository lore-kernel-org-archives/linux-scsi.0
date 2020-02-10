Return-Path: <SRS0=AJIY=36=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C19DC3F68F
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 01:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C9B420870
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 01:59:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Z0O73LDg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgBJB7a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Feb 2020 20:59:30 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:11470 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726207AbgBJB7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Feb 2020 20:59:30 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581299969; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=N2ueIASSsPG9v5/Y5fOzat7g9SFpFYPheldlsYo4p6w=;
 b=Z0O73LDgiEje+uQGBqVHlaP2e7ysUcNFYxrP5iF4hzfXR9kTmv5bXyuwfNQ7hgL6apsjU/GM
 bYT6NMOohI67NfwQkFNh9sGL3CpaqkVVHAOi+Fvoxa7laGv1Ksue8xYzhRLGBfVAJQRcfMOs
 lf0Z8ofUxGz4Z6EwFFSxn7WpMUY=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e40b8fb.7fc587f09fb8-smtp-out-n03;
 Mon, 10 Feb 2020 01:59:23 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EB423C447A9; Mon, 10 Feb 2020 01:59:21 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1B00AC43383;
        Mon, 10 Feb 2020 01:59:20 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 10 Feb 2020 09:59:20 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v7 5/8] scsi: ufs: Fix ufshcd_hold() caused scheduling
 while atomic
In-Reply-To: <2c485ce3fac4d92ab3776daecc1af493@codeaurora.org>
References: <1580978008-9327-1-git-send-email-cang@codeaurora.org>
 <1580978008-9327-6-git-send-email-cang@codeaurora.org>
 <MN2PR04MB6991346267CD619E823501F0FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <2c485ce3fac4d92ab3776daecc1af493@codeaurora.org>
Message-ID: <e15f1117e8808fdcc7c18e3ec3b7cf04@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-10 09:28, Can Guo wrote:
> On 2020-02-06 18:28, Avri Altman wrote:
>> Hi,
>> 
>>> 
>>> The async version of ufshcd_hold(async == true), which is only called
>>> in queuecommand path as for now, is expected to work in atomic 
>>> context,
>>> thus it should not sleep or schedule out. When it runs into the 
>>> condition
>>> that clocks are ON but link is still in hibern8 state, it should bail 
>>> out
>>> without flushing the clock ungate work.
>> 
>> Fixes: f2a785ac2312 (scsi: ufshcd: Fix race between clk scaling and 
>> ungate work)
> 
> Sorry, missed this one, if another version is needed, I will add this 
> line.
> 
>>> 
>>> Signed-off-by: Can Guo <cang@codeaurora.org>
>>> Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
>>> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
>>> Reviewed-by: Bean Huo <beanhuo@micron.com>
>>> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
>>> ---
>>>  drivers/scsi/ufs/ufshcd.c | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>> 
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index bbc2607..e8f7f9d 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -1518,6 +1518,11 @@ int ufshcd_hold(struct ufs_hba *hba, bool 
>>> async)
>>>                  */
>>>                 if (ufshcd_can_hibern8_during_gating(hba) &&
>>>                     ufshcd_is_link_hibern8(hba)) {
>>> +                       if (async) {
>>> +                               rc = -EAGAIN;
>>> +                               hba->clk_gating.active_reqs--;
>>> +                               break;
>>> +                       }
>>>                         spin_unlock_irqrestore(hba->host->host_lock, 
>>> flags);
>>>                         flush_work(&hba->clk_gating.ungate_work);
>>>                         spin_lock_irqsave(hba->host->host_lock, 
>>> flags);
>> Since now the above code is shared in all cases,
>> Maybe find a more economical way to pack it?
>> 
>> Thanks,
>> Avri
>> 
>> 
> 
> There are only 2 of this same code pieces in ufshcd_hold() and located
> in different cases, meanwhile there can be fall through, I don't see
> a good way to pack it, can you suggest if you have any ideas?
> 

Now, with this patch, there are 2 same code snippets located in CLKS_ON
and REQ_CLKS_ON. If we somehow pack them, say bring in a inline func to
pack them, we would have to tear it down later if we have to fix
something for only one specific case by adding lines into the snippet.
And actually this is the truth, we do have some fixes for CLKS_ON's case
but not yet uploaded, so let's leave it as it is for now.

> Regards,
> Can Guo.
> 
>>> --
>>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>>> Forum,
>>> a Linux Foundation Collaborative Project
