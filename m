Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AF4C00A5A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 16:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjASQuJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Jan 2023 11:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjASQuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2023 11:50:02 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFDC6A4C
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 08:49:57 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230119164951epoutp02c14fbd41589867bd8947a9933d196332~7w9G0oCB30630606306epoutp02J
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 16:49:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230119164951epoutp02c14fbd41589867bd8947a9933d196332~7w9G0oCB30630606306epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1674146991;
        bh=Y77O+7tmZm0PpAgkke1OEWnIQEpL6I3OPl40gRrIy9k=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=a/tGy009mnpDBQ4tyxV4RzcbmZ2+VA6TqEvzlynn+lc9hEREit4rH/xpgNRjFetLF
         jVgoQw3DSr/QebQaKmJ+aciZZeLpzeq7az56BZ7xwGjnTDEgPzhocKHQWRogMEcT64
         a/aWdc16/pGWrxLruOYhW+a9RQt3eLMRYCZ4YlTM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230119164950epcas5p21377f124fda2dc213214d17e22d54d32~7w9F32oLS0924509245epcas5p2I;
        Thu, 19 Jan 2023 16:49:50 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4NyTBP1X2kz4x9Pp; Thu, 19 Jan
        2023 16:49:49 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        48.0E.10528.DA479C36; Fri, 20 Jan 2023 01:49:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230119164948epcas5p1dc8143fe200f8dc2c3bee87e67e13477~7w9D3rZ0Z0064700647epcas5p14;
        Thu, 19 Jan 2023 16:49:48 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230119164948epsmtrp1bb92d39102cdc445c43abf68488e0677~7w9D2_QA92601726017epsmtrp13;
        Thu, 19 Jan 2023 16:49:48 +0000 (GMT)
X-AuditID: b6c32a49-c17ff70000012920-e9-63c974adc92b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        54.8A.17995.CA479C36; Fri, 20 Jan 2023 01:49:48 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230119164947epsmtip1e5b94e1874e5bd3e05b243dafe0c82db~7w9CYpamk3183231832epsmtip1G;
        Thu, 19 Jan 2023 16:49:47 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Jaegeuk Kim'" <jaegeuk@kernel.org>, <linux-scsi@vger.kernel.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@linaro.org>,
        "'Chanho Park'" <chanho61.park@samsung.com>,
        "'Bean Huo'" <beanhuo@micron.com>
In-Reply-To: <20230112234215.2630817-3-bvanassche@acm.org>
Subject: RE: [PATCH v2 2/3] scsi: ufs: Exynos: Fix the maximum segment size
Date:   Thu, 19 Jan 2023 22:19:45 +0530
Message-ID: <0a3601d92c26$0ac62f00$20528d00$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMm5ykAdtwQU0o+6B5Pbw7bIF/e7AJG/876ATSzCQ2r7p+3QA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf0wTZxjHfe+OayEWzvLrpQOsN8iCpNBq2x2kDDM6d7NLZFn8Yy6uu7UX
        irTX0itsMy7RaEAhU5sZpoXEBTJ0OG3osDSAKyAM6jaDg01gawKKiThKcAQ2ozFrOdj47/s8
        7+d5v8/z/hCj0gAuE1dyLtbJMVYST8D8t/LyFNdcIZMyHMKp0Ny3ODUwexqjmpaeotR4MJ+a
        83pQqnXSj1A3/7whoqa6hjGq8V4Apy6PvED2JNDjEwa6rW8eoX0dp3H6j9/6cPpcaz+g//ae
        wuknD6cx+kxXB6CXfdnl8QerdBaWMbNOOcuZ7OZKrqKENLxrLDNqtEqVQlVEvUrKOcbGlpD6
        t8sVeyut0T5JeS1jrYmmyhmeJwtf0zntNS5WbrHzrhKSdZitDrWjgGdsfA1XUcCxrmKVUrlL
        EwU/rLJ03pnGHKvEJyvex3HHwNXEBhAvhoQaBgMTcTEtJXoBfDab3QASovovAG+fP48KwTKA
        F3w3sY0K76WF9YUeAJvHgogQzAMYPvkjEqNwQgEDbXV4AxCLUwgzDM5kxBiUCCOwb6YfjzHx
        RDE8/t31tV2TCQOc7BgCMR4jcuHAydJYWkIUwc65MVTQ22Do4twajhLbYXekBRUaksOnD9vX
        RkghXofuE4MigUmH88NDopgvJH4Sw/pQ2/oEerja0owIOhk+HukSCVoG58/WiWI9QIKGrc9l
        QtoCI5e9QNClsH+iBYshKJEHvT2FglUi/PzZHCJUSuCpOqlA58ITi7+um74E3Y2NcRubj3bu
        Pwd2eDbN5dk0l2dT/57/vb4CWAfIYB28rYLlNQ4Vx37832Wb7DYfWHvCO98KgPDMUsEgQMRg
        EEAxSqZIkrwjJqnEzHx6hHXajc4aK8sPAk30rN2oLNVkj/4BzmVUqYuUaq1Wqy7arVWR6ZJX
        SkImKVHBuNgqlnWwzo06RBwvO4bU+l/e05Tt3juZ1vT1z+lfPtG3Xxrboc/RNV+8rYtc2//g
        gzfzp6Zsi1hioOt+9xfDhueerAXZO1eQg/985G9tud4e4NsMqVm/bL0VSdd8X5buIGsn9tmq
        JEfLwvRdWeYPBwLTSWP+ANufpiiuNmQc7c9XpCV9duRA/ZJ7ofpBgWQgS2ZkVnJSiG2RLYeC
        U4fuROJ3ZfZmQpPhfexw/ZlvdJYL4sm+WenZ8cyC1IZqkigbs/1+X1eqHj3OmN9LC09wV1ds
        1OEVfeGNxWXfI9FqbU91b7Mu2Tr6xqO7fonZhcXJh5TdWGdu7oLc3vFieMvWvqbtosoB072c
        5ZzdYTuJ8RZGtRN18sy/ndNpI0sEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWy7bCSnO6akpPJBm8b1C1OPlnDZnHwYSeL
        xbQPP5ktLu/XtniyfhazxaIb25gs9r7eym5xc8tRFovu6zvYLJYf/8fkwOVx+Yq3x+I9L5k8
        Nq3qZPO4c20Pm8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8kFcEZx2aSk5mSWpRbp2yVwZWw8
        d4ul4JtAxdf1r1gbGFfzdTFyckgImEisn/+GuYuRi0NIYAejxMtDC5kgEtIS1zdOYIewhSVW
        /nvODlH0nFFi4fPnrCAJNgFdiR2L29hAbBGBFIkZCz6CFTELPGaSeNraxATRsZNRouvcU0aQ
        Kk4BK4nGzetYQGxhAW+JG6uOAMU5OFgEVCUOttiDhHkFLCU2PrnADGELSpyc+YQFpIRZQE+i
        bSPYFGYBeYntb+cwQxynIPHz6TJWiBucJCY2H2KHqBGXeHn0CPsERuFZSCbNQpg0C8mkWUg6
        FjCyrGKUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECI5HLa0djHtWfdA7xMjEwXiIUYKD
        WUmEl3/98WQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUa
        mLwixA16uq1rH6zmXvDunPOn/ztD32wtZH7q1r+/2LbLYKH+ksUc75Xm3/nZYZ57Qzgy+qWY
        6497V8Ievqkpipu6fsWcg+qisRuFZvHPPPmn6J7bh+kia1M27HR0nn3NdaZLTHSHZuG13NIt
        F7IfyeYLxWwVyUm48CGt4HSZ6GPp2PaMmNrwkxtbz1z56eCq0ue3zakvfHN6pVq29KqWjy8n
        f5opr7vCV+pFLkNdkWLyueopzNkvBGMOWGRkas9f+lla1lPpye4zi5zNBKOktiUbqllXBxiW
        MIYJBZb+4P676d6F9AeZcaki2lNbXRsrNL2s8hTjZpz75CnzUOPLcfeHLm3z1m0rkO2svMOr
        xFKckWioxVxUnAgACKJH1DYDAAA=
