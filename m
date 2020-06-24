Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE45C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 16:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83B292073E
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 16:57:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="V0cCQaCx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405265AbgFXQ5f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 12:57:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58409 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405263AbgFXQ5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 12:57:34 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200624165731epoutp04dea8d325d483c22440b20ea550a0463a~biUvBTHJX1970719707epoutp04K
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2020 16:57:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200624165731epoutp04dea8d325d483c22440b20ea550a0463a~biUvBTHJX1970719707epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593017851;
        bh=KMd0eqO8GtMWjgpfB+VCvK0D2tfYjlEPKEeNRLFEtnU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=V0cCQaCxsrgMYT8h8x4Uri96K7ttSZdTEKZ2AdTe6hop/MYICRQefyCpYJRdMyl2p
         hnGGdtM6+jvKDF+o7vhT9NJWJY9JAmxsXgTkew4MxNdxdFNdnoN0dCYOf/gCDoL25Y
         OIXHUSaMG8GtjvK6uNVzyFajUeWBOL79exnjTRvo=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200624165730epcas5p308d7aa7476e68ec2f67d033269104742~biUt-TL3a1144711447epcas5p3j;
        Wed, 24 Jun 2020 16:57:30 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8E.95.09467.AF583FE5; Thu, 25 Jun 2020 01:57:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200624165730epcas5p1e3eeb64857ac214b70f5437017cfc2ea~biUtoidCr3199531995epcas5p1n;
        Wed, 24 Jun 2020 16:57:30 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200624165730epsmtrp1cc2c747d18b9c824162b4cf22946e699~biUtnqRXt0105301053epsmtrp1N;
        Wed, 24 Jun 2020 16:57:30 +0000 (GMT)
X-AuditID: b6c32a49-a29ff700000024fb-a4-5ef385fa56d2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.4A.08303.AF583FE5; Thu, 25 Jun 2020 01:57:30 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200624165726epsmtip28bf5d75b985779d3d7ca28befebd281c~biUp9YYsN2887728877epsmtip2S;
        Wed, 24 Jun 2020 16:57:25 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Vinod Koul'" <vkoul@kernel.org>
Cc:     "'Kishon Vijay Abraham I'" <kishon@ti.com>, <robh@kernel.org>,
        <krzk@kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <avri.altman@wdc.com>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cang@codeaurora.org>,
        <devicetree@vger.kernel.org>, <kwmad.kim@samsung.com>,
        <linux-kernel@vger.kernel.org>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>
In-Reply-To: <20200624102112.GX2324254@vkoul-mobl>
Subject: RE: [PATCH v10 00/10] exynos-ufs: Add support for UFS HCI
Date:   Wed, 24 Jun 2020 22:27:23 +0530
Message-ID: <004b01d64a48$8bb87270$a3295750$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-in
Thread-Index: AQNA14zZ9KpC6NxovY65uGX80LQ4kgIpylB3AdlmWUMBx1WEmQIl7FhyAiYYQSwBBY3htKW5/StQ
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7bCmhu6v1s9xBvMuyFi8/HmVzeLT+mWs
        FvOPnGO1uPC0h83i/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUaLnXdOMDvweVzu62Xy2LSqk81j85J6j5aT+1k8Pj69xeLRt2UVo8fxG9uZPD5vkvNo
        P9DNFMAZxWWTkpqTWZZapG+XwJXxd89y1oKLQhWHj/9laWD8w9fFyMEhIWAicbmrrouRi0NI
        YDejxPyPq5i6GDmBnE+MEof2FUIkPjNKtE7bwAaSAGk48vMVG0TRLkaJy70+EPYbRonzkwxA
        bDYBXYkdi9vAakQEVCW2PHkAZjMLLGSW2LJAH8TmFDCSWHh2OSuILSzgJPF6xR6wxSxA9Q3b
        lrKA2LwClhL7dx9mgrAFJU7OfMICMUdeYvvbOcwQ9yhI/Hy6jBUiLi5x9GcPM8TeKIlLP54w
        gTwgIfCCQ+LD9YWsEA0uEjPX7meBsIUlXh3fwg5hS0m87G9jh4RKtkTPLmOIcI3E0nnHoMrt
        JQ5cmcMCUsIsoCmxfpc+xFo+id7fIKtAOnklOtqEIKpVJZrfXYXqlJaY2N3NClHiIdHXJDqB
        UXEWkr9mIflrFpJfZiHsWsDIsopRMrWgODc9tdi0wDAvtVyvODG3uDQvXS85P3cTIzjRaXnu
        YLz74IPeIUYmDsZDjBIczEoivCFun+KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8yr9OBMnJJCe
        WJKanZpakFoEk2Xi4JRqYJq/b8WpX9YlbvHuhzr+iHkGZyrKlljavP3KHyu371Kx5gfhlW2C
        Lr4L2bdoqO1WZEnqClh2cJ9HxdPMKPfquQbs39+fZW148S9XKUhx95P/M1zXJ8xdvUlEmeG5
        i4szr6IXs/m6DxXO8490/+DPSmh4dFdJS1mlUmH+yixx83ZOidN9e6Z8ezb1WIxQqaycWr3k
        I+eJW3KrlgoKeCi94msIvVM/T9TMXvz9wr/VJYd/mFgbOXqX/Vmdy7i6XEDs93ffmNnWnhPf
        C0pw/7mmv2bp9Y2HZrN+/KVl458quTw+8YOlwvxt/2692af8rCWw0H/u1vVlZ9fZzS2KvXJt
        V0Pw/p+Z5mvt287d0dSLUmIpzkg01GIuKk4EAIr9fdDjAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWy7bCSvO6v1s9xBp9/sFi8/HmVzeLT+mWs
        FvOPnGO1uPC0h83i/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUaLnXdOMDvweVzu62Xy2LSqk81j85J6j5aT+1k8Pj69xeLRt2UVo8fxG9uZPD5vkvNo
        P9DNFMAZxWWTkpqTWZZapG+XwJXxd89y1oKLQhWHj/9laWD8w9fFyMkhIWAiceTnKzYQW0hg
        B6PE+lklEHFpiesbJ7BD2MISK/89B7K5gGpeMUosWjCLGSTBJqArsWNxG1iziICqxJYnD9hA
        ipgF1jJLzD+0mg2i4yeTxLdbX8FGcQoYSSw8u5wVxBYWcJJ4vWIPE4jNAtTdsG0pC4jNK2Ap
        sX/3YSYIW1Di5MwnQHEOoKl6Em0bGUHCzALyEtvfzmGGuE5B4ufTZawQcXGJoz97mCEOipK4
        9OMJ0wRG4VlIJs1CmDQLyaRZSLoXMLKsYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQI
        jlwtrR2Me1Z90DvEyMTBeIhRgoNZSYQ3xO1TnBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHer7MW
        xgkJpCeWpGanphakFsFkmTg4pRqYOiYFn7zjp5G0jrdUsqtP4ICwQvTmHvnvHAorrmaVN77M
        9Th+8/XC/KmzK+d0SVou0RIRuv3I1D/p0w4txr0lTt5RaVPtgpJ1+G13zXkSEL9m1vze0zI1
        rnvW3IiK5nFgfCw+vY1RTHVix/alz/TajG9V8VrJfsiv3vf03eV7LV/8vebdEJnaLHPWMTzs
        ct6ZnI0/vzWrLbDu/B0007VD1jnu2KF/Oj/1f535t+nurrCXnKorF6/gkGNhK+aUcDc7Xnw3
        r/3SlYjs4NRrVRm6K+sOZ19beuWZe43vPPPVf3/Z7K+crZu/Nvvo2zeHVLZ+kOqTmL+Ona1J
        YHGSeeePE6KBUf+STx1ISVRgiY1UYinOSDTUYi4qTgQARvMgWksDAAA=
