Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B822EC7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 02:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjDLCFR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 22:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjDLCFO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 22:05:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731295257
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 19:05:11 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLFiRR023117;
        Wed, 12 Apr 2023 02:05:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=thLnBSCc/b0C/76HfrYD3Hv0/1ROSfRiWPFyuTGq1Sk=;
 b=puG/eK376KV5V51jbUYwHA3TQHzmNHnFhAA1jRk93oRcUzmDislsu9Q02iP9zGlcAHB6
 XuiJdoHE+1h9fEwN3k+2BjRom8XAMeQZ0BXcCSHqmbZ2svBGY+74z6DyHt3nudLkx4gt
 ryR4zuAMMIvO/Q8teCYxkWuiJLxgymDtEgk4Zbr4vj0ISNuwSCxlfTNbnP4alvuBBTjS
 fD3OBakBZhBJZcr1RChHaXmmDEWEHUFKOP54ebZKUNv1frR/m2zkZoEQKbbB38Smq3OM
 S0vER/9zRdz8rJqELkXVRn1F7AGr9YvhUpu/rsmva5oy6TBwGR1WLRr/qLmAlJZCExQP 8w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0eq6x0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 02:05:01 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C20Aal008113;
        Wed, 12 Apr 2023 02:05:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwc54tu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 02:05:00 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33C24xeS031283;
        Wed, 12 Apr 2023 02:05:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3puwc54tqc-4;
        Wed, 12 Apr 2023 02:05:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Enze Li <lienze@kylinos.cn>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, enze.li@gmx.com
Subject: Re: [PATCH] scsi: sr: simplify the sr_open function
Date:   Tue, 11 Apr 2023 22:04:44 -0400
Message-Id: <168126077051.185856.14316410037180963305.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230327030237.3407253-1-lienze@kylinos.cn>
References: <20230327030237.3407253-1-lienze@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=702 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304120016
X-Proofpoint-GUID: Hh-KyedDnL8H4yUPsDgdtU1xsghQnGQL
X-Proofpoint-ORIG-GUID: Hh-KyedDnL8H4yUPsDgdtU1xsghQnGQL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 27 Mar 2023 11:02:37 +0800, Enze Li wrote:

> Simplify the sr_open function by removing the goto label as it does only
> return one error code.
> 
> 

Applied to 6.4/scsi-queue, thanks!

[1/1] scsi: sr: simplify the sr_open function
      https://git.kernel.org/mkp/scsi/c/ca62009eff72

-- 
Martin K. Petersen	Oracle Linux Engineering
