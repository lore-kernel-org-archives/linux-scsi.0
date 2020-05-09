Return-Path: <SRS0=PQdO=6X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB61EC47255
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 00:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6D5424960
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 00:33:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hAiMPJi+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgEIAc6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 20:32:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43297 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbgEIAc5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 20:32:57 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200509003254epoutp04a7043b80aaa871e83ffa46a0208e558b~NNN6216lv2443124431epoutp04W
        for <linux-scsi@vger.kernel.org>; Sat,  9 May 2020 00:32:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200509003254epoutp04a7043b80aaa871e83ffa46a0208e558b~NNN6216lv2443124431epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1588984374;
        bh=neo+HlKkQMCxdPB9fgCSJEAlMpQVKOxhn4oUXLHS10E=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=hAiMPJi+nizBw2Fj/dnHMciZK9KPIa6IJwQTAji8h10W6euA+4TKz62jSFO+xFcrd
         /lc34pmvu239DrIG1IBCUHi0GkvAmROTHaIac18THQ7mHl2i/rkDUnMaoN7ZmzY/2Z
         e6n6OEiB0xxVJg+ugXNOeV6JGo6kMsD/+fXKQo7o=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200509003253epcas5p12e5c0818bdeb7dd26794d78ea4f841dd~NNN5oftA52572825728epcas5p1f;
        Sat,  9 May 2020 00:32:53 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E9.13.10010.53AF5BE5; Sat,  9 May 2020 09:32:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200509003252epcas5p105fcdf77df196a4f581f51fc7e82f1f8~NNN43vH4C0506305063epcas5p1v;
        Sat,  9 May 2020 00:32:52 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200509003252epsmtrp2b1babae60489d2cafa01eac8fa1ed4b3~NNN424e_p1992219922epsmtrp2L;
        Sat,  9 May 2020 00:32:52 +0000 (GMT)
X-AuditID: b6c32a49-735ff7000000271a-b9-5eb5fa351a28
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A0.1A.25866.43AF5BE5; Sat,  9 May 2020 09:32:52 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200509003248epsmtip2b6fddca22f966ae2f394d65a39833f31~NNN1ile1w2388123881epsmtip2O;
        Sat,  9 May 2020 00:32:48 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Kishon Vijay Abraham I'" <kishon@ti.com>, <robh@kernel.org>
Cc:     <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <krzk@kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <kwmad.kim@samsung.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, "'Vinod Koul'" <vkoul@kernel.org>
In-Reply-To: <b0239aa5-004e-fc88-93a4-5b0d6f174ca3@ti.com>
Subject: RE: [PATCH v7 07/10] phy: samsung-ufs: add UFS PHY driver for
 samsung SoC
