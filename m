Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 033ADC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 17:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFEB820760
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 17:22:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WMoxc3Zi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgF0RVy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 13:21:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50366 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbgF0RVx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 13:21:53 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200627172150epoutp02c48f25dfd4bbd17c98f3a601d57bfe7e~cdl06ipje1918119181epoutp02-
        for <linux-scsi@vger.kernel.org>; Sat, 27 Jun 2020 17:21:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200627172150epoutp02c48f25dfd4bbd17c98f3a601d57bfe7e~cdl06ipje1918119181epoutp02-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593278511;
        bh=Mj1/tnc6RZFnSYd28tvLcQszmXhlaLfSSZ9fxlrTZtc=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=WMoxc3ZiqxbpGbYYNLAxHmXvCHoyngG0OdE7lAM2M5qdLl2EYnoCloVuLOk7POuU0
         R9S8Z410rbvgvbh5AF7J1CbJNNHECAtAHoVVnUKRA4+yNqDsf3X9ytG6KGs+8+Q5Zl
         w/I/bEJQPo0emYl1BdaBkaCjhDs9azUGrGt4cZpU=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200627172150epcas5p2e2f7f15adf0a99adf4859de8b5b1cbd8~cdl0ZzVgW0331203312epcas5p2v;
        Sat, 27 Jun 2020 17:21:50 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.62.09703.E2087FE5; Sun, 28 Jun 2020 02:21:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200627172149epcas5p258f6c4e9aaacaae7be3f57ab45284b36~cdlzYjdtB3099630996epcas5p2z;
        Sat, 27 Jun 2020 17:21:49 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200627172149epsmtrp16b4a101457857ed0bef3cc6e5ffec1e1~cdlzX1YR_1968219682epsmtrp1S;
        Sat, 27 Jun 2020 17:21:49 +0000 (GMT)
X-AuditID: b6c32a4a-4b5ff700000025e7-fa-5ef7802e51f8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7D.60.08303.D2087FE5; Sun, 28 Jun 2020 02:21:49 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200627172146epsmtip1f6660a7806fee34e60dcbe3081c3bf6f~cdlwqXWU91592315923epsmtip1G;
        Sat, 27 Jun 2020 17:21:46 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Dan Carpenter'" <dan.carpenter@oracle.com>
Cc:     "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Kukjin Kim'" <kgene@kernel.org>,
        "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Wei Yongjun'" <weiyongjun1@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
