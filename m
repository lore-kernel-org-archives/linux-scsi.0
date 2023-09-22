Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C2FE7D0BB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 02:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjIVCXV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 22:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjIVCXU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 22:23:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B37B18F
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 19:23:15 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIsTw8005970;
        Fri, 22 Sep 2023 02:23:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=djzFfIBa5ss1XIa1Ys0vqvJN0TDND+1+GhXIIUl2e1w=;
 b=NopbYLuN0TQdXJU8JTy5Y2cfX8FZ/lzTNzdGz/gVMil++eYAgCxHGkAbfMX2V1fI3FNn
 7oi5JEJfA6s2aRNyLj36c0spP2heXFgnZlVHDG1xI9daD7MDSFmzjqD7s8U8pB2M48rL
 7B1NJQf6VATXoztnGTdfo6y5rtjf2TAgdwhLaGu+lOzgimAnaHiHVgg7Y2WRt4VwiseN
 G4JbTiQwrcXWnTUZhhJ6yLucNYwpByVvw/iPeeHVG5gDyrC7avz3zlZeSuE4CvAvGGYF
 4SH7zJUlKg9EhnnOyrKsrfNQFWHLcqP+SkUi9X7b6FgsUjZJI3AliKZYv1GZ0oqxyoF7 Tw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsv0n4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 02:23:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38M2411f039460;
        Fri, 22 Sep 2023 02:23:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8ty1wdph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 02:23:10 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38M2N9vo004714;
        Fri, 22 Sep 2023 02:23:09 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8ty1wdp8-1;
        Fri, 22 Sep 2023 02:23:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        John David Anglin <dave.anglin@bell.net>
Subject: Re: [PATCH] scsi: Do no try to probe for CDL on old drives
Date:   Thu, 21 Sep 2023 22:23:04 -0400
Message-Id: <169534937576.915878.5079989781301943980.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230915022034.678121-1-dlemoal@kernel.org>
References: <20230915022034.678121-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_01,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309220019
X-Proofpoint-ORIG-GUID: yLgk4opRjTT1ev2JdBpK_DJrhfSh86_w
X-Proofpoint-GUID: yLgk4opRjTT1ev2JdBpK_DJrhfSh86_w
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 15 Sep 2023 11:20:34 +0900, Damien Le Moal wrote:

> Some old drives (e.g. an Ultra320 SCSI disk as reported by John) do not
> seem to execute MAINTENANCE_IN / MI_REPORT_SUPPORTED_OPERATION_CODES
> commands correctly and hang when a non-zero service action is specified
> (one command format with service action case in scsi_report_opcode()).
> 
> Currently, CDL probing with scsi_cdl_check_cmd() is the only caller
> using a non zero service action for scsi_report_opcode(). To avoid
> issues with these old drives, do not attempt CDL probe if the device
> reports support for an SPC version lower than 5 (CDL was introduced in
> SPC-5). To keep things working with ATA devices which probe for the CDL
> T2A and T2B pages introduced with SPC-6, modify ata_scsiop_inq_std() to
> claim SPC-6 version compatibility for ATA drives supporting CDL.
> 
> [...]

Applied to 6.6/scsi-fixes, thanks!

[1/1] scsi: Do no try to probe for CDL on old drives
      https://git.kernel.org/mkp/scsi/c/2132df16f53b

-- 
Martin K. Petersen	Oracle Linux Engineering
