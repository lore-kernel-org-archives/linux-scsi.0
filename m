Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED91C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jul 2022 01:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiGVB17 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jul 2022 21:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGVB16 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2022 21:27:58 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5323E18383
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2022 18:27:52 -0700 (PDT)
X-UUID: 02730eedee7843d89e7bf127450bb4d1-20220722
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:1a5a4136-1269-42fe-a460-bf0755c88c3c,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:5
X-CID-META: VersionHash:0f94e32,CLOUDID:3b66f264-0b3f-4b2c-b3a6-ed5c044366a0,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 02730eedee7843d89e7bf127450bb4d1-20220722
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <chaotian.jing@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2103498637; Fri, 22 Jul 2022 09:27:47 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Fri, 22 Jul 2022 09:27:46 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Fri, 22 Jul 2022 09:27:45 +0800
Message-ID: <fab0b6332a5a43634f3df437c2b38bc3e618aa4d.camel@mediatek.com>
Subject: Re: [PATCH v1] scsi: ufs: correct ufshcd_shutdown flow
From:   Chaotian Jing <chaotian.jing@mediatek.com>
To:     Peter Wang <peter.wang@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>
Date:   Fri, 22 Jul 2022 09:27:45 +0800
In-Reply-To: <a71af42f-3b66-c0a1-c79d-a4573d0376fe@mediatek.com>
References: <20220719130208.29032-1-peter.wang@mediatek.com>
         <afb8d403-f8f5-5161-4680-ce2c3ae7787d@acm.org>
         <a71af42f-3b66-c0a1-c79d-a4573d0376fe@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-07-21 at 12:30 +0800, Peter Wang wrote:
> Hi Bart
> 
> On 7/21/22 5:40 AM, Bart Van Assche wrote:
> > On 7/19/22 06:02, peter.wang@mediatek.com wrote:
> > > From: Peter Wang <peter.wang@mediatek.com>
> > > 
> > > After ufshcd_wl_shutdown set device poweroff and link off,
> > > ufshcd_shutdown not turn off regulators/clocks.
> > > Correct the flow to wait ufshcd_wl_shutdown done and turn off
> > > regulators/clocks by polling ufs device/link state 500ms.
> > > Also remove pm_runtime_get_sync because it is unnecessary.
> > 
> > Please explain in the patch description why the
> > pm_runtime_get_sync() 
> > call is not necessary.
> 
> Because shutdown is focus on turn off clock/power, we don't need
> turn 
> on(resume) and turn off, right?
> 
> > 
> > > diff --git a/drivers/ufs/core/ufshcd.c
> > > b/drivers/ufs/core/ufshcd.c
> > > index c7b337480e3e..1c11af48b584 100644
> > > --- a/drivers/ufs/core/ufshcd.c
> > > +++ b/drivers/ufs/core/ufshcd.c
> > > @@ -9461,10 +9461,14 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
> > >    */
> > >   int ufshcd_shutdown(struct ufs_hba *hba)
> > >   {
> > > -    if (ufshcd_is_ufs_dev_poweroff(hba) &&
> > > ufshcd_is_link_off(hba))
> > > -        goto out;
> > > +    ktime_t timeout = ktime_add_ms(ktime_get(), 500);
> > 
> > Where does the 500 ms timeout come from?
> 
> It is a time to wait device into power off, if the 500 ms is not 
> suitable, could you suggess a value?
> 
> > 
> > Additionally, given the large timeout, please use jiffies instead
> > of 
> > ktime_get().
> 
> Okay, will change next version.
> 
> > 
> > > -    pm_runtime_get_sync(hba->dev);
> > > +    /* Wait ufshcd_wl_shutdown clear ufs state, timeout 500 ms
> > > */
> > > +    while (!ufshcd_is_ufs_dev_poweroff(hba) || 
> > > !ufshcd_is_link_off(hba)) {
> > > +        if (ktime_after(ktime_get(), timeout))
> > > +            goto out;
> > > +        msleep(1);
> > > +    }
> > 
> > Please explain why this wait loop has been introduced.
> 
> Both ufshcd_shtdown and ufshcd_wl_shutdown could run concurrently.

Is it possible to avoid the dev's shutdown and its parent's shutdown
run concurrently ? if cannnot avoid it, then seems the concurrently run
case may happen at any device and its parent device! then how do deal
with it ?

Also, the timeout 500ms may make no sense as the child device may not
get the device lock of its parent(it must wait parent's shutdown()
return then it can get the device lock).
> 
> if ufshcd_wl_shutdown -> ufshcd_shtdown, clock/power off should ok.
> 
> If ufshcd_shtdown -> ufshcd_wl_shutdown, wait ufshcd_wl_shutdown set 
> device to power off and turn off clock/power.
> 
> If timeout happen, means device still in active mode, cannot turn
> off 
> clock/power directly. Skip and keep clock/power on in this case.
> 
> 
> > 
> > Thanks,
> > 
> > Bart.

