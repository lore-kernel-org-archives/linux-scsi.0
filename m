Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B491EC7619A
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 02:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjDCCUY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 22:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjDCCUX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 22:20:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FD25258
        for <linux-scsi@vger.kernel.org>; Sun,  2 Apr 2023 19:20:22 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 332JhZLQ030798;
        Mon, 3 Apr 2023 02:20:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=ekjhlV7/3qW3X/2paHAKsnJv/bFKMDWm3A0JE2r9o4M=;
 b=HMaOJQzFXr1vimhGloR8BL0l6JiY7a7tg+bXOu2t+ABysuWF3qMHL2bXWjjvbhIZeHuX
 wR4VlHMdHkZJ+nD9t1FVw/MoBS5Z8vlWYrAKSVvsbvK9urfNRll7ZMcqZGmIZS0LhAkb
 7ACwXAVKItmUG8dtzYAP6Gh00F/vLc4eO8I9VcBNT1UxBz0kRLIYN10RZyoI9CkDIwLM
 t+O2TjUVU00cemHN4ybml3UJJ3kClZVwDLPkP9osJPX6flNyWDkJF5+TIbfqJnGinPuU
 CjSdZiD8HJS32ludQjXDdTXa8qF4J8OlwTEyr0BcNCo0Hdnytegu2xba8xSr/ce26hbt aQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbhbt24y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 02:20:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 332MO8et017423;
        Mon, 3 Apr 2023 02:20:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptp4n16v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 02:20:19 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3332COOt008162;
        Mon, 3 Apr 2023 02:20:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pptp4n164-3;
        Mon, 03 Apr 2023 02:20:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com
Subject: Re: [PATCH] mpi3mr: soft reset in progress fault code (0xF002) handling
Date:   Sun,  2 Apr 2023 22:20:14 -0400
Message-Id: <168048838485.1036111.17232694198324553524.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230331122317.11391-1-ranjan.kumar@broadcom.com>
References: <20230331122317.11391-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030015
X-Proofpoint-GUID: f8lZAJU73ThubSihRRGbir0I2OGg7_29
X-Proofpoint-ORIG-GUID: f8lZAJU73ThubSihRRGbir0I2OGg7_29
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 31 Mar 2023 17:53:17 +0530, Ranjan Kumar wrote:

> The driver is exiting from the fault watchdog thread if it
> sees the 0xF002 (Soft reset in progress) fault code,  If the
> driver initiates the soft reset, then the driver restarts the
> watchdog at the end of the soft reset completion.  However, if
> the soft reset is initiated by the firmware asynchronously then
> the driver will never restart the watchdog and never re-initialize
> the controller after the asynchronous soft reset completion.
> 
> [...]

Applied to 6.3/scsi-fixes, thanks!

[1/1] mpi3mr: soft reset in progress fault code (0xF002) handling
      https://git.kernel.org/mkp/scsi/c/a3d27dfdcfc2

-- 
Martin K. Petersen	Oracle Linux Engineering
