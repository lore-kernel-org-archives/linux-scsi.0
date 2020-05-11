Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1255C54E8E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 17:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CDAF20714
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 17:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QfzYDsuG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbgEKRDM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 13:03:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34974 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730861AbgEKRDL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 13:03:11 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200511170308epoutp028c2d762675daa615212a04300529a6d4~OCBEnFAqt2562525625epoutp024
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 17:03:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200511170308epoutp028c2d762675daa615212a04300529a6d4~OCBEnFAqt2562525625epoutp024
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589216588;
        bh=BP0GmkEpYQ0GqUiqdlf5eptimMZ4Tdy6/dykKqQWuFk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=QfzYDsuGy0FFWKAR1Xhv521BmsBSBmvheot3+SL/IbWwAAxXJ6M34sY8wfBlpiThf
         Llmw1DMR8kd/L89xqwDREEiN4QWPQq7GdyLwANj+KAGYhvHG0bWzMgfDNOuOvH81Rq
         WVNJJFv0nby7XVhEsBMJ6UXCDAcWS0UGcrZ8d2C8=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200511170306epcas5p2f9e34c776e0e46842b8fca5083b1680c~OCBDa8vHz1696616966epcas5p2-;
        Mon, 11 May 2020 17:03:06 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F3.B7.10010.A4589BE5; Tue, 12 May 2020 02:03:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200511170306epcas5p3ccb24e93409e22c01cee3ca2146c4b57~OCBCv-6u91934419344epcas5p3i;
        Mon, 11 May 2020 17:03:06 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200511170306epsmtrp2a470c7712dd96f0d23d86cc9d0ba2679~OCBCvK9C-0054600546epsmtrp2d;
        Mon, 11 May 2020 17:03:06 +0000 (GMT)
X-AuditID: b6c32a49-71fff7000000271a-32-5eb9854ae6f0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.0D.18461.A4589BE5; Tue, 12 May 2020 02:03:06 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200511170302epsmtip2950973488d6edc7e8639c79cda388b1c~OCA-aWL8_3019230192epsmtip2f;
        Mon, 11 May 2020 17:03:02 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Randy Dunlap'" <rdunlap@infradead.org>, <robh@kernel.org>
Cc:     <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <krzk@kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <kwmad.kim@samsung.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <80a387eb-2325-caab-6754-6d94daeeabac@infradead.org>
Subject: RE: [PATCH v8 09/10] scsi: ufs-exynos: add UFS host support for
 Exynos SoCs
Date:   Mon, 11 May 2020 22:33:00 +0530
Message-ID: <036901d627b6$09da7050$1d8f50f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIr/+V/dIQXVbOwuFE2pmdpRHTClQGDb/BuAb5g8twBywnFG6fPBS1A
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsWy7bCmhq5X6844g/MTTC1e/rzKZvFp/TJW
        i/lHzrFanD+/gd3i5pajLBabHl9jtbi8aw6bxYzz+5gsuq/vYLNYfvwfk8XbO9NZLP7v2cFu
        sXTrTUYHXo/Lfb1MHptXaHlsWtXJ5rF5Sb1Hy8n9LB4fn95i8ejbsorR4/MmOY/2A91MAZxR
        XDYpqTmZZalF+nYJXBkLW9cwF3TzVfR3X2dqYNzN3cXIySEhYCIxYUoPSxcjF4eQwG5GiUOL
        pzNCOJ8YJfa8n8EM4XxjlHh2azErTMuxv5/YIBJ7GSV+H38A1fKGUWLqssWMIFVsAroSOxa3
        sYHYIgL2EgfnnAYrYhY4ziTxuOMWE0iCU8BR4szKNWC2sECYxMUfz4H2cXCwCKhK3H8lBhLm
        FbCU+PR0CQuELShxcuYTMJtZQFti2cLXzBAXKUj8fLqMFWKXm8TSGSeYIGrEJY7+7AF7QULg
        BofE60VHoV5wkfgxcy8jhC0s8er4FnYIW0ri87u9bCA3SAhkS/TsMoYI10gsnXeMBcK2lzhw
        ZQ4LSAmzgKbE+l36EKv4JHp/P2GC6OSV6GgTgqhWlWh+dxWqU1piYnc31AEeEu1fPzFNYFSc
        heSxWUgem4XkgVkIyxYwsqxilEwtKM5NTy02LTDMSy3XK07MLS7NS9dLzs/dxAhOc1qeOxjv
        Pvigd4iRiYPxEKMEB7OSCG9L5s44Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4ryn07bECQmkJ5ak
        ZqemFqQWwWSZODilGpj0ZW/pzVz3a51+VH/zmV/3/n826DkW66V+ZX5l9D7eh/ZfbaNfVt5s
        yz7Iuq6+6DD7nx9Tc1SYp7GnO9y+1Jl1YNb3F3uOKXcJslQr1DNdSNK1nd3+s6Lwf0/Ijdup
        BfH2OuYz/xye3XIh7TnPbKeXIUeX8H22Uw0JEl5RcfbFsY1/TotzMGpwnezgbf31NO7UvMXl
        ho1/1xzvXP8oXHP5ptbF3AtrfGd+XC/9XrJJ+YmL3U/FQI091+dOY7tZdkAgO4PZ8L2IhLjH
        xLlxL2ykXimorM3bv6aJgzVZqil48m7pp/8PnfilPzPVm9///x3plk8n97qKCzA2PylpCL6e
        e4n7z1aDvlCl84k+39YqsRRnJBpqMRcVJwIAx990ReIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWy7bCSvK5X6844g5XP2Cxe/rzKZvFp/TJW
        i/lHzrFanD+/gd3i5pajLBabHl9jtbi8aw6bxYzz+5gsuq/vYLNYfvwfk8XbO9NZLP7v2cFu
        sXTrTUYHXo/Lfb1MHptXaHlsWtXJ5rF5Sb1Hy8n9LB4fn95i8ejbsorR4/MmOY/2A91MAZxR
        XDYpqTmZZalF+nYJXBmHrnezFlznrVj2kb+BsZm7i5GTQ0LAROLY309sXYxcHEICuxkl/m46
        xwyRkJa4vnECO4QtLLHy33N2iKJXjBI3vy8HS7AJ6ErsWNzGBmKLCDhK7N/wmxmkiFngMpPE
        kTcvoMZ+ZZS4vuIZK0gVJ1DVmZVrmEBsYYEQiXnd84AmcXCwCKhK3H8lBhLmFbCU+PR0CQuE
        LShxcuYTMJtZQFui92ErI4y9bOFrqEsVJH4+XcYKcYSbxNIZJ5ggasQljv7sYZ7AKDwLyahZ
        SEbNQjJqFpKWBYwsqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxguNVS3MH4/ZVH/QO
        MTJxMB5ilOBgVhLhbcncGSfEm5JYWZValB9fVJqTWnyIUZqDRUmc90bhwjghgfTEktTs1NSC
        1CKYLBMHp1QDU8DFNVtTXtyWPbN1rcz0x0uP9fNXqFlVZU15n8fydd/Vtflv1cpTua91Te/n
        DXL6YiDp8G/i2dxnkwVytTjXNZmuOme+9/fGPwXHuBuVlWf6/q27IlmasVJpWWLw8u4Hie5V
        3rLpS7dG26if2CodOr37lu6N53E15z8sUuS2O6Ks6LSQu+f7Hv41VgXScm7ubHd1zgTkN+2b
        +uzFB4O3UoY3+zh5VVe9YdZR0NOR1Azu/5u2qL2jZeklexHd22+2cop++PZvttnk9i3T1qQZ
        lx6/YBRRVSMWH2DSV1XU6HuheEF2muHCztkvXgiaLvD/wma154iEatDP18q/L9wXYN5t97Ev
        bzZv1r7DV+IDlViKMxINtZiLihMBNDT9sEYDAAA=
