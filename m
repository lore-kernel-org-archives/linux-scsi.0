Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6A7CCA479
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 03:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbiGSDJU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 23:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbiGSDJR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 23:09:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDE83C173;
        Mon, 18 Jul 2022 20:09:16 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IKihg8024556;
        Tue, 19 Jul 2022 03:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=SelJW1NFk8AZ0XjTZ3yL2HdUivxxk0nyrbeU6D4RpIE=;
 b=qRlKzhb1vRwswI5yqB9U6CQ6bsTGStNz0DZJMwobxet0Gs9R+2V/cqO8iiI3hC32cbEk
 dx/HTJmPZH2kUBPtHohzlaJ+pv9tKzuLTjyNMqn6HIV7bPmOeX5Bf8FkC9dJVNulOna6
 5+y+zX2lgMIXm9sfB8OEF98+v9Xte90+QZGr2yIyI0QPaM50HPjNDvF21zeS7kAdz5cH
 0JDUIhkeT9yv576zUPIkmgIuV1fjtmOZlD2cCAGNNlVLOYq0Z6sQl6AM33OPX2NteKH7
 Eu/xo4NOMRKILslhb2O2Hcgzz5sACOlz773aPlUhUuZHAMs7rA6e03GoJmiTPA1vp1vc cw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbm42cyma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 03:09:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IND6rQ002047;
        Tue, 19 Jul 2022 03:09:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2ypt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 03:09:02 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26J391U1016855;
        Tue, 19 Jul 2022 03:09:01 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3hc1k2ypt1-1;
        Tue, 19 Jul 2022 03:09:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Vinod Koul <vkoul@kernel.org>,
        Chanho Park <chanho61.park@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 0/3] change exynos ufs phy control
Date:   Mon, 18 Jul 2022 23:08:54 -0400
Message-Id: <165820009733.29375.13730837711131450349.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706020255.151177-1-chanho61.park@samsung.com>
References: <CGME20220706020540epcas2p37a8b697af2c6786db9e4ed67cf20a40f@epcas2p3.samsung.com> <20220706020255.151177-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190011
X-Proofpoint-ORIG-GUID: D1y6NFQDdt_KabmPI9U_UHxu2d-dmPWi
X-Proofpoint-GUID: D1y6NFQDdt_KabmPI9U_UHxu2d-dmPWi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 6 Jul 2022 11:02:52 +0900, Chanho Park wrote:

> Since commit 1599069a62c6 ("phy: core: Warn when phy_power_on is called
> before phy_init"), below warning has been reported.
> 
> phy_power_on was called before phy_init
> 
> To address this, we need to remove phy_power_on from
> exynos_ufs_phy_init.
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[3/3] ufs: ufs-exynos: change ufs phy control sequence
      https://git.kernel.org/mkp/scsi/c/3d73b200f989

-- 
Martin K. Petersen	Oracle Linux Engineering
