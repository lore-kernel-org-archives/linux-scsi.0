Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D51FBEB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 16:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbjGKQho (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 12:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbjGKQhl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 12:37:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE1A19BA
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 09:37:18 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36B9UTXV002903;
        Tue, 11 Jul 2023 16:32:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=djBw+w2BnbkUNkng121307/+jRCT3FBRqjiwSOUg6w4=;
 b=YvNBoD6zZ7oFtOB4bPgdLS+W+2tECNGpK0a1onlNeGFdD/I2B8aCE2q17ekK8EWgk+WS
 rrmWWdt2hIKq6UULcvE2kaGviOkvmcc8nEk2MPccdpMp3prSTZ7+/ZF4sYoOcaMS27bu
 tv/rjp9UEF8wbnxsJsC4GZkIOPpNWkNQ5y7tODuX+oRCrIhF/YBuzfwj5EnifUW+LMyd
 uskKUB12Z3tp0CRyiudGZBMLVNCIA01n+buEw8ATj/05/x0Oi1UFrclpH2GdCWmxv0jd
 eOb1g8jrefo38qjI+upRxfintJQ5yXpctXIpPP9axfqP/4NsmRx+/Qf/D0Td7JtawNxD 0A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rr8xukrxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 16:32:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BF7CCU007119;
        Tue, 11 Jul 2023 16:32:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx854ceq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 16:32:03 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BGQBXR019529;
        Tue, 11 Jul 2023 16:32:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3rpx854c4h-5;
        Tue, 11 Jul 2023 16:32:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Maurizio Lombardi <mlombard@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: remove dead code
Date:   Tue, 11 Jul 2023 12:31:46 -0400
Message-Id: <168909306206.1197987.9923313215071326639.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230628150638.53218-1-mlombard@redhat.com>
References: <20230628150638.53218-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=722
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110148
X-Proofpoint-GUID: Bf1YldkDb5T3G785vIIgYIuo4xTjo2Og
X-Proofpoint-ORIG-GUID: Bf1YldkDb5T3G785vIIgYIuo4xTjo2Og
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 28 Jun 2023 17:06:38 +0200, Maurizio Lombardi wrote:

> The ramdisk rwlocks are not used anymore
> 
> 

Applied to 6.5/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: remove dead code
      https://git.kernel.org/mkp/scsi/c/23815df5af57

-- 
Martin K. Petersen	Oracle Linux Engineering
