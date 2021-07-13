Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37F3C11F66
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 03:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDF366115B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 03:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbhGNDMz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 23:12:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26617 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237436AbhGNDMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 23:12:54 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210714031001epoutp03e1732d45a8961821b41c3d4b73a7f5f4~RiZJFYFOU1492814928epoutp03c
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 03:10:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210714031001epoutp03e1732d45a8961821b41c3d4b73a7f5f4~RiZJFYFOU1492814928epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626232201;
        bh=cFDrPIvrVF0lz6D3LluAt5u8rVCj1HQqxkHoPwB2C1s=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=KoXTeJEsD9/ybGOi/Z2YKC50mwVqE14qq2juZnTObfLk11KjCOJRdbNksqkpO43Ax
         Hki68KwZuZ0OajS9wnaQDTK+NXs1AkiWd2PwKuTseCYYw39QDhBPCgWDaTuehMNG44
         ugH0Ec9bX6s5aCJAE4SfjJX+z3VtcIPm5BTUEMoM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20210714031001epcas5p4a4b79ac7b2749ce75f729e56e55b4f45~RiZIkzg8A1021410214epcas5p4X;
        Wed, 14 Jul 2021 03:10:01 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.40.196]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GPjD73cncz4x9Pt; Wed, 14 Jul
        2021 03:09:59 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        65.24.09452.7855EE06; Wed, 14 Jul 2021 12:09:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210713181829epcas5p47e4dcec8231a059d4eef18d26d129ae4~RbJDKvl0k3019330193epcas5p4u;
        Tue, 13 Jul 2021 18:18:29 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210713181829epsmtrp280cda58ae83a9ccd6c3ab25215b7a6dd~RbJDJ0Rtj0070800708epsmtrp2h;
        Tue, 13 Jul 2021 18:18:29 +0000 (GMT)
X-AuditID: b6c32a4b-429ff700000024ec-0b-60ee5587cbff
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        08.99.08289.5F8DDE06; Wed, 14 Jul 2021 03:18:29 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210713181827epsmtip27574cac0cdf566ff1bb0f9f8e7ebc6a1~RbJBEeJu71155211552epsmtip2i;
        Tue, 13 Jul 2021 18:18:27 +0000 (GMT)
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
In-Reply-To: <20210709065711.25195-4-chanho61.park@samsung.com>
Subject: RE: [PATCH 03/15] scsi: ufs: ufs-exynos: change pclk available max
 value
