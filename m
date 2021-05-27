Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6391CC47089
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 16:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D4C5613AF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 16:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbhE0Qo3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 12:44:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36712 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbhE0Qo3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 12:44:29 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210527164254epoutp0497995a6a6517255caa9bc733c55b4a55~C_hLIQEBj2737927379epoutp04V
        for <linux-scsi@vger.kernel.org>; Thu, 27 May 2021 16:42:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210527164254epoutp0497995a6a6517255caa9bc733c55b4a55~C_hLIQEBj2737927379epoutp04V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622133774;
        bh=1+JFESdSBsotFHC3dcKI7dw1DchltoZ8JDX1hkdLQDo=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=BG3GogtEO1GLc4PBoBNpPg8Pi9s2xWFq+MYisR02DxaIE5luJj6qzz9hkqZ63Ctby
         mbWSmfRJhoOPiA36rijifByWjAUY5JoxzyYmZaSpTPC8lA07n2QV42s9WL3/v3TAap
         i2bGJh6d2dT4HW6kO70my6MNN4+sY43Q69hoDyPQ=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20210527164252epcas5p15a44edede8f6b14329115b9df2996fc3~C_hJjMfV60595305953epcas5p1n;
        Thu, 27 May 2021 16:42:52 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.C8.09835.C0CCFA06; Fri, 28 May 2021 01:42:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210527163955epcas5p43641cf28a8b95639fa8c42d5391cddeb~C_eks0OaM0685106851epcas5p4i;
        Thu, 27 May 2021 16:39:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210527163955epsmtrp24c096cf20d8f49d491b4c0312c5b14f6~C_ekr4KbS2331423314epsmtrp2h;
        Thu, 27 May 2021 16:39:55 +0000 (GMT)
X-AuditID: b6c32a4b-7dfff7000000266b-f3-60afcc0c7298
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        5A.79.08163.B5BCFA06; Fri, 28 May 2021 01:39:55 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210527163953epsmtip1f53c36e265fc40091396df6b41f7fd8a~C_einSiei0363303633epsmtip1e;
        Thu, 27 May 2021 16:39:53 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Alice'" <alice.chao@mediatek.com>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>
Cc:     <wsd_upstream@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <powen.kao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>
In-Reply-To: <20210527155817.15006-2-alice.chao@mediatek.com>
Subject: RE: [PATCH 1/1] scsi: ufs-mediatek: Fix HWReset timing
Date:   Thu, 27 May 2021 22:09:51 +0530
Message-ID: <002501d75316$ec811f30$c5835d90$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJ/S3WtpA616KKvLcMZkQ69/Ytq8AE2mfPgATAvLX+plF6GgA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTdxjG/Z9LOVyKh0L0HQw1TUCL2qJgdrxiALGJH8QPGjUxUPUECVBq
        Czg2N29oB8WlUxBtgBqUi0RFUWjtZikVLCqGgEULUqMElmFAERYFm4C0ByLffu/1eZ/kpXBB
        CxlMpcqzWKVcli7k+RCNj0Si1X7tdcmR/7QuY/KKyryYocluHjPd4fJiXvbqeUztsJHHVDga
        McaR30Qy+io9zmhezeSqbVMY0zDmIpkR5zTBVDb0IMYw1Ydt9ZdqKyxImvekiZB+GuwlpOP1
        S6RqiwZLJPf7bDrMpqfmsErJlmSfIyZzKaH4l//zZectdBK99C1A3hTQ0XA/f5IsQD6UgP4b
        wX+d3bPBGILewQ6cC8YRmF84iLmR9ikTcrOANiEYrvLlmoYQWG0tngKPXg3Ga+d47kIQfQeB
        6VOtZxVODyKoMJs9q7zpzeCydGFuDqRjoNDxyMMEHQY9A2dxN/Pp9dBf/tWL4wB4cmXAM4vT
        S8EwUopzJy2DycEq0s1BdCxM2PWI61kMrZOFHmGg2yn4rDNj3EA8OAxqkuNAeG+778VxMIx/
        eDhzNjXDaVBoiuLSx6Gy/PGs/Riw2EsJdwtOi6DOJOHSoVD89DbGyfrDedfArBIfjOVzHAZn
        PnTPrgmBvzQaUouEunnOdPOc6eY50H1Xu4qIWvQDq1BlpLCqdYooOXtMrJJlqLLlKeJDmRn1
        yPNoETuMqP/tqNiKMApZEVC4MIjffOZWsoB/WJb7C6vMTFJmp7MqKwqhCOFifs27i8kCOkWW
        xaaxrIJVzlUxyjv4JLZkVZzd+CUnu+j03qW5iZvHBA12vwj7nyXFoRsGHhrEby+pF7U1b9Ob
        1WX69cVrriaWJFn2OfuaYqabnp+Pf6/Isq7TPVBERiqcHem55B8R1y8YzN6+afB/+E3xyrBs
        /z0tfnG5bXf5PQHsyNBE7U5l8a7PVM1N0ZXbNUO6E46DPD+VOo8vsSmeLdROCMO3p22897pF
        m1AfIo2uPr42roQYPaTB+9ZKonJOdaVevBOtrMQDjlq6Ol1fWoeZkH4m4VpnwscFy3fYytpE
        sY2yqCRjV7TD+dOPTvnjX+tkv6+yvcnY2V9x43mCb2DzbmOo9mDdqcD83w6skHyMTSkYjc/0
        FxKqI7I1EbhSJfsG0PtLJtcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSnG706fUJBvMeyFi0TJnLbvHy51U2
        i//nf7NbXLs1n81i1ZsdbBaLbmxjsrjRuZ/VYv6y+cwW3deBYsuP/2Oy2PrpN6vF27v/WSyW
        br3JaLH93x0mBz6PCYsOMHq0nNzP4vHx6S0Wj8+b5DzaD3QzBbBGcdmkpOZklqUW6dslcGXs
        2jeHpeAZb8WMu2sZGxivcXcxcnJICJhInPm3i7GLkYtDSGAHo8SN9Q9YIRLSEtc3TmCHsIUl
        Vv57DmYLCTxnlLj8WAHEZhPQldixuI0NpFlEYBujROOsk8wgCWaBt4wSr97rQkzdzyix7P4V
        sKmcArYSvw9cYgKxhQXsJXpuHAazWQRUJW4+aQVr5hWwlHg07xc7hC0ocXLmE5YuRg6goXoS
        bRsZIebLS2x/O4cZ4jgFiZ9Pl4GNFxFwkvhxZT5UjbjE0Z89zBMYhWchmTQLYdIsJJNmIelY
        wMiyilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOCa1tHYw7ln1Qe8QIxMH4yFGCQ5m
        JRHeg81rE4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpg
        WrLTaL56zn/GqIILR97+2O608vuOzi2vLNWeisqWKy3aNets4oJ8zxtb7eN3yLHmvFrwe9rc
        F08ULhzU//L5gM1Uy0MrJhrcYWIJOsYQabwxZnKM2h6JpQ3CCxcc8GEr2jjdQfr1o+/qUzlO
        Bm3/9llj+pTT3lc846dI1drl1+eVz498WCj4dgVTfS2H7+7P+1eKa53WFtglIq/Byfk2167k
        7dK2QuMpeYeF70o/3bVY0ErgZxlL4Lb+wpLmZX93/Nq+Zr/qVfa/MwuZNP19Wy3UqysaP2RN
        OdevPd0rdXPUjbL7GfOXCG78lnlwwvqva1wDi6L3dcR2t/IqVKpkfDF5K17YPHdOVyt7EMeM
        XCWW4oxEQy3mouJEAEv2yuY4AwAA
