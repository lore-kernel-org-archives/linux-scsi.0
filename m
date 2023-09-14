Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E564EE0213
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 01:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbjINBk5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 21:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbjINBk4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 21:40:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6BF1BD1
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 18:40:51 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DLjqHn031345;
        Thu, 14 Sep 2023 01:40:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=AhGjhb9yG3tJYXTp33N2aAdPtkAnpNJAP9O83ONRrb0=;
 b=G7QFc+jrdg30O8zYl2wFUInl4/V9keIS3T2RQbVpilnCY7rLPHusIT1ftWqpJnXLLvqJ
 OBhvsxuPRXoSfXr0ZrBjO8FTW63bTfS6djOCCb4egg7ST+ux7WT1WkKanbCjWIPYJTaJ
 MWRjEHwVWt1fUUIggDTwFrZduvYU0pcg+zdstHuADMyF2hOOVw//cSQmSU13qgfcANgG
 6Huc/SFtqQlMq6JrmTjupoBq7GnRG90qVM4QxDLwsNQXE2iwJAkjp8P/aUxMbqu+wItf
 3D1juJIqKySZtqnLyrLoHnNoIyll1Ek9MlBB5y0p5Q4+jU71IdKafhdzAtuZPkqxJteh wQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7rbsbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:49 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38DNmcFt007733;
        Thu, 14 Sep 2023 01:40:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f581r2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:48 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38E1efpZ038417;
        Thu, 14 Sep 2023 01:40:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t0f581qyy-7;
        Thu, 14 Sep 2023 01:40:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH] qla2xxx: correct endianness for rqstlen and rsplen
Date:   Wed, 13 Sep 2023 21:40:30 -0400
Message-Id: <169465549429.730690.15330197380704324784.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230831112146.32595-1-njavali@marvell.com>
References: <20230831112146.32595-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=568 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140013
X-Proofpoint-ORIG-GUID: kUfHzPK_4lYyBJc-mhM-F49OtpsYte8a
X-Proofpoint-GUID: kUfHzPK_4lYyBJc-mhM-F49OtpsYte8a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 31 Aug 2023 16:51:45 +0530, Nilesh Javali wrote:

> rqstlen and rsplen were changed to __le32 to fix
> sparse warnings.
> 
> drivers/scsi/qla2xxx/qla_nvme.c:402:30: warning: incorrect type in assignment (different base types)
> drivers/scsi/qla2xxx/qla_nvme.c:402:30:    expected restricted __le32 [usertype] cmd_len
> drivers/scsi/qla2xxx/qla_nvme.c:402:30:    got unsigned short [usertype] rsplen
> drivers/scsi/qla2xxx/qla_nvme.c:507:30: warning: incorrect type in assignment (different base types)
> drivers/scsi/qla2xxx/qla_nvme.c:507:30:    expected restricted __le32 [usertype] cmd_len
> drivers/scsi/qla2xxx/qla_nvme.c:507:30:    got unsigned int [usertype] rqstlen
> drivers/scsi/qla2xxx/qla_nvme.c:508:30: warning: incorrect type in assignment (different base types)
> drivers/scsi/qla2xxx/qla_nvme.c:508:30:    expected restricted __le32 [usertype] rsp_len
> drivers/scsi/qla2xxx/qla_nvme.c:508:30:    got unsigned int [usertype] rsplen
> 
> [...]

Applied to 6.6/scsi-fixes, thanks!

[1/1] qla2xxx: correct endianness for rqstlen and rsplen
      https://git.kernel.org/mkp/scsi/c/0be7592885d7

-- 
Martin K. Petersen	Oracle Linux Engineering