Date:   Sat, 9 May 2020 06:02:36 +0530
Message-ID: <006701d62599$5fbc2c80$1f348580$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQINaKJiJYqhfY8pF8dQGQjTbFgO/QI75FnYAdd4tKsCTMaX9af9XhAA
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWy7bCmhq7pr61xBm83CFm8/HmVzeLT+mWs
        FvOPnGO1uPC0h83i/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUaLnXdOMDvweVzu62Xy2LSqk81j85J6j5aT+1k8Pj69xeLRt2UVo8fxG9uZPD5vkvNo
        P9DNFMAZxWWTkpqTWZZapG+XwJWx/PUz1oKruhX3rx9jbWDsVOli5OSQEDCRmPB1PksXIxeH
        kMBuRonbq3ZAOZ+AnJt/WSGcz4wS115OYoRp2XFvAiNEYhejxIcPrcwQzhtGiYaWl0wgVWwC
        uhI7FrexdTFycIgIOEo07IoDqWEWeMUk8XfbRhaQGk4BK4mbHWeYQWxhgRCJa++2gcVZBFQk
        etuug23jFbCUONh3GMoWlDg58wlYDbOAtsSyha+ZIS5SkPj5dBkriC0i4CaxcepWNogacYmj
        P3vAjpMQeMAhcbP1DytEg4vExJ+3oZqFJV4d38IOYUtJfH63F+xoCYFsiZ5dxhDhGoml846x
        QNj2EgeuzGEBKWEW0JRYv0sfYhWfRO/vJ0wQnbwSHW1CENWqEs3vrkJ1SktM7O6GOsBDYv7m
        s+wTGBVnIXlsFpLHZiF5YBbCsgWMLKsYJVMLinPTU4tNCwzzUsv1ihNzi0vz0vWS83M3MYJT
        npbnDsa7Dz7oHWJk4mA8xCjBwawkwjuxYkucEG9KYmVValF+fFFpTmrxIUZpDhYlcd7TaUAp
        gfTEktTs1NSC1CKYLBMHp1QDk2z1xlj77zpPxZ/UqM37t0/tjPOHJRW/Au/M+XQ8pv3mT4k5
        zw7U9h97UtUatq9UaOvRxas/3+g7EXz+yPKZHP9zCtSDF664dUKnk/Oq0c1t1ZdZ1Gv/Jro7
        82pHL4s78M3LZNKyMGOVF2VTOS5cVkjv+Prf6pjCNuOYme2X+iOf/hDTD/60LC9k+QmRfcvn
        qe42XdivcPBg0M+2HFaHfHm+e35JnCmJUlPSGJawHE3Y+IzL0CVgZ/8kC1GmZRaVieUsnFZR
        9U3sOXOWfUhw+d6f8i+l0pyrXS6vYn2u/j6rZbzv5ix7lvkpwqVF62MZd/wBXo7dKUe3l53o
        KuWxZv6TI9wvquf/pqP3iK6DEktxRqKhFnNRcSIAf9XfVugDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsWy7bCSvK7Jr61xBitvSlu8/HmVzeLT+mWs
        FvOPnGO1uPC0h83i/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUaLnXdOMDvweVzu62Xy2LSqk81j85J6j5aT+1k8Pj69xeLRt2UVo8fxG9uZPD5vkvNo
        P9DNFMAZxWWTkpqTWZZapG+XwJXx7uZrloJ32hVHu3ezNzAuUepi5OSQEDCR2HFvAmMXIxeH
        kMAORomvR06yQySkJa5vnABlC0us/PecHaLoFaPE7uZpzCAJNgFdiR2L29hAbBEBZ4m7256y
        ghQxC/xgkjg7pRNq7FtGicY7G8FGcQpYSdzsOAPWLSwQJHF/VTcriM0ioCLR23adEcTmFbCU
        ONh3GMoWlDg58wkLiM0soC3R+7CVEcZetvA1M8R5ChI/ny5jhbjCTWLj1K1sEDXiEkd/9jBP
        YBSehWTULCSjZiEZNQtJywJGllWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMHxq6W1
        g3HPqg96hxiZOBgPMUpwMCuJ8E6s2BInxJuSWFmVWpQfX1Sak1p8iFGag0VJnPfrrIVxQgLp
        iSWp2ampBalFMFkmDk6pBqalDd837vr9qY89RvacjuCHA4bhAf2OIRfDZBOlrONK1j7Oc15z
        vibx03kWNfdnFyfNnLxhi0ZEbGGQavjLUpumLFHHFyGiO2d+WMdqznj/SsbsiD3cCQL8jmLM
        01U/aq/d/EtI+ZqfrPSudWWxAnXBC6ccq3TKWSrkH/KxJ4v9ybFjd5oUI0wVOFVWBtae9ub7
        cuj8skcHU5dtqNDTZl54J1co8H3L4Y03PwbYnJ/K7MVUFrPwxLxVDG+CXI+cFA14Ozc03Fbk
        u8hOZS+2AOv55Telf1hw+KUn8C3+tGDl+7UHPdZUWqe092gdsePdoLLJqMrCPrpkZ1lNqu2l
        myGx904ny/jcrjzD7juxW4mlOCPRUIu5qDgRAM2N5vdOAwAA
X-CMS-MailID: 20200509003252epcas5p105fcdf77df196a4f581f51fc7e82f1f8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200426174217epcas5p2c7d1606b641b73f67a169b8d22f0637d
References: <20200426173024.63069-1-alim.akhtar@samsung.com>
        <CGME20200426174217epcas5p2c7d1606b641b73f67a169b8d22f0637d@epcas5p2.samsung.com>
        <20200426173024.63069-8-alim.akhtar@samsung.com>
        <b0239aa5-004e-fc88-93a4-5b0d6f174ca3@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kishon,
