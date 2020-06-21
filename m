Return-Path: <SRS0=/9Oe=AC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61372C433E3
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 01:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B55524794
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 01:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oyZfjqOm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgFUBiV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Jun 2020 21:38:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21574 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbgFUBiU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2020 21:38:20 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200621013817epoutp01486a2051b2f567c33b0d44257e8b10c3~aa2SWnOQW1420014200epoutp01i
        for <linux-scsi@vger.kernel.org>; Sun, 21 Jun 2020 01:38:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200621013817epoutp01486a2051b2f567c33b0d44257e8b10c3~aa2SWnOQW1420014200epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592703498;
        bh=Wf35kHoe0kBkM2P1G3hvVfMZgb+ge6GLQ+rh6scetTA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=oyZfjqOmmvg4CquvIiWu9xZbjq6xXpmsr6O429uxn9H7vy+qZbjvn/vjoe0zlq3J3
         vNvp1ggF9n6WpaQ80ppuxz0gvnxAyQBJ7ZVPqSOtiEw/5nQAn08WGUPSxHCFEwJ5fK
         /VnL+85z/Pozqnlg8CbKouizo/wKAp72s92ROP60=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200621013816epcas5p3c091768b942a44b4e9ee4ca532f740b8~aa2QtRjrS0280502805epcas5p34;
        Sun, 21 Jun 2020 01:38:16 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F8.7F.09467.80ABEEE5; Sun, 21 Jun 2020 10:38:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200621013815epcas5p33e3ce3ac74320cab11a9b7ad89a94801~aa2QK9WUq1672016720epcas5p3p;
        Sun, 21 Jun 2020 01:38:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200621013815epsmtrp1acbc7b1126993a84f4179ed8b8e04bcc~aa2QKK0580926709267epsmtrp1J;
        Sun, 21 Jun 2020 01:38:15 +0000 (GMT)
X-AuditID: b6c32a49-a29ff700000024fb-af-5eeeba08ef53
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.56.08382.70ABEEE5; Sun, 21 Jun 2020 10:38:15 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200621013812epsmtip1d7c354e34ec41636e6480620c63d0b58~aa2NCWDBA3012930129epsmtip1P;
        Sun, 21 Jun 2020 01:38:12 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Wei Yongjun'" <weiyongjun1@huawei.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Kukjin Kim'" <kgene@kernel.org>,
        "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Seungwon Jeon'" <essuuj@gmail.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        "'Hulk Robot'" <hulkci@huawei.com>
In-Reply-To: <20200618133837.127274-1-weiyongjun1@huawei.com>
Subject: RE: [PATCH -next] scsi: ufs: ufs-exynos: Fix return value check in
 exynos_ufs_init()