X-CMS-MailID: 20230119164948epcas5p1dc8143fe200f8dc2c3bee87e67e13477
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230112234317epcas5p4f010c4801e7553d76aecb15308ff353d
References: <20230112234215.2630817-1-bvanassche@acm.org>
        <CGME20230112234317epcas5p4f010c4801e7553d76aecb15308ff353d@epcas5p4.samsung.com>
        <20230112234215.2630817-3-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



>-----Original Message-----
>From: Bart Van Assche [mailto:bvanassche@acm.org]
>Sent: Friday, January 13, 2023 5:12 AM
>To: Martin K . Petersen <martin.petersen@oracle.com>
>Cc: Jaegeuk Kim <jaegeuk@kernel.org>; linux-scsi@vger.kernel.org; Adrian
>Hunter <adrian.hunter@intel.com>; Alim Akhtar
><alim.akhtar@samsung.com>; Bart Van Assche <bvanassche@acm.org>;
>Kiwoong Kim <kwmad.kim@samsung.com>; James E.J. Bottomley
><jejb@linux.ibm.com>; Krzysztof Kozlowski
><krzysztof.kozlowski@linaro.org>; Chanho Park
><chanho61.park@samsung.com>; Bean Huo <beanhuo@micron.com>
>Subject: [PATCH v2 2/3] scsi: ufs: Exynos: Fix the maximum segment size
>
>Prepare for enabling DMA clustering and also for supporting PAGE_SIZE !=
>4096 by declaring explicitly that the maximum segment size is 4096 bytes
for
>Exynos UFS host controllers. Add this code in
>exynos_ufs_hce_enable_notify() such that it happens after
>scsi_host_alloc() and before __scsi_init_queue() is called by the LUN
scanning
>code.
>
>Cc: Alim Akhtar <alim.akhtar@samsung.com>
>Cc: Kiwoong Kim <kwmad.kim@samsung.com>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>---

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

Tested basic read/write on platform containing Exynos UFS HCI, so 

Tested-by: Alim Akhtar <alim.akhtar@samsung.com>

> drivers/ufs/host/ufs-exynos.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>
>diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
>index 3cdac89a28b8..7c985fc38db1 100644
>--- a/drivers/ufs/host/ufs-exynos.c
>+++ b/drivers/ufs/host/ufs-exynos.c
>@@ -1300,6 +1300,14 @@ static int exynos_ufs_hce_enable_notify(struct
>ufs_hba *hba,
>
> 	switch (status) {
> 	case PRE_CHANGE:
>+		/*
>+		 * The maximum segment size must be set after
>scsi_host_alloc()
>+		 * has been called and before LUN scanning starts
>+		 * (ufshcd_async_scan()). Note: this callback may also be
>called
>+		 * from other functions than ufshcd_init().
>+		 */
>+		hba->host->max_segment_size = 4096;
>+
> 		if (ufs->drv_data->pre_hce_enable) {
> 			ret = ufs->drv_data->pre_hce_enable(ufs);
> 			if (ret)