Date:   Tue, 13 Jul 2021 23:48:26 +0530
Message-ID: <034801d77813$7af5a670$70e0f350$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEgh/xhOfR89Em7SpyJUmGCKeOVGQJgar2qAvOcEFOshHYPsA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEJsWRmVeSWpSXmKPExsWy7bCmpm576LsEg7NvRS1OPlnDZvHy51U2
        i2kffjJbfFq/jNXi8n5ti56dzhanJyxisniyfhazxaIb25gsVl6zsLi55SiLxYzz+5gsuq/v
        YLNYfvwfkwOfx+Ur3h6X+3qZPDav0PJYvOclk8emVZ1sHhMWHWD0+Pj0FotH35ZVjB6fN8l5
        tB/oZgrgisqxyUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
        zAG6XkmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhUoFecmFtcmpeul5yfa2Vo
        YGBkClSZkJOx+08bS8EXnoq+v1tZGxibubsYOTkkBEwkJp/vZ+pi5OIQEtjNKNH27Qw7hPOJ
        UeLs1R1Qmc+MEgduPWCBaVl1cgELRGIXo8SnxfuhWl4ySvxYMB2sik1AV2LH4jY2kISIwExG
        iV2rzzKDJJgFTjBLTD4FZnMK2EusPLOSHcQWFgiWOH/4FlicRUBV4s/J+WwgNq+ApcTTIwuZ
        IWxBiZMzn7BAzNGWWLbwNTPESQoSP58uY+1i5ABa5iSx8agSRIm4xNGfPVAlLzgkDvR5Q9gu
        Evce74KKC0u8Or6FHcKWkvj8bi8byBgJgWyJnl3GEOEaiaXzjkE9by9x4MocFpASZgFNifW7
        9CHCshJTT61jgtjKJ9H7+wkTRJxXYsc8GFtVovndVagx0hITu7tZJzAqzULy1ywkf81C8sAs
        hG0LGFlWMUqmFhTnpqcWmxYY56WWI8f3JkZw4tby3sH46MEHvUOMTByMhxglOJiVRHiXGr1N
        EOJNSaysSi3Kjy8qzUktPsRoCgzsicxSosn5wNyRVxJvaGpkZmZgaWBqbGFmqCTOu5T9UIKQ
        QHpiSWp2ampBahFMHxMHp1QDk6Vc+osJL04zT2jIvb/rYO9SnqzjzxpYz8yMntsysVed0WDS
        wy82ypwXtm+7WBBtJN33/k09W8gPxSqv/0xfp0XMS1Lhehrten6vB7PeQSF2zZr9bc8C19t/
        OLXPt7SrtkqddcYmsR/6nzsZr6cEuHHeLu9T3pdU/eajUU9BapNZdatoXvCsvYENZlZW/807
        1ZcW/GBqy9y1YLt3rXCQrct0IdGznXLVLaduLVpyJOyHoGO6nqtvUcbxLVkPbJZbrmGInVL5
        4P+dz17VazbNff9ipvK1ojd2vB0bz0/b7bNZM937byzbrfbNK+UP79mSHr1be5f1lPXGAq+V
        eQ/+jtJSNGEPnOt3rn/+u2ApJZbijERDLeai4kQAsTLuSmUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWy7bCSvO7XG28TDN58l7Y4+WQNm8XLn1fZ
        LKZ9+Mls8Wn9MlaLy/u1LXp2OlucnrCIyeLJ+lnMFotubGOyWHnNwuLmlqMsFjPO72Oy6L6+
        g81i+fF/TA58HpeveHtc7utl8ti8Qstj8Z6XTB6bVnWyeUxYdIDR4+PTWywefVtWMXp83iTn
        0X6gmymAK4rLJiU1J7MstUjfLoErY/H350wFW3kqfnV+Z25gPMbVxcjJISFgIrHq5AKWLkYu
        DiGBHYwSHXeus0MkpCWub5wAZQtLrPz3nB2i6DmjxPqVvSwgCTYBXYkdi9vYQBIiArMZJTac
        2g5WxSxwgVniwu4nbBAthxklnq+5zArSwilgL7HyzEqwucICgRKfGq+CjWIRUJX4c3I+G4jN
        K2Ap8fTIQmYIW1Di5MwnYDXMAtoST28+hbOXLXzNDHGfgsTPp8uA5nMAneEksfGoEkSJuMTR
        nz3MExiFZyGZNAvJpFlIJs1C0rKAkWUVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZw
        BGtp7WDcs+qD3iFGJg7GQ4wSHMxKIrxLjd4mCPGmJFZWpRblxxeV5qQWH2KU5mBREue90HUy
        XkggPbEkNTs1tSC1CCbLxMEp1cAkEGTXbZ9TUOB+e/XkhO8H2b3evzr+NnvX1K2dhXqLN2/W
        X5epeu2z8N5jkmqzt6SEKfE3HC/bti2o/+T/WYrTpxxnl/BesVuPrzZiamvpYdbJu5h84s61
        +e17cTx4yqy+NzpMet8KmBqkrWRmXilfknX0hIidhUdFuPniOY8cvqsH1U4TZFj3O7s/yvee
        j9E8GSWr0lSdA9p+d9Q22t9SPh9dfUdoU/3kpZ6Xnj45ZyBzqHPmp8nrbkctsjApEGtI4gkN
        aV6nV6EYprpMY059I1/tmruPdFx2fomeU2D+7radp4sV22WfxQeVIpmPJe3RCur/ML/RgUtv
        WUtGZEfwbDtu1w8N8Vfmr1R9906JpTgj0VCLuag4EQCqozZUTwMAAA==
X-CMS-MailID: 20210713181829epcas5p47e4dcec8231a059d4eef18d26d129ae4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p47985fa3c33297a36d772fb9d45f30972
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p47985fa3c33297a36d772fb9d45f30972@epcas2p4.samsung.com>
        <20210709065711.25195-4-chanho61.park@samsung.com>
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
> Subject: =5BPATCH 03/15=5D scsi: ufs: ufs-exynos: change pclk available m=
ax value
>=20
> To support 167MHz PCLK, we need to adjust the maximum value.
>=20
> Signed-off-by: Chanho Park <chanho61.park=40samsung.com>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar=40samsung.com>

>  drivers/scsi/ufs/ufs-exynos.h =7C 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.=
h
> index 67505fe32ebf..475a5adf0f8b 100644
> --- a/drivers/scsi/ufs/ufs-exynos.h
> +++ b/drivers/scsi/ufs/ufs-exynos.h
> =40=40 -99,7 +99,7 =40=40 struct exynos_ufs;
>  =23define PA_HIBERN8TIME_VAL	0x20
>=20
>  =23define PCLK_AVAIL_MIN	70000000
> -=23define PCLK_AVAIL_MAX	133000000
> +=23define PCLK_AVAIL_MAX	167000000
>=20
>  struct exynos_ufs_uic_attr =7B
>  	/* TX Attributes */
> --
> 2.32.0


