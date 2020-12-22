Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC5E9C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89C4B22AED
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgLVCXW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 21:23:22 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:30201 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgLVCXV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 21:23:21 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201222022237epoutp049408dc128e7411220bfb4746e6538927~S6Jg8pM9r2588425884epoutp04i
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:22:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201222022237epoutp049408dc128e7411220bfb4746e6538927~S6Jg8pM9r2588425884epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608603757;
        bh=RLiJuGSk+dj3cueT8lTJXvb6aeqRsDHDMw7qMG4sHdc=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=YylZADCS9zACLoBYYksHuK97TBSEJsGJyTA/HZdfsaHupvRereicbmhEGouBcmkOC
         wJLE2JC6AfVBryci9WqQKNqI8YyGX/Zl2nlNjyEPOEPzRbU+6qORfVtgHfwR72k00K
         KMFXD60D5JGCDtUSdBXFhOsY34xdrzZsJ2pAzZXc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201222022236epcas2p2e6330ab5e69a87846e200e4bbe87a236~S6Jf1r3vE0046800468epcas2p20;
        Tue, 22 Dec 2020 02:22:36 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4D0KqZ666dzMqYkV; Tue, 22 Dec
        2020 02:22:34 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        2D.25.05262.76851EF5; Tue, 22 Dec 2020 11:22:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20201222022231epcas2p1f38d8c8268f818b5e61f253c35a9d2d3~S6Ja9_U912863528635epcas2p1x;
        Tue, 22 Dec 2020 02:22:31 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201222022231epsmtrp2ee631becc880c8adfd7cbba3a1c862b8~S6Ja8_DL_1014810148epsmtrp2P;
        Tue, 22 Dec 2020 02:22:31 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-24-5fe158677d85
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B2.24.08745.66851EF5; Tue, 22 Dec 2020 11:22:30 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201222022230epsmtip22fc2dc3acc3b9e6daab2087780e5943a~S6JabpOdi2316523165epsmtip2F;
        Tue, 22 Dec 2020 02:22:30 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <bvanassche@acm.org>, <grant.jung@samsung.com>,
        <sc.suh@samsung.com>, <hy50.seo@samsung.com>,
        <sh425.lee@samsung.com>, <bhoon95.kim@samsung.com>
In-Reply-To: <750d12f8707189b51d0f1befb5f264a247e05cef.1608602725.git.kwmad.kim@samsung.com>
Subject: RE: [PATCH v2 2/2] ufs: ufs-exynos: set dma_alignment to 4095
Date:   Tue, 22 Dec 2020 11:22:30 +0900
Message-ID: <000d01d6d809$4c9bc2f0$e5d348d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHm7+6dPdAGyfjDiuSAwvjqkSxCMwJ2yeZBAuAqL2Spt3rKEA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUwTZxzOe72WK0nlLGy81mWDolvUQT9c66Ew0Rm8BBJBzQJO093gUupK
        W3vQzG3J2LRQqzJERFsycE5YxmQFJB2pKUJZ0jIWQ7RsjFAoc4AfERzNYLiAa7ma8d/z+3ie
        5/d7PzCO0McTYRpdGW3UUVoxLxZ19m8hUtUFkyrpxF0lEWx08gh3pS+GeLg0zCP6Js+gxN/N
        01yi/ukSh5h3tHCJZ8uOGOL7b4IocW3EiRBnf+vmEd96VxDCGhgBRPPKEzRrHXnPn0Peqz6P
        kDXXegG56LDwyL+mRlGyuqsVkKHOV8mq3rNIHnZEm1FCU8W0MYnWFemLNTp1pjjnkOodlUIp
        laXK0okd4iQdVUpnivfl5qVma7ThucVJJkpbHk7lUQwjlrydYdSXl9FJJXqmLFNMG4q1BpnM
        kMZQpUy5Tp1WpC/dKZNK5Ypw5/vaksWuP1DDvPAjZ5uXWwEa4qyAj0H8LfjL8lWuFcRiQrwb
        wMctfTFsMA+g3/dvNAgBuDhah76gBKpDgC24AKy31UeDBwBamyJ8PsbDt8H6yVurwgn4AwSO
        tE3wrADD+PhR6L0jicB4PBvODUsi7Si+Gbb3BlYNBHg6vDlzhcfi9XDA9udqnhOWbPn6MYcd
        IgkuTbVwIzgB3wuHB60I25MAG85UciK2EPdj8I5jBo14QXwfrPOsZ7nx8JG3K4bFIhiadfNY
        /BnsuVTBZbnnAJzqWQFsYTu0T1eBiA4H3wIdLgkrmQJ/Go2Otg5a+pdj2LQAWiqFLDEFPqu9
        GBXZAG2/j0VdSRi43smtAcn2NUva1yxpX7OM/X/fqwBtBS/TBqZUTTNyw/a1d90JVp/01v3d
        4MqTp2kegGDAAyDGEScIlKIJlVBQTJ38mDbqVcZyLc14gCJ87Bc4opeK9OE/oStTyRRypVKa
        riAUSjkhThQw0qBKiKupMvpDmjbQxhc8BOOLKpDbFneA8pm7bM6AecFi4Yskz5nSXxt8cnf6
        pjoqPvbG0NzPs0c+HZpaGjHFbdjhsdWnTg0N5X6RfLBtV8f5rDeun+j2Yj3nskbaTY2bL7u3
        kRI3NDs0RV8Wprx76qsPamsdWN/9E88PL/XUFSQf0yruZ2883r6w8XP6qIccY37MX5h3igqb
        O1zKzI4fLjUYik9lBD0X+m/O3mo6+U/V+MArtoDWNa54uAerOfydIs49bTrtP25bJN8bG0yM
        9b/ZNLhrLiOE7DZ/cnFs92t7XaeruYWP/I2C8bv4TP4EciPx9TpSNHDQZG+S5BYcmz90u0iT
        f6Bvv3l2jzoneLl154FOMcqUULKtHCND/Qf+gxI/WwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWy7bCSvG5axMN4g6unjCwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6MP58+MhVsEapYOGsbWwPjTb4uRk4OCQETibt9nxm7GLk4hAR2MEps
        Pr6RBSIhKXFi53NGCFtY4n7LEVYQW0jgGaPE1+NJIDabgLbEtIe7WUGaRQR+MUlcO7aZFWLS
        LUaJi9NfMHcxcnBwCsRIHD+nD2IKC7hJvL+qD9LLIqAqseHAXbBdvAKWEpufz2CDsAUlTs58
        AhZnBprf+7CVEcZetvA1M8Q9ChI/ny4Du0dEwEni6ukuJogaEYnZnW3MExiFZiEZNQvJqFlI
        Rs1C0rKAkWUVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZwXGpp7WDcs+qD3iFGJg7G
        Q4wSHMxKIrxmUvfjhXhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl
        4uCUamBSF3+/7riUhCTXLanmx0p7jHc//K3TwXqYuXT+NpNnvJ83TJxm6bp8jeX/+ktizofX
        FkyYM6NVgCkx5ePvvT+PFy567Wxg7+Wlf5n3zf6cV1UCfL3Wn7rKI6I6/udl5qW2MxS//1Jy
        7WUUU7OLjY5L2UEN380zY6o0V2kz9CSfS70ZX5i/8g3jnlCNaZonDXMkL+7pf25QYFS5Pskq
        7YVA7hneQPu3f1LW/Gj+cfD34jrpmMn7+b+G6WxnUIjete7osYnmIa/a/37gV2Pm2si36mto
        vw3n78q3HFvfpT+fI6qesqFRuvavKkcYU8LbU6XZq++/+LtXqXyBHbdB+KFLYgur1Be6HN21
        16JuN48SS3FGoqEWc1FxIgBgEO7xOgMAAA==
