Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B423C5479D
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Jan 2023 06:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjAKGVp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 01:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjAKGVm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 01:21:42 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633E7FCEB
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2023 22:21:41 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230111062139epoutp0150b15a77f5fdf8417f07580cabcf0bb3~5LOVLwNMQ2400224002epoutp01I
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2023 06:21:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230111062139epoutp0150b15a77f5fdf8417f07580cabcf0bb3~5LOVLwNMQ2400224002epoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1673418099;
        bh=QXSHrRpWlpG9i9kz2torWQEjbvxxs+eqZvAH7/uUX34=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=KMd822Os+4yujdfNEvEbAp/NFPQ5Yb7e8Pv9R3+lg9ftTM5yxY/9RypIm25LQjseA
         c58gu9u5GVSOTjOaAAGA8wT552AgOvaK4I8mwWfe7TsOEo65lBip8Ussj8DUMUwMCU
         vjaziz/P7RuuDeXmuWN2KDQgVJ3Mgh5Jx50ZBqBw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230111062139epcas5p30dcb334f0f95087dbcb695b202947385~5LOUmvJ7K1373513735epcas5p34;
        Wed, 11 Jan 2023 06:21:39 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4NsHdG0fL4z4x9Q9; Wed, 11 Jan
        2023 06:21:38 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.10.03362.1755EB36; Wed, 11 Jan 2023 15:21:38 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230111062137epcas5p1a7df3bff4b0535f51314fbb143c125ce~5LOTFmRDO2586225862epcas5p1r;
        Wed, 11 Jan 2023 06:21:37 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230111062137epsmtrp1c6aab4b5c7bf9a55b4b877df45951e9f~5LOTE1Za70151801518epsmtrp1D;
        Wed, 11 Jan 2023 06:21:37 +0000 (GMT)
X-AuditID: b6c32a4b-4e5fa70000010d22-83-63be55717c56
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D0.7A.02211.1755EB36; Wed, 11 Jan 2023 15:21:37 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230111062135epsmtip1608b74da98afa72b3b29f2c6bdd3b72b~5LORh0ikJ0169901699epsmtip1O;
        Wed, 11 Jan 2023 06:21:35 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@linaro.org>,
        "'Chanho Park'" <chanho61.park@samsung.com>,
        "'Bean Huo'" <beanhuo@micron.com>
In-Reply-To: <20230106215800.2249344-3-bvanassche@acm.org>
Subject: RE: [PATCH 2/3] scsi: ufs: Exynos: Fix the maximum segment size
Date:   Wed, 11 Jan 2023 11:51:34 +0530
Message-ID: <018d01d92584$f5d57c60$e1807520$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQFZzN7Pa8YB12UZCtrq39dv9ZdUcwFJCC56AwNFyk2vdQ130A==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEJsWRmVeSWpSXmKPExsWy7bCmum5R6L5kgy8LGC1OPlnDZvHy51U2
        i4MPO1kspn34yWxxeb+2xZP1s5gtFt3YxmSx9/VWdoubW46yWHRf38Fmsfz4PyYHbo/LV7w9
        Fu95yeSxaVUnm8eda3vYPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBXVLZNRmpi
        SmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDFSgpliTmlQKGA
        xOJiJX07m6L80pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjMfzl7EX
        zBWsuLjiEGMD4ym+LkZODgkBE4lfT5cxgdhCArsZJW5c1O9i5AKyPzFKbJ/UygbhfGOUmHH4
        I5DDAdZx60IZRHwvo8STKd/ZILpfMkqcfKILYrMJ6ErsWNwGVi8ikCKx/4EkSD2zQBuzxLu5
        NxhBajgFrCS+z2kB6xUW8JA4svYmWJxFQFViS0srK4jNK2Ap8fLaLzYIW1Di5MwnLCA2s4C8
        xPa3c5ghPlCQ+Pl0GStEXFzi5dEj7CC2iICTxMQn75lAFksI3OGQmLVgPjtEg4tEy9kvLBC2
        sMSr41ug4lISL/vb2CGe9JBY9EcKIpwh8Xb5ekYI217iwJU5LCAlzAKaEut36UOs5ZPo/f2E
        CaKTV6KjTQiiWlWi+d1VqEXSEhO7u1khbA+Jxv9HmCcwKs5C8tgsJI/NQvLMLIRlCxhZVjFK
        phYU56anFpsWGOellsMjOzk/dxMjODFree9gfPTgg94hRiYOxkOMEhzMSiK8Kzn3JAvxpiRW
        VqUW5ccXleakFh9iNAWG9kRmKdHkfGBuyCuJNzSxNDAxMzMzsTQ2M1QS503dOj9ZSCA9sSQ1
        OzW1ILUIpo+Jg1Oqgelqlrq11YbbOU11Nj9PTrq18aT5n+p13NvUTY1v7LK6pvzXcsO67YdS
        z79qnW3Q8+Ae6zye7d7L3Ix8ZlqceLf7TNpz6dOvvjoHMp8/mPhIWLH2Q8R+FvGH4V4qczpM
        zix61flbZiGLtjLPtTNxE/Suly6JiT739w2Lr7Dxhb9ZZwTN3R72Hn4RF66Tn5X3fcqBYv/f
        8446Xnxdki51zE8hxO9rmpPB7tP1i77YqigYnRS+dz1UfZOz7vvMuce3cNcxLdZnefFe6dfe
        67brFy6Zu/+S3OEd+5buX26v8mz5gpAJTnOvbBReLJNbV9mTnb1h4XX9hO3/G63msKyct4Hh
        9b6ZT4TzGBPfCepMeffstxJLcUaioRZzUXEiANzOFZpVBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWy7bCSnG5h6L5kg0u9ShYnn6xhs3j58yqb
        xcGHnSwW0z78ZLa4vF/b4sn6WcwWi25sY7LY+3oru8XNLUdZLLqv72CzWH78H5MDt8flK94e
        i/e8ZPLYtKqTzePOtT1sHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYArissmJTUn
        syy1SN8ugSvj8fxl7AVzBSsurjjE2MB4iq+LkYNDQsBE4taFsi5GLg4hgd2MEhtXrmfqYuQE
        iktLXN84gR3CFpZY+e85O0TRc0aJDXPPsYIk2AR0JXYsbmMDsUUEUiRmLPgIVsQs0MMscfze
        KzaIjp2MEs2rfrGAVHEKWEl8n9MC1iEs4CFxZO1NRhCbRUBVYktLK9hUXgFLiZfXfrFB2IIS
        J2c+YQE5lVlAT6JtI1g5s4C8xPa3c5ghrlOQ+Pl0GStEXFzi5dEj7BAHOUlMfPKeaQKj8Cwk
        k2YhTJqFZNIsJN0LGFlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEx6iW5g7G7as+
        6B1iZOJgPMQowcGsJMK7knNPshBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNT
        UwtSi2CyTBycUg1MvQ84Qj/U8pzSkaj7s3PNumDdq2Is6492aqjaXqus57uTy3Dl3af+e5M/
        SX7b2LMjcqvAvaKv+zoiWB6mPZJx/f1u0dkG5Q3XV3cdW9Ab7l63b6pcYWno3h1swX/TCx2v
        ZTUz5t8v+HKQ48YHT0HZZ9ff34zr9d6U813V+fuR4FM3RVjtQ9pDXATvXkzsP6/gz+TEsr/l
        vbRXm9bFbLd7KoFssizTBKfx+VzJ+WkV6hzK78uy9u0OHdmawwGvl6ldYU5t0Ax8n6KhybPX
        JmH23U8b9eLvTf/4RdlkqvnZmJv2FY2lgQ4fFS61HXVsfrEr8JSVB79plEah+GXfRBOtuJVd
        oZPXF+RfUzq8+JsSS3FGoqEWc1FxIgDfbJWgQAMAAA==
