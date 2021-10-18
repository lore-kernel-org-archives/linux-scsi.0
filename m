Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5877EC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 06:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33EF6610A6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 06:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhJRGds (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 02:33:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23030 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhJRGdr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 02:33:47 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211018063135epoutp04e4d66dc81a88010af2819f340dbc6839~vDEh8hem11360813608epoutp04Q
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 06:31:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211018063135epoutp04e4d66dc81a88010af2819f340dbc6839~vDEh8hem11360813608epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634538695;
        bh=D8LECzm2Cz/FNEZlROMKdjbLXBaXbCmOFeIQ52q6C/A=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ZMzlAPxJ+QSxeeoNXPxNk42JTNV2u7uTj53coJ+D2jRyOE/GDbrY6/EFiw0jM5hFr
         +vNlMT/06oinVnIWarcdLKxbo7/YeOK/eXDDPUyxU+gAl2sVo9T/CrEiVaRJR+XcLl
         mGhyhEra2ZtZkGZOaIP7528xfawphP5ySf6N+Z5o=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211018063134epcas2p19b7290ae28615d47a4902e27db9ee93a~vDEhCXosg0772807728epcas2p1u;
        Mon, 18 Oct 2021 06:31:34 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.99]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HXn893GYYz4x9QF; Mon, 18 Oct
        2021 06:31:21 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        DE.51.09823.6B41D616; Mon, 18 Oct 2021 15:31:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211018063117epcas2p28bfc50a5d793abadf37291942e139448~vDERuUcE60173401734epcas2p2n;
        Mon, 18 Oct 2021 06:31:17 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211018063117epsmtrp28722c669471a66b2c47f9ea897c43eab~vDERtgtlx1601316013epsmtrp28;
        Mon, 18 Oct 2021 06:31:17 +0000 (GMT)
X-AuditID: b6c32a48-127ff7000000265f-77-616d14b6fa19
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.3D.08902.5B41D616; Mon, 18 Oct 2021 15:31:17 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211018063117epsmtip1a01cafc1737850ade4f60741b90f023f~vDERgdDVF1675716757epsmtip18;
        Mon, 18 Oct 2021 06:31:17 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH] scsi: ufs: ufs-exynos: correct timeout value setting
 registers
