Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 976E2C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 19:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AE3264E7A
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 19:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhBPTk2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Feb 2021 14:40:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58256 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbhBPTkN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Feb 2021 14:40:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11GJUW5t136422;
        Tue, 16 Feb 2021 19:39:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=492vjlvaUPKSaMVwta9O8w4AIhJp40UlYOsCPkXq78k=;
 b=LrPylPDGtm4ZLNKFaTBQM/JzmJDsyajlKXztfGk8NDpmypeyD456DUWrNfjEB/Y4dFy0
 xZDBsMsYXz1gUakkY+u+7M2IABRo6zSVuanmSXhCbyNa5JXeuP2qj9jd+SMpbVsB8YQF
 Dln0vmZPxRFDqgUqj3gnHnCYgLobeKcmXQUmthTSkYVEV3re4LO1rxM43ccgQaup3bik
 7Mi68SrnioK+8Yq//XZjINtGaZ7W5ReQcICpRQEa7mrwSLJz53AidRis2nu8mZ0vTmDg
 WomBsVAVkTbDr9RnWQ3bcuB2ZsTySO6joi4H3VGoZiFgMrUfBUjByoIOgIaD1tSnezl6 9A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36pd9a7jna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Feb 2021 19:39:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11GJVWun145914;
        Tue, 16 Feb 2021 19:39:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 36prhryb24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Feb 2021 19:39:25 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11GJdNPN029503;
        Tue, 16 Feb 2021 19:39:23 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Feb 2021 11:39:23 -0800
Date:   Tue, 16 Feb 2021 22:39:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     johannes.thumshirn@wdc.com
Cc:     linux-scsi@vger.kernel.org, Michal Hocko <mhocko@kernel.org>
Subject: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Message-ID: <YCuvSfKw4qEQBr/t@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=770 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102160162
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=678 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160162
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Johannes Thumshirn,

The patch 5795eb443060: "scsi: sd_zbc: emulate ZONE_APPEND commands"
from May 12, 2020, leads to the following static checker warning:

	drivers/scsi/sd_zbc.c:741 sd_zbc_revalidate_zones()
	error: kvmalloc() only makes sense with GFP_KERNEL

drivers/scsi/sd_zbc.c
   721          /*
   722           * There is nothing to do for regular disks, including host-aware disks
   723           * that have partitions.
   724           */
   725          if (!blk_queue_is_zoned(q))
   726                  return 0;
   727  
   728          /*
   729           * Make sure revalidate zones are serialized to ensure exclusive
   730           * updates of the scsi disk data.
   731           */
   732          mutex_lock(&sdkp->rev_mutex);
   733  
   734          if (sdkp->zone_blocks == zone_blocks &&
   735              sdkp->nr_zones == nr_zones &&
   736              disk->queue->nr_zones == nr_zones)
   737                  goto unlock;
   738  
   739          sdkp->zone_blocks = zone_blocks;
   740          sdkp->nr_zones = nr_zones;
   741          sdkp->rev_wp_offset = kvcalloc(nr_zones, sizeof(u32), GFP_NOIO);
                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We're passing GFP_NOIO here so it just defaults to kcalloc() and will
not vmalloc() the memory.

   742          if (!sdkp->rev_wp_offset) {
   743                  ret = -ENOMEM;
   744                  goto unlock;
   745          }
   746  
   747          ret = blk_revalidate_disk_zones(disk, sd_zbc_revalidate_zones_cb);
   748  

regards,
dan carpenter
