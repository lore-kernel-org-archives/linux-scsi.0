Return-Path: <SRS0=fKRq=4M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35E2C11D2F
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 17:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B90F72084E
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 17:46:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tj0oqQjd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbgBXRqP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Feb 2020 12:46:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58826 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbgBXRqP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Feb 2020 12:46:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OHVkex055441;
        Mon, 24 Feb 2020 17:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=wOyg6AZYzx8B3gzJf/TaGxdYs+eWnvDJ5KGi1ZgdBnY=;
 b=tj0oqQjdz6l53VfXucuBeIBJSKBr7MyC2t/FI2nrNzsjqFvBwSahJ0BVP0RP8FGqJ8hZ
 FOJv6HWiZZyzH0BZSmjo6YAWLZpOYpWki+iPkf6tDnqvniqoSRzfDe15fJ0GMa/LXAHm
 +WDAwtvevqcTOSaCJCjapBtFKVpliII52bxwqGqPi3PEIMHajsl5v9Koawdiwa9nh5up
 /vtpC1fvXJm0vRJeakLsoP5bPAmMm5JPYROyvQ24VP279M7VBnK3ejmEyThYItsUHeCc
 849q57R2MAXxzWYNq1eGD0uTa4XberA+JPBYLtrhoZ5BYDiOA4EfeaaLDknc1Vlv97sa JQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ybvr4n7vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 17:46:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OHQfiD028674;
        Mon, 24 Feb 2020 17:46:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ybduuvkj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 17:46:13 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01OHkCSW021765;
        Mon, 24 Feb 2020 17:46:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 09:46:12 -0800
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd_sbc: Fix sd_zbc_report_zones()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200219063800.880834-1-damien.lemoal@wdc.com>
Date:   Mon, 24 Feb 2020 12:46:10 -0500
In-Reply-To: <20200219063800.880834-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Wed, 19 Feb 2020 15:38:00 +0900")
Message-ID: <yq18skrho9p.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=617 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=675 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240131
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The block layer generic blk_revalidate_disk_zones() checks the
> validity of zone descriptors reported by a disk using the
> blk_revalidate_zone_cb() callback function executed for each zone
> descriptor. If a ZBC disk reports invalid zone descriptors,
> blk_revalidate_disk_zones() returns an error and sd_zbc_read_zones()
> changes the disk capacity to 0, which in turn results in the gendisk
> structure capacity to be set to 0. This all works well for the first
> revalidate pass on a disk and the block layer detects the capactiy
> change.

Applied to 5.6/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
