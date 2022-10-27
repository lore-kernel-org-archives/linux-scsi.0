Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED526C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 02:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbiJ0C6p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 22:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbiJ0C6m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 22:58:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525A0D8EEB
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 19:58:42 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM1xZS014791;
        Thu, 27 Oct 2022 02:58:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=wye36RKnSQcypgE8WBtv7zUkThgfoMC7m7LgTSpDK0A=;
 b=GI8Z3U+sgKdOvS+coojlK+GUEupfTbyKHLuQlnvbQ1EeEQ3Qfvl7W42VpqnDfcS8hM6I
 JJGvw1XAdl0r5liQ6TdPdpU9Zq3tcpn3+2lv7tj8h3dKKg31ClPOvGJ/p9T3cdoU6dOn
 q3H/J5Jel0Jb8yaGujZQL3VJZKAzdXCkLKL3azxxncFkPSjgEpoRthxsRW93i2P8Ggh+
 l7Xgy//qdgl1EyR+q1Fxcj9Lnk5xBS4tWs9Z5dqwsASqJCq2RER6JmjZUo8bR4D1rD+t
 nFvDuyNPzDZ/P1Ow0cpzha9qejlwmuZ8Prv9FbG1gF8lbxefbmfqlLLJeOJajU1X1uzt 2Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfays0t46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 02:58:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM89ik006563;
        Thu, 27 Oct 2022 02:58:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaggh3hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 02:58:39 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29R2wWsh007945;
        Thu, 27 Oct 2022 02:58:39 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3kfaggh3fk-6;
        Thu, 27 Oct 2022 02:58:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jsmart2021@gmail.com, Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH 1/5] lpfc: Set sli4_param's cmf option to zero when CMF is turned off
Date:   Wed, 26 Oct 2022 22:58:31 -0400
Message-Id: <166683942544.3791741.13972934784912934052.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221017164323.14536-1-justintee8345@gmail.com>
References: <20221017164323.14536-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_10,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=901
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270015
X-Proofpoint-ORIG-GUID: ndqPJmaHPTKobuWfmD2_tT5bScI9e6tN
X-Proofpoint-GUID: ndqPJmaHPTKobuWfmD2_tT5bScI9e6tN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 17 Oct 2022 09:43:19 -0700, Justin Tee wrote:

> Add missed clearing of phba->sli4_hba.pc_sli4_params.cmf when CMF is turned
> off.
> 
> 

Applied to 6.2/scsi-queue, thanks!

[1/5] lpfc: Set sli4_param's cmf option to zero when CMF is turned off
      https://git.kernel.org/mkp/scsi/c/4fc66e7b16ad
[2/5] lpfc: Fix hard lockup when reading the rx_monitor from debugfs
      https://git.kernel.org/mkp/scsi/c/c44e50f4a0ec
[3/5] lpfc: Log when congestion management limits are in effect
      https://git.kernel.org/mkp/scsi/c/eaf660e4282b
[4/5] lpfc: Create a sysfs entry called lpfc_xcvr_data for transceiver info
      https://git.kernel.org/mkp/scsi/c/479b0917e447
[5/5] lpfc: Update lpfc version to 14.2.0.8
      https://git.kernel.org/mkp/scsi/c/24b3e45ca9c5

-- 
Martin K. Petersen	Oracle Linux Engineering
