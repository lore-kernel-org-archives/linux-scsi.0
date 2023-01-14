Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CEFC6379F
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Jan 2023 03:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjANDT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjANDTz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 22:19:55 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0AA892ED;
        Fri, 13 Jan 2023 19:19:54 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30E2saBI030971;
        Sat, 14 Jan 2023 03:19:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=AulYsugT7122ZycNxv5XSVLA058ObqNcje95f1DxxLQ=;
 b=mcZIRjQd9GtKpM81S77kt/0QbARGzNQY4AW2BL1Q3uPqvnt0mMbsZEYSNiaRXV0qybI4
 cxp7Cawk2shDXyB/yVnZ0OkHUIyVS2dDQjaBg1iGn4VAY5eO+Tsn/LCpPkLC4eb4BDli
 1SpEdl5Gd0nVZYihzzGhbxvRHwFswfzj+3nryVemeIKKoNDSQ5TjbO7jhh1JipZUI+2k
 4pfPuqZjMzEwl8Kl8yzGqqvDS7YBLgj4q6IW5tfiX5gQTdkdyYdhLi6SA5LNCURlNRjy
 jIKyyjxBQG+i0V0MSEWPKQUA508nPQ4dfWL0YmO9fJCRSonm6cfzqG/W5avD4MEAm6HL fg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3m0tg0d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 03:19:34 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30E2mjqS005810;
        Sat, 14 Jan 2023 03:19:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n3kxgrjvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 03:19:33 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30E3JVov032298;
        Sat, 14 Jan 2023 03:19:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3n3kxgrjun-4;
        Sat, 14 Jan 2023 03:19:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        Zhe Wang <zhe.wang1@unisoc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com, zhang.lyra@gmail.com,
        zhewang116@gmail.com
Subject: Re: [PATCH v4 0/2] Add support for Unisoc UFS host controller
Date:   Fri, 13 Jan 2023 22:19:28 -0500
Message-Id: <167366567312.3069740.3869848755641832363.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209124121.20306-1-zhe.wang1@unisoc.com>
References: <20221209124121.20306-1-zhe.wang1@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_12,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301140021
X-Proofpoint-GUID: Owth98HSzpecb2ko9z_lZMXexbihHYwj
X-Proofpoint-ORIG-GUID: Owth98HSzpecb2ko9z_lZMXexbihHYwj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 09 Dec 2022 20:41:19 +0800, Zhe Wang wrote:

> V3 -> V4:
>  - Added "Reviewed-by" to the dt-bindings patch
>  - Addressed Alim's comments
> 
> V2 -> V3:
>  - Modify the clock and reset names to more appropriate names
>  - Use 'assigned-clock-parents' to place parent clock of 'core'
>  - Do some format order modification
> 
> [...]

Applied to 6.3/scsi-queue, thanks!

[1/2] dt-bindings: ufs: Add document for Unisoc UFS host controller
      https://git.kernel.org/mkp/scsi/c/aa67971b2736
[2/2] scsi: ufs-unisoc: Add support for Unisoc UFS host controller
      https://git.kernel.org/mkp/scsi/c/df7320bac37e

-- 
Martin K. Petersen	Oracle Linux Engineering
