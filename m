Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0F4C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 01:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55771205CB
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 01:21:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="n/GFm0Qo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHMBVZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 21:21:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20330 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgHMBVY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 21:21:24 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200813012121epoutp0321bb0e62d74d8564e045c7fd708a29e4~qrzn2_vIl0782307823epoutp03t
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2020 01:21:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200813012121epoutp0321bb0e62d74d8564e045c7fd708a29e4~qrzn2_vIl0782307823epoutp03t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1597281681;
        bh=rIf2aP70tcoCuctATkuo4ryv929cSpVAnCs+GM8kOT4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=n/GFm0QoN+kqH1AnhI/9I8rbUfpGAZ4BLOCC2T0f6nuvwA/XumeusZgQ3GD80kiTt
         aivLMTFxnOoGSSh1Kc+gS9m7g1EKQcAImZ+yLq38mzHoA24c3SlxRQdAuQZ6rQVbyh
         Bt7kj3MsSkuHbgR1rJc++E809oAxbnX1eI6VvEko=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200813012120epcas5p285d4bb722d0c48a79842eec0cd9d012d~qrzm6eKtx2473924739epcas5p2R;
        Thu, 13 Aug 2020 01:21:20 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C7.79.09475.095943F5; Thu, 13 Aug 2020 10:21:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200813012119epcas5p3c6bb1b51ff89ed57dc3c8eae7fe80888~qrzl1l6DG0125501255epcas5p3k;
        Thu, 13 Aug 2020 01:21:19 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200813012119epsmtrp2db0dd40a660422b079a3feaab3ba0698~qrzl0pP9g1048610486epsmtrp2n;
        Thu, 13 Aug 2020 01:21:19 +0000 (GMT)
X-AuditID: b6c32a4b-39fff70000002503-96-5f3495904025
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E8.DA.08303.F85943F5; Thu, 13 Aug 2020 10:21:19 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200813012115epsmtip1dad765160f388deae709a79eaf3bc4ed~qrzijvUVK0847808478epsmtip1W;
        Thu, 13 Aug 2020 01:21:15 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Eric Biggers'" <ebiggers@kernel.org>
Cc:     <robh@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <krzk@kernel.org>,
        <avri.altman@wdc.com>, <martin.petersen@oracle.com>,
        <kwmad.kim@samsung.com>, <stanley.chu@mediatek.com>,
        <cang@codeaurora.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>
In-Reply-To: <20200812002920.GA1352011@gmail.com>
Subject: RE: [RESEND PATCH v10 04/10] scsi: ufs: introduce
 UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
Date:   Thu, 13 Aug 2020 06:51:13 +0530
Message-ID: <000401d67110$0be2d9c0$23a88d40$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQG4t7PjQZEdjsbMgiywO+bF2ZMTLwIzeQaKAlwJ5TgBughjDak+YmDg
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsWy7bCmhu6EqSbxBq3TeS1e/rzKZvFp/TJW
        i/lHzrFarN3zh9niwtMeNovz5zewW9zccpTFYtPja6wWl3fNYbOYcX4fk0X39R1sFsuP/2Oy
        +L9nB7vF0q03GR34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4MpY8OUzc8E5qYrvV16wNDC+Eu1i5OSQEDCRePG4mamLkYtD
        SGA3o8Syn+tZIJxPjBK9U2awQjifGSUePPkFlOEAa9k2tQikW0hgF6PE+dVeEDVvGCX6uv+x
        gyTYBHQldixuYwOxRQS0JHrnPAUbxCzwlkniwr9drCAJTgFDifcnN4E1CAvESdzdtBhsAYuA
        qsSbHZUgYV4BS4n7/zuYIWxBiZMzn7CA2MwC8hLb385hhnhBQeLn02WsELvcJD6dO88KUSMu
        cfRnDzPIXgmBNxwS1/+dZIdocJHYd2AqE4QtLPHq+BaouJTE53d72SCezJbo2WUMEa6RWDrv
        GAuEbS9x4MocsDOZBTQl1u/Sh1jFJ9H7+wkTRCevREebEES1qkTzu6tQndISE7u7WSFsD4kH
        C14wTmBUnIXksVlIHpuF5IFZCMsWMLKsYpRMLSjOTU8tNi0wzkst1ytOzC0uzUvXS87P3cQI
        Tnda3jsYHz34oHeIkYmD8RCjBAezkggv82XjeCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8Sj/O
        xAkJpCeWpGanphakFsFkmTg4pRqYFov8zvkzg9d44rHcpuI9KhYntZffvZQ1Q+gm4+mLwZo+
        +3681/gXcDtLt2hPjkW5V3vuXXGRCdcevD9l1bN+5f3GSfZ6l7Inbr+WobF05pLSl9Vr+xb9
        MW1av4ONU6rzuMpmVpX/WXtNMrl3vZobZzn3e8KKrlXThZdEzuNYyDiv6uyVE+Vvr2+aw1Ee
        eaFifpm4cMim1LpdumdbMvPXpZc5dceKzvyqVsqv6//sXu+GWbdtVErWzbb/c+Px00MLFshp
        NGVui5K1aq3d/Uut3O1eY4rpqSDZW77ysWz3jEK3p7xeqfbh5K7pq9Of9t7wjvj0/38J64Si
        8DM+ey5uePxklhp3XCdjevOSuBfLlJVYijMSDbWYi4oTAdGs8gbmAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWy7bCSnG7/VJN4g0VX2Sxe/gQSn9YvY7WY
        f+Qcq8XaPX+YLS487WGzOH9+A7vFzS1HWSw2Pb7GanF51xw2ixnn9zFZdF/fwWax/Pg/Jov/
        e3awWyzdepPRgc/jcl8vk8emVZ1sHpuX1Hu0nNzP4vHx6S0Wj74tqxg9jt/YzuTxeZOcR/uB
        bqYAzigum5TUnMyy1CJ9uwSujAVfPjMXnJOq+H7lBUsD4yvRLkYODgkBE4ltU4u6GLk4hAR2
        MErM3rKAsYuREyguLXF94wR2CFtYYuW/5+wQRa8YJR4t/AiWYBPQldixuI0NxBYR0JLonfOU
        FaSIWeA3k8ST+RuZITqeMEocXfgabCyngKHE+5ObwLqFBWIkuv8/YQU5g0VAVeLNjkqQMK+A
        pcT9/x3MELagxMmZT1hASpgF9CTaNoJNYRaQl9j+dg4zxHEKEj+fLmOFuMFN4tO586wQNeIS
        R3/2ME9gFJ6FZNIshEmzkEyahaRjASPLKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M
        4LjV0trBuGfVB71DjEwcjIcYJTiYlUR4mS8bxwvxpiRWVqUW5ccXleakFh9ilOZgURLn/Tpr
        YZyQQHpiSWp2ampBahFMlomDU6qBqXK22dIv25pynHwEY9eLvFtU5mMSxZPREXg5IL/l5KxV
        vkwp/H0tjzWsD9zZ5nqr1M/G5NiyTfOFZqk61U/vmXD+ZLPDn00FgosOPmz6/d4gzGYKx9mE
        jULfXtxe9nHXix2SvZPjKiyXVaU8mxGaVnD6aGnHdAbOvB8iHVem5l4/tviL1qmu6b7HFgSf
        SVe511G5Q+W+47v7kw9fu3qLxyHYIZpvt/Oyb7qWd6dwcHpyB/vNCA103bHdR//PL5aj6lXP
        msRuLt+sk5S67tV/7fLNJ6OffQm58qltRbK6wdk/26+uO3HYg78g4o1oaq5YzvFFecFmfOoP
        ku8037t85LS3sp/cotjfPmpJlXv+31ViKc5INNRiLipOBADF1RaBSgMAAA==