Date:   Mon, 18 Oct 2021 15:28:41 +0900
Message-Id: <20211018062841.18226-1-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmme42kdxEg/vneC0ezNvGZvHy51U2
        i4MPO1kspn34yWxxeb+2xaIb25gsNr79wWRxc8tRFosZ5/cxWXRf38Fmsfz4PyYHbo/LV7w9
        ZjX0snlMWHSA0eP7+g42j49Pb7F49G1ZxejxeZOcR/uBbqYAjqhsm4zUxJTUIoXUvOT8lMy8
        dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygO5UUyhJzSoFCAYnFxUr6djZF+aUl
        qQoZ+cUltkqpBSk5BeYFesWJucWleel6eaklVoYGBkamQIUJ2Rkfbl1nLHjFXfH8+TTmBsat
        XF2MnBwSAiYSZyfvYO1i5OIQEtjBKPG+bxszSEJI4BOjxPcbWhCJb4wSU27PYoHpONB0nAki
        sZdRYuXPFnaIjo+MEr8azEBsNgFdiS3PXzGCFIkIvGeUePJ4CjuIwyxwg1GitesZG0iVsECg
        xINTj5lAbBYBVYnPFw+C2bwCdhK9Rx+xQayTlzjyq5MZIi4ocXLmE7AzmIHizVtnM4MMlRBo
        5JA4d2MH1H0uEp8+X2GFsIUlXh3fwg5hS0l8freXDaKhG+iKR/+hEqsZJTobfSBse4lf07cA
        NXMAbdCUWL9LH8SUEFCWOHILai+fRMfhv+wQYV6JjjYhiEZ1iQPbp0NdICvRPecz1AUeErdb
        5jBCAihWYvfuvywTGOVnIflmFpJvZiHsXcDIvIpRLLWgODc9tdiowAQeq8n5uZsYwWlVy2MH
        4+y3H/QOMTJxMB5ilOBgVhLh5fuYkyjEm5JYWZValB9fVJqTWnyI0RQYvhOZpUST84GJPa8k
        3tDE0sDEzMzQ3MjUwFxJnNdSNDtRSCA9sSQ1OzW1ILUIpo+Jg1OqgUlMwqelLVbnoMXmZdXR
        C1JCJjgkHJv1IcY7Iuxa3KvKh/Y3bd8lCuabMjtm+UyauC3I3KCa+53x7Cnx0+fdMj7xUaC+
        J1jMf4vf/qNclb1717WyeruK/vm5IKeJU59hXfsss9franoyuLJ6Kn+ffHJLY/MWzsZiJh+H
        +0EL50s8bMuQdBRl71huvHXbS52TBXYMi9lt5nT/vJhXzWoSk3cq3G7CL9Oniy6/uB5zfRnv
        j0/mnXqiH78yXl0ddW+JRoyeY+YRDW/Wg0smcpSeWl4fP0vzkZBGp5nshqd8z+Qm7Gng33Lw
        1nq5Bc1H/yR9arUrj1RI0TylsjzQJmS5bfTDc4nPlCrd3id/EXV7o8RSnJFoqMVcVJwIAFoG
        LgM0BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSnO5WkdxEg4VvtCwezNvGZvHy51U2
        i4MPO1kspn34yWxxeb+2xaIb25gsNr79wWRxc8tRFosZ5/cxWXRf38Fmsfz4PyYHbo/LV7w9
        ZjX0snlMWHSA0eP7+g42j49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TUnMyy1CJ9uwSujA+3
        rjMWvOKueP58GnMD41auLkZODgkBE4kDTceZuhi5OIQEdjNKbLzymREiISvx7N0OdghbWOJ+
        yxFWEFtI4D1Q0QQ/EJtNQFdiy/NXYPUiAh8ZJeZ80wIZxCxwj1Hiwqs3YA3CAv4SF0+tAiti
        EVCV+HzxIBOIzStgJ9F79BEbxAJ5iSO/Opkh4oISJ2c+YQGxmYHizVtnM09g5JuFJDULSWoB
        I9MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgQNfS3MG4fdUHvUOMTByMhxglOJiV
        RHj5PuYkCvGmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cB0
        4JKWkPPSk/sW1hbtnWyy89RDrkOT5AJdKo18FPbbf+GZL1HEbHfY52/S0fNlGjzschbdkRIT
        rz/VzNWumpZWtvSIhJTKgzVirkkK/b2bzpeGSZn5Pryh93Ht4+7wibIS2xa9aDDsj1JfqvSE
        SeiNwZ+XdRV1XMn8Ei/ceH43nggpnFSRsupj5F6Ohpgr/9esCdn1aT/Hq1mtpcbOp4t4Dyqr
        Vu7m2nLCM1CvvlroSnbCt2UTVFWPeUTcOpN+855H19vnK9p35R/gW7hHaeZbhVsrZ8qFr8hS
        C5p65FLP3S07Gp7FvLg9/c6vxadaP5R+aHnZZKNzeObmt6//7//rse/1E7eb5iGS92onz5AR
        VmIpzkg01GIuKk4EAE28hebjAgAA
X-CMS-MailID: 20211018063117epcas2p28bfc50a5d793abadf37291942e139448
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018063117epcas2p28bfc50a5d793abadf37291942e139448
References: <CGME20211018063117epcas2p28bfc50a5d793abadf37291942e139448@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PA_PWRMODEUSERDATA0 -> DL_FC0PROTTIMEOUTVAL
PA_PWRMODEUSERDATA1 -> DL_TC0REPLAYTIMEOUTVAL
PA_PWRMODEUSERDATA2 -> DL_AFC0REQTIMEOUTVAL

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Fixes: a967ddb22d94 ("scsi: ufs: ufs-exynos: Apply vendor-specific values for three timeouts")
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
- Separated this patch from [1] as suggested by Avri Altman.
[1]: https://lore.kernel.org/linux-scsi/20211007080934.108804-1-chanho61.park@samsung.com/

 drivers/scsi/ufs/ufs-exynos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index d81a2eb894ad..226e7e64fad4 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -643,9 +643,9 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
 	}
 
 	/* setting for three timeout values for traffic class #0 */
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 8064);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 28224);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 20160);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_FC0PROTTIMEOUTVAL), 8064);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_TC0REPLAYTIMEOUTVAL), 28224);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_AFC0REQTIMEOUTVAL), 20160);
 
 	return 0;
 out:
-- 
2.33.0

