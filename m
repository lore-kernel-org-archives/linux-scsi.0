Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBEDC7EE2A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jun 2023 00:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbjFAAoB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 20:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbjFAAn6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 20:43:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAC8185;
        Wed, 31 May 2023 17:43:50 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VJbiXu020031;
        Thu, 1 Jun 2023 00:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=GD6hCxEk3L0IIhByLlcvvVsHmFrFS9FYPAJZDk1KJhs=;
 b=rT+oBvRU4md5ESCBLwSk9WX0jyi4rVTbUx5sEEy/2jewAQhAaxa1AOsvdwQfrdI6rUc8
 l/lmL1/wSqH13/anfp4OCbDrw5Mh062dZCImOrxEdO013OP5OoOgiaA1LA3QHM6yiFIm
 RWuMRycEOkLWPlEMCl1aNXsp0sT8rnTbtCx5x8tpaEyte7KcNuy2XRQ7p7TdRZ+0nc7I
 8GvzgbVAZO0rqZSrmfNh60543LejhE3a5mve9qkmBHLMbRu8xgY2bTHB/QHTeBA0tpUu
 dFbYjP+57m5X+AHFRSdn6l3dhrk9oYFCg1I/Drv+xmtCIWBzdLemf0BkFie0jyDibHWz tg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhjh7cnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jun 2023 00:43:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VMhvGw004404;
        Thu, 1 Jun 2023 00:43:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qv4ye2eav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jun 2023 00:43:34 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3510hV9L008516;
        Thu, 1 Jun 2023 00:43:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qv4ye2e6s-3;
        Thu, 01 Jun 2023 00:43:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Niklas Cassel <nks@flawful.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH v7 00/19] Add Command Duration Limits support
Date:   Wed, 31 May 2023 20:43:12 -0400
Message-Id: <168558000054.2461197.15843380024043711693.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
References: <20230511011356.227789-1-nks@flawful.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_18,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=830
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010004
X-Proofpoint-GUID: 0ArI-bCon4iraFW0sj-1q9sYhdeEwk0Q
X-Proofpoint-ORIG-GUID: 0ArI-bCon4iraFW0sj-1q9sYhdeEwk0Q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 11 May 2023 03:13:33 +0200, Niklas Cassel wrote:

> This series adds support for Command Duration Limits.
> The series is based on linux tag: v6.4-rc1
> The series can also be found in git:
> https://github.com/floatious/linux/commits/cdl-v7
> 
> 
> =================
> CDL in ATA / SCSI
> =================
> Command Duration Limits is defined in:
> T13 ATA Command Set - 5 (ACS-5) and
> T10 SCSI Primary Commands - 6 (SPC-6) respectively
> (a simpler version of CDL is defined in T10 SPC-5).
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[01/19] ioprio: cleanup interface definition
        https://git.kernel.org/mkp/scsi/c/eca2040972b4
[02/19] block: introduce ioprio hints
        https://git.kernel.org/mkp/scsi/c/6c913257226a
[03/19] block: introduce BLK_STS_DURATION_LIMIT
        https://git.kernel.org/mkp/scsi/c/dffc480d2df1
[04/19] scsi: core: allow libata to complete successful commands via EH
        https://git.kernel.org/mkp/scsi/c/3d848ca1ebc8
[05/19] scsi: rename and move get_scsi_ml_byte()
        https://git.kernel.org/mkp/scsi/c/734326937b65
[06/19] scsi: support retrieving sub-pages of mode pages
        https://git.kernel.org/mkp/scsi/c/a6cdc35fab0d
[07/19] scsi: support service action in scsi_report_opcode()
        https://git.kernel.org/mkp/scsi/c/152e52fb6ff1
[08/19] scsi: detect support for command duration limits
        https://git.kernel.org/mkp/scsi/c/624885209f31
[09/19] scsi: allow enabling and disabling command duration limits
        https://git.kernel.org/mkp/scsi/c/1b22cfb14142
[10/19] scsi: sd: set read/write commands CDL index
        https://git.kernel.org/mkp/scsi/c/e59e80cfef60
[11/19] scsi: sd: handle read/write CDL timeout failures
        https://git.kernel.org/mkp/scsi/c/390e2d1a5874
[12/19] ata: libata-scsi: remove unnecessary !cmd checks
        https://git.kernel.org/mkp/scsi/c/91a8967ca7f4
[13/19] ata: libata: change ata_eh_request_sense() to not set CHECK_CONDITION
        https://git.kernel.org/mkp/scsi/c/24aeebbf8ea9
[14/19] ata: libata: detect support for command duration limits
        https://git.kernel.org/mkp/scsi/c/62e4a60e0cdb
[15/19] ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
        https://git.kernel.org/mkp/scsi/c/0de558015286
[16/19] ata: libata-scsi: add support for CDL pages mode sense
        https://git.kernel.org/mkp/scsi/c/673b2fe6ff1d
[17/19] ata: libata: add ATA feature control sub-page translation
        https://git.kernel.org/mkp/scsi/c/df60f9c64576
[18/19] ata: libata: set read/write commands CDL index
        https://git.kernel.org/mkp/scsi/c/eafe804bda7b
[19/19] ata: libata: handle completion of CDL commands using policy 0xD
        https://git.kernel.org/mkp/scsi/c/18bd7718b5c4

-- 
Martin K. Petersen	Oracle Linux Engineering
