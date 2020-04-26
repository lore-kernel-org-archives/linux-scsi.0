Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEEDC54FCB
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 15:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E00720700
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 15:56:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nax4sOpe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgDZP4U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 11:56:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13319 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgDZP4S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 11:56:18 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200426155616epoutp042c651a31e37576c3df8c9e07364b5187~JabZ2EoYY3040330403epoutp04H
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 15:56:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200426155616epoutp042c651a31e37576c3df8c9e07364b5187~JabZ2EoYY3040330403epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587916576;
        bh=R/ffaCRKEQrXQ6OTqoLZTxkSTG1ctXIv1g7iS30Cjpk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=nax4sOpeYl9/HQq7dglKr0bc9RKuoS9wfoQdRoE+HmWLQykTwr1Swy/vBk7eOffBA
         luio6lKffnX+vaLc3MQ3UTWab0TH/O3BpoYxgB4sAHtTl9+EtsuR/WmM6mWc5f2DKp
         CanDtOgKfMEAISRxO5pdnc6C949aV2xQoi95kLMM=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200426155614epcas5p203e1348516c80b9a7886ebe271501f5f~JabYdooGN3114831148epcas5p2X;
        Sun, 26 Apr 2020 15:56:14 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.4B.04736.E1FA5AE5; Mon, 27 Apr 2020 00:56:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200426155613epcas5p22db6f4a090a05124ca987564645cfefe~JabX9NkAC3114831148epcas5p2W;
        Sun, 26 Apr 2020 15:56:13 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200426155613epsmtrp1f7bbca856242516fdca7287ccc2ffd0f~JabX5nyml1689016890epsmtrp1T;
        Sun, 26 Apr 2020 15:56:13 +0000 (GMT)
X-AuditID: b6c32a4b-ae3ff70000001280-60-5ea5af1ee499
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.EB.25866.D1FA5AE5; Mon, 27 Apr 2020 00:56:13 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200426155610epsmtip2a2527b919abc969e14934b32653fcce8~JabUxz3JZ0981409814epsmtip2I;
        Sun, 26 Apr 2020 15:56:10 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Christoph Hellwig'" <hch@infradead.org>
Cc:     <robh@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <krzk@kernel.org>,
        <avri.altman@wdc.com>, <martin.petersen@oracle.com>,
        <kwmad.kim@samsung.com>, <stanley.chu@mediatek.com>,
        <cang@codeaurora.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20200422065414.GK20318@infradead.org>
Subject: RE: [PATCH v6 04/10] scsi: ufs: introduce
 UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
