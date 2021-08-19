Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3530C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 01:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D02B60698
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 01:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235663AbhHTBtl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 21:49:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47998 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbhHTBtg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 21:49:36 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210820014849epoutp022c6f31774603bdb5683e12b4a566078e~c4JzV7T3a1212512125epoutp02J
        for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2021 01:48:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210820014849epoutp022c6f31774603bdb5683e12b4a566078e~c4JzV7T3a1212512125epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629424129;
        bh=cJclmsx1J4mvtXjmATU0vJEiyj8TKhy8Fdf/AtpVQeo=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Bd7STVyVR7EdCwHGuHYmAFy5Ut8z8iMWU/DE9hPfqdT13tM3CDuWgTsN6s+pFrsxs
         6hKGmtZyoBlo5A3KMVdIgUs46eEoDGSXiqBZH55pAILlI+W8Vons9hn9btkIWyh0n1
         58YhfwUPYstbkt0/rGgmF5GcU16YnfDDQIuoIaMc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20210820014849epcas5p203e17f7a6d558fb48cd5ea0f9f86e35c~c4JzKUkFy1347513475epcas5p24;
        Fri, 20 Aug 2021 01:48:49 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GrPgD2rNMz4x9QP; Fri, 20 Aug
        2021 01:48:40 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.58.41701.1F90F116; Fri, 20 Aug 2021 10:48:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20210819165730epcas5p1311d3c2dcaa9ed6c12242e511c092e1b~cw55YHZDj1891018910epcas5p10;
        Thu, 19 Aug 2021 16:57:30 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210819165730epsmtrp1f574aff4a893eda0252af82c9e93bcb5~cw55XX0yN0116901169epsmtrp1X;
        Thu, 19 Aug 2021 16:57:30 +0000 (GMT)
X-AuditID: b6c32a4b-0abff7000001a2e5-57-611f09f13610
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.16.32548.97D8E116; Fri, 20 Aug 2021 01:57:29 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210819165729epsmtip16960f18e8153262e598d8fb939b13f50~cw54wELSw2740427404epsmtip1I;
        Thu, 19 Aug 2021 16:57:28 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Dan Carpenter'" <dan.carpenter@oracle.com>
Cc:     <linux-scsi@vger.kernel.org>,
        "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>
In-Reply-To: <20210727094619.GA27436@kili>
Subject: RE: [bug report] scsi: ufs: ufs-exynos: Add UFS host support for
 Exynos SoCs
