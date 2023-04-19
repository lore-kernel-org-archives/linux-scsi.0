Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 577F7C77B76
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 03:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjDSDUb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 23:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDSDU1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 23:20:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC89D2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 20:20:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33ILirYx006867;
        Wed, 19 Apr 2023 03:20:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=AFg8H2xhMdYq3pM/DWqR3iFE++iOXlLoUrPgwam/fu0=;
 b=DszViI/O+DZYy1/PlVDDQUJuSZHIjkNdYF0Ku3+E3nWgZPb5cgzgkwgosdtS3J2YNtn2
 nFNYcWhZFlJT3lTVmrsyzjUmFFEzghJALrgV78wD0qkqD6GbyBp7cI4XQXygw6SqJfgM
 NpSgoKtcSNvC1CLlnfXMUAqv1jgSRHVDMNiuzfNGaTY+x/Id2Nj+esTcaRonhU18I7J7
 9AdLOWATfJmNc3ktNFYbkoiuciBQwv5wCAK38X3u+g+fMB2yz51rDUDO39DixmV7m+y6
 HWk0ehwdpBzWYZZgWCN4s3527/StRasppOt4jsucIvPdwMgw2mQsuTjP8xyHB/NtUwMO 6g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q0768x885-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 03:20:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33J1sCGd037106;
        Wed, 19 Apr 2023 03:20:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcccvvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 03:20:23 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33J3KLpF012748;
        Wed, 19 Apr 2023 03:20:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pyjcccvts-5;
        Wed, 19 Apr 2023 03:20:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH] mpt3sas: Remove logging BIOS version in the kernel log
Date:   Tue, 18 Apr 2023 23:20:14 -0400
Message-Id: <168187437331.702980.14778813115197070285.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230322092713.6961-1-ranjan.kumar@broadcom.com>
References: <20230322092713.6961-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_17,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=834 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304190029
X-Proofpoint-ORIG-GUID: cwLQX3qC9INkwWq3xY-YLf1r5r5pQ-Lu
X-Proofpoint-GUID: cwLQX3qC9INkwWq3xY-YLf1r5r5pQ-Lu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 22 Mar 2023 14:57:13 +0530, Ranjan Kumar wrote:

> It is done to avoid ambiguity between BIOS and UEFI version.
> Management tools can be used for getting proper version information
> 
> 

Applied to 6.4/scsi-queue, thanks!

[1/1] mpt3sas: Remove logging BIOS version in the kernel log
      https://git.kernel.org/mkp/scsi/c/3fc5d6d6dcac

-- 
Martin K. Petersen	Oracle Linux Engineering