X-CMS-MailID: 20201222022231epcas2p1f38d8c8268f818b5e61f253c35a9d2d3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222021739epcas2p306802e943b386815e819259681c9efd4
References: <cover.1608602725.git.kwmad.kim@samsung.com>
        <CGME20201222021739epcas2p306802e943b386815e819259681c9efd4@epcas2p3.samsung.com>
        <750d12f8707189b51d0f1befb5f264a247e05cef.1608602725.git.kwmad.kim@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Exynos requires one scatterlist entry for smaller than page size, i.e. 4K=
B.
> For the cases of dispatching commands with more than one scatterlist entr=
y
> and under 4KB size, Exynos behaves as follows:
>=20
> Given that a command to read something
> from device is dispatched with two scatterlist entries that are named AAA
> and BBB. After dispatching, host builds two PRDT entries and during
> transmission, device sends just one DATA IN because device doesn't care o=
n
> host dma. The host then tranfers the whole data from start address of the
> area named AAA.
> In consequebnce, the area that follows AAA would be corrupted.
>=20
>     =7C<------------->=7C
>     +-------+------------         +-------+
>     +  AAA  + (corrupted)   ...   +  BBB  +
>     +-------+------------         +-------+
>=20
> Signed-off-by: Kiwoong Kim <kwmad.kim=40samsung.com>
> ---
>  drivers/scsi/ufs/ufs-exynos.c =7C 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.=
c
> index a8770ff..1fd5265 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> =40=40 -14,6 +14,7 =40=40
>  =23include <linux/of_address.h>
>  =23include <linux/phy/phy.h>
>  =23include <linux/platform_device.h>
> +=23include <linux/blkdev.h>
>=20
>  =23include =22ufshcd.h=22
>  =23include =22ufshcd-pltfrm.h=22
> =40=40 -1193,6 +1194,13 =40=40 static int exynos_ufs_resume(struct ufs_hb=
a *hba,
> enum ufs_pm_op pm_op)
>  	return 0;
>  =7D
>=20
> +static void exynos_ufs_config_request_queue(struct scsi_device *sdev) =
=7B
> +	struct request_queue *q =3D sdev->request_queue;
> +
> +	blk_queue_update_dma_alignment(q, PAGE_SIZE - 1); =7D
> +
>  static struct ufs_hba_variant_ops ufs_hba_exynos_ops =3D =7B
>  	.name				=3D =22exynos_ufs=22,
>  	.init				=3D exynos_ufs_init,
> =40=40 -1204,6 +1212,7 =40=40 static struct ufs_hba_variant_ops ufs_hba_e=
xynos_ops
> =3D =7B
>  	.hibern8_notify			=3D exynos_ufs_hibern8_notify,
>  	.suspend			=3D exynos_ufs_suspend,
>  	.resume				=3D exynos_ufs_resume,
> +	.config_request_queue		=3D exynos_ufs_config_request_queue,
>  =7D;
>=20
>  static int exynos_ufs_probe(struct platform_device *pdev)
> --
> 2.7.4

Sorry for bothering all of you posting because of a wrong version of this. =
Will do again.

Thanks.
Kiwoong Kim

