Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53B2C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 02:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9878D2256F
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 02:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbgLXCWB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Dec 2020 21:22:01 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:39630 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbgLXCWB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2020 21:22:01 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608776500; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=S8nLSphtgRIthcWd+DqYiMxGoyZFuv5gfG0AMVjl8Ic=;
 b=sDHq1HLzrnCg4rjPXkdsdNCfj2wIcHy9NG9+2G/cOCizT0cSWK7q4V7VppCcuIbXAy8HfnzQ
 RydBEnGJAiZcJz297u5oxIT5nV04gtii2uWPGV6VlljsG/IqzTc73IjmILGr+PiXOa3R4ENJ
 QuxgjU5/B+vEjvtm1L7RbpKAa/8=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fe3fb17120d248bb548277e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Dec 2020 02:21:11
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 998BBC43461; Thu, 24 Dec 2020 02:21:10 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1B8B6C433C6;
        Thu, 24 Dec 2020 02:21:09 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Dec 2020 10:21:09 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Subject: Re: [PATCH v1] scsi: ufs-mediatek: Enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
In-Reply-To: <c83d34ca8b0338526f6440f1c4ee43dd@codeaurora.org>
References: <20201222072928.32328-1-stanley.chu@mediatek.com>
 <c862866ec97516a7ffb891e5de3d132d@codeaurora.org>
 <1608697172.14045.5.camel@mtkswgap22>
 <c83d34ca8b0338526f6440f1c4ee43dd@codeaurora.org>
Message-ID: <ff8efda608e6f95737a675ee03fa3ca2@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-23 12:41, Can Guo wrote:
> On 2020-12-23 12:19, Stanley Chu wrote:
>> Hi Can,
>> 
>> On Tue, 2020-12-22 at 19:34 +0800, Can Guo wrote:
>>> On 2020-12-22 15:29, Stanley Chu wrote:
>>> > Flush during hibern8 is sufficient on MediaTek platforms, thus
>>> > enable UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL to skip enabling
>>> > fWriteBoosterBufferFlush during WriteBooster initialization.
>>> >
>>> > Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
>>> > ---
>>> >  drivers/scsi/ufs/ufs-mediatek.c | 1 +
>>> >  1 file changed, 1 insertion(+)
>>> >
>>> > diff --git a/drivers/scsi/ufs/ufs-mediatek.c
>>> > b/drivers/scsi/ufs/ufs-mediatek.c
>>> > index 80618af7c872..c55202b92a43 100644
>>> > --- a/drivers/scsi/ufs/ufs-mediatek.c
>>> > +++ b/drivers/scsi/ufs/ufs-mediatek.c
>>> > @@ -661,6 +661,7 @@ static int ufs_mtk_init(struct ufs_hba *hba)
>>> >
>>> >  	/* Enable WriteBooster */
>>> >  	hba->caps |= UFSHCD_CAP_WB_EN;
>>> > +	hba->quirks |= UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL;
>>> >  	hba->vps->wb_flush_threshold = UFS_WB_BUF_REMAIN_PERCENT(80);
>>> >
>>> >  	if (host->caps & UFS_MTK_CAP_DISABLE_AH8)
>>> 
>>> I guess we need it too...
>> 
>> AHHA, if you decide to add this in your platform too later, maybe we
>> could change the way it does: Keep manual flush disabled by default 
>> and
>> remove this quirk.
>> 
> 
> Yeah... I will get back with an answer later.

Hi Stanley,

Do you see any substantial benefit of having fWriteBoosterBufferFlushEn 
disabled?

Thanks,
Can Guo.

> 
> Thanks,
> 
> Can Guo.
> 
>> Thanks,
>> Stanley Chu
>>> 
>>> Change LGTM.
>>> 
>>> Regards,
>>> 
>>> Can Guo.
