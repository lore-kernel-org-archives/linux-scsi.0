Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A646C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 18:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240594AbiKQSaZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240603AbiKQSaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 13:30:02 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF4F82200
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:30:01 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHIJAM0014223;
        Thu, 17 Nov 2022 18:29:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=DUkZCy6zC0/xjgLeL+TZfp+yZ3cMW1gmvXoRRti7KSc=;
 b=S/RTBoUJwBZMgmcbiCBYREh3WbFuIEhq22M7OZSdJykpmaWRWo4uNcdQ0jCF6m0HTpDL
 3pBXBnmiHAwNXR4egsaZCS0stiiFLP4WFGWnCNvnYO693s3uFlJsMAlp1MlfrgHSXOeR
 DHHYz4NjUoC1eFsGXmbmyetYmk6tmcXkN6R4mGDMfHc0xlUlgw9g8d4msYBIekEzVx0V
 FJ1qakVKE4YuUQFyYQYXzS7E4Vi66mUAjtVT6MwUoKK+D/K/UavOGIvTOnqpt74IRTry
 IK88VKikHfYPMaHqLFtwOqrQpnv07iqimK5dH95MTvbdrRe7BNiZsmLzA/g5TgyiOu14 zQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3jst0su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:29:48 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AHHGRWx010916;
        Thu, 17 Nov 2022 18:29:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ku3kab0hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:29:38 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AHITap5022894;
        Thu, 17 Nov 2022 18:29:37 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ku3kab0gb-3;
        Thu, 17 Nov 2022 18:29:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v2] scsi: ufs: Introduce ufshcd_abort_all()
Date:   Thu, 17 Nov 2022 13:29:25 -0500
Message-Id: <166870943114.1584889.18312998917447757097.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221031183433.2443554-1-bvanassche@acm.org>
References: <20221031183433.2443554-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=504 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211170133
X-Proofpoint-ORIG-GUID: h9zooDkeo0-rdUfsOXjYhoIycKhEwJKj
X-Proofpoint-GUID: h9zooDkeo0-rdUfsOXjYhoIycKhEwJKj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 31 Oct 2022 11:34:21 -0700, Bart Van Assche wrote:

> Move the code for aborting all SCSI commands and TMFs into a new function.
> This patch makes the ufshcd_err_handler() easier to read. Except for adding
> more logging, this patch does not change any functionality.
> 
> 

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: ufs: Introduce ufshcd_abort_all()
      https://git.kernel.org/mkp/scsi/c/b817e6ffbad7

-- 
Martin K. Petersen	Oracle Linux Engineering
