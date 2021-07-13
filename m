Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB99C07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 03:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7D4C6115B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 03:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237673AbhGNDNA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 23:13:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37975 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237436AbhGNDM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 23:12:58 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210714031006epoutp04350c3b90b3423c1843996195d6a1aa87~RiZNBTAPc0532905329epoutp04U
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 03:10:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210714031006epoutp04350c3b90b3423c1843996195d6a1aa87~RiZNBTAPc0532905329epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626232206;
        bh=uNo6/gDO60NpiFx4cHEsAijYP4DccQw7dZnzns/e6uY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=tzWuYYlzWkw9ywLKxAbLZhTPsIhjIaIhPqnH154X0cVgQWMWsBCFQpZ0FWWqBhXvZ
         SVAKqQknlYf5/cnIhkM+FLLw/EuhOXJuQJRLTIF8p7EDuCVhU39jWenpwyJLzJfzuw
         02gNGqU5ZO3mTEdowZey+gK8hWMSqkfzFJkbjvJc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20210714031004epcas5p4e0ab1652d9de7fa07b0961e3ec4cf066~RiZL57nyh2657526575epcas5p4H;
        Wed, 14 Jul 2021 03:10:04 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.40.193]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GPjDB0s8Nz4x9Pv; Wed, 14 Jul
        2021 03:10:02 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D3.1E.09595.3855EE06; Wed, 14 Jul 2021 12:09:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20210713181042epcas5p3a1329897f7237ebc3c52ec1305670f58~RbCQbLnCL0815108151epcas5p3o;
        Tue, 13 Jul 2021 18:10:42 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210713181042epsmtrp1fc228b26c9be844dd2b426e8553a8471~RbCQaPYwj0053000530epsmtrp1h;
        Tue, 13 Jul 2021 18:10:42 +0000 (GMT)
X-AuditID: b6c32a4a-eebff7000000257b-5b-60ee55839000
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8E.69.08289.227DDE06; Wed, 14 Jul 2021 03:10:42 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210713181040epsmtip12be81ae1e2ef5612446af5082493e821~RbCOOUTlE2108921089epsmtip1-;
        Tue, 13 Jul 2021 18:10:40 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Chanho Park'" <chanho61.park@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'jongmin jeong'" <jjmin.jeong@samsung.com>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>
In-Reply-To: <20210709065711.25195-3-chanho61.park@samsung.com>
Subject: RE: [PATCH 02/15] scsi: ufs: add quirk to enable host controller
 without interface configuration
Date:   Tue, 13 Jul 2021 23:40:39 +0530
Message-ID: <034701d77812$64a57b30$2df07190$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEgh/xhOfR89Em7SpyJUmGCKeOVGQH8s41uAjAZoGKsja38QA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIJsWRmVeSWpSXmKPExsWy7bCmhm5L6LsEg6P/mSxOPlnDZvHy51U2
        i2kffjJbfFq/jNXi8n5ti56dzhanJyxisniyfhazxaIb25gsVl6zsLi55SiLxYzz+5gsuq/v
        YLNYfvwfkwOfx+Ur3h6X+3qZPDav0PJYvOclk8emVZ1sHhMWHWD0+Pj0FotH35ZVjB6fN8l5
        tB/oZgrgisqxyUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
        zAG6XkmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhUoFecmFtcmpeul5yfa2Vo
        YGBkClSZkJOxZZ1FwVPRits7rrI0ME4S6mLk5JAQMJE4ceU+UxcjF4eQwG5GiT8nW9khnE9A
        zqMmVgjnM6PEpOlzmLsYOcBaHnwPhojvYpS48OACVPtLRokPpyYygsxlE9CV2LG4jQ0kISIw
        k1Fi1+qzzCAJZoETzBKTT4HZnAL2Eu/mrGEHsYUFsiX+nfzJCmKzCKhKfF62CGwQr4ClxL0n
        f9ghbEGJkzOfsEDM0ZZYtvA1M8QTChI/ny4D6xURcJI4v+k/I0SNuMTRnz1QNW84JA4eU4Gw
        XSTerbzFBGELS7w6voUdwpaSeNnfxg7xZbZEzy5jiHCNxNJ5x1ggbHuJA1fmsICUMAtoSqzf
        pQ8RlpWYemodE8RWPone30+gpvNK7JgHY6tKNL+7CjVGWmJidzfrBEalWUgem4XksVlIHpiF
        sG0BI8sqRsnUguLc9NRi0wKjvNRy5OjexAhO21peOxgfPvigd4iRiYPxEKMEB7OSCO9So7cJ
        QrwpiZVVqUX58UWlOanFhxhNgaE9kVlKNDkfmDnySuINTY3MzAwsDUyNLcwMlcR5l7IfShAS
        SE8sSc1OTS1ILYLpY+LglGpgsjsq3Jqzh6V4RibL3XlzrshyH1l7KPyTflJv7B0e/9VCTfk/
        QyymSq9/9UR+00m2j8EROx6+Obpa11Fhonjas4Y+taOdLbuWt0w4tumu2ZHMrC9vHhXuCM1f
        cXJ15YEfGy+uLnrxY9qdjoWlzJ9makzcFf1V3iX5zc3DD03d++/LxjlO+WI++/bm9xy8kz1n
        n99pfUUo1NnqjtmvuWd2n8tarPB5xy+9ledq3G/kfNu41KpSdar1OpZJR+b9f9S/ds2Dxwet
        3lbY9aXKK8tv3J32xiSi8aC3LYer1Ffvxd9VLhxIzxR59fzqlWuWFSJFHyt3XzoYEhkWVXGp
        OEsyWGP+qr9TDklsPTa36OnLRXGLlViKMxINtZiLihMB7RxQAmQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWy7bCSnK7S9bcJBstuqVucfLKGzeLlz6ts
        FtM+/GS2+LR+GavF5f3aFj07nS1OT1jEZPFk/Sxmi0U3tjFZrLxmYXFzy1EWixnn9zFZdF/f
        wWax/Pg/Jgc+j8tXvD0u9/UyeWxeoeWxeM9LJo9NqzrZPCYsOsDo8fHpLRaPvi2rGD0+b5Lz
        aD/QzRTAFcVlk5Kak1mWWqRvl8CVsbj7NEvBEtGKG0d/MDYwnhfsYuTgkBAwkXjwPbiLkYtD
        SGAHo8TGHTNYuhg5geLSEtc3TmCHsIUlVv57zg5R9JxRYvW7b2AJNgFdiR2L29hAEiICsxkl
        NpzaDlbFLHCBWeLC7idsEC2HGSWaX71lBGnhFLCXeDdnDVi7sECmRNOyfUwgNouAqsTnZYvA
        angFLCXuPfnDDmELSpyc+QTsJmYBbYmnN5/C2csWvmaGuE9B4ufTZawgtoiAk8T5Tf8ZIWrE
        JY7+7GGewCg8C8moWUhGzUIyahaSlgWMLKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3
        MYIjWEtrB+OeVR/0DjEycTAeYpTgYFYS4V1q9DZBiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+F
        rpPxQgLpiSWp2ampBalFMFkmDk6pBiaVDSwigfIu6TF6l/jysrT3/jvD3pmW7jjFtFFu/Sd7
        houRJWb7Wf3Xv9p1vbT2VsqtBRfubWv6IhdVes/3z2Mdl1l3X7sHfizP7DONC5ghtvHkI5/P
        +dllqu2aFya4ydiop/dPCVafPPvI6ZN8FxTVt4dZ+ov9vRbSZjHXIfr+Y46QtZ1c9/qVMzhW
        ZsqmLJXvnvFQaiPnvcXX3hfNYd6w6qbQ4u+tzKaRORcX/n7Nu7W/89NUJca65VUq6gr78iXz
        FmWsilPwvq9rtdrpNvt0Js5TqUrHND8udeQ6m8TJOsN3vrP68shpd83zskPSJx+XF7Y5rmu0
        IH/emWyF+BsfTlhfnfZsS+mlBZuWVSixFGckGmoxFxUnAgD4C6NBTwMAAA==
