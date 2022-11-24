Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED35FC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Nov 2022 05:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiKXFgs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Nov 2022 00:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKXFgr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Nov 2022 00:36:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A417C654F
        for <linux-scsi@vger.kernel.org>; Wed, 23 Nov 2022 21:36:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6D0BB826CB
        for <linux-scsi@vger.kernel.org>; Thu, 24 Nov 2022 05:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB20FC433D6;
        Thu, 24 Nov 2022 05:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669268203;
        bh=6//otftWLt5Z80vEhfa2f66DpLVIrPufozfnD/G9TZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CFqDXcezf6g+bDIS5sAWN8P+swdCXly4q2h3YFjio18IMxOMa0qanCQ5LYGecOyTe
         N9oexlMU4ZKiBcPDFkVav0wHtew1FKjX/JsaG9uoguhXURFc/x1R0Gw5rOmpMnwfU6
         KBvbWo0MC//mxg9fz6+7IeIokHSd+4LvKxCL+b4rJH7IKLuFBhQsjgswopbH2NVdVy
         KozLAtSVU7tgAtAN7kGM9M9Y6o+AqXUhBz2goZHcHuk+xdX5ORblKsUhaE1Ts3fAXz
         biILi88eLaobcSwsNtpx1gx1R5btMtNlNRgmLA1uxro/nQHOBmATUh57Kj6XGWm70F
         f+LSrXqGCXr7g==
Date:   Thu, 24 Nov 2022 11:06:34 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Asutosh Das <quic_asutoshd@quicinc.com>
Cc:     Powen Kao =?utf-8?B?KOmrmOS8r+aWhyk=?= <Powen.Kao@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu =?utf-8?B?KOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Peter Wang =?utf-8?B?KOeOi+S/oeWPiyk=?= 
        <peter.wang@mediatek.com>,
        Naomi Chu =?utf-8?B?KOacseipoOeUsCk=?= <Naomi.Chu@mediatek.com>,
        Alice Chao =?utf-8?B?KOi2meePruWdhyk=?= 
        <Alice.Chao@mediatek.com>, linux-scsi@vger.kernel.org,
        quic_cang@quicinc.com
Subject: Re: 52a518019c causes issue with Qualcomm UFSHC
Message-ID: <20221124053634.GB5119@thinkpad>
References: <20221115014804.GA24294@asutoshd-linux1.qualcomm.com>
 <KL1PR03MB5836A982CAE0FE411743BF7283069@KL1PR03MB5836.apcprd03.prod.outlook.com>
 <20221117174634.GA12056@asutoshd-linux1.qualcomm.com>
 <584b6f9a-c4f9-8ecc-98d9-216923d85ddf@acm.org>
 <20221118191058.GA28646@asutoshd-linux1.qualcomm.com>
 <TYZPR03MB5825B4D5259FA22CCC876E7783089@TYZPR03MB5825.apcprd03.prod.outlook.com>
 <20221121225634.GA20677@asutoshd-linux1.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221121225634.GA20677@asutoshd-linux1.qualcomm.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 21, 2022 at 02:56:34PM -0800, Asutosh Das wrote:
> On Sat, Nov 19 2022 at 20:16 -0800, Powen Kao (高伯文) wrote:
> > Hi Asutosh,
> > 
> > 
> > 
> > Reverting the patch doesn't sound feasible on MTK platform ☹
> > 
> > 
> > 
> > > > I don't think invoking a clock scaling notification during
> > 
> > > > ufshcd_host_reset_and_restore() sounds right to me.
> > 
> > But the point is that driver has the right to know that the clk is scaled no matter where ufshcd_scale_clks() is invoked, no?
> > 
> > 
> > 
> > Do you mind applying this patch on qcom driver to check on host status before further operation?
> 
> + Mani, linux-scsi
> 
> Hello Powen
> Thanks for the change. I will think of something to work-around the issue.
> However, I would like to point out that a change that breaks an existing driver
> must be fixed or reverted, not the other way around.
> 

May I know what the actual issue is? I've tested v6.1-rc1 that has this change
and didn't see any issues on SM8250, SDM845 and SM8450.

Thanks,
mani

> -asd
> 

-- 
மணிவண்ணன் சதாசிவம்
