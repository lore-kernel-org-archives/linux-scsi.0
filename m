Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474BEC0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 16:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjGKQcT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 12:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbjGKQcP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 12:32:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CA81717;
        Tue, 11 Jul 2023 09:32:12 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36B9O4D8003075;
        Tue, 11 Jul 2023 16:32:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=duJo6dFZPc9TZ+zeNFKEGWFdOQH0TAr+ovYMi+zg3Yc=;
 b=Vlsl8wL/bFboyFYNKXgcRadKw4fZJm8Enf9mLgttkhJZnRVef+opeem0UMQpPXMC2LrN
 BeJcBTRDggGyJBHzn8sePBnutmVDTx6PxRlQAmrwvhp19wvQ8tvRFs3d4pCfKCflPhli
 QH5H7/5ssSqVDmevyPSKV4PQ7btmQ75x9sYj5k8koo+9CLtYgQnGBSAFq6rNJTmQ/FhE
 +6B+CGGnhwK6YWqYzLTXGPYpqM6wDRApQev0VtIPENOzCyppgpDPx6YCAuxWqPG3l9+E
 SRXU2SodKbDtBLPaVALkAeZ4MgQBj/Iz4JSqvLe+4H66eiQvca2U1k+8Zokap96tSO2B tg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rr8xukrx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 16:32:00 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BF8eDB007120;
        Tue, 11 Jul 2023 16:31:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx854c9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 16:31:59 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BGQBXN019529;
        Tue, 11 Jul 2023 16:31:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3rpx854c4h-3;
        Tue, 11 Jul 2023 16:31:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/5] Improve checks in blk_revalidate_disk_zones()
Date:   Tue, 11 Jul 2023 12:31:44 -0400
Message-Id: <168909306220.1197987.14432939684729585921.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230703024812.76778-1-dlemoal@kernel.org>
References: <20230703024812.76778-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=643
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110148
X-Proofpoint-GUID: O48tnqYTQ71yllnqdpl3Xg3Ox4QMLAJx
X-Proofpoint-ORIG-GUID: O48tnqYTQ71yllnqdpl3Xg3Ox4QMLAJx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 03 Jul 2023 11:48:07 +0900, Damien Le Moal wrote:

> blk_revalidate_disk_zones() implements checks of the zones of a zoned
> block device, verifying that the zone size is a power of 2 number of
> sectors, that all zones (except possibly the last one) have the same
> size and that zones cover the entire addressing space of the device.
> 
> While these checks are appropriate to verify that well tested hardware
> devices have an adequate zone configurations, they lack in certain areas
> which may result in issues with potentially buggy emulated devices
> implemented with user drivers such as ublk or tcmu. Specifically, this
> function does not check if the device driver indicated support for the
> mandatory zone append writes, that is, if the device
> max_zone_append_sectors queue limit is set to a non-zero value.
> Additionally, invalid zones such as a zero length zone with a start
> sector equal to the device capacity will not be detected and result in
> out of bounds use of the zone bitmaps prepared with the callback
> function blk_revalidate_zone_cb().
> 
> [...]

Applied to 6.5/scsi-fixes, thanks!

[1/5] scsi: sd_zbc: Set zone limits before revalidating zones
      https://git.kernel.org/mkp/scsi/c/f79846ca2f04
[2/5] nvme: zns: Set zone limits before revalidating zones
      https://git.kernel.org/mkp/scsi/c/d226b0a2b683
[3/5] block: nullblk: Set zone limits before revalidating zones
      https://git.kernel.org/mkp/scsi/c/a442b899fe17
[4/5] block: virtio_blk: Set zone limits before revalidating zones
      https://git.kernel.org/mkp/scsi/c/a3d96ed21507
[5/5] block: improve checks in blk_revalidate_disk_zones()
      https://git.kernel.org/mkp/scsi/c/03e51c4a74b9

-- 
Martin K. Petersen	Oracle Linux Engineering
