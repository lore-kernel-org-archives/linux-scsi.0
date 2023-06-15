Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF1AEB64DB
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 02:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbjFOCPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 22:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237412AbjFOCPq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 22:15:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FD1213B
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 19:15:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EK7DX8011669;
        Thu, 15 Jun 2023 02:15:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=7GTYBtnpNwSdTKALCTAg2O/IL8pV3Hyn7k2eLdauLnc=;
 b=UXDhaV/MS0bf0jfXuqxU69Pt8zgAcShZCsVymlyFIPjcy0KqHnzVOkxS979sZqbmWVd3
 157jj7guVwj5Z+JlBpj+RY9/db2Ct2Zy8cikTCHrHKhCDgEza9bfNAaF781hXVAuQ9Tx
 ocXWfdy/NhXHgwKiKikXjF45fRcdGNst3k2pK3FCMJ/RvH53hZsXNLCYGRNugFCvphT6
 b8gb6tO5NXBtppy+NKzjFviVuJFQu72sf7hJ302VnYF/T4U2RBHv3TjGcojwehh7a7/4
 lE7DfrNbHazEkrq8ROoe+SA1c9GLokYFcLBTQL9zAuaVpRJmaJ3RUKwL1zBbZfvoNTOi mA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4gsu0trp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 02:15:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35ENex0Q008298;
        Thu, 15 Jun 2023 02:15:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fmcm0hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 02:15:42 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35F2FfSt031296;
        Thu, 15 Jun 2023 02:15:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3r4fmcm0h8-1;
        Thu, 15 Jun 2023 02:15:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jsmart2021@gmail.com, justin.tee@broadcom.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 1/1] lpfc: Fix incorrect big endian type assignment in bsg loopback path
Date:   Wed, 14 Jun 2023 22:15:31 -0400
Message-Id: <168679530536.3778443.17261467717162016668.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230614175944.3577-1-justintee8345@gmail.com>
References: <20230614175944.3577-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=810 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150017
X-Proofpoint-GUID: Xzq7YJuDDUrR2ici7VmyPiGbG0w0gzil
X-Proofpoint-ORIG-GUID: Xzq7YJuDDUrR2ici7VmyPiGbG0w0gzil
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 14 Jun 2023 10:59:44 -0700, Justin Tee wrote:

> The kernel test robot reported sparse warnings regarding incorrect type
> assignment for __be16 variables in bsg loopback path.
> 
> Change the flagged lines to use the be16_to_cpu and cpu_to_be16 macros
> appropriately.
> 
> 
> [...]

Applied to 6.4/scsi-fixes, thanks!

[1/1] lpfc: Fix incorrect big endian type assignment in bsg loopback path
      https://git.kernel.org/mkp/scsi/c/9cefd6e7e0a7

-- 
Martin K. Petersen	Oracle Linux Engineering
