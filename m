Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E90C761A1
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 01:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7F8D24670
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 01:37:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ZCBB9Nph"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgBTBhH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:37:07 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:54429 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727801AbgBTBhH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Feb 2020 20:37:07 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1582162627; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=hsLg89Wno2a4zivhXbQ7ZlOQv+K/T+fljhSoDklnjik=;
 b=ZCBB9NphBCt+uiD4lxFgj+CFf7EVmmhrHhDJBG9OFw6A4Vc1D7cNK4oi3xvHzkvwPpg5wri6
 3el6XrvUSRvyvpg8UD8KuaG7Kst99GTA/QNVrPia5T8o4JaQjzK0524VMTafvwFl6WCnBNvS
 YNrmrK6xzC5/pjCzfyQmR/qjbEA=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e4de2ba.7f38666f83b0-smtp-out-n02;
 Thu, 20 Feb 2020 01:36:58 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 49875C447A4; Thu, 20 Feb 2020 01:36:58 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 90B50C433A2;
        Thu, 20 Feb 2020 01:36:57 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 20 Feb 2020 09:36:57 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
Subject: Re: [PATCH v3 1/2] scsi: ufs: pass device information to
 apply_dev_quirks
In-Reply-To: <1582009359.26304.29.camel@mtksdccf07>
References: <1578726707-6596-1-git-send-email-stanley.chu@mediatek.com>
 <1578726707-6596-2-git-send-email-stanley.chu@mediatek.com>
 <2a8fc44914b7ed8777a4a99ba6b8647a@codeaurora.org>
 <1582009359.26304.29.camel@mtksdccf07>
Message-ID: <57698522f7e1d9401ac27a0bd7f0756a@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-02-18 15:02, Stanley Chu wrote:
> Hi Can,
> 
> 
>> Hi Stanley,
>> 
>> Is this series merged? If no, would you mind moving
>> ufshcd_vops_apply_dev_quirks(hba, card); a little bit? Like below.
>> 
>> @@ -6852,14 +6852,14 @@ static void ufshcd_tune_unipro_params(struct
>> ufs_hba *hba)
>>                  ufshcd_tune_pa_hibern8time(hba);
>>          }
>> 
>> +       ufshcd_vops_apply_dev_quirks(hba, card);
>> +
>>          if (hba->dev_quirks & UFS_DEVICE_QUIRK_PA_TACTIVATE)
>>                  /* set 1ms timeout for PA_TACTIVATE */
>>                  ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE), 10);
>> 
>> In this way, vendor codes have a chance to modify the dev_quirks
>> before ufshcd_tune_unipro_params() does the rest of its job.
>> 
> 
> This patch has been merged to 5.6-rc1.
> 
> Basically I am fine with your proposal. But if you need to move it to
> new mentioned position, our apply_dev_quirks callback also need
> corresponding change so it might need our co-works : )
> 
> For example, you could just post your proposed changes and then we 
> would
> provide corresponding change as soon as possible?
> 
> Besides, I would like to remind that allowing vendor to "fix" device
> quirks in advance imply that current common device quirks have some
> problems? If so, would you consider to fix common device quirks 
> instead?
> 
> 
>> Thanks,
>> Can Guo.
> 
> Thanks,
> Stanley Chu

Thanks for your cooperations on this :)

There are some failure seen with specific UFS devices on our platforms,
we can fix it with the quirk QUIRK_HOST_PA_TACTIVATE, but we are not
sure if other vendors need it or not. So we want to handle it more
carefully by limiting it to our platforms only. I had sent out that
patch weeks ago, so I will just upload the new patch as we both agreed
in that patch series.

Thanks,
Can Guo