Thanks for review.

> -----Original Message-----
> From: Kishon Vijay Abraham I <kishon=40ti.com>
> Sent: 07 May 2020 10:49
> To: Alim Akhtar <alim.akhtar=40samsung.com>; robh=40kernel.org
> Cc: devicetree=40vger.kernel.org; linux-scsi=40vger.kernel.org; krzk=40ke=
rnel.org;
> avri.altman=40wdc.com; martin.petersen=40oracle.com;
> kwmad.kim=40samsung.com; stanley.chu=40mediatek.com;
> cang=40codeaurora.org; linux-samsung-soc=40vger.kernel.org; linux-arm-
> kernel=40lists.infradead.org; linux-kernel=40vger.kernel.org; Vinod Koul
> <vkoul=40kernel.org>
> Subject: Re: =5BPATCH v7 07/10=5D phy: samsung-ufs: add UFS PHY driver fo=
r
> samsung SoC
>=20
=2E
=2E
=2E
> Okay, here you are using a state machine for the PHY configuration becaus=
e of
> the way the PHY is integrated with the UFS. Would be nice to have the sta=
te
> machine documented somewhere. I only have the PHY patch in my inbox.
Ok, will document in the driver file as well as in the header file.

> > +
> > +	if (ufs_phy->ufs_phy_state =3D=3D CFG_POST_PWR_HS)
> > +		err =3D samsung_ufs_phy_wait_for_lock_acq(phy);
> > +out:
> > +	return err;
> > +=7D
> > +
> > +static int samsung_ufs_phy_symbol_clk_init(struct samsung_ufs_phy
> > +*phy) =7B
> > +	struct clk *clk;
> > +	int ret =3D 0;
> > +
> > +	clk =3D devm_clk_get(phy->dev, =22tx0_symbol_clk=22);
>=20
> There is no =22exit=22 callback in phy_ops which means if there are multi=
ple phy_init
> calls, this clock will not be freed. This could be moved to =22probe=22 I=
MO.

Ok, will add exit callback.

> > +	if (IS_ERR(clk)) =7B
> > +		dev_err(phy->dev, =22failed to get tx0_symbol_clk clock=5Cn=22);
> > +		goto out;
> > +	=7D else =7B
>=20
> =22else=22 here and below is not required. Something like below
>=20
Ack
> 	clk =3D devm_clk_get(phy->dev, =22tx0_symbol_clk=22);
> 	if (IS_ERR(clk)) =7B
> 		dev_err(phy->dev, =22failed to get tx0_symbol_clk clock=5Cn=22);
> 		goto out;
> 	=7D
> 	phy->tx0_symbol_clk =3D clk;
>=20
> > +		phy->tx0_symbol_clk =3D clk;
> > +	=7D
> > +
> > +	clk =3D devm_clk_get(phy->dev, =22rx0_symbol_clk=22);
> > +	if (IS_ERR(clk)) =7B
> > +		dev_err(phy->dev, =22failed to get rx0_symbol_clk clock=5Cn=22);
> > +		goto out;
> > +	=7D else =7B
> > +		phy->rx0_symbol_clk =3D clk;
> > +	=7D
> > +
> > +	clk =3D devm_clk_get(phy->dev, =22rx1_symbol_clk=22);
> > +	if (IS_ERR(clk)) =7B
> > +		dev_err(phy->dev, =22failed to get rx1_symbol_clk clock=5Cn=22);
> > +		goto out;
> > +	=7D else =7B
> > +		phy->rx1_symbol_clk =3D clk;
> > +	=7D
> > +
> > +	ret =3D clk_prepare_enable(phy->tx0_symbol_clk);
> > +	if (ret) =7B
> > +		dev_err(phy->dev, =22%s: tx0_symbol_clk enable failed %d=5Cn=22,
> > +				__func__, ret);
> > +		goto out;
> > +	=7D
> > +	ret =3D clk_prepare_enable(phy->rx0_symbol_clk);
> > +	if (ret) =7B
> > +		dev_err(phy->dev, =22%s: rx0_symbol_clk enable failed %d=5Cn=22,
> > +				__func__, ret);
> > +		goto out;
> > +	=7D
> > +	ret =3D clk_prepare_enable(phy->rx1_symbol_clk);
> > +	if (ret) =7B
> > +		dev_err(phy->dev, =22%s: rx1_symbol_clk enable failed %d=5Cn=22,
> > +				__func__, ret);
> > +		goto out;
> > +	=7D
>=20
> All these clocks are never disabled?
Sure, will add disabling of clocks in exit callback=20

