Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D6FC0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jun 2023 01:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjFVB0n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 21:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjFVB0l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 21:26:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432031BD2;
        Wed, 21 Jun 2023 18:26:40 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LKMYmI030100;
        Thu, 22 Jun 2023 01:26:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=sgGAGARs9EYRkrFIXZTgZTxyGFjpcSODZlJHTlvf6qM=;
 b=i4WUVWaAp8FxbavN1scYCIYSVMjGYwg92L4OPOtxMg2C57AVSNWZT9wnXjowY/BJOvnh
 Zu3tGnvt5b2PjnwqsPa9S+FY8jInt/stI1W+defdv/iWkWz+TB+E8RR1RWz1H/c71Sit
 Uj07xiCUoRRTpruDzfTgrWl0KyxT07TK4OnmlxPnjsZj27/rqzIxOsIJmBFtvba3DUoj
 e194AwjvMNIl1zpXUgC4RilmjP7TaA1iyLyXkM6QL9Qp+W9k7KN1CI9LAvWS+vahNcI+
 lwg2n7kRBWdlzoZiR+DSx5X8Qakh3Lee0AEF3lB2zkK+x50Jxq80GVaJfEuz/bxS91dA iQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r93rbrtr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:26:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35LMenVS038672;
        Thu, 22 Jun 2023 01:26:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r9396thxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:26:33 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35M1QXar038374;
        Thu, 22 Jun 2023 01:26:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3r9396thxp-2;
        Thu, 22 Jun 2023 01:26:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH RESEND] block: improve ioprio value validity checks
Date:   Wed, 21 Jun 2023 21:26:20 -0400
Message-Id: <168739587238.247655.7821502100444129447.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608095556.124001-1-dlemoal@kernel.org>
References: <20230608095556.124001-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_14,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=600 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306220009
X-Proofpoint-ORIG-GUID: 6Rh6LqVZWO8Ui6BHW215g0KyXMa9lW41
X-Proofpoint-GUID: 6Rh6LqVZWO8Ui6BHW215g0KyXMa9lW41
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 08 Jun 2023 18:55:56 +0900, Damien Le Moal wrote:

> The introduction of the macro IOPRIO_PRIO_LEVEL() in commit
> eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")
> results in an iopriority level to always be masked using the macro
> IOPRIO_LEVEL_MASK, and thus to the kernel always seeing an acceptable
> value for an I/O priority level when checked in ioprio_check_cap().
> Before this patch, this function would return an error for some (but not
> all) invalid values for a level valid range of [0..7].
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/1] block: improve ioprio value validity checks
      https://git.kernel.org/mkp/scsi/c/01584c1e2337

-- 
Martin K. Petersen	Oracle Linux Engineering
