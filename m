Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442F3C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 02:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjEQCNC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 May 2023 22:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjEQCM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2023 22:12:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732AC171E;
        Tue, 16 May 2023 19:12:56 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GJxV4C010609;
        Wed, 17 May 2023 02:12:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=MOe2uol9J17qqL/F0q9NZdYXCm7Ki2SxuF7bX26mwEs=;
 b=3+jrSAqy7kMtV0Cgt+o6UjVuVNyNNo/m32YccaVkOXSJ3Ln3WLSD/V2AEPN0/IsYfWp1
 0wUpZDEg1PiXRnu1rE5AcK+D1IJRjxISVJ2/oJJZP/oka7wAmlcm/FSOspH35+z+yu8a
 Q2nBzC27UvowAUEB92kGe8S8a1Rz9P3/A+Rby2uOWaSFk4WlswYw3yVYI8ww4ME4LpmS
 d32Rccy2r0BfA3Grm7sHyn/HVc1AVheXQuAVnbdASNNvbi0exqEtGEB8x08MTG5dLh2j
 s9kjfy2rJCuiumt31Yr8fKXv7rKSob2oOPT+2x3tlllzliDGMAG/q67HgpJhbg8qmZ8P lw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj1fc4qgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 02:12:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34H1hGQF025011;
        Wed, 17 May 2023 02:12:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj104tw0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 02:12:40 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34H2CdOA016064;
        Wed, 17 May 2023 02:12:40 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qj104tw04-1;
        Wed, 17 May 2023 02:12:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        Dan Carpenter <dan.carpenter@linaro.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Andy Teng <andy.teng@mediatek.com>, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: delete some dead code
Date:   Tue, 16 May 2023 22:12:24 -0400
Message-Id: <168428950421.722180.7255235436045780552.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <68fce64f-4970-45f1-807e-6c0eecdfcdc2@kili.mountain>
References: <68fce64f-4970-45f1-807e-6c0eecdfcdc2@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_14,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=863 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305170016
X-Proofpoint-ORIG-GUID: jtwOJvnf0hB-_vEEcFLgR0Q8ovdyZ_kD
X-Proofpoint-GUID: jtwOJvnf0hB-_vEEcFLgR0Q8ovdyZ_kD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 03 May 2023 13:40:59 +0300, Dan Carpenter wrote:

> There is already a test for "if (val == state)" earlier so it's not
> possible here.  Delete the dead code.
> 
> 

Applied to 6.5/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-mediatek: delete some dead code
      https://git.kernel.org/mkp/scsi/c/19c9322e36a0

-- 
Martin K. Petersen	Oracle Linux Engineering
