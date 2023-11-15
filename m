Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8D3C5AD4C
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Nov 2023 15:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344436AbjKOPNc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 10:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344409AbjKOPNa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 10:13:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A00098;
        Wed, 15 Nov 2023 07:13:27 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AFE4g2h017281;
        Wed, 15 Nov 2023 15:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=jyDtzjiRA41HQpEbPCZGjyaytaZes/PnKBEdOJnA+6s=;
 b=eCTe7BYQG34Wv3ifVRkRPjyiv7MV8kPIlHsJlhiBG1cWhZSufM4jMAmihcFKbeAGl4jg
 t5RQhqHjNZstLB25ChP9SaByr/I4z7fGmK+I30EwigaJ7yXp+VMrcr+AO/r6F0OLUCGc
 C7EpDn+CUjetsjaZmfTTKC9OhVd3qwIRuImEvbaoB+ZZo96NCvYXDVPFtxbIbF07tzM0
 oDLuN26gCpEdgIuAZZjQAuwHK9yjlKOrST8u4wxwrpBRe3EfJLs7s1/0uVeC4Dz5ykFr
 4GqkkfrT25brQxa0af/hVE8Ic7tdNc0EY6b7cuTBYb7NnqJ1yyrOUYNk11Kb8VqGff7N rQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2strr7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Nov 2023 15:13:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AFF4iCA003911;
        Wed, 15 Nov 2023 15:13:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxj40897-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Nov 2023 15:13:11 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AFFD8SV011253;
        Wed, 15 Nov 2023 15:13:10 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uaxj4085x-5;
        Wed, 15 Nov 2023 15:13:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        peter.wang@mediatek.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] ufs: core: fix racing issue between ufshcd_mcq_abort and ISR
Date:   Wed, 15 Nov 2023 10:13:03 -0500
Message-Id: <170006111392.506874.14169694579430411833.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231106075117.8995-1-peter.wang@mediatek.com>
References: <20231106075117.8995-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-15_13,2023-11-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=756 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311150115
X-Proofpoint-GUID: l1LmW0E1INyKXeC4nRpQVlhFvJ1l8L1_
X-Proofpoint-ORIG-GUID: l1LmW0E1INyKXeC4nRpQVlhFvJ1l8L1_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 06 Nov 2023 15:51:17 +0800, peter.wang@mediatek.com wrote:

> If command timeout happen and cq complete irq raise at the same time,
> ufshcd_mcq_abort null the lprb->cmd and NULL poiner KE in ISR.
> Below is error log.
> 
> ufshcd_abort: Device abort task at tag 18
> Unable to handle kernel NULL pointer dereference at virtual address
> 0000000000000108
> pc : [0xffffffe27ef867ac] scsi_dma_unmap+0xc/0x44
> lr : [0xffffffe27f1b898c] ufshcd_release_scsi_cmd+0x24/0x114
> 
> [...]

Applied to 6.7/scsi-fixes, thanks!

[1/1] ufs: core: fix racing issue between ufshcd_mcq_abort and ISR
      https://git.kernel.org/mkp/scsi/c/27900d7119c4

-- 
Martin K. Petersen	Oracle Linux Engineering
