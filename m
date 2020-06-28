Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D77C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 01:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C912207E8
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 01:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="n79FeKi9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgF1B4j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 21:56:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19410 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbgF1B4j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 21:56:39 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200628015636epoutp0382edff0bed1c8b029c37b41995515a93~cknRJIX__1286312863epoutp03S
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jun 2020 01:56:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200628015636epoutp0382edff0bed1c8b029c37b41995515a93~cknRJIX__1286312863epoutp03S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593309396;
        bh=6+zZ2sOipA1Lg8Fb+N3C/N+HBDK1ASbTTeVIKAsigmM=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=n79FeKi9YFx2ssBYhXdiv3j5t0QwwlRX4xsbLMzmX2Ugek6XjcQhBBMyX77VfaH7P
         YD4WnJYS0Mn9un2H8HNbKC2Pwu9313dAVZSSk2OLgyIvDzb1S4r0nzhqEX+2IEF0hK
         XEs0HPbZbcG62oV8dDG2EFpYl1ilTfqqs5Ty3b/c=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200628015634epcas5p1072d65e95e6f99584082dff66745c1ba~cknP5wup72537825378epcas5p1a;
        Sun, 28 Jun 2020 01:56:34 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DE.35.09475.2D8F7FE5; Sun, 28 Jun 2020 10:56:34 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200628015634epcas5p476e8084c7e2d36c5d26d97e71802793e~cknPaB3tq0123901239epcas5p4I;
        Sun, 28 Jun 2020 01:56:34 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200628015634epsmtrp22e8e3256357e1f0dc6be877392fbb983~cknPZNQpH1319613196epsmtrp2H;
        Sun, 28 Jun 2020 01:56:34 +0000 (GMT)
