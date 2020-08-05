Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA8FC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEE2F2075D
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:17:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MTmq8GO6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgHEBRt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:17:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHEBRs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 21:17:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0751Catb135695;
        Wed, 5 Aug 2020 01:17:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=QBxoi7CuGiZwj/G+hSgITqi0Bv+fAd4u2yI1jADqGJ4=;
 b=MTmq8GO6DQ4YVqaEC2wRUEvO/zQr4IDkcHCgy1/3AMBm0iHCVKcmFLC3XDi1GmO4diYB
 eNeGI9+u0QWSEvNAMVX7hESzI6jJ9ygB2TG1ba34wMUdvCi8iMKpM22R22eKWqKQQkj8
 RSKKE8dhsuL93F18U6YBICGqcqFMZHcbwV131ScaYHSGXUUd4k2n/PzoZUeG/OuhaODZ
 lUSC/TgBGIvbL1FFiNdxvFi8q5/IQycbNDtE5CXOGVGJ0YCb5MtvJuoPMmwCzE/gBi6G
 h6dauIvm1HXqAbskYhHguusWAKiBswFkZDWPsou9v8bWXxeixmp4hHTiiW3jVAyPX+V0 Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32n11n7apx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 05 Aug 2020 01:17:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0751Hkg6176243;
        Wed, 5 Aug 2020 01:17:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32njaxnb2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Aug 2020 01:17:46 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0751HZvq007435;
        Wed, 5 Aug 2020 01:17:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Aug 2020 18:17:35 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v2] scsi: sd_zbc: Improve zone revalidation
Date:   Tue,  4 Aug 2020 21:17:28 -0400
Message-Id: <159659019688.15726.4684025700268712554.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200731054928.668547-1-damien.lemoal@wdc.com>
References: <20200731054928.668547-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=875 mlxscore=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008050009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=894 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 31 Jul 2020 14:49:28 +0900, Damien Le Moal wrote:

> Currently, for zoned disks, since blk_revalidate_disk_zones() requires
> the disk capacity to be set already to operate correctly, zones
> revalidation can only be done on the second revalidate scan once the
> gendisk capacity is set at the end of the first scan. As a result, if
> zones revalidation fails, there is no second chance to recover from the
> failure and the disk capacity is changed to 0, with the disk left
> unusable.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: sd_zbc: Improve zone revalidation
      https://git.kernel.org/mkp/scsi/c/a3d8a2573687

-- 
Martin K. Petersen	Oracle Linux Engineering