Date:   Sun, 26 Apr 2020 21:26:08 +0530
Message-ID: <000101d61be3$362e79f0$a28b6dd0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJQDPill8kAmUENoj8JBCZ49rLenQFjH0G5AqRtQZkDmWzjbqdapFOg
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG+c7OOTtKq8+p+KahNhGaoJWrOIaVgckB+0MCNcKsoQcT3Ryb
        WVaQZelqmZoJJqKlzsuiltNsmrcslZW3MjNFKki7oXYRIgsqj8fI/358z/N87/vAy0jk45Qn
        k6xN5/VadaqCdiabHyqVgd5Wc/ymrqfr2I8LozT7zVpDsRWPBin2SUElwQ4N3ZGy4009JGt7
        +4JiR1rLaLZkqINgTWN2mq3t+02wf9rsUtZ8dxyFybiRy3kE11gXwNksF2iusfo0d87RSXJf
        pydI7nKTBXHzNm8ut8tERDkdcA5N5FOTM3j9xp2HnY/8qI7UWfDx5o7XdBZyyC4iJwbwFhht
        aZRcRM6MHN9HYG37JBUEOf6GYKpKKQrzCL5WFkn+Jfot76Si0IpgpPwmJSZmEFRVHBSYxoFg
        r8qhBXZb5IEbH5AQkOBJAoq/f178iWGcsAoeONYIHlccA10TA4TAJPYHS7tjiWU4BGrbSqQi
        u4Dj2hQpsAT7wL3ZsuWFfGFhuoYSZ0XA+ZkvSPR4QM/CpaVqgCcZyH81RomBcGi0V0pFdoVP
        fU3L7Akf83Okwm6AU+BSq0p8PgXm8l5S5F3Q9byMFCwSrARr60Zx1GrI+zVFiEkZGHPkotsf
        sudGl5NeUGgyLS/AwfSbCVSA1peuKFa6oljpigKl/4ddR6QFreV1Bk0Sb9iqU2n5Y0EGtcZw
        VJsUlJCmsaGlgwuItCPb4N5uhBmkWCUz8tXxckqdYcjUdCNgJAo3WVx6ZbxclqjOPMHr0w7p
        j6byhm7kxZAKD9kVajROjpPU6XwKz+t4/T+VYJw8s1C4cTa7hS0p3mM9E3377gxj1A0PD+q+
        zGdEhO4Y9q5/0RMVHLOf9roVba73vZrrMfTGGPvyjEv+SVefIvfOiMSG4rPKsN11zcZt0++o
        kA3hfaa89/sKt6uIzNhnoSqc0O73kjw7oXUfaGh/nOn3bG5MEzYPvXJH/+SAV/DP7PZIBWk4
        ot4cINEb1H8Bs6de3mwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWy7bCSvK7s+qVxBj2XTSxe/rzKZvFp/TJW
        i/lHzrFanJ6wiMni/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptXaHlsWtXJ5rF5Sb1Hy8n9LB4fn95i8ejbsorR4/MmOY/2A91MAZxR
        XDYpqTmZZalF+nYJXBk/lngXrBKo2LbvPlsD40neLkZODgkBE4kzq56xdzFycQgJ7GCUuPR7
        LStEQlri+sYJ7BC2sMTKf8/BbCGBV4wSR77agthsAroSOxa3sYHYIkD22YUvGEEGMQu8YJKY
        +OYvE0TDM0aJXV+Zuxg5ODgFjCUOnuQHCQsLhEjMP9gM1ssioCqxau9JsHJeAUuJ5XtmsEPY
        ghInZz5hAWllFtCTaNvICBJmFpCX2P52DjPEaQoSP58uY4U4wU2i9c0HqBpxiaM/e5gnMArP
        QjJpFsKkWUgmzULSsYCRZRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnCcamntYNyz
        6oPeIUYmDsZDjBIczEoivDEli+KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ836dtTBOSCA9sSQ1
        OzW1ILUIJsvEwSnVwLRGyOWKbsiK+QV2glXuD76tOe8dxDzVy3n77LWH+d3vWRXXPNP/4rh3
        mZaujqvVz01dsnlzytxLz0/rePvxN8dnWx9fn/KvLV28tT6Kx02aBS7sjbzX8WqN+vOea6wX
        rtX7LvVIEO/qrmE7ahmpf1dd8d+ViVLLOI46JwSxh4ZWFj+J9+s0MHBnat2X2pT+Yf5vq0lz
        F9qn9klPjOWffeaGtc6srDfz8gsb3r03npeyZYfSTsvbi3QZV2VLJms9+1b9kC1Eq/XkEWPL
        rmmOk5+sctoexlmxqXXfjy/OGa0MJ0z1/s184PLkoUiU6P4VnJ+7Lptu7Zv4WdrKzMzd4Nuv
        U/NZtLetbmNjD6w7oMRSnJFoqMVcVJwIAFlrMsVCAwAA
X-CMS-MailID: 20200426155613epcas5p22db6f4a090a05124ca987564645cfefe
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200417181014epcas5p1343bc81fb246133cc332d3fc7a394c15
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181014epcas5p1343bc81fb246133cc332d3fc7a394c15@epcas5p1.samsung.com>
        <20200417175944.47189-5-alim.akhtar@samsung.com>
        <20200422065414.GK20318@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,

> -----Original Message-----
> From: Christoph Hellwig <hch@infradead.org>
> Sent: 22 April 2020 12:24
> To: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: robh@kernel.org; devicetree@vger.kernel.org;
linux-scsi@vger.kernel.org;
> krzk@kernel.org; avri.altman@wdc.com; martin.petersen@oracle.com;
> kwmad.kim@samsung.com; stanley.chu@mediatek.com;
> cang@codeaurora.org; linux-samsung-soc@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v6 04/10] scsi: ufs: introduce
> UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
> 
> On Fri, Apr 17, 2020 at 11:29:38PM +0530, Alim Akhtar wrote:
> > Some UFS host controllers may think granularities of PRDT length and
> > offset as bytes, not double words.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 30 +++++++++++++++++++++++-------
> > drivers/scsi/ufs/ufshcd.h |  6 ++++++
> >  2 files changed, 29 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index ee30ed6cc805..b32fcedcdcb9 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -2151,8 +2151,14 @@ static int ufshcd_map_sg(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
> >  		return sg_segments;
> >
> >  	if (sg_segments) {
> > -		lrbp->utr_descriptor_ptr->prd_table_length =
> > -			cpu_to_le16((u16)sg_segments);
> > +
> > +		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
> > +			lrbp->utr_descriptor_ptr->prd_table_length =
> > +				cpu_to_le16((u16)(sg_segments *
> > +					sizeof(struct ufshcd_sg_entry)));
> > +		else
> > +			lrbp->utr_descriptor_ptr->prd_table_length =
> > +				cpu_to_le16((u16) (sg_segments));
> 
> No double words here.  "Normal" UFS uses the actual segment count, while
> Samsumg uses bytes.  Also no need fo the u16 count in either the old or
new
> version.
Ok, will update the commit message and take your suggestion in the next
version. 

