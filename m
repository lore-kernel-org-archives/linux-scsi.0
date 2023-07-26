Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9828BEB64DD
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 02:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjGZCFL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 22:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGZCFK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 22:05:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B01A121
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 19:05:06 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PJIpTU010853;
        Wed, 26 Jul 2023 02:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=KYcwFIDCjgXm0wLYnhdJ0VIg9RN0uaqycJCDTJDvnnA=;
 b=kLePzP2KN1Mt0gb/o44KlH1vMv4mMxd0hx6qMOyJxLVI6G357gwSJGMjPHQMWi96hZm/
 8pkKpzhUSvOFY89CAFJrU4r8LaAp/Mn7sYA3M3DHADXnWRYUt5Gc3v6H7g/MHv1JNag0
 uKLtKMgm0j/dq2PHfvcUxz/tR4iQXtvoJTebGTmfG2G5/pbvzduATTDCD2KYv1DXmKpJ
 Yx8sMa2XhcqHLkC5FtRaV6l1fMNmAW6cSTey+pzLz3H10EK5CjA9Mk5A2qiCu/WzqKC1
 hF2UA4AXJKrlzC2FO86AA1uXxuh8lMFXbvFMeWfgNkl4fXM9aBihOqIk6fCmWwweli2a +w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s07nupcg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q0rsUH022991;
        Wed, 26 Jul 2023 02:05:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j5jcx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:03 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36Q253NR038905;
        Wed, 26 Jul 2023 02:05:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s05j5jcwf-1;
        Wed, 26 Jul 2023 02:05:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix residual handling in two SCSI LLDs
Date:   Tue, 25 Jul 2023 22:04:46 -0400
Message-Id: <169033702315.2256288.7694624984611370911.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230721160154.874010-1-bvanassche@acm.org>
References: <20230721160154.874010-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_14,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=471
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260016
X-Proofpoint-ORIG-GUID: J8uGV5oQr5o8tWhMF3VSkaJeIbOE73GJ
X-Proofpoint-GUID: J8uGV5oQr5o8tWhMF3VSkaJeIbOE73GJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 21 Jul 2023 09:01:31 -0700, Bart Van Assche wrote:

> This patch series fixes the documentation of scsi_set_resid() and also fixes
> residual handling in two SCSI LLDs. Please consider this patch series for the
> next merge window.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/3] scsi: core: Fix the scsi_set_resid() documentation
      https://git.kernel.org/mkp/scsi/c/f669b8a683e4

-- 
Martin K. Petersen	Oracle Linux Engineering