X-AuditID: b6c32a4b-39fff70000002503-06-5ef7f8d2e0d8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        36.8A.08303.2D8F7FE5; Sun, 28 Jun 2020 10:56:34 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200628015631epsmtip257e47784d63f8acc7c02fc76717745ca~cknMRkwAA0088400884epsmtip2u;
        Sun, 28 Jun 2020 01:56:30 +0000 (GMT)
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
In-Reply-To: <20200627175445.GG2571@kadam>
Subject: RE: [PATCH] scsi: ufs: ufs-exynos: Remove an unnecessary NULL check
Date:   Sun, 28 Jun 2020 07:26:29 +0530
Message-ID: <041e01d64cef$5a166480$0e432d80$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-in
Thread-Index: AQJZTJzG6GPUwl4om2Vud+BKbvKiigG4ppPqAkqZIKgCOdI8zqe1XE8A
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsWy7bCmlu6lH9/jDDbftbB4+fMqm8Xrf9NZ
        LBbd2MZksfWWtEX/49fMFufPb2C3uLnlKIvF5V1z2CxmnN/HZNF9fQebxfLj/5gsDn/ZxebA
        49Fy5C2rx6ZVnWweExYdYPT4+PQWi0ffllWMHp83yXm0H+hmCmCP4rJJSc3JLEst0rdL4Mr4
        f38Xa8Futordq+cxNTD+Zeli5OSQEDCRaDvTxgRiCwnsZpQ4tzeui5ELyP7EKLF+91F2COcz
        o8SVT18ZYToe/tzFCpHYxSixcMd5NgjnDaPEnrmPmEGq2AR0JXYsbmMDsUUEDCTunXzBAlLE
        LHCAWeJm/2OwIk4BLYlDZ2eBHSIs4CPRth/iKBYBVYm+k1fZQWxeAUuJiyfms0LYghInZz4B
        q2EWkJfY/nYOM8RJChI/ny5jhYiLSxz92cMMsdhNonfua7DFEgInOCR2zXvBDtHgIrHjyzOo
        f4QlXh3fAhWXkvj8bi/Q1RxAdrZEzy5jiHCNxNJ5x6ABZi9x4MocFpASZgFNifW79CHW8kn0
        /n7CBNHJK9HRJgRRrSrR/O4qVKe0xMTublYI20PixuP3rBMYFWcheWwWksdmIXlmFsKyBYws
        qxglUwuKc9NTi00LjPNSy/WKE3OLS/PS9ZLzczcxglOZlvcOxkcPPugdYmTiYDzEKMHBrCTC
        +9n6W5wQb0piZVVqUX58UWlOavEhRmkOFiVxXqUfZ+KEBNITS1KzU1MLUotgskwcnFINTMoa
        dlxbOZf+6938+NnOtKzzmteXlneaukglXfaRWjmpzn8OR4+HXxV7VMLajRnzCrTk/Lt6+kIX
        rwuPSHj03nzDrJsrN7vm2ncnzfTYM3fn/ZC6zWf/PGRO1eK32hzOuXjCsnMiVw7qtny8YcQu
        rfBkU5W3kde+KotfbpKp3ROPCMZvrj3RHXgoKPCYGHfJYsvsskgfwdCo5S+K07hX9NoGHv15
        WnBWhLsZTyXjyu0dL8R2Zsx40iwhzBJ5J+jv403J1jwS2+1Zz0ad77RJevrje8f+KSbs9d8c
        Jn+eIj3h9snFQbuWnu6Z53T51LNdDxydvr2REsmS2eywjPl686TFlQvXvY0T+VGcU+EYqsRS
        nJFoqMVcVJwIAKf3uLPUAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSvO6lH9/jDJbeFbV4+fMqm8Xrf9NZ
        LBbd2MZksfWWtEX/49fMFufPb2C3uLnlKIvF5V1z2CxmnN/HZNF9fQebxfLj/5gsDn/ZxebA
        49Fy5C2rx6ZVnWweExYdYPT4+PQWi0ffllWMHp83yXm0H+hmCmCP4rJJSc3JLEst0rdL4Mr4
        f38Xa8Futordq+cxNTD+Zeli5OSQEDCRePhzF2sXIxeHkMAORol1kzayQySkJa5vnABlC0us
        /PecHaLoFaPE202NbCAJNgFdiR2L28BsEQEDiXsnX7CAFDELnGCW+PlgGRNExylGiedTToPt
        4xTQkjh0dhaYLSzgI9G2H+IOFgFVib6TV8HW8QpYSlw8MZ8VwhaUODnzCVANB9BUPYm2jYwg
        YWYBeYntb+cwQ1ynIPHz6TJWiLi4xNGfPcwQB7lJ9M59zTKBUXgWkkmzECbNQjJpFpLuBYws
        qxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgmNSS2sH455VH/QOMTJxMB5ilOBgVhLh
        /Wz9LU6INyWxsiq1KD++qDQntfgQozQHi5I479dZC+OEBNITS1KzU1MLUotgskwcnFINTCyf
        94qaZap7G0rM0ZH1eLw2bv+2tLNyF2obom3NPj3OZb7Rlz+L2SMucdruhYrSJTv/OTjkNETF
        Sb5/qrupqvcEy3SDAE1Hac8zh4Pc3Bm9zp/MYej5PmvxMi6uYw/WJCUnBhhV3BHQvZ34eW0r
        I//NiEM3z80QWXAj94N1YFClSd6M7mBGlQ6vbxwxGuJrV5dY1JZKvmjgnyqxs6VyVaW92fxl
        N+6YbHFu1l9dvLnF4bTkm6M3ig2kUj0P6llO655/7vfnFPXpvrPjCiv6xQVsdp1K2VcuqLhG
        dK935SV35VNb3211Zm/i0LVven2vbflC9nsSctk5/w+ta+lmXT794I9LbA4TjU+XfZRRYinO
        SDTUYi4qTgQAjsnVYjgDAAA=
X-CMS-MailID: 20200628015634epcas5p476e8084c7e2d36c5d26d97e71802793e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200626105156epcas5p191d18d66af6bd09a10635559461c0bc0
References: <CGME20200626105156epcas5p191d18d66af6bd09a10635559461c0bc0@epcas5p1.samsung.com>
        <20200626105133.GF314359@mwanda>
        <041701d64ca7$70bafb80$5230f280$@samsung.com> <20200627175445.GG2571@kadam>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Dan,

> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@oracle.com>
> On Sat, Jun 27, 2020 at 10:51:44PM +0530, Alim Akhtar wrote:
> > Hi Dan
> >
> > > -----Original Message-----
> > > The "head" pointer can't be NULL because it points to an address in
the
> > middle
> > > of a ufs_hba struct.  Looking at this code, probably someone would
wonder
> > if
> > > the intent was to check whether "hba" is NULL, but "hba"
> > > isn't NULL and the check can just be removed.
> > >
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > ---
> > Please add Fixes: tag
> > With that
> > Acked-by: Alim Akhtar <alim.akhtar@samsung.com>
> 
> It's not a bug fix it's just a cleanup.
> 
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>

Thanks!

> regards,
> dan carpenter


