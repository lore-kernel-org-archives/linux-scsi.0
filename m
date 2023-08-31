Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C937C6FA8F
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345603AbjHaBtG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242200AbjHaBtG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:49:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD264CD6
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 18:49:03 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0E6Dl009604;
        Thu, 31 Aug 2023 01:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=7aOh7aUgMDJmVEwNN+hQDFnvPJYNpx7+wDrgnXjdEWc=;
 b=cDsV4Gv1weNeGb73DtR2w7/JQ3GktPeusZQeGDEhPWdTheOnmowEmOHYOwVwjbLefdvA
 Pr52fbw40l2W9F3z1wjAwhvUVHG17mSBRT896a3Gms9PWy1s83gX14E/1a+UPIO0FOua
 V9GXA+QAtJ/oh+yjSG4JrPA2QREmaNxoMxWIyfKbm3FYYgL5A1p4FaC+CiFYxBxxwLDo
 dftZVBo6ZOJquB/LNJAx6coGNAXXm/K5Uu9IoDqWqZvlOECawfpgEHggNd/Ue1UV0YH5
 SRaC2V7/WB1cX/8TplIO10qOaFaNGrsni4Hkk9y7s6tZr+K2joD9mVhYJNB5MVLLqY1e qA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9j4gtbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:49:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0DLou032873;
        Thu, 31 Aug 2023 01:49:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6dqtxna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:49:01 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37V1mnKx000352;
        Thu, 31 Aug 2023 01:49:01 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3sr6dqtxfw-8;
        Thu, 31 Aug 2023 01:49:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH] qla2xxx: fix nvme_fc_rcv_ls_req undefined error
Date:   Wed, 30 Aug 2023 21:48:35 -0400
Message-Id: <169344360096.1293881.5899692458384627082.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230824151521.35261-1-njavali@marvell.com>
References: <20230824151521.35261-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-31_01,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=746 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308310014
X-Proofpoint-GUID: 3DTnzTiHNzXJy5DDMefZ1ROLgZmDISfV
X-Proofpoint-ORIG-GUID: 3DTnzTiHNzXJy5DDMefZ1ROLgZmDISfV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 24 Aug 2023 20:45:21 +0530, Nilesh Javali wrote:

> The kernel robot reported below build error,
> 
> >> ERROR: modpost: "nvme_fc_rcv_ls_req" [drivers/scsi/qla2xxx/qla2xxx.ko] undefined!
> 
> Use CONFIG_NVME_FC enabled check to fix the build error.
> 
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/1] qla2xxx: fix nvme_fc_rcv_ls_req undefined error
      https://git.kernel.org/mkp/scsi/c/27177862de96

-- 
Martin K. Petersen	Oracle Linux Engineering