> > +out:
> > +	return ret;
> > +=7D
> > +
> > +static int samsung_ufs_phy_clks_init(struct samsung_ufs_phy *phy) =7B
> > +	struct clk *phy_ref_clk;
> > +	int ret;
> > +
> > +	phy_ref_clk =3D devm_clk_get(phy->dev, =22ref_clk=22);
> > +	if (IS_ERR(phy_ref_clk))
> > +		dev_err(phy->dev, =22failed to get ref_clk clock=5Cn=22);
> > +	else
> > +		phy->ref_clk =3D phy_ref_clk;
> > +
> > +	ret =3D clk_prepare_enable(phy->ref_clk);
> > +	if (ret) =7B
> > +		dev_err(phy->dev, =22%s: ref_clk enable failed %d=5Cn=22,
> > +				__func__, ret);
> > +		return ret;
> > +	=7D
> > +
> > +	dev_info(phy->dev, =22UFS MPHY ref_clk_rate =3D %ld=5Cn=22,
> > +clk_get_rate(phy_ref_clk));
> > +
> > +	return 0;
> > +=7D
> > +
> > +static int samsung_ufs_phy_init(struct phy *phy) =7B
> > +	struct samsung_ufs_phy *_phy =3D get_samsung_ufs_phy(phy);
> > +	int ret;
> > +
> > +	_phy->lane_cnt =3D phy->attrs.bus_width;
> > +	_phy->ufs_phy_state =3D CFG_PRE_INIT;
> > +
> > +	_phy->is_pre_init =3D true;
> > +	_phy->is_post_init =3D false;
> > +	_phy->is_pre_pmc =3D false;
> > +	_phy->is_post_pmc =3D false;
> > +
> > +
> > +	if (of_device_is_compatible(_phy->dev->of_node,
> > +				=22samsung,exynos7-ufs-phy=22)) =7B
>=20
> Can't it be added in driver data for this compatible?
Sure, will handle via driver data.

> > +		ret =3D samsung_ufs_phy_symbol_clk_init(_phy);
> > +		if (ret)
> > +			dev_err(_phy->dev,
> > +				=22failed to set ufs phy symbol clocks=5Cn=22);
> > +	=7D
> > +
=2E
=2E
=2E
> > +static int samsung_ufs_phy_set_mode(struct phy *generic_phy,
> > +					enum phy_mode mode, int submode) =7B
> > +	struct samsung_ufs_phy *_phy =3D get_samsung_ufs_phy(generic_phy);
> > +
> > +	_phy->mode =3D PHY_MODE_INVALID;
> > +
> > +	if (mode > 0)
> > +		_phy->mode =3D mode;
> > +
> > +	return 0;
> > +=7D
> > +
> > +static struct phy_ops samsung_ufs_phy_ops =3D =7B
> > +	.init		=3D samsung_ufs_phy_init,
> > +	.power_on	=3D samsung_ufs_phy_power_on,
> > +	.power_off	=3D samsung_ufs_phy_power_off,
> > +	.calibrate	=3D samsung_ufs_phy_calibrate,
> > +	.set_mode	=3D samsung_ufs_phy_set_mode,
>=20
> missing .owner.
Ack,

> > +=7D
> > +;
=2E
=2E
> > +++ b/drivers/phy/samsung/phy-samsung-ufs.h
> > =40=40 -0,0 +1,142 =40=40
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * UFS PHY driver for Samsung EXYNOS SoC
> > + *
> > + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
>=20
> 2020
>=20
Sure, will update.

> Thanks
> Kishon

