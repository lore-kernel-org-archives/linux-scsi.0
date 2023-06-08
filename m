Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A33C7EE2F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 01:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbjFHBoD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 21:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbjFHBnZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 21:43:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A892D55
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 18:42:56 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357MkLM2017104;
        Thu, 8 Jun 2023 01:42:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=I9jxgMhJZJUIKHNyTGdnX/9+CJ5tkNEHqNACaOmMyOg=;
 b=IvtJtTQdYyXAIzUtGpQGMXO4cWdWhpVromzgzYUWMJyyTySGKU5cWmbnpEoTorYDftdV
 NbGH62Rf0llTZNmlEZycY7o/uOp3aS7X9y75synpxEXArHF90d4zVV6CG0cA8FZ8/Jmi
 jCgwWeOdCAOu2Khe7M0mfDTK8ai8Fd5afCjcht725+deImRjFefDKfwtZIws58FVamHX
 +QQ0OP5aXK+G4AApPFhwea9K/O2J/WsQq2nzZKJcZUGCiDlufRSFIE309UcubTqRt3h/
 OVpWjRO2vyIbuV3pmr1QiEzFwFzB6+XvtNkiZ99Cvrs3+mtMYHyNIwX1CQHfH/4uTkIV IA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6pk6r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 357N13ed037208;
        Thu, 8 Jun 2023 01:42:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6hytb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:46 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3581gQV9031871;
        Thu, 8 Jun 2023 01:42:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3r2a6hyt3a-16;
        Thu, 08 Jun 2023 01:42:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        bvanassche@acm.org, mani@kernel.org, stanley.chu@mediatek.com,
        adrian.hunter@intel.com, beanhuo@micron.com, avri.altman@wdc.com,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 0/7] ufs: core: mcq: Add ufshcd_abort() and error handler support in MCQ mode
Date:   Wed,  7 Jun 2023 21:42:20 -0400
Message-Id: <168618844285.2636448.2565904146781284618.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685396241.git.quic_nguyenb@quicinc.com>
References: <cover.1685396241.git.quic_nguyenb@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_13,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=489 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306080011
X-Proofpoint-ORIG-GUID: vJHTFYvr6RCT6pla-kr9KH6gMjn1a8mu
X-Proofpoint-GUID: vJHTFYvr6RCT6pla-kr9KH6gMjn1a8mu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 29 May 2023 15:12:19 -0700, Bao D. Nguyen wrote:

> This patch series enable support for ufshcd_abort() and error handler in MCQ mode.
> 
> Bao D. Nguyen (7):
>   ufs: core: Combine 32-bit command_desc_base_addr_lo/hi
>   ufs: core: Update the ufshcd_clear_cmds() functionality
>   ufs: mcq: Add supporting functions for mcq abort
>   ufs: mcq: Add support for clean up mcq resources
>   ufs: mcq: Added ufshcd_mcq_abort()
>   ufs: mcq: Use ufshcd_mcq_poll_cqe_lock() in mcq mode
>   ufs: core: Add error handling for MCQ mode
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/7] ufs: core: Combine 32-bit command_desc_base_addr_lo/hi
      https://git.kernel.org/mkp/scsi/c/a8f9a36e4634
[2/7] ufs: core: Update the ufshcd_clear_cmds() functionality
      https://git.kernel.org/mkp/scsi/c/7aa12d2fe89d
[3/7] ufs: mcq: Add supporting functions for mcq abort
      https://git.kernel.org/mkp/scsi/c/8d7290348992
[4/7] ufs: mcq: Add support for clean up mcq resources
      https://git.kernel.org/mkp/scsi/c/adf452611677
[5/7] ufs: mcq: Added ufshcd_mcq_abort()
      https://git.kernel.org/mkp/scsi/c/f1304d442077
[6/7] ufs: mcq: Use ufshcd_mcq_poll_cqe_lock() in mcq mode
      https://git.kernel.org/mkp/scsi/c/57d6ef4601c0
[7/7] ufs: core: Add error handling for MCQ mode
      https://git.kernel.org/mkp/scsi/c/ab248643d3d6

-- 
Martin K. Petersen	Oracle Linux Engineering
