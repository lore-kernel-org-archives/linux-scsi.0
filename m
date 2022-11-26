Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5650EC4167B
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 03:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiKZD1x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 22:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiKZD1s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 22:27:48 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52239EE22
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 19:27:47 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ2hbuo007916;
        Sat, 26 Nov 2022 03:27:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=CFbMYQoGpIj96GEQHJHkHcORVrLyPZmxUis/AGo0MbI=;
 b=MJRmQBe88mM49Eh74Wuwi9Yaq0rrVfI7C4VWAt5dlFdOJZRi4eIjNzi+MJEPB7airPZv
 PwYZuwGzheJen2+PZutpgM97tyT+jPqPEm2I7/WfH0ZmBfzBB7sw/XFHnpuktzVRc6KY
 PGafvzdgZQYh6GQX8PRvaoTWj6n2lCg4vAvjR8b7g/sUWcqVhEIGowFio2uuZcHRLHg7
 QEgdbEfrAxLdwOSQ500WWG5qecQfLVilHT77ERnWi1vdRvRedR5NOV9ipTHzY7/cwWap
 u94hpqcUf5NWlQuzod33Qsfr9T/Kz+AGYIMPY45ZiO0vSuSygV9HCabh2Ehx/LMEwsrV pQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m39k2g1nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 03:27:46 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AQ1XcPo007448;
        Sat, 26 Nov 2022 03:27:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m3988b80j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 03:27:45 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AQ3RhsX028327;
        Sat, 26 Nov 2022 03:27:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3m3988b7y9-6;
        Sat, 26 Nov 2022 03:27:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Colin Ian King <colin.i.king@gmail.com>
Subject: Re: [PATCH v2] scsi: lpfc: remove redundant pointer lp
Date:   Sat, 26 Nov 2022 03:27:37 +0000
Message-Id: <166943312537.1684293.4438589900329077039.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108183620.93978-1-jsmart2021@gmail.com>
References: <20221108183620.93978-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-26_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=754 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260024
X-Proofpoint-GUID: xkgYE9tSZWO_2pL5bfKMdrHPd1PTiOvq
X-Proofpoint-ORIG-GUID: xkgYE9tSZWO_2pL5bfKMdrHPd1PTiOvq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 8 Nov 2022 10:36:20 -0800, James Smart wrote:

> From:   Colin Ian King <colin.i.king@gmail.com>
> 
> Pointer lp is being initialized and incremented but the result
> is never read. The pointer is redundant and can be removed.
> 
> Once lp is removed, pcmd is not longer used. So removed pcmd as well
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: lpfc: remove redundant pointer lp
      https://git.kernel.org/mkp/scsi/c/729c287e9f74

-- 
Martin K. Petersen	Oracle Linux Engineering