X-CMS-MailID: 20230111062137epcas5p1a7df3bff4b0535f51314fbb143c125ce
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230106215900epcas5p3b37893c02dfdd363ebb697e5a5c9ffb8
References: <20230106215800.2249344-1-bvanassche@acm.org>
        <CGME20230106215900epcas5p3b37893c02dfdd363ebb697e5a5c9ffb8@epcas5p3.samsung.com>
        <20230106215800.2249344-3-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart

>-----Original Message-----
>From: Bart Van Assche [mailto:bvanassche@acm.org]
>Sent: Saturday, January 7, 2023 3:28 AM
>To: Martin K . Petersen <martin.petersen@oracle.com>
>Cc: Jaegeuk Kim <jaegeuk@kernel.org>; Avri Altman
><avri.altman@wdc.com>; Adrian Hunter <adrian.hunter@intel.com>; linux-
>scsi@vger.kernel.org; Bart Van Assche <bvanassche@acm.org>; Kiwoong Kim
><kwmad.kim@samsung.com>; James E.J. Bottomley <jejb@linux.ibm.com>;
>Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>; Chanho Park
><chanho61.park@samsung.com>; Alim Akhtar <alim.akhtar@samsung.com>;
>Bean Huo <beanhuo@micron.com>
>Subject: [PATCH 2/3] scsi: ufs: Exynos: Fix the maximum segment size
>
>Prepare for enabling DMA clustering and also for supporting PAGE_SIZE !=
>4096 by declaring explicitly that the maximum segment size is 4096 bytes
for
>Exynos UFS host controllers.
>
>Cc: Kiwoong Kim <kwmad.kim@samsung.com>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>---

Thanks!

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

Tested on platforms containing Exynos HCI, so feel free to add

Tested-by: Alim Akhtar <alim.akhtar@samsung.com>


For some reason, I didn't receive you patch-3/3 in my inbox.

> drivers/ufs/host/ufs-exynos.c | 10 ++++++++--
> 1 file changed, 8 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
>index 3cdac89a28b8..821c000ca6b0 100644
>--- a/drivers/ufs/host/ufs-exynos.c
>+++ b/drivers/ufs/host/ufs-exynos.c
>@@ -1586,15 +1586,21 @@ static int exynos_ufs_probe(struct
>platform_device *pdev)
> 	const struct ufs_hba_variant_ops *vops = &ufs_hba_exynos_ops;
> 	const struct exynos_ufs_drv_data *drv_data =
> 		device_get_match_data(dev);
>+	struct ufs_hba *hba;
>
> 	if (drv_data && drv_data->vops)
> 		vops = drv_data->vops;
>
> 	err = ufshcd_pltfrm_init(pdev, vops);
>-	if (err)
>+	if (err) {
> 		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
>+		return err;
>+	}
>+
>+	hba = dev_get_drvdata(dev);
>+	hba->host->max_segment_size = 4096;
>
>-	return err;
>+	return 0;
> }
>
> static int exynos_ufs_remove(struct platform_device *pdev)

