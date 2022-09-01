Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6853ECAAD1
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 05:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbiIAFNL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 01:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbiIAFNF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 01:13:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1361286DD
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 22:13:05 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VNnRxl017139;
        Thu, 1 Sep 2022 05:13:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=8MDoobcsH3PdT+lNiwRmQXh+YAV4ZZagXTHUuJ9XJhI=;
 b=Jvuz8hraT5chIIGiAFjBRcjZjwO06jK0napi8FxqmqEj3vXULohJpzdAcmKiEvYID4vi
 qS5sveIpo9CmRO6tKiH0DQNQODrAKNHFmV6Di/BypwujIq1W5fttF+NbrN98f3WDMeIp
 QTICnp/iAz5pvXszOyEc3M1euzOZmc86rai1ojx6pGwDpfF5pbK94ArM4xhBuNgGmcro
 OCo2Lv12XcTtWvxfOUbZd3Mx8VI3ef7uKtP+9Ybhz+j3y3Kow+iEK6InM/VPH/ifKYqO
 eJGdFIIwGfXr2QuDY2IfKGS325iYNRejrWhSQLoCesVBSpxE3dT2mX7mKEw1o8I9SrfI Hw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7bttb0bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:13:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2813QKY0033605;
        Thu, 1 Sep 2022 05:12:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ja6gr3g3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:12:59 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2815CsXT008754;
        Thu, 1 Sep 2022 05:12:58 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ja6gr3g0k-8;
        Thu, 01 Sep 2022 05:12:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v5 1/4] scsi: qla2xxx: Remove unused del_sess_list field
Date:   Thu,  1 Sep 2022 01:12:52 -0400
Message-Id: <166200877450.26143.13114640534200573694.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <0c335e86-5624-b599-5137-f1377419fb0c@I-love.SAKURA.ne.jp>
References: <0c335e86-5624-b599-5137-f1377419fb0c@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010022
X-Proofpoint-ORIG-GUID: k5V5xkDtZx_ckBGacfQ8CnP4MR2NCkJM
X-Proofpoint-GUID: k5V5xkDtZx_ckBGacfQ8CnP4MR2NCkJM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 21 Aug 2022 12:57:50 +0900, Tetsuo Handa wrote:

> "struct qla_tgt"->del_sess_list is no longer used since commit
> 726b85487067d7f5 ("qla2xxx: Add framework for async fabric discovery").
> 
> 

Applied to 6.1/scsi-queue, thanks!

[1/4] scsi: qla2xxx: Remove unused del_sess_list field
      https://git.kernel.org/mkp/scsi/c/e6852b41b560
[2/4] scsi: qla2xxx: Remove unused qlt_tmr_work()
      https://git.kernel.org/mkp/scsi/c/1b2b8d45ccd6
[3/4] scsi: qla2xxx: always wait for qlt_sess_work_fn() from qlt_stop_phase1()
      https://git.kernel.org/mkp/scsi/c/a4345557527f
[4/4] scsi: qla2xxx: avoid flush_scheduled_work() usage
      https://git.kernel.org/mkp/scsi/c/3cb0643a9aae

-- 
Martin K. Petersen	Oracle Linux Engineering
