Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE089C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 04:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbiKHECH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 23:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbiKHECF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 23:02:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B3C558C;
        Mon,  7 Nov 2022 20:02:03 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A80OPcp018481;
        Tue, 8 Nov 2022 04:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=VvufGExqIsZGMSXQWCAF/7A8NOxZhMPBKA9GewCOj/Q=;
 b=22rpEzup+8rLOgBZ/bL38PVDBnYIQFon4fn6htH9xm4D9EpDbzIedq5UBg35BMDVoPzc
 vi1xhlKZVU8vleBGQssqkFlZp2pG23NiJuDDqRgjsJMh4GKFisXWFtbqYjRN8oQhSY89
 5aLPYk4yZUYIq8XunW77fmzQHOKeY0+w/8vo05cmjgRDRW8RneP4d8CxM+sUGhQoURNg
 oOEAvhUbPc2B0z24sh+wNbZdOCyYuMD59iucguKdGalFmyo3AA40qFxsR2SbEPl5MKSV
 Uh/PyDRGjHmVN8I0GFKyG/7y/6w2HqHzJ+KqhIA/FDCOGNXqdR0gHNT0p5sWZqKeG755 ng== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngk6e5js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 04:02:01 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A82jKIl025544;
        Tue, 8 Nov 2022 04:02:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqfh3t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 04:02:00 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A841vcm022774;
        Tue, 8 Nov 2022 04:01:59 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3kpcqfh3s5-5;
        Tue, 08 Nov 2022 04:01:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>, linux@yadro.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/6] add support of RSOC command
Date:   Mon,  7 Nov 2022 23:01:52 -0500
Message-Id: <166787988578.644518.5478359069130392892.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220906103421.22348-1-d.bogdanov@yadro.com>
References: <20220906103421.22348-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=909 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211080020
X-Proofpoint-ORIG-GUID: 7xxG7MiQMUwNT1z17l4Xs7ZVH-yetdTr
X-Proofpoint-GUID: 7xxG7MiQMUwNT1z17l4Xs7ZVH-yetdTr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 6 Sep 2022 13:34:15 +0300, Dmitry Bogdanov wrote:

> This patchset is based on 6.1/scsi-queue.
> 
> Resending with a current datetime. Sorry for the experiment with a date
> of the patch creation.
> 
> The patchset adds support of REPORT SUPPORTED OPERATION CODES command
> according to SPC4. Including CDB USAGE DATA and timeout descriptors.
> Timeout descriptors are zeroed currently, meaning that no time is
> indicated, but an encoding of it there is.
> Opcode support and Usage Data are dynamically generated - reflects
> the backstore configuration.
> libiscsi tests for RSOC and tests that uses RSOC command are all PASSED.
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/6] scsi: target: core: add support of RSOC command
      https://git.kernel.org/mkp/scsi/c/b9b8782f8966
[2/6] scsi: target: core: add list of opcodes for RSOC
      https://git.kernel.org/mkp/scsi/c/0016e820716f
[3/6] scsi: target: core: dynamic opcode support in RSOC
      https://git.kernel.org/mkp/scsi/c/553b08d9b3a7
[4/6] scsi: target: core: add emulate_rsoc attribute
      https://git.kernel.org/mkp/scsi/c/bd217b8c3a1f
[5/6] scsi: target: check emulate_3pc for RECEIVE COPY
      https://git.kernel.org/mkp/scsi/c/b8908e5e1d1d
[6/6] scsi: target: core: dynamicaly set dpofua in usage_bits
      https://git.kernel.org/mkp/scsi/c/415d82b44011

-- 
Martin K. Petersen	Oracle Linux Engineering