X-CMS-MailID: 20210713181042epcas5p3a1329897f7237ebc3c52ec1305670f58
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p2f353983bbc64c1a21571fda2be59df34
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p2f353983bbc64c1a21571fda2be59df34@epcas2p2.samsung.com>
        <20210709065711.25195-3-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Chanho

> -----Original Message-----
> From: Chanho Park <chanho61.park=40samsung.com>
> Sent: 09 July 2021 12:27
> To: Alim Akhtar <alim.akhtar=40samsung.com>; James E . J . Bottomley
> <jejb=40linux.ibm.com>; Martin K . Petersen <martin.petersen=40oracle.com=
>
> Cc: Can Guo <cang=40codeaurora.org>; Jaegeuk Kim <jaegeuk=40kernel.org>;
> Kiwoong Kim <kwmad.kim=40samsung.com>; Avri Altman
> <avri.altman=40wdc.com>; Adrian Hunter <adrian.hunter=40intel.com>;
> Christoph Hellwig <hch=40infradead.org>; Bart Van Assche
> <bvanassche=40acm.org>; jongmin jeong <jjmin.jeong=40samsung.com>;
> Gyunghoon Kwon <goodjob.kwon=40samsung.com>; linux-samsung-
> soc=40vger.kernel.org; linux-scsi=40vger.kernel.org; Chanho Park
> <chanho61.park=40samsung.com>
> Subject: =5BPATCH 02/15=5D scsi: ufs: add quirk to enable host controller=
 without
> interface configuration
>=20
> From: jongmin jeong <jjmin.jeong=40samsung.com>
>=20
> samsung ExynosAuto SoC has two types of host controller interface to
> support the virtualization of UFS Device.
> One is the physical host(PH) that the same as conventaional UFSHCI, and t=
he
> other is the virtual host(VH) that support data transfer function only.
>=20
> In this structure, the virtual host does not support like device manageme=
nt.
> This patch skips the interface configuration part that cannot be performe=
d in
> the virtual host.
>=20
> Signed-off-by: jongmin jeong <jjmin.jeong=40samsung.com>
> Signed-off-by: Chanho Park <chanho61.park=40samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c =7C 3 +++
>  drivers/scsi/ufs/ufshcd.h =7C 6 ++++++
>  2 files changed, 9 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 9702086e9860..3451b335f2b4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> =40=40 -7988,6 +7988,9 =40=40 static int ufshcd_probe_hba(struct ufs_hba =
*hba,
> bool async)
>  	if (ret)
>  		goto out;
>=20
> +	if (hba->quirks &
> UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION)
> +		goto out;
> +
>  	/* Debug counters initialization */
>  	ufshcd_clear_dbg_ufs_stats(hba);
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> e67b1fcfe1a2..fe523cbd68dd 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> =40=40 -573,6 +573,12 =40=40 enum ufshcd_quirks =7B
>  	 * support UIC command
>  	 */
>  	UFSHCD_QUIRK_BROKEN_UIC_CMD			=3D 1 << 15,
> +
> +	/*
> +	 * This quirk needs to be enabled if the host controller cannot
> +	 * support interface configuration.
> +	 */
> +	UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION	=3D 1 << 16,
May be UFSHCD_QUIRK_SKIP_PH_CONFIGURATION

>  =7D;
>=20
>  enum ufshcd_caps =7B
> --
> 2.32.0


