Return-Path: <SRS0=AJIY=36=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6326C35254
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 02:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D0082082E
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 02:01:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="X48nFf84"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbgBJCAo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Feb 2020 21:00:44 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:25854 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727363AbgBJCAn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Feb 2020 21:00:43 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581300042; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=kn1eCoX1vGFsUPSDIWx1LkICtUFdlC5DFGOw/o4zcls=;
 b=X48nFf84lU98Qk0+CHBnOy0sW4qMtoLcb6ZSDFSicNceexD11VYVEOx3wRLXIJ21W54oIi3R
 vUpxXMGA86c5U/nZOdWs7hLblT0iET7l2p6HC4P3vnkOhfetTO6iDIpfoqht/BVtT28ctKCb
 wOR+i4E/Lbk3T1MfDb++xGjnNEw=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e40b949.7f592c4b1030-smtp-out-n02;
 Mon, 10 Feb 2020 02:00:41 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 38B2CC433A2; Mon, 10 Feb 2020 02:00:41 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BDCF7C43383;
        Mon, 10 Feb 2020 02:00:40 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 10 Feb 2020 10:00:40 +0800
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
Subject: Re: [PATCH 5/7] scsi: ufs: Fix ufshcd_hold() caused scheduling while
 atomic
In-Reply-To: <MN2PR04MB69919F988AA4F1B7BD36408BFC1E0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1581123030-12023-1-git-send-email-cang@codeaurora.org>
 <1581123030-12023-6-git-send-email-cang@codeaurora.org>
 <MN2PR04MB69919F988AA4F1B7BD36408BFC1E0@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <c89901f4e7f2c7200d1aefe55e3c9fb4@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-09 15:48, Avri Altman wrote:
> You didn't address any of my comments to this patch.
> 
> Thanks,
> Avri

Replied in that thread.

Thanks,
Can Guo.

>> 
>> The async version of ufshcd_hold(async == true), which is only called
>> in queuecommand path as for now, is expected to work in atomic 
>> context,
>> thus it should not sleep or schedule out. When it runs into the 
>> condition
>> that clocks are ON but link is still in hibern8 state, it should bail 
>> out
>> without flushing the clock ungate work.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
>> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
>> Reviewed-by: Bean Huo <beanhuo@micron.com>
>> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index bbc2607..e8f7f9d 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1518,6 +1518,11 @@ int ufshcd_hold(struct ufs_hba *hba, bool 
>> async)
>>                  */
>>                 if (ufshcd_can_hibern8_during_gating(hba) &&
>>                     ufshcd_is_link_hibern8(hba)) {
>> +                       if (async) {
>> +                               rc = -EAGAIN;
>> +                               hba->clk_gating.active_reqs--;
>> +                               break;
>> +                       }
>>                         spin_unlock_irqrestore(hba->host->host_lock, 
>> flags);
>>                         flush_work(&hba->clk_gating.ungate_work);
>>                         spin_lock_irqsave(hba->host->host_lock, 
>> flags);
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>> Forum,
>> a Linux Foundation Collaborative Project
