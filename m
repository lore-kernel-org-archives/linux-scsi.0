Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 935A9EB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 02:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbjFOCPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 22:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFOCPq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 22:15:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C612103
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 19:15:45 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EJgtAW011554;
        Thu, 15 Jun 2023 02:15:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=Nsv1T/g290JU70cepLe00P0EFHsc0tF0x9ywfgBO4Do=;
 b=acU7xLxoP1C7kR59LtOLEEbRpZ247ufjKrZI5w9ZO+Zd3xavain4vfiAm79VIWfFNnvl
 yvGgvsnL6DfA5afTrYPOwwLxi5IhqH5oTwI4w56MCCUNc85pw+51fgK45MhUXkLbP91S
 +ik7UUOtyMgtEj2W2LGrGdZDAFuQgia//inC7sFtmRVvt2g3UrLDwv7xgSLtuiBxL4Qo
 uVutczlrKB3SreI9PdnJW1Ms4ADXoJgz299wW6Kcco2TRugzXobRA/LeFeYL7wECJ8Cs
 IevJNI50fJwGzOGVAxKigQEDZ5S3I4e1Kt+J8htar/IiedaMFhqb+8Ps0bMFPkbIZPN9 Vw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hqurxvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 02:15:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35ENUWmK008281;
        Thu, 15 Jun 2023 02:15:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fmcm0j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 02:15:42 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35F2FfSx031296;
        Thu, 15 Jun 2023 02:15:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3r4fmcm0h8-3;
        Thu, 15 Jun 2023 02:15:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        Bob Pearson <rpearsonhpe@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] drivers: target: Fix error path in target_setup_session
Date:   Wed, 14 Jun 2023 22:15:33 -0400
Message-Id: <168679530534.3778443.15762943378225050526.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230613144259.12890-1-rpearsonhpe@gmail.com>
References: <20230613144259.12890-1-rpearsonhpe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=770 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150017
X-Proofpoint-ORIG-GUID: MDctnGwNY6d4DC3e4en70LMJzrX57ErZ
X-Proofpoint-GUID: MDctnGwNY6d4DC3e4en70LMJzrX57ErZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 13 Jun 2023 09:43:00 -0500, Bob Pearson wrote:

> In the error exits in target_setup_session, if a branch is taken
> to free_sess: transport_free_session may call to target_free_cmd_counter
> and then fall through to call target_free_cmd_counter a second time.
> This can, and does, sometimes cause seg faults since the data field
> in cmd_cnt->refcnt has been freed in the first call. This patch
> fixes this problem by simply returning after the call to
> transport_free_session. The second call is redundant for those
> cases.
> 
> [...]

Applied to 6.4/scsi-fixes, thanks!

[1/1] drivers: target: Fix error path in target_setup_session
      https://git.kernel.org/mkp/scsi/c/91271699228b

-- 
Martin K. Petersen	Oracle Linux Engineering