X-CMS-MailID: 20200624165730epcas5p1e3eeb64857ac214b70f5437017cfc2ea
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013223epcas5p2be85fa8803326b49a905fb7225992cad
References: <CGME20200528013223epcas5p2be85fa8803326b49a905fb7225992cad@epcas5p2.samsung.com>
        <20200528011658.71590-1-alim.akhtar@samsung.com>
        <159114947915.26776.12485309894552696104.b4-ty@oracle.com>
        <013a01d63d3e$ecf404d0$c6dc0e70$@samsung.com>
        <89b96bd0-a9a3-cdd8-dc67-1f9f49eef264@ti.com>
        <000001d646a6$6cb5fd70$4621f850$@samsung.com>
        <20200624102112.GX2324254@vkoul-mobl>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Vinod

> -----Original Message-----
> From: Vinod Koul <vkoul@kernel.org>
> Sent: 24 June 2020 15:51
> To: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: 'Kishon Vijay Abraham I' <kishon@ti.com>; robh@kernel.org;
> krzk@kernel.org; linux-samsung-soc@vger.kernel.org; avri.altman@wdc.com;
> stanley.chu@mediatek.com; linux-scsi@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; cang@codeaurora.org;
devicetree@vger.kernel.org;
> kwmad.kim@samsung.com; linux-kernel@vger.kernel.org; 'Martin K. Petersen'
> <martin.petersen@oracle.com>
> Subject: Re: [PATCH v10 00/10] exynos-ufs: Add support for UFS HCI
> 
> On 20-06-20, 07:29, Alim Akhtar wrote:
> > Hi Kishon,
> >
> > > -----Original Message-----
> > > From: Alim Akhtar <alim.akhtar@samsung.com>
> > > Sent: 11 June 2020 20:49
> > > To: 'Kishon Vijay Abraham I' <kishon@ti.com>; 'Martin K. Petersen'
> > > > >>
> > > > >> Applied [1,2,3,4,5,9] to 5.9/scsi-queue. The series won't show
> > > > >> up in my
> > > > > public
> > > > >> tree until shortly after -rc1 is released.
> > > > >>
> > > > > Thanks Martin,
> > > > > Hi Rob and Kishon/Vinod
> > > > > Can you please pickup dt-bindings and PHY driver respectively?
> > > >
> > > > You might have CC'ed me only for the PHY patch. I don't have the
> > > > dt-bindings in my inbox. Care to re-send what's missing again?
> > > > This will be merged after -rc1 is tagged.
> > > >
> >
> > -rc1 is out, I do not see phy driver patch in your tree[1] yet, let me
know if I am
> looking into right tree.
> > [1] -> git://git.kernel.org/pub/scm/linux/kernel/git/phy/linux-phy.git
> 
> Right tree
> >
> > Thanks!
> >
> > > Sure, will re-send this series.
> 
> But patches have not been sent right, pls send and me/Kishon will review
> 
Thanks for your kind attention on this series. As per [0] comment from
Kishon, patch 7/10 [1] and probably 6/10 [2] should have been Applied after
5.8-rc1 was tagged.
I have already send and re-send V10 of this series. Kishon has already
reviewed and provided comments and I have addressed them as well. These
patches already have and Reviewed-by, Tested-by tags.
Let me know if something more needs to be done from my side.
[0] https://lkml.org/lkml/2020/6/7/410
[1] https://lkml.org/lkml/2020/5/27/1705
[2] https://lkml.org/lkml/2020/5/27/1701

Thanks!

> Thanks
> --
> ~Vinod