X-CMS-MailID: 20200511170306epcas5p3ccb24e93409e22c01cee3ca2146c4b57
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200511021409epcas5p3b78fe59669f13ffae481b57a944da675
References: <20200511020031.25730-1-alim.akhtar@samsung.com>
        <CGME20200511021409epcas5p3b78fe59669f13ffae481b57a944da675@epcas5p3.samsung.com>
        <20200511020031.25730-10-alim.akhtar@samsung.com>
        <80a387eb-2325-caab-6754-6d94daeeabac@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Randy

> -----Original Message-----
> From: Randy Dunlap <rdunlap=40infradead.org>
> Sent: 11 May 2020 08:43
> To: Alim Akhtar <alim.akhtar=40samsung.com>; robh=40kernel.org
> Cc: devicetree=40vger.kernel.org; linux-scsi=40vger.kernel.org; krzk=40ke=
rnel.org;
> avri.altman=40wdc.com; martin.petersen=40oracle.com;
> kwmad.kim=40samsung.com; stanley.chu=40mediatek.com;
> cang=40codeaurora.org; linux-samsung-soc=40vger.kernel.org; linux-arm-
> kernel=40lists.infradead.org; linux-kernel=40vger.kernel.org
> Subject: Re: =5BPATCH v8 09/10=5D scsi: ufs-exynos: add UFS host support =
for Exynos
> SoCs
>=20
> On 5/10/20 7:00 PM, Alim Akhtar wrote:
> > diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig index
> > e2005aeddc2d..cc7e29c8c24f 100644
> > --- a/drivers/scsi/ufs/Kconfig
> > +++ b/drivers/scsi/ufs/Kconfig
> > =40=40 -160,3 +160,15 =40=40 config SCSI_UFS_BSG
> >
> >  	  Select this if you need a bsg device node for your UFS controller.
> >  	  If unsure, say N.
> > +
> > +config SCSI_UFS_EXYNOS
> > +	bool =22EXYNOS specific hooks to UFS controller platform driver=22
> > +	depends on SCSI_UFSHCD_PLATFORM && ARCH_EXYNOS =7C=7C
> COMPILE_TEST
>=20
> Since && has higher precedence than =7C=7C, I am thinking that this shoul=
d be
>=20
> 	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS =7C=7C
> COMPILE_TEST)
>=20
Sure, I missed this, will add in next version.

> > +	select PHY_SAMSUNG_UFS
> > +	help
> > +	  This selects the EXYNOS specific additions to UFSHCD platform drive=
r.
> > +	  UFS host on EXYNOS includes HCI and UNIPRO layer, and associates
> with
> > +	  UFS-PHY driver.
> > +
> > +	  Select this if you have UFS host controller on EXYNOS chipset.
> > +	  If unsure, say N.
>=20
>=20
> --
> =7ERandy


