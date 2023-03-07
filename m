Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 205CAC64EC4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 02:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjCGC6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 21:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbjCGC62 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 21:58:28 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011844FA89;
        Mon,  6 Mar 2023 18:58:14 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326NwkVl003461;
        Tue, 7 Mar 2023 02:57:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=PXP43dbIa4N6tBNeeYGo8M6iX7CVuoy+r/rFnZQ/2Sg=;
 b=qCWcfKlFFPENswHqVTEEqklyqT/EhVuEGLAvrNAr5kpkHNcb3eGtSdUDORjnLO8qNHp1
 pZ8AMFSGL1yuWGOTvk6DJHhLpD74kQ0FVkzu1Ur1OX109HN/7rnG+iSak8lm5BnFvWZH
 c0hzjaBDI4+m/9i49eWXzxRPvnOHLxoBZIEE53/mATcbAHb3+7KB+BCNBkXpWH9fVbfr
 SKKP8o2HyJkeQiM1hNVMDymIMLQphGOB4r9OqkmLHJKkAkBsUdnFqsn1RpCFbD13yqi1
 Y/C/ZF1ku4mXmab8B+LK3bA90ppKqGueolekk9Z5ia0ZRLirlVBE4J3YOG7evBW5NhMA jQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p417ccg7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 327277Hg038193;
        Tue, 7 Mar 2023 02:57:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4txdvjjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:37 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3272vY2G009567;
        Tue, 7 Mar 2023 02:57:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p4txdvjhj-4;
        Tue, 07 Mar 2023 02:57:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Yaniv Gardi <ygardi@codeaurora.org>,
        Dan Carpenter <error27@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Gilad Broner <gbroner@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-qcom: remove impossible check
Date:   Mon,  6 Mar 2023 21:57:21 -0500
Message-Id: <167815780202.2075334.16632158719817352336.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <Y/yA3niWUcGYgBU8@kili>
References: <Y/yA3niWUcGYgBU8@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=801 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070025
X-Proofpoint-GUID: KXtM477-1ezEF6M-3bVrF-6Ex0jSO2KR
X-Proofpoint-ORIG-GUID: KXtM477-1ezEF6M-3bVrF-6Ex0jSO2KR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 27 Feb 2023 13:07:26 +0300, Dan Carpenter wrote:

> The "dev_req_params" pointer points to inside the middle of a struct
> so it can't be NULL.  Removing this impossible condition is nice because
> now we don't need to consider the correct error code for that situation.
> 
> 

Applied to 6.3/scsi-fixes, thanks!

[1/1] scsi: ufs: ufs-qcom: remove impossible check
      https://git.kernel.org/mkp/scsi/c/fa8d32721a07

-- 
Martin K. Petersen	Oracle Linux Engineering
