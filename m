Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4008EE021A
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 01:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbjINBkx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 21:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbjINBkx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 21:40:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329F31BD2
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 18:40:49 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DHWbnX032113;
        Thu, 14 Sep 2023 01:40:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=xLaW6QfGZKSUhHR4+JjLy9koBPBXcOIEEffQPN/lOFU=;
 b=Yvnj64DdP88RHy/wdJZlfD6KOszZpscsEtUTxgU1sT5r7y4U1NA6Dr82/7a0kAAcukgL
 DI29xi6F8IxxQu53de9+AaoLC/YDCVZv8K75ZLl2gZlFewwEYwBhgyOsVZxU0nOXX5xC
 bgekfUPLsaczja29ut1xzFuYf4pSlIyha3CZUpRIN1pSPoBvSP6Yn1x5PMlZYhVurBOH
 g8M6T9n/2Mj/X9a9D/+sGF4QWAPDc4yHFHUmW78czP7w6MoKVC3KhZbaoMZQ6kBq83kx
 ayDCdIadWuuxOjHj+YRbHMzO9MNymmIrFWMQHSHTQ4S4dT7gxMPZ49frY8Mb/o8kc1O3 KA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7muhvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38DNEZGf007564;
        Thu, 14 Sep 2023 01:40:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f581r0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:42 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38E1efpN038417;
        Thu, 14 Sep 2023 01:40:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t0f581qyy-1;
        Thu, 14 Sep 2023 01:40:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, linux-parport@lists.infradead.org,
        Alex Henrie <alexhenrie24@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ppa: Fix accidentally reversed conditions for 16-bit and 32-bit EPP
Date:   Wed, 13 Sep 2023 21:40:24 -0400
Message-Id: <169465549427.730690.14141622267790000447.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230831051945.515476-1-alexhenrie24@gmail.com>
References: <20230831051945.515476-1-alexhenrie24@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=809 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140013
X-Proofpoint-ORIG-GUID: 2ElMYxqpJdR1m8au_90KCVDdR3Av30xR
X-Proofpoint-GUID: 2ElMYxqpJdR1m8au_90KCVDdR3Av30xR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 30 Aug 2023 23:19:42 -0600, Alex Henrie wrote:

> The conditions were correct in the ppa_in function but not in the
> ppa_out function.
> 
> 

Applied to 6.6/scsi-fixes, thanks!

[1/1] scsi: ppa: Fix accidentally reversed conditions for 16-bit and 32-bit EPP
      https://git.kernel.org/mkp/scsi/c/31a0865bf593

-- 
Martin K. Petersen	Oracle Linux Engineering
