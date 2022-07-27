Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECDEC19F21
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 03:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240253AbiG0DP2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 23:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240247AbiG0DPZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 23:15:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1058019C0B
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 20:15:19 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26R2oXUe024544;
        Wed, 27 Jul 2022 03:15:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=NeYSpmUc75UFbJLJmKRwVqAPYjHbnaqeEe7yTsnGn4o=;
 b=YOI2+wkZXdlU8mYXHHXw0lIwqydzPiMvxlE12hBhspPoJdDCu1jmk0OwiOBpBMY8CbWx
 wDHGR9VF64ljJOJ3J4O8FvfOK59piBMRlSbue+At88yzwGxSdB9wItQ/w8QRUjyqFz2p
 nGcMAvoaB1tNpbLyrgBA8aRJ6pPvAPurEAViqqcn7l1m7SvmxzkEXJuPDanT3SuhHG0j
 jAS0cAETwR41JlOh8m7FkuTE8fWMFNaBm01Nerhppo1k7wjRL8HjpbgO03B8R9mhOI1R
 O0IFFscYYquHBREmKix0ISz/4JXMxM6uP/0MPqnrHM1sIMaUQ6QsB85hBRnhfbhwVhHb bQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg940r0pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 03:15:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26QNn39A020003;
        Wed, 27 Jul 2022 03:15:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh638mkst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 03:15:15 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26R3Dx7X005078;
        Wed, 27 Jul 2022 03:15:15 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3hh638mkrj-2;
        Wed, 27 Jul 2022 03:15:15 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, David Jeffery <djeffery@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Laurence Oberman <loberman@redhat.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH] scsi: mpt3sas: Stop fw fault watchdog work item during system shutdown
Date:   Tue, 26 Jul 2022 23:15:11 -0400
Message-Id: <165889169551.689.2429580988083621138.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220722142448.6289-1-djeffery@redhat.com>
References: <20220722142448.6289-1-djeffery@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207270009
X-Proofpoint-GUID: qYTpmqi8Sx2vmoep_NfST8FZiJy62-2E
X-Proofpoint-ORIG-GUID: qYTpmqi8Sx2vmoep_NfST8FZiJy62-2E
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 22 Jul 2022 10:24:48 -0400, David Jeffery wrote:

> During system shutdown or reboot, mpt3sas will reset the firmware back to
> ready state. However, the driver leaves running a watchdog work item
> intended to keep the firmware in operational state. This causes a second,
> unneeded reset on shutdown and moves the firmware back to operational
> instead of in ready state as intended. And if the mpt3sas_fwfault_debug
> module parameter is set, this extra reset also panics the system.
> 
> [...]

Applied to 5.19/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: Stop fw fault watchdog work item during system shutdown
      https://git.kernel.org/mkp/scsi/c/0fde22c5420e

-- 
Martin K. Petersen	Oracle Linux Engineering