Date:   Thu, 19 Aug 2021 22:27:27 +0530
Message-ID: <000001d7951b$4bc36070$e34a2150$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGvIAYWJYooPVTOnBKSQDI8eUhRsQIseBEWq5ZutZA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmuu5HTvlEg7vrNC1e/5vOYtE5cQm7
        Rff1HWwOzB6zO2ayenx8eovF4/MmuQDmqGybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0Nd
        Q0sLcyWFvMTcVFslF58AXbfMHKBFSgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwC
        kwK94sTc4tK8dL281BIrQwMDI1OgwoTsjLZpS1kL+iUqrt6/x9rAuFuwi5GTQ0LARKJ552Km
        LkYuDiGB3YwS35b9Y4FwPjFKzPtzkw3C+cwo0XbxGlCGA6yl4VANRHwXo8TSa7fZQEYJCbxk
        lPi7hB3EZhPQldixuA0sLiJgIHHv5AsWEJtZIEZi5s6VjCBzOAW0JDrb1EDCwgLhEu+mLGcC
        sVkEVCW6P+8DK+cVsJS4uHcdlC0ocXLmE6gx8hLb385hhvhAQeLn02WsICNFBKwkbs6NhSgR
        lzj6s4cZ5EwJgbfsErub57FC1LtIvD7QAmULS7w6voUdwpaSeNnfxg7xYrZEzy5jiHCNxNJ5
        x1ggbHuJA1fmgEOBWUBTYv0ufYiwrMTUU+uYINbySfT+fsIEEeeV2DEPxlaVaH53FWqMtMTE
        7m7WCYxKs5A8NgvJY7OQfDALYdsCRpZVjJKpBcW56anFpgXGeanl8MhOzs/dxAhOg1reOxgf
        Pfigd4iRiYPxEKMEB7OSCO+xP7KJQrwpiZVVqUX58UWlOanFhxhNgaE9kVlKNDkfmIjzSuIN
        TSwNTMzMzEwsjc0MlcR5dV/JJAoJpCeWpGanphakFsH0MXFwSjUwbd7J7KR/fvrHycITXQ5b
        /+zwF5u7pNJPe2nHhZUNx9I0Ln98nyEm7x/jqxWVJSNwKy/Z+XDg0tIdN0rljl3JPfP6Y8vn
        Ly9/Phatmck+Jyz0Rfsls3/RcmZuy2tuuWfK7N7iXcFkprR7NovfHbHtHaXikcY3b6zbz2zY
        3bxs6/IL14Uk3th0/l9SaXLJrElWd1ODVPjmeT+FOv+96DdfIsNj/e7ARB3PX5JvApz1197/
        F7IgcVP8TF37uuRlz0We8vDX3zVS/dV+NnD2r1uzf33cVTb/yXqzxs9lm6wUJ+U9cJXU51jW
        cjnw1OObE11ZlYL1Q+9cCFxVm2Y8PV7Imy3N9ZlM4mP+pGfet2+zKLEUZyQaajEXFScCAP4C
        SmsMBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSnG5lr1yiwcZH1hav/01nseicuITd
        ovv6DjYHZo/ZHTNZPT4+vcXi8XmTXABzFJdNSmpOZllqkb5dAldG27SlrAX9EhVX799jbWDc
        LdjFyMEhIWAi0XCopouRi0NIYAejxP9f35m6GDmB4tIS1zdOYIewhSVW/nsOZgsJPGeUWPWO
        GcRmE9CV2LG4jQ3EFhEwkLh38gULiM0sECOxc8ZdNoj6aonLp9czg+ziFNCS6GxTAwkLC4RK
        HJiwkBHEZhFQlej+vA+slVfAUuLi3nVQtqDEyZlPWEBamQX0JNo2MkJMl5fY/nYOM8RlChI/
        ny5jBSkREbCSuDk3FqJEXOLozx7mCYzCs5AMmoUwaBaSQbOQdCxgZFnFKJlaUJybnltsWGCU
        l1quV5yYW1yal66XnJ+7iREcB1paOxj3rPqgd4iRiYPxEKMEB7OSCO+xP7KJQrwpiZVVqUX5
        8UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTC1/N+Z9fIgA98vPZmn3e7b
        vPjfLPFPkW+8eX7JU6U5ifZK0b9Cdq0JnSO1+5rWzNxIa7/PR9SLDa5smX6wxjEzoXObkOOp
        Thb1uZ3CqjY5iZse3ttWqfDkym9r6Vvqbx9c35n4ISNo+wzuhau+Bn85b/x4lpHP7Je6fo/C
        mS5qCwo2xN0LnZKovSsrkHGa4ZSuGcoRp/gDv5ps1b10P+6aOUtDjOLucJGpxixPMvMN5vmt
        k/pwZsON9j+xQnrP9+9skd66lv3cyfDzmfs6z8zwUTLVT1DS9ntc91hvluryZ1FKDdYds/iv
        W6kLfl19vFHqgz2bi8eiOdN8JW6/XOr506711Ja4u8y5kz8oWaYrsRRnJBpqMRcVJwIAkDTl
        QvICAAA=
X-CMS-MailID: 20210819165730epcas5p1311d3c2dcaa9ed6c12242e511c092e1b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210727094640epcas5p1250e6d4fee4381e5cfa8209723b5dd1d
References: <CGME20210727094640epcas5p1250e6d4fee4381e5cfa8209723b5dd1d@epcas5p1.samsung.com>
        <20210727094619.GA27436@kili>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Dan
