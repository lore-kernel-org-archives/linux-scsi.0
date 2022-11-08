Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346B2C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 04:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiKHECG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 23:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbiKHECF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 23:02:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579EF11457
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 20:02:03 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A80ODJ9028458;
        Tue, 8 Nov 2022 04:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=cPWzRaczDZsVIQzZRV8hfIap5mNyi74pKSmvAeploCI=;
 b=Hr9xm3FelsQAgYjbUGWE6+QfX8CeG5W3MmlWGMgpEl6zwDoSjOQpGAA7Uuk64hWW13ou
 yLf92005pP/qXf1uoDSKQfJR+q8n91B7XgrYaimW3p2EZ0Kx3G7DPGysStUjhH/TnVXu
 y1Jr78xA4kLYg73nlrTjxJvw+rjZy9KS3yd5uAmsUzwfG16pGVxn3GdY8h7f7FfzlXa5
 WId0M3oYqlOgI7uqTSojjqral4VzVBuDbl3EJHFAJ450+hy8tK2t8AtcY77cOOG8TKgf
 pvUpm716TfhPfZ9430hkYf3Jt/Rlf/YTRLnLLkfL75H1dJrXvi0kXOMbuw/SBBpN161V Sg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkfx5e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 04:02:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A825W51025607;
        Tue, 8 Nov 2022 04:01:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqfh3sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 04:01:59 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A841vci022774;
        Tue, 8 Nov 2022 04:01:58 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3kpcqfh3s5-3;
        Tue, 08 Nov 2022 04:01:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v3] scsi: scsi_debug: Make the READ CAPACITY response compliant with ZBC
Date:   Mon,  7 Nov 2022 23:01:50 -0500
Message-Id: <166787992424.644674.14545295169018316209.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221102193248.3177608-1-bvanassche@acm.org>
References: <20221102193248.3177608-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=892 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211080020
X-Proofpoint-ORIG-GUID: TyuRISA2dUmdHv4ajyg5SbvAAp24hJjE
X-Proofpoint-GUID: TyuRISA2dUmdHv4ajyg5SbvAAp24hJjE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2 Nov 2022 12:32:48 -0700, Bart Van Assche wrote:

> From ZBC-1:
> * RC BASIS = 0: The RETURNED LOGICAL BLOCK ADDRESS field indicates the
>   highest LBA of a contiguous range of zones that are not sequential write
>   required zones starting with the first zone.
> * RC BASIS = 1: The RETURNED LOGICAL BLOCK ADDRESS field indicates the LBA
>   of the last logical block on the logical unit.
> 
> [...]

Applied to 6.1/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: Make the READ CAPACITY response compliant with ZBC
      https://git.kernel.org/mkp/scsi/c/ecb8c2580d37

-- 
Martin K. Petersen	Oracle Linux Engineering
