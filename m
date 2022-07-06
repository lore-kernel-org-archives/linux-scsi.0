Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AA0C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 01:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiGFBvr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 21:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGFBvq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 21:51:46 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D8918E18
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jul 2022 18:51:45 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220706015142epoutp01306693ba533685006cd82c324cf3bac3~-GnrgTLsE0736107361epoutp01G
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2022 01:51:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220706015142epoutp01306693ba533685006cd82c324cf3bac3~-GnrgTLsE0736107361epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657072302;
        bh=69WDHWt1URt36gBZWJ/4kmkQkf9MiyX8ANYmSfBpJck=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=BpTlbV1vss1u3CIgS2Lec5Vix9x4X9Qxfg9Gvim8unpri07pSKruQA/F90ZyY2oLv
         o0u6WEq5U99D2jQniCBsxp7aQsHjTiEwLWZiwXRK8wZ433x5aRjaJ8ViS3IrBS7jCx
         146p2tuOfUTpHCutOE2y9vTr92a2zEMp28IpmO2o=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20220706015142epcas2p378df24e05353c6bc0e9faaa0bab2fddc~-GnqzrGcL2100721007epcas2p3k;
        Wed,  6 Jul 2022 01:51:42 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.101]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Ld2b15ZVPz4x9Q7; Wed,  6 Jul
        2022 01:51:41 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        1B.90.09662.DAAE4C26; Wed,  6 Jul 2022 10:51:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20220706015140epcas2p217041d42e81cfdadd415271c7fe91d15~-GnpoFnJK2968629686epcas2p2g;
        Wed,  6 Jul 2022 01:51:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220706015140epsmtrp2eccf22d5f02b3e850c01f885a847e610~-GnpnOARA2282122821epsmtrp2p;
        Wed,  6 Jul 2022 01:51:40 +0000 (GMT)
