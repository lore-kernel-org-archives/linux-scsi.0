Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA23AC001DB
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 02:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjHHCnq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 22:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjHHCnn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 22:43:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90405E62
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 19:43:42 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3781jRgx011326;
        Tue, 8 Aug 2023 02:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=VkXAapsddS2lL6/wp6Uyjwf6HRlKgttVTZBmuKnHyW4=;
 b=d0l5DharCqIORNORSRD/jxI3O5xX6GNIZXFO2YtCZF7OXDwJY3FYINQ3dBvyb0VM/KwQ
 H0IiXAfZZT2p35qbdUAcG4FuEJyD9e2nDPplBQQVJfna+/jQuWyr7UMt1DGiqJa672yQ
 FuF8ZRaF2Pv4WoV1JKG9nMQ7bU3SCZr79rXcbm8oPg0a9Ua3m81AVkFW6IDHnaTS7p3p
 z0Wp1wzlX5bC9pcRQVZeed39k3w7hsklTcmlmFluay90DRLCGy2AnZxFLly5HDeNSWZb
 Z46EumDkCgo+KfZBtpF5IGhUJhkubgTuEDbc9d5jbpuB6lau3c2a/f/a5Zo8IR9AdSEZ pQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9eyuc436-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:43:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 377NqViY027349;
        Tue, 8 Aug 2023 02:43:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cv55wg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:43:35 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3782hYGl038171;
        Tue, 8 Aug 2023 02:43:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3s9cv55wfu-2;
        Tue, 08 Aug 2023 02:43:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 1/1] lpfc: Remove reftag check in DIF paths
Date:   Mon,  7 Aug 2023 22:43:23 -0400
Message-Id: <169146257049.4040705.7670827612104973172.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230803211932.155745-1-justintee8345@gmail.com>
References: <20230803211932.155745-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_28,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=472 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308080022
X-Proofpoint-GUID: k8nbSx-HfdliajATddNtx7cXjIrN9NIk
X-Proofpoint-ORIG-GUID: k8nbSx-HfdliajATddNtx7cXjIrN9NIk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 03 Aug 2023 14:19:32 -0700, Justin Tee wrote:

> When preparing protection DIF I/O for DMA, the driver obtains reference
> tags from scsi_prot_ref_tag.  Previously, there was a wrong assumption that
> an all 0xffffffff value meant error and thus the driver failed the I/O.
> This patch removes the evaluation code and accepts whatever the upper layer
> returns.
> 
> 
> [...]

Applied to 6.5/scsi-fixes, thanks!

[1/1] lpfc: Remove reftag check in DIF paths
      https://git.kernel.org/mkp/scsi/c/8eebf0e84f06

-- 
Martin K. Petersen	Oracle Linux Engineering
