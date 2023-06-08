Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2EC5C7EE23
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 01:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbjFHBnP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 21:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbjFHBnE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 21:43:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935B026A9
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 18:42:47 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357LvCYY026964;
        Thu, 8 Jun 2023 01:42:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=zFLnoLVEooFxW2OVFnOVeEEYuLM4jTfp+w0ZKcMOs5E=;
 b=D75hbtxfZ0PzW13KmdFK3CVaRJ/mCiDec2Ztuerl522Tgjsiup7K2RnxqMdFYtwezURB
 PX68xrESpcqpkfLNmLi7vbu0FM+6i2OtvszCSr7jakEfF6/O+Szf7oK169nGTCRKT/8h
 vI/+3ftbrL5Uzg+d0vIqvUYAs3mrN9+cIo3RwedgYP/9oJfWNmAEkVjLBCSAdOKp/b0X
 qzYDSCq+Lmes+q0nYl7sX0OgTuYzdZNRRA4XSQR8L8wqR0CjJ7dwwVoVIM0kFSIf7UDz
 kACqiddOyPyvgXqlyNcaa4yRWSD/GhUJflZdtjrF5R+IXyvkWxGpBtRZI21ZOlc6Ao8b pw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6rb4yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:44 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3581RwVH036752;
        Thu, 8 Jun 2023 01:42:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6hyta3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:43 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3581gQV5031871;
        Thu, 8 Jun 2023 01:42:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3r2a6hyt3a-14;
        Thu, 08 Jun 2023 01:42:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jsmart2021@gmail.com, justin.tee@broadcom.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 1/1] lpfc: Fix incorrect big endian type assignments in FDMI and VMID paths
Date:   Wed,  7 Jun 2023 21:42:18 -0400
Message-Id: <168618844274.2636448.9103250179190042612.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530191405.21580-1-justintee8345@gmail.com>
References: <20230530191405.21580-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_13,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=722 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306080011
X-Proofpoint-ORIG-GUID: KNI8lbndMN6rnlPGqiQxsXCh6TtLOgQH
X-Proofpoint-GUID: KNI8lbndMN6rnlPGqiQxsXCh6TtLOgQH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 30 May 2023 12:14:05 -0700, Justin Tee wrote:

> The kernel test robot reported sparse warnings regarding the improper usage
> of beXX_to_cpu macros.
> 
> Change the flagged FDMI and VMID member variables to __beXX and redo the
> beXX_to_cpu macros appropriately.
> 
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/1] lpfc: Fix incorrect big endian type assignments in FDMI and VMID paths
      https://git.kernel.org/mkp/scsi/c/6e8a669e61af

-- 
Martin K. Petersen	Oracle Linux Engineering