X-AuditID: b6c32a48-9f7ff700000025be-a9-62c4eaade153
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.FC.08905.CAAE4C26; Wed,  6 Jul 2022 10:51:40 +0900 (KST)
Received: from KORCO082417 (unknown [10.229.8.121]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220706015140epsmtip16aaaef3d62a7b9687dd9ee0cce2f09d8~-GnpaMMGC2676726767epsmtip1d;
        Wed,  6 Jul 2022 01:51:40 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzysztof.kozlowski@linaro.org>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Vinod Koul'" <vkoul@kernel.org>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>
Cc:     <linux-phy@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>
In-Reply-To: <d23604f8-f6b3-0f2f-6ab0-418a6fb9549f@linaro.org>
Subject: RE: [PATCH 3/3] ufs: ufs-exynos: change ufs phy control sequence
Date:   Wed, 6 Jul 2022 10:51:40 +0900
Message-ID: <002301d890da$efc75d00$cf561700$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKPbDrS+pUW8WXjub+LNM/Jc4lIEQFxfr+JAj/nB9wCgSJAFavRR6Ng
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJsWRmVeSWpSXmKPExsWy7bCmue7aV0eSDF5eEbJ4MG8bm8W0Dz+Z
        LRbd2MZkceFpD5vF3tdb2S02Pb7GajFh1TcWixnn9zFZdF/fwWax/Pg/Joudd04wO3B7XL7i
        7bFpVSebx51re9g8Jiw6wOixeUm9x8ent1g8+rasYvQ4fmM7k8fnTXIBnFHZNhmpiSmpRQqp
        ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAxyoplCXmlAKFAhKLi5X0
        7WyK8ktLUhUy8otLbJVSC1JyCswL9IoTc4tL89L18lJLrAwNDIxMgQoTsjMWftvAXDCDo6L/
        2hOWBsaLbF2MnBwSAiYSDb/eMHcxcnEICexglLg48zAThPOJUeLkt0Yo5xujxMoLu5lgWpZc
        +MsOkdjLKLG6tRuq/wWjxIX2B2CD2QT0JV52bGMFSYgIXGCS+DbtOCOIwywwgVHi5fL7LF2M
        HBycAnYSHxfbgjQIC3hK7L81EayZRUBF4uvTRWA2r4ClxKnji1ggbEGJkzOfgNnMAvIS29/O
        YYY4SUHi59NlrCC2iICbxK3zu5khakQkZne2gV0nIXCDQ2Jz9ymoH1wk1vSfggaBsMSr41vY
        IWwpic/v9kLFiyWWzvrEBNHcwChxedsvqISxxKxn7YwgDzALaEqs36UPYkoIKEscuQV1G59E
        x2FQEIGEeSU62oQgGtUlDmyfzgJhy0p0z/nMOoFRaRaSz2Yh+WwWkg9mIexawMiyilEstaA4
        Nz212KjABB7dyfm5mxjBKVnLYwfj7Lcf9A4xMnEwHmKU4GBWEuFdNelgkhBvSmJlVWpRfnxR
        aU5q8SFGU2BYT2SWEk3OB2aFvJJ4QxNLAxMzM0NzI1MDcyVxXq+UDYlCAumJJanZqakFqUUw
        fUwcnFINTF3MIlu4eTI2Bqxa/mHqkiWeXgksnoUX5E/ERblbc03Qrp2tn6dyr00tWl9SoUzv
        ZmDEp5kxrzY1XhZJz/Xd8nnSt1+M4mKnzbWFuuZfWz03M/Wtgsfpk69mfTLMeuNcpWVwfpeD
        0Kb+HqtcL+t7/yPP/Lrxy51DU6uifvGOap/ws8773zNHXJle0fZ79aT8RH2/fbyrGb4dfPHw
        eYpKTlCRUJHls/IQK2fZLwEhW7w5jN63uf20Mnh4xVqzY7s4A8vh9texWZ6M90xE95z9sDdV
        4f5W+Z1v159d5RX51ufakuw6Z61r1af4Fpwr5+y+XujlIimWtjps5pwK7XDOd7Yiqpw7k6QY
        zywUNvJXYinOSDTUYi4qTgQAksszwFIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWy7bCSnO6aV0eSDD7uM7R4MG8bm8W0Dz+Z
        LRbd2MZkceFpD5vF3tdb2S02Pb7GajFh1TcWixnn9zFZdF/fwWax/Pg/Joudd04wO3B7XL7i
        7bFpVSebx51re9g8Jiw6wOixeUm9x8ent1g8+rasYvQ4fmM7k8fnTXIBnFFcNimpOZllqUX6
        dglcGQu/bWAumMFR0X/tCUsD40W2LkZODgkBE4klF/6ydzFycQgJ7GaUOLT+FQtEQlbi2bsd
        7BC2sMT9liOsEEXPGCUatlwAK2IT0Jd42bENLCEicIVJou/lKUYQh1lgCqPEzW3/mUCqhAS+
        M0r03qvpYuTg4BSwk/i42BYkLCzgKbH/1kSwM1gEVCS+Pl0EZvMKWEqcOr6IBcIWlDg58wmY
        zSygLdH7sJURwpaX2P52DjPEdQoSP58uYwWxRQTcJG6d380MUSMiMbuzjXkCo/AsJKNmIRk1
        C8moWUhaFjCyrGKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECI5OLc0djNtXfdA7xMjE
        wXiIUYKDWUmEd9Wkg0lCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2C
        yTJxcEo1ME24oLrnU06s8fmnvUnnHq8TUitce+D2laPHlhjI3q1sUxZp7g75EZ2/TG6lVv5L
        uTWpm+8rfmO+JHE++dYbYUPFYBludQ3pxC4BxRVG7Gtvb/pZv5bHYuqXv3u4hKRz5eTOnJqo
        7mN36NHaecamp+fc/G+x38f73v1S4VWnu1NdbtvZrVs5sf28t1ruRs1oFpvzYbMrsl8su1fx
        5ND91Uuf8NQ9OdEn/ivJ41yQ2MGHKXPkJ2tXpKYsNVF+/d5sateC0M5tL9hT3nD+Zn/MnSvD
        nnpvC9fd/rJWG+Eore9hhy70b5r67uTh+zr9p6b0LL/gKfrrjvr0Cnf2DUe7jk2b9FDl7/+a
        hjm/9975J2ulxFKckWioxVxUnAgAfCLPNz0DAAA=
X-CMS-MailID: 20220706015140epcas2p217041d42e81cfdadd415271c7fe91d15
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220705065722epcas2p3f9970697f6d1f1fed43e10fe17019619
References: <20220705065440.117864-1-chanho61.park@samsung.com>
        <CGME20220705065722epcas2p3f9970697f6d1f1fed43e10fe17019619@epcas2p3.samsung.com>
        <20220705065440.117864-4-chanho61.park@samsung.com>
        <d23604f8-f6b3-0f2f-6ab0-418a6fb9549f@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Since commit 1599069a62c6 ("phy: core: Warn when phy_power_on is
> > called before phy_init"), below warning has been reported.
> >
> > phy_power_on was called before phy_init
> >
> > To address this, we need to remove phy_power_on from
> > exynos_ufs_phy_init and move it after phy_init. phy_power_off and
> > phy_exit are also necessary in exynos_ufs_remove.
> >
> > Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> > ---
> >  drivers/ufs/host/ufs-exynos.c | 13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/ufs/host/ufs-exynos.c
> > b/drivers/ufs/host/ufs-exynos.c index f971569bafc7..5718296e2521
> > 100644
> > --- a/drivers/ufs/host/ufs-exynos.c
> > +++ b/drivers/ufs/host/ufs-exynos.c
> > @@ -908,6 +908,8 @@ static int exynos_ufs_phy_init(struct exynos_ufs
> *ufs)
> >  		goto out_exit_phy;
> >  	}
> >
> > +	phy_power_on(generic_phy);
> 
> 
> What about phy_power_on() return code?

I'll back the check next patch.

Best Regards,
Chanho Park

