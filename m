Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E567EB64DD
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 02:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjGZCFw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 22:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGZCFv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 22:05:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F08526BC
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 19:05:50 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PJIXWs020077;
        Wed, 26 Jul 2023 02:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=GvPrsKeg4d5v38Aykmi+714yaCmCDrRHiqYJQj0S02o=;
 b=KH4TAf2TKWXKbD4cgwi3jK812cyW58CDEqab5DlO/NJvSlBFWdQmJMnPi0IcKdJ4t/BF
 UFETgry+WNyVe3oyS3mIiIWDcbgdPMLeLm4f4rFxQAeH5nBHEbpL+qOMdR+KQLX6SYP3
 S37uyF/aCQkeHw/eynDc+pG6VpYr/v78Ri/FQth1NFiQQ1IkoXwlssfe3h1P1IBkqmbT
 pLJ4iALFAv0UQMEzC/AtM4nbzMdes67COX6/RHfIpi3uyA0xpbLVzLhvJr1xm0YupJtq
 2eOW3YAB7QoL2OyeqdF0tb6JMprRKghX2nb1eMEFRXSg6cvijtR7gEF4HHWEGXKloxKD VA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05hdxdne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q0Yb53023022;
        Wed, 26 Jul 2023 02:05:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j5jcy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:06 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36Q253NT038905;
        Wed, 26 Jul 2023 02:05:05 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s05j5jcwf-2;
        Wed, 26 Jul 2023 02:05:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Markus Fuchs <mklntf@gmail.com>
Subject: Re: [PATCH] scsi: ufs: Convert UPIU_HEADER_DWORD() into a function
Date:   Tue, 25 Jul 2023 22:04:47 -0400
Message-Id: <169033702293.2256288.16604378952755514903.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230706215054.4113469-1-bvanassche@acm.org>
References: <20230706215054.4113469-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_14,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=769
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260016
X-Proofpoint-ORIG-GUID: EjJ3UwIg3Zk-Sfnkyu7F6AVKPV72yExY
X-Proofpoint-GUID: EjJ3UwIg3Zk-Sfnkyu7F6AVKPV72yExY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 06 Jul 2023 14:50:24 -0700, Bart Van Assche wrote:

> This change reduces the number of parentheses that are required in the
> definition of this function and also when using this function.
> 
> 

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: ufs: Convert UPIU_HEADER_DWORD() into a function
      https://git.kernel.org/mkp/scsi/c/aa2db9d44a8b

-- 
Martin K. Petersen	Oracle Linux Engineering