Sorry for the delay in responding; I had overlooked this.

> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Sent: 27 July 2021 15:16
> To: alim.akhtar@samsung.com
> Cc: linux-scsi@vger.kernel.org; Laurent Pinchart
> <laurent.pinchart@ideasonboard.com>
> Subject: [bug report] scsi: ufs: ufs-exynos: Add UFS host support for
Exynos
> SoCs
> 
> Hello Alim Akhtar,
> 
> The patch 55f4b1f73631: "scsi: ufs: ufs-exynos: Add UFS host support for
> Exynos SoCs" from May 28, 2020, leads to the following static checker
> warning:
> 
> 	drivers/scsi/ufs/ufs-exynos.c:286 exynos_ufs_get_clk_info()
> 	warn: wrong type for 'ufs->mclk_rate' (should be 'ulong')

> 
> 	drivers/scsi/ufs/ufs-exynos.c:287 exynos_ufs_get_clk_info()
> 	warn: wrong type for 'pclk_rate' (should be 'ulong')
> 
> drivers/scsi/ufs/ufs-exynos.c
>     258 static int exynos_ufs_get_clk_info(struct exynos_ufs *ufs)
>     259 {
>     260 	struct ufs_hba *hba = ufs->hba;
>     261 	struct list_head *head = &hba->clk_list_head;
>     262 	struct ufs_clk_info *clki;
>     263 	u32 pclk_rate;
>                 ^^^^^^^^^^^^^
> 
>     264 	u32 f_min, f_max;
>     265 	u8 div = 0;
>     266 	int ret = 0;
>     267
>     268 	if (list_empty(head))
>     269 		goto out;
>     270
>     271 	list_for_each_entry(clki, head, list) {
>     272 		if (!IS_ERR(clki->clk)) {
>     273 			if (!strcmp(clki->name, "core_clk"))
>     274 				ufs->clk_hci_core = clki->clk;
>     275 			else if (!strcmp(clki->name,
"sclk_unipro_main"))
>     276 				ufs->clk_unipro_main = clki->clk;
>     277 		}
>     278 	}
>     279
>     280 	if (!ufs->clk_hci_core || !ufs->clk_unipro_main) {
>     281 		dev_err(hba->dev, "failed to get clk info\n");
>     282 		ret = -EINVAL;
>     283 		goto out;
>     284 	}
>     285
> --> 286 	ufs->mclk_rate = clk_get_rate(ufs->clk_unipro_main);
> --> 287 	pclk_rate = clk_get_rate(ufs->clk_hci_core);
> 
> This a new Smatch warning which is not yet pushed.  The clk_get_rate()
> function returns unsigned long so I guess ufs->mclk_rate and pclk_rate
> should be changed from u32.  Not sure the runtime impact.
> 
Thanks for reporting this, I checked ufs functionality with this change, no
regression.
Will be posting a fix soon.

>     288 	f_min = ufs->pclk_avail_min;
>     289 	f_max = ufs->pclk_avail_max;
>     290
>     291 	if (ufs->opts & EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL) {
>     292 		do {
>     293 			pclk_rate /= (div + 1);
>     294
>     295 			if (pclk_rate <= f_max)
>     296 				break;
>     297 			div++;
>     298 		} while (pclk_rate >= f_min);
>     299 	}
>     300
>     301 	if (unlikely(pclk_rate < f_min || pclk_rate > f_max)) {
>     302 		dev_err(hba->dev, "not available pclk range %d\n",
> pclk_rate);
>     303 		ret = -EINVAL;
>     304 		goto out;
>     305 	}
>     306
>     307 	ufs->pclk_rate = pclk_rate;
>     308 	ufs->pclk_div = div;
>     309
>     310 out:
>     311 	return ret;
>     312 }
> 
> regards,
> dan carpenter