X-CMS-MailID: 20210527163955epcas5p43641cf28a8b95639fa8c42d5391cddeb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210527160141epcas5p278b7a9f787b6b359ec175fcade57323a
References: <20210527155817.15006-1-alice.chao@mediatek.com>
        <CGME20210527160141epcas5p278b7a9f787b6b359ec175fcade57323a@epcas5p2.samsung.com>
        <20210527155817.15006-2-alice.chao@mediatek.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Alice <alice.chao@mediatek.com>
> Sent: 27 May 2021 21:28
> To: stanley.chu@mediatek.com; linux-scsi@vger.kernel.org;
> martin.petersen@oracle.com; avri.altman@wdc.com;
> alim.akhtar@samsung.com; jejb@linux.ibm.com
> Cc: wsd_upstream@mediatek.com; peter.wang@mediatek.com; chun-
> hung.wu@mediatek.com; alice.chao@mediatek.com;
> jonathan.hsu@mediatek.com; powen.kao@mediatek.com;
> cc.chou@mediatek.com; chaotian.jing@mediatek.com;
> jiajie.hao@mediatek.com
> Subject: [PATCH 1/1] scsi: ufs-mediatek: Fix HWReset timing
> 
> From: "Alice.Chao" <alice.chao@mediatek.com>
> 
> HCI disable before HW Reset.
> Because of the property of mtk ufshci,
> we need to change reset flow to avoid potential issues.
> 
Please re-format the commit message and mention few wards about potential
issues.

> Change-Id: I3eb917fd2953b58dcf7e021286d1de71c9232cfb
Hmm, run a checkpatch before submitting any patch. 

> Signed-off-by: Alice.Chao <alice.chao@mediatek.com>
> CR-Id: ALPS05728133
What are these ID? Please remove.
> Feature: UFS(Universal Flash Storage)
Please check Documentation/process/submitting-patches.rst, before submitting
patches.

> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c
b/drivers/scsi/ufs/ufs-mediatek.c
> index a981f261b304..c62603ed3d33 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -846,6 +846,9 @@ static int ufs_mtk_device_reset(struct ufs_hba *hba)
> {
>  	struct arm_smccc_res res;
> 
> +	/* disable hba before device reset */
> +	ufshcd_hba_stop(hba);
> +
>  	ufs_mtk_device_reset_ctrl(0, res);
> 
>  	/*
> --
> 2.18.0


