Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A67E82CC3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 19:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjI0Tex (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 15:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjI0Tes (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 15:34:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE5210C8
        for <linux-scsi@vger.kernel.org>; Wed, 27 Sep 2023 12:34:39 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RIxasE031661;
        Wed, 27 Sep 2023 19:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=AWIDvF5Sx4rZkHO4HWYEhdX6A4CcbVLsLGM4KNFqguw=;
 b=0987vZ6UcIcLUK/+W6eQrWyjeAe0oX67IH9OS9tNy2u6vVUa8pWpyqUxwRasFa/87Im5
 cafyB+6BMtW7hb+DJ2gLoLAUX8YWlFQ7R/l9yra9SI6rdpmPD67GKcqWOfn2TMjZIszu
 4rHJMEtFPhdsGOiT55SF1/nxEbOGDWuIL5EGMLtYAdNoSr948biJymQyYab94W5MdedW
 OOgTr1JegZeymPwaAl2PsS0ERSKnm7OmAQi7ObEN1KZTNacDQ7She2hM+oU/ql60V23A
 GaWaSNIazTn9TS+Tm6YU9rkLMYpsLZ+wkdk7kdWkKDACkvs9TfHVeAOpyh1GDPcWMKpu IA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pxc2jgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:34:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38RI0fOn030612;
        Wed, 27 Sep 2023 19:34:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf8cv2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:34:32 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38RJYTlt010018;
        Wed, 27 Sep 2023 19:34:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t9pf8cuyr-3;
        Wed, 27 Sep 2023 19:34:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>
Subject: Re: [PATCH v2 00/10] scsi: pm8001: Bug fix and cleanup
Date:   Wed, 27 Sep 2023 15:34:24 -0400
Message-Id: <169582723789.1126739.11429782984168011239.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230911232745.325149-1-dlemoal@kernel.org>
References: <20230911232745.325149-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_12,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=372 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309270166
X-Proofpoint-GUID: 11hh8EoLUFeyNzJl7IsBhhInVzKpbNSV
X-Proofpoint-ORIG-GUID: 11hh8EoLUFeyNzJl7IsBhhInVzKpbNSV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Sep 2023 08:27:35 +0900, Damien Le Moal wrote:

> The first patch of this series fixes an issue with IRQ setup which
> prevents the controller from resuming after a system suspend.
> The following patches are code cleanup without any functional changes.
> 
> Changes from v1:
>  * Added Acked-by tag from Jack
>  * Fixed patch 10 to avoid a sparse warning
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[01/10] scsi: pm8001: Setup IRQs on resume
        https://git.kernel.org/mkp/scsi/c/c91774818b04
[02/10] scsi: pm8001: Introduce pm8001_free_irq()
        https://git.kernel.org/mkp/scsi/c/d21bfabf0e65
[03/10] scsi: pm8001: Introduce pm8001_init_tasklet()
        https://git.kernel.org/mkp/scsi/c/a08119183bc6
[04/10] scsi: pm8001: Introduce pm8001_kill_tasklet()
        https://git.kernel.org/mkp/scsi/c/80bb942b35c7
[05/10] scsi: pm8001: Introduce pm8001_handle_irq()
        https://git.kernel.org/mkp/scsi/c/07ca8c1ad061
[06/10] scsi: pm8001: Simplify pm8001_chip_interrupt_enable/disable()
        https://git.kernel.org/mkp/scsi/c/d6f2f6c6e341
[07/10] scsi: pm8001: Remove pm80xx_chip_intx_interrupt_enable/disable()
        https://git.kernel.org/mkp/scsi/c/d93e1ac40354
[08/10] scsi: pm8001: Remove PM8001_USE_MSIX
        https://git.kernel.org/mkp/scsi/c/efa1fca45082
[09/10] scsi: pm8001: Remove PM8001_USE_TASKLET
        https://git.kernel.org/mkp/scsi/c/205430290ad0
[10/10] scsi: pm8001: Remove PM8001_READ_VPD
        https://git.kernel.org/mkp/scsi/c/80975adc79dd

-- 
Martin K. Petersen	Oracle Linux Engineering
