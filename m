Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23E2C727AD
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 01:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240082AbjHYBOJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237545AbjHYBNu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 21:13:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7021BFB
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 18:13:48 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OJEKUD009518;
        Fri, 25 Aug 2023 01:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=d+RzcbZ8AM15pQSEis3QdksmOpUbfnav0Cnedf7xZbo=;
 b=01PotcQgBQbnyG4KdtheaXGg17cAcQpZKKX8E+BCJ3KV+aehwe9EALQNjvozmr2kvj3E
 T8wCpX3q+PkHtS8tzaEh8wXZbvwezCEO33FOX722xIe81xM3xokUNk6W8vTxXOy0/kqg
 UH5kVmociMTGRD8H6GQw+21vwJr2/BZ5fdSacw/SMCgTWcGO6g2DClKvHx5fcFUWAZqE
 U5ghrthMHMNyjIzebgWZqVFf8SQ9iTTwwEdOYS3LxRhHk8D2S2dLmDvkxXUcH7DqJI6T
 rUF/evmO9qnOoZsN1dRlMSZpqWigHNdUtlm8j1SEL++3SOdkEqCwwEiEfa5BH/Oigb1U VQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1ytwdym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37P0egFk036119;
        Fri, 25 Aug 2023 01:13:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1ywqfkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:39 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37P1DVEA019787;
        Fri, 25 Aug 2023 01:13:39 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3sn1ywqf8n-9;
        Fri, 25 Aug 2023 01:13:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Igor Pylypiv <ipylypiv@google.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH v2 0/2] Returning FIS on success for CDL
Date:   Thu, 24 Aug 2023 21:12:55 -0400
Message-Id: <169292577176.789945.15516770848658570642.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230819213040.1101044-1-ipylypiv@google.com>
References: <20230819213040.1101044-1-ipylypiv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=588 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308250009
X-Proofpoint-ORIG-GUID: xMkwu93D-QBIozBmnfxNNJGJ4y719-_F
X-Proofpoint-GUID: xMkwu93D-QBIozBmnfxNNJGJ4y719-_F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 19 Aug 2023 14:30:38 -0700, Igor Pylypiv wrote:

> This patch series plumbs libata's request for a result taskfile
> (ATA_QCFLAG_RESULT_TF) through libsas to pm80xx LLDD. Other libsas LLDDs
> can start using the newly added return_fis_on_success as well, if needed.
> 
> For Command Duration Limits policy 0xD (command completes without
> an error) libata needs FIS in order to detect the ATA_SENSE bit and read
> the Sense Data for Successful NCQ Commands log (0Fh). pm80xx HBAs do not
> return FIS on success by default, hence, the driver is updated to set
> the RETFIS bit (Return FIS on good completion) when requested by libsas.
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/2] scsi: libsas: Add return_fis_on_success to sas_ata_task
      https://git.kernel.org/mkp/scsi/c/72875018f638
[2/2] scsi: pm80xx: Set RETFIS when requested by libsas
      https://git.kernel.org/mkp/scsi/c/545432959551

-- 
Martin K. Petersen	Oracle Linux Engineering
