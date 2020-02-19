Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E947C34047
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 10:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33A0F208E4
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 10:33:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Lita4j8V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgBSKdp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 05:33:45 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:23425 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726497AbgBSKdp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Feb 2020 05:33:45 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1582108425; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=rw6UHf0KTPLkHoH94qTywzRb5mw/2w3OWlPPBjvpPNw=;
 b=Lita4j8Vo+12yohtKUda38CRGo4YiaVYzSNZoQr1muQKs2rqct7K7PEzHmgEML0VHW1/kePF
 1X5eiT+YKfWfwmuXH5KeLvhQe7RH+h9DXRjIkERHYvobZnmU+60JENE8t/eetP7Ud1XWj474
 rWkHxQSQ6y2AXIc9djTI1UDdyQk=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e4d0eff.7f3c98b57f80-smtp-out-n01;
 Wed, 19 Feb 2020 10:33:35 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 40509C4479C; Wed, 19 Feb 2020 10:33:35 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 75BA6C43383;
        Wed, 19 Feb 2020 10:33:34 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 19 Feb 2020 18:33:34 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Asutosh Das <asutoshd@codeaurora.org>, hongwus@codeaurora.org,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
Subject: Re: [PATCH v1 1/2] scsi: ufs: add required delay after gating
 reference clock
In-Reply-To: <1582103495.26304.42.camel@mtksdccf07>
References: <20200217093559.16830-1-stanley.chu@mediatek.com>
 <20200217093559.16830-2-stanley.chu@mediatek.com>
 <c6874825dd60ea04ed401fbd1b5cb568@codeaurora.org>
 <1581945168.26304.4.camel@mtksdccf07>
 <e518c4d1d94ec15e9c4c31c34a9e42d1@codeaurora.org>
 <1581946449.26304.15.camel@mtksdccf07>
 <56c1fc80919491d058d904fcc7301835@codeaurora.org>
 <a8cd5beee0a1e12a40da752c6cd9b5de@codeaurora.org>
 <1582103495.26304.42.camel@mtksdccf07>
Message-ID: <bbb0b0637d9667d4691a9a28f9988dea@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-02-19 17:11, Stanley Chu wrote:
> Hi Can,
> 
> On Wed, 2020-02-19 at 10:35 +0800, Can Guo wrote:
> 
>> Since we all need this delay here, how about put the delay in the
>> entrence of ufshcd_setup_clocks(), before vops_setup_clocks()?
>> If so, we can remove all the delays we added in our vops since the
>> delay anyways delays everything inside ufshcd_setup_clocks().
>> 
> 
> Always putting the delay in the entrance of ufshcd_setup_clocks() may
> add unwanted delay for vendors, just like your current implementation,
> or some other vendors who do not want to disable the reference clock.
> 
> I think current patch is more reasonable because the delay is applied 
> to
> clock only named as "ref_clk" specifically.
> 
> If you needs to keep "ref_clk" in DT, would you consider to remove the
> delay in your ufs_qcom_dev_ref_clk_ctrl() and let the delay happens via
> common ufshcd_setup_clocks() only? However you may still need delay if
> call path comes from ufs_qcom_pwr_change_notify().
> 
> What do you think?
> 

I agree current change is more reasonable from what it looks, but the 
fact
is that I canont remove the delay in ufs_qcom_dev_ref_clk_ctrl() even 
with
this change. On our platforms, ref_clk in DT serves multipule purposes,
the ref_clk provided to UFS device is actually controlled in
ufs_qcom_dev_ref_clk_ctrl(), which comes before where this change kicks 
start,
so if I remove the delay in ufs_qcom_dev_ref_clk_ctrl(), this change 
cannot
provide us the correct delay before gate the ref_clk provided to UFS 
device.

> Always putting the delay in the entrance of ufshcd_setup_clocks() may
> add unwanted delay for vendors, just like your current implementation,
> or some other vendors who do not want to disable the reference clock.

I meant if we put the delay in the entrance, I will be able to remove
the delay in ufs_qcom_dev_ref_clk_ctrl(). Meanwhile, we can add proper
checks before the delay to make sure it is initiated only if ref_clk 
needs
to be disabled, i.e:

if(!on && !skip_ref_clk && hba->dev_info.clk_gating_wait_us)
     usleep_range();

Does this look better to you?

Anyways, we will see regressions with this change on our platforms, can 
we
have more discussions before get it merged? It should be OK if you go 
with
patch #2 alone first, right? Thanks.

Best regards,
Can Guo.

>> Meanwhile, if you want to modify the delay
>> (hba->dev_info.clk_gating_wait_us) for some reasons, say for specific
>> UFS devices, you still can do it in vops_apply_dev_quirks().
>> 
>> What do you say?
>> 
>> Thanks,
>> Can Guo.
> 
> Thanks,
> Stanley Chu