In-Reply-To: <20200626105133.GF314359@mwanda>
Subject: RE: [PATCH] scsi: ufs: ufs-exynos: Remove an unnecessary NULL check
Date:   Sat, 27 Jun 2020 22:51:44 +0530
Message-ID: <041701d64ca7$70bafb80$5230f280$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-in
Thread-Index: AQJZTJzG6GPUwl4om2Vud+BKbvKiigG4ppPqp9jvn9A=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsWy7bCmhq5ew/c4g92ThSxe/rzKZvH633QW
        i0U3tjFZbL0lbdH/+DWzxfnzG9gtbm45ymJxedccNosZ5/cxWXRf38Fmsfz4PyaLw192sTnw
        eLQcecvqsWlVJ5vHhEUHGD0+Pr3F4tG3ZRWjx+dNch7tB7qZAtijuGxSUnMyy1KL9O0SuDLW
        XPjFWjCNo+LRqf1MDYyH2boYOTkkBEwkFh2ZyNzFyMUhJLCbUeLfju8sEM4nRokdzzqgnM+M
        Eg8+XwByOMBavv00g4jvYpT48P8pE4TzhlHi1oM77CBz2QR0JXYsbgPbISJgIHHv5AuwScwC
        B5glbvY/ZgZJcAIVHZ99kwnEFhbwkWjb/5cFxGYRUJW42nqXEcTmFbCUePp8JSuELShxcuYT
        sBpmAXmJ7W/nMEM8oSDx8+kyVoi4uMTRnz3MEIutJKZ+XAa2WELgAofEzGNL2CBecJGYe9gL
        oldY4tXxLewQtpTEy/42doiSbImeXcYQ4RqJpfOOsUDY9hIHrswBBwSzgKbE+l36EFv5JHp/
        P2GC6OSV6GgTgqhWlWh+dxWqU1piYnc3K4TtIXHj8XvWCYyKs5D8NQvJX7OQ/DILYdkCRpZV
        jJKpBcW56anFpgVGeanlesWJucWleel6yfm5mxjBiUzLawfjwwcf9A4xMnEwHmKU4GBWEuH9
        bP0tTog3JbGyKrUoP76oNCe1+BCjNAeLkjiv0o8zcUIC6YklqdmpqQWpRTBZJg5OqQYmsb6o
        TIUkkZDzx0+rHe9ySj21Z7f2jZcmCQczu5NnX/5YLO7xrnvJN5uQ1wZ2er8u/Lv0JST+zLWD
        czdNXruyhVOJQ2KaSGO06bP9B0MTtba879swK7Z3/YyPkYJxm/IVdcPsP1//W/Fo26I5DDeu
        nL6o8rDgs+WBQ89meTUesPXZ+Ge+g4K3/A1xw1nM2W7TNNY2NSckMr+SnX7C2vlQ5xJPmdtJ
        b1/dCLNcmrP7+aEPJgf/2S/wu+K/T33Nn69CZ8sjP721VzptnbXc7t6FpB39Xzel1fW+XRer
        qf6kWu7K2tvHuZ6anZwj1vVVf46TSYs+49JCoylNs44wW16JfRqrIVUqnNqszSWZYTrrnRJL
        cUaioRZzUXEiAE4ddX7TAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWy7bCSnK5uw/c4g/WfeC1e/rzKZvH633QW
        i0U3tjFZbL0lbdH/+DWzxfnzG9gtbm45ymJxedccNosZ5/cxWXRf38Fmsfz4PyaLw192sTnw
        eLQcecvqsWlVJ5vHhEUHGD0+Pr3F4tG3ZRWjx+dNch7tB7qZAtijuGxSUnMyy1KL9O0SuDLW
        XPjFWjCNo+LRqf1MDYyH2boYOTgkBEwkvv0062Lk4hAS2MEo8WXaBJYuRk6guLTE9Y0T2CFs
        YYmV/56zQxS9YpT4/Ws2K0iCTUBXYsfiNjYQW0TAQOLeyRcsIEXMAieYJX4+WMYEkhASqJNo
        bd0KZnMCNRyffRPMFhbwkWjb/xdsG4uAqsTV1ruMIDavgKXE0+crWSFsQYmTM5+wgFzKLKAn
        0bYRrIRZQF5i+9s5zBDHKUj8fLqMFSIuLnH0Zw8zxD1WElM/LmOZwCg8C8mkWQiTZiGZNAtJ
        9wJGllWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMHxqKW1g3HPqg96hxiZOBgPMUpw
        MCuJ8H62/hYnxJuSWFmVWpQfX1Sak1p8iFGag0VJnPfrrIVxQgLpiSWp2ampBalFMFkmDk6p
        BqZZ8+ba/1+WENV0SEgsuz1fI31O9eKZlv1yG76zKl81/lg/oTObxf35AR2v13+uT45j/Sd8
        eZ7H7ca5z27vY5/45cfPm9cf/V5+Ytubi72cixSmWS5T8A7JMWmyd7RREK07+iU8bf/6s3cd
        3qZO92UwjLeP2ewYfnFB6ORu2cnr7FmcYlInr16yw17y/Z1ogdtn4/YLKd9gZNeP+au++kyx
        38epsxZr87u9f9N44PjUVRcTfT4c7NihYy945IDrPZVpBpd41u7IzeeZGsGXeEamZ1WvLZsE
        R85uTvuaYC0h9g3a57byPbjwe62OkOK9P0HLF8wJljefs0ggoHrN0+PcH1w4W/JjH28wXOpw
        9d9qJZbijERDLeai4kQAf11sgTYDAAA=
X-CMS-MailID: 20200627172149epcas5p258f6c4e9aaacaae7be3f57ab45284b36
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200626105156epcas5p191d18d66af6bd09a10635559461c0bc0
References: <CGME20200626105156epcas5p191d18d66af6bd09a10635559461c0bc0@epcas5p1.samsung.com>
        <20200626105133.GF314359@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Dan

> -----Original Message-----
> The "head" pointer can't be NULL because it points to an address in the
middle
> of a ufs_hba struct.  Looking at this code, probably someone would wonder
if
> the intent was to check whether "hba" is NULL, but "hba"
> isn't NULL and the check can just be removed.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
Please add Fixes: tag
With that
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>

Thanks!

>  drivers/scsi/ufs/ufs-exynos.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index
> 16544b3dad47..802f7de626e8 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -264,7 +264,7 @@ static int exynos_ufs_get_clk_info(struct exynos_ufs
> *ufs)
>  	u8 div = 0;
>  	int ret = 0;
> 
> -	if (!head || list_empty(head))
> +	if (list_empty(head))
>  		goto out;
> 
>  	list_for_each_entry(clki, head, list) {
> --
> 2.27.0


