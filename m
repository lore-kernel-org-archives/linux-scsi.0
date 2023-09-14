Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47BAEE0217
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 01:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbjINBlK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 21:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbjINBlF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 21:41:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7121BDF
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 18:40:55 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38E1Sukf014717;
        Thu, 14 Sep 2023 01:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=FdA1jQbBDRL1L+yBE2BoagHdZVeQD02mC8YjaZP2QP0=;
 b=WF5A0m0OjpX9AMPdQ0Z3/NbVDFIU8oU9JMDAe7Y9hZDszVsaFWNBq5/khki5oudPRJD6
 XgUXxNaUv7QGaRr/GaptIS5IfIyj4NNoFeyNguhgPahXz0feTkBCJwdXKs+asndm9w/a
 jpvdylvZzXDjrflVE8KFr+GwXZ5LvGdGm1RN2a4LwubTJudOY0Qv/Lb9PaPsIxCJLje/
 2gAlOMDsBUdWgUmeBsunQCWlNCH8eO4qrOvFTxDEeTwHRQ5/KxHbXzoMMGffaw1WmB3A
 fZRe2CQvzFY1OY79jhxC62Xbh08JGb2XdUkFo7bXJI4Ea0p3e7gAQZ0aFLy1f0COIwQB GA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7pkk42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:54 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38E0oMs3007781;
        Thu, 14 Sep 2023 01:40:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f581r4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:53 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38E1efph038417;
        Thu, 14 Sep 2023 01:40:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t0f581qyy-11;
        Thu, 14 Sep 2023 01:40:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, njavali@marvell.com
Subject: Re: [PATCH] qedf: Added the synchronization between IO completions and abort.
Date:   Wed, 13 Sep 2023 21:40:34 -0400
Message-Id: <169465549435.730690.11001353269408138923.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230901060646.27885-1-skashyap@marvell.com>
References: <20230901060646.27885-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=519 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140013
X-Proofpoint-GUID: sXFHAQWqoUWwHgB5mzM7MAK4D8ReG7Wi
X-Proofpoint-ORIG-GUID: sXFHAQWqoUWwHgB5mzM7MAK4D8ReG7Wi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 01 Sep 2023 11:36:46 +0530, Saurav Kashyap wrote:

> This fix is added to avoid the race condition between IO completion and
> abort process by protecting the cmd_type with the lock.
> 
> 

Applied to 6.6/scsi-fixes, thanks!

[1/1] qedf: Added the synchronization between IO completions and abort.
      https://git.kernel.org/mkp/scsi/c/7df0b2605489

-- 
Martin K. Petersen	Oracle Linux Engineering
