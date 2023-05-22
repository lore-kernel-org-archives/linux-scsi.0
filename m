Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F579C77B75
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 22:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbjEVWqF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 18:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbjEVWp4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 18:45:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C9590
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 15:45:49 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MKOKai021197;
        Mon, 22 May 2023 22:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=3NyL9qsEYHFKG6hKmSImWdIJdjlKIvmyKD/2p7buYvM=;
 b=fAYPxl8MgzQ8xiPkGCLZ/3nuv1Jgni9rQGFnHALJlxyC/TidVgSV3Crhm+yqv2XXJ3r5
 HwOu1xpyyvy+8O1bVJoyyhoymaxveZsztUUl7XhMt9jvfJ8OCxCBfZL1bWoS3UY765jU
 3EjczcfBGdYLcvTLqBH5ddRJfSp6O7sf2UpJy3lHcSxZ4s46W50+EGt2Dda+v6rKIdR5
 E060z71egaeLKqNQ28+qaKbkDbt+QDH7JSYWmzu3Kd6WoueAvMu8HYQdv9WpU9OuWjAc
 TiQlNohw3sLkhlSonT7aUQv/t+Haquhxc2DSbwaTAh4C1vLENxRKxiZskG/ylfjh8sQc Zg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp5bku3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 22:45:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34MLgW3O012971;
        Mon, 22 May 2023 22:45:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk7e2n9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 22:45:44 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34MMjiVU023074;
        Mon, 22 May 2023 22:45:44 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qqk7e2n9a-1;
        Mon, 22 May 2023 22:45:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Gleb Chesnokov <gleb.chesnokov@scst.dev>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer dereference in target mode
Date:   Mon, 22 May 2023 18:45:38 -0400
Message-Id: <168479546538.1263525.11015484620208683851.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <56b416f2-4e0f-b6cf-d6d5-b7c372e3c6a2@scst.dev>
References: <32b0bb9f-ba6a-e9f1-e779-5af2e115c67a@scst.dev> <yq1h6sbvjne.fsf@ca-mkp.ca.oracle.com> <56b416f2-4e0f-b6cf-d6d5-b7c372e3c6a2@scst.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-22_16,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220192
X-Proofpoint-GUID: RVb3ws_X1Vxst3Bt8BnAZ2e51J3XIEO4
X-Proofpoint-ORIG-GUID: RVb3ws_X1Vxst3Bt8BnAZ2e51J3XIEO4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 May 2023 11:22:35 +0300, Gleb Chesnokov wrote:

> When target mode is enabled, the pci_irq_get_affinity() function may return
> a NULL value in qla_mapq_init_qp_cpu_map() due to the qla24xx_enable_msix()
> code that handles IRQ settings for target mode. This leads to a crash due
> to a NULL pointer dereference.
> 
> This patch fixes the issue by adding a check for the NULL value returned
> by pci_irq_get_affinity() and introducing a 'cpu_mapped' boolean flag to
> the qla_qpair structure, ensuring that the qpair's CPU affinity is updated
> when it has not been mapped to a CPU.
> 
> [...]

Applied to 6.4/scsi-fixes. Whitespace was still mangled so I had to
apply by hand. Please verify, thanks!

[1/1] qla2xxx: Fix NULL pointer dereference in target mode
      https://git.kernel.org/mkp/scsi/c/d54820b22e40

-- 
Martin K. Petersen	Oracle Linux Engineering