X-CMS-MailID: 20200813012119epcas5p3c6bb1b51ff89ed57dc3c8eae7fe80888
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200613030445epcas5p4428da322cd9527d1075ff0f1ccc75d23
References: <20200613024706.27975-1-alim.akhtar@samsung.com>
        <CGME20200613030445epcas5p4428da322cd9527d1075ff0f1ccc75d23@epcas5p4.samsung.com>
        <20200613024706.27975-5-alim.akhtar@samsung.com>
        <20200812002920.GA1352011@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Eric,

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: 12 August 2020 05:59
> To: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: robh@kernel.org; devicetree@vger.kernel.org;
linux-scsi@vger.kernel.org;
> krzk@kernel.org; avri.altman@wdc.com; martin.petersen@oracle.com;
> kwmad.kim@samsung.com; stanley.chu@mediatek.com;
> cang@codeaurora.org; linux-samsung-soc@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; kishon@ti.com
> Subject: Re: [RESEND PATCH v10 04/10] scsi: ufs: introduce
> UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
> 
> Hi Alim,
> 
> On Sat, Jun 13, 2020 at 08:17:00AM +0530, Alim Akhtar wrote:
> > Some UFS host controllers like Exynos uses granularities of PRDT
> > length and offset as bytes, whereas others uses actual segment count.
> >
> > Reviewed-by: Avri Altman <avri.altman@wdc.com>
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 30 +++++++++++++++++++++++-------
> > drivers/scsi/ufs/ufshcd.h |  6 ++++++
> >  2 files changed, 29 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index ee30ed6cc805..ba093d0d0942 100644
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
> > +				cpu_to_le16((sg_segments *
> > +					sizeof(struct ufshcd_sg_entry)));
> > +		else
> > +			lrbp->utr_descriptor_ptr->prd_table_length =
> > +				cpu_to_le16((u16) (sg_segments));
> >
> >  		prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
> >
> > @@ -3500,11 +3506,21 @@ static void
> ufshcd_host_memory_configure(struct ufs_hba *hba)
> >
> 	cpu_to_le32(upper_32_bits(cmd_desc_element_addr));
> >
> >  		/* Response upiu and prdt offset should be in double words
*/
> > -		utrdlp[i].response_upiu_offset =
> > -			cpu_to_le16(response_offset >> 2);
> > -		utrdlp[i].prd_table_offset = cpu_to_le16(prdt_offset >> 2);
> > -		utrdlp[i].response_upiu_length =
> > -			cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
> > +		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN) {
> > +			utrdlp[i].response_upiu_offset =
> > +				cpu_to_le16(response_offset);
> > +			utrdlp[i].prd_table_offset =
> > +				cpu_to_le16(prdt_offset);
> > +			utrdlp[i].response_upiu_length =
> > +				cpu_to_le16(ALIGNED_UPIU_SIZE);
> > +		} else {
> > +			utrdlp[i].response_upiu_offset =
> > +				cpu_to_le16(response_offset >> 2);
> > +			utrdlp[i].prd_table_offset =
> > +				cpu_to_le16(prdt_offset >> 2);
> > +			utrdlp[i].response_upiu_length =
> > +				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
> > +		}
> >
> >  		ufshcd_init_lrb(hba, &hba->lrb[i], i);
> >  	}
> 
> Isn't this patch missing an update to ufshcd_print_trs()?  It uses
> ->prd_table_length as the number of segments, not the number of bytes.
> 
prd_table_length will be populated before it reaches ufshcd_print_trs()
based on UFSHCD_QUIRK_PRDT_BYTE_GRAN.

> - Eric

