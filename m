Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 443C7C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 02:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjEQCNZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 May 2023 22:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjEQCNL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2023 22:13:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F5249FC
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 19:13:06 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GJx6Tj019996;
        Wed, 17 May 2023 02:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=m46ZupWWhKrJdAqPVAVCtUR5FSYt4wL0x4bQb9NimNU=;
 b=yaKfJYmn65iYp81HHVrGchtXPjbT1tvBoUYuhKRNc4E+ZJnHjROARnAckipfdk69Kmcm
 Nwwl5xTnAEGl42DKcAbjY353zNmX3m7Mc51LWGDnbV/z0w5kKn9KsTMuZc/0/XGLyJgY
 xeOe/6Nfr6NgbJepQy/V4BO4A+hjlcHL1mfGUNq2jYn8oFhE669nzGOXKVA+aOCmskwM
 Gwxwq1fxVUcdj3noliyB9OGfgKmC0DChi6vBoWQu0yDGJswYmAHgxaOGLDbQaXXJ+SO9
 IaN4OxbvI9ZC2N/MWsA/eEILzynYfJiu8F1woKmTD4zovpEqXlm1s1n3A32i9sAcYCKz Dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj1b3vtt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 02:12:51 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34H20scW025027;
        Wed, 17 May 2023 02:12:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj104tw35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 02:12:51 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34H2CdOO016064;
        Wed, 17 May 2023 02:12:50 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qj104tw04-8;
        Wed, 17 May 2023 02:12:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Jason Yan <yanaijie@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com, john.g.garry@oracle.com
Subject: Re: [PATCH v3 0/3] scsi: libsas: remove empty branches and code simplification
Date:   Tue, 16 May 2023 22:12:31 -0400
Message-Id: <168428950407.722180.13597344962239712976.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421093744.1583609-1-yanaijie@huawei.com>
References: <20230421093744.1583609-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_14,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=845 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305170016
X-Proofpoint-GUID: ANOjdUBhZONWC3DyBvuXa7npXIlpB3El
X-Proofpoint-ORIG-GUID: ANOjdUBhZONWC3DyBvuXa7npXIlpB3El
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 21 Apr 2023 17:37:41 +0800, Jason Yan wrote:

> Three patches to remove two empty branches and a little code
> simplification.
> 
> v2->v3:
>   1. Drop patch #3.
>   2. Factor out sas_check_edge_expander_topo().
>   3. Factor out sas_check_fanout_expander_topo().
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/3] scsi: libsas: Simplify sas_check_eeds()
      https://git.kernel.org/mkp/scsi/c/e3be011e8280
[2/3] scsi: libsas: Remove an empty branch in sas_check_parent_topology()
      https://git.kernel.org/mkp/scsi/c/ba9be7e70e15
[3/3] scsi: libsas: factor out sas_check_fanout_expander_topo()
      https://git.kernel.org/mkp/scsi/c/cf3cd61e7660

-- 
Martin K. Petersen	Oracle Linux Engineering