Date:   Sun, 21 Jun 2020 07:08:10 +0530
Message-ID: <005301d6476c$a1e22200$e5a66600$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHj8OS7jYL7T9AGs6Fok+5I/oXdWQK16nsaqLFHRuA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7bCmhi7HrndxBvNusVm8/HmVzWL5hSVM
        Fv+XX2G0WHRjG5PF1lvSFv2PXzNbnD+/gd3i5pajLBabHl9jtZhxfh+TRff1HUANx/8xWRz+
        sovNgddj56y77B4tR96yemxa1cnmMWHRAUaPzUvqPT4+vcXi0bdlFaPH501yHu0HupkCOKO4
        bFJSczLLUov07RK4Mtp3PWEpmMFf0f9iKXsD42qeLkZODgkBE4mT9xezdzFycQgJ7GaUOLRv
        KytIQkjgE6PEtB4xiMQ3RokvR6exw3R0Hb7CApHYyyjxqXc+G4TzhlHi5otWRpAqNgFdiR2L
        28ASIgJ3mCS6WtrAljAL7GCUePf9KdgSTgFbiV+PJrGB2MIC8RLXmnaAdbMIqEq8uLsTLM4r
        YClx4s8FJghbUOLkzCcsIDazgLzE9rdzmCFuUpD4+XQZ2EwRASuJRX+vsEPUiEsc/dnDDLJY
        QuABh8Ste62sEA0uEpMuPYdqFpZ4dXwL1HNSEi/7QS7lALKzJXp2GUOEaySWzjvGAmHbSxy4
        MocFpIRZQFNi/S59iFV8Er2/nzBBdPJKdLQJQVSrSjS/uwrVKS0xsbsb6gAPid/dz1knMCrO
        QvLYLCSPzULywCyEZQsYWVYxSqYWFOempxabFhjmpZbrFSfmFpfmpesl5+duYgQnOi3PHYx3
        H3zQO8TIxMF4iFGCg1lJhPd1wLs4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxKP87ECQmkJ5ak
        ZqemFqQWwWSZODilGpiE4z9sSJ7rH/3/Zkrd1iWrxebx/Z0onz77CV+EscBHeYZ1xp41h1Ju
        ZNe/q5v285u0fW/+Hbt+/QNchbOzst3vZVi73vry2VOZRdfAvmj2ce3At+ViSxpN7b8tcOFq
        ipndk7lVTrnlQPe+izEdS5LeFbu5HOB8eCFaTvBDe8LjMukVZ9dtq9K98m15nTrjpPDA94W/
        813MDTWndz6sOpNT861MU/dxjVPalsbL57NOHlyxYIa7Hv/EB1VPErX2b9YyaM7yfPbV7sxU
        z21fDjw92HonZYtLy88n07a0fXzzau3+5q5MhnMnVjU+urux9+Knh6Uv2x9m5a0W2nfy5ObD
        y11Ein+WFH/Q03CaZLtdiaU4I9FQi7moOBEAVwbEZuMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWy7bCSnC77rndxBu3LlC1e/rzKZrH8whIm
        i//LrzBaLLqxjcli6y1pi/7Hr5ktzp/fwG5xc8tRFotNj6+xWsw4v4/Jovv6DqCG4/+YLA5/
        2cXmwOuxc9Zddo+WI29ZPTat6mTzmLDoAKPH5iX1Hh+f3mLx6NuyitHj8yY5j/YD3UwBnFFc
        NimpOZllqUX6dglcGe27nrAUzOCv6H+xlL2BcTVPFyMnh4SAiUTX4SssXYxcHEICuxklFtze
        zg6RkJa4vnEClC0ssfLfc3aIoleMEi+X32ADSbAJ6ErsWNzGBpIQEXjEJLHvwGGwUcwCexgl
        Wtbth2rpY5SYP2k2WAungK3Er0eTwGxhgViJZWenMYLYLAKqEi/u7gSL8wpYSpz4c4EJwhaU
        ODnzCdBUDqCpehJtG8HKmQXkJba/ncMMcZ6CxM+ny1hBbBEBK4lFf6+wQ9SISxz92cM8gVF4
        FpJJsxAmzUIyaRaSjgWMLKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYIjVktzB+P2
        VR/0DjEycTAeYpTgYFYS4X0d8C5OiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+NwoVxQgLpiSWp
        2ampBalFMFkmDk6pBiYfq13ywvYzwy4VmX3Ucgn5JqXVHvrD1/e/2k+3qWmZ27vfzb10hu/2
        o6sfV0k/Kzyikmj+8t7/Fs3vH0Mld6zgvutrbH5ZfKKyzcu/NceF1qkrP9sVs3GS7IHH3voi
        sammHCnFizvsFcM/7Pvw6Ka66pEFNyY5TF3Gm364e8I1l4lnL9g+OH1qtmPhvk+yP18udspM
        qV/q5dfupXFaQUlg+maNmX5XRYKMr744tCQn7vauJXFKp++lrTMsr1tx5uXsqFtcahNOLN7z
        RiqrgVdTSe5f4uEfQV8mvdBcqKLzS2O9snN438K1kt8dukX8qjQmnLu0vYfX3mbtjg2H9h/q
        YhTUkti2cb37fIOdP2Z/UmIpzkg01GIuKk4EAIUGRlRHAwAA
X-CMS-MailID: 20200621013815epcas5p33e3ce3ac74320cab11a9b7ad89a94801
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200618133510epcas5p2e9350caceec46069d21174129af4564a
References: <CGME20200618133510epcas5p2e9350caceec46069d21174129af4564a@epcas5p2.samsung.com>
        <20200618133837.127274-1-weiyongjun1@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Wei,

> In case of error, the function devm_ioremap_resource() returns ERR_PTR()
and
> never returns NULL. The NULL test in the return value check should be
replaced
> with IS_ERR().
> 
> Fixes: 55f4b1f73631 ("scsi: ufs: ufs-exynos: Add UFS host support for
Exynos
> SoCs")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>

Thanks!

>  drivers/scsi/ufs/ufs-exynos.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index
> 440f2af83d9c..c918fbc6ca60 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -950,25 +950,25 @@ static int exynos_ufs_init(struct ufs_hba *hba)
>  	/* exynos-specific hci */
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> "vs_hci");
>  	ufs->reg_hci = devm_ioremap_resource(dev, res);
> -	if (!ufs->reg_hci) {
> +	if (IS_ERR(ufs->reg_hci)) {
>  		dev_err(dev, "cannot ioremap for hci vendor register\n");
> -		return -ENOMEM;
> +		return PTR_ERR(ufs->reg_hci);
>  	}
> 
>  	/* unipro */
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> "unipro");
>  	ufs->reg_unipro = devm_ioremap_resource(dev, res);
> -	if (!ufs->reg_unipro) {
> +	if (IS_ERR(ufs->reg_unipro)) {
>  		dev_err(dev, "cannot ioremap for unipro register\n");
> -		return -ENOMEM;
> +		return PTR_ERR(ufs->reg_unipro);
>  	}
> 
>  	/* ufs protector */
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> "ufsp");
>  	ufs->reg_ufsp = devm_ioremap_resource(dev, res);
> -	if (!ufs->reg_ufsp) {
> +	if (IS_ERR(ufs->reg_ufsp)) {
>  		dev_err(dev, "cannot ioremap for ufs protector register\n");
> -		return -ENOMEM;
> +		return PTR_ERR(ufs->reg_ufsp);
>  	}
> 
>  	ret = exynos_ufs_parse_dt(dev, ufs);
> 
> 


