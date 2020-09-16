Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BAD1C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 00:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FB8B20739
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 00:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dcLb6rs+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgIPAJg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:09:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37878 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbgIPAJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 20:09:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G03iav066137;
        Wed, 16 Sep 2020 00:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=dJlUurZ7ip5OVS7wNF4rh6ayKvqydcqKCaUrBfVDz18=;
 b=dcLb6rs+8ppq65OSHGf3uba36NboEkZAdKG0HHJzO0fYYWw4N6I6GCqdqXWDl2PTxHOH
 qw0QqfUYEFCsDM31ykf5aAsr0dYhF1kjXToh6MzY+Zl9zRMEP0ActCwWxlYPnvQGwvWX
 SwNmG5T6qPeqxbLDXjYM3KOVGO2b0fYXk3QQe4aESFgyIm18b8rZyaqNf/NFkZCQ42Bz
 COnjsY8ADWRrpLKDY2eb4d6S6yP7mF2AJqO3GRsvfPNlgQxkhWb+6nkGgM6qy6PU+vtz
 sIMX7HMigIhucW0arAqT1/Rq7xbRReoLr04uJbKCU4wBUxh+VepD2kMjhR1r2qZe6WEr 7Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 33gnrr052w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 00:09:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G04jjf062226;
        Wed, 16 Sep 2020 00:09:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33h8909jmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 00:09:26 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08G09P1Z008895;
        Wed, 16 Sep 2020 00:09:25 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 00:09:24 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@suse.de>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v3 0/2] Fix handling of host-aware ZBC disks
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bli637mx.fsf@ca-mkp.ca.oracle.com>
References: <20200915073347.832424-1-damien.lemoal@wdc.com>
Date:   Tue, 15 Sep 2020 20:09:22 -0400
In-Reply-To: <20200915073347.832424-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Tue, 15 Sep 2020 16:33:45 +0900")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1011 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150191
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The first patch fixes host-aware disk initialization and command
> completion processing. It also enables the use of host-aware disks as
> regular disks when CONFIG_BLK_DEV_ZONED is disabled.
>
> The second patch fixes the CONFIG_BLK_DEV_ZONED enabled configuration
> so that zone append emulation is not initialized for host-aware disks
> with partitions/used as regular disks. While at it, this patch also
> removes a problem with sd_zbc_init_disk() error handling in
> sd_revalidate_disk() by moving this function execution inside
> sd_zbc_revalidate_zones().

Applied to 5.9/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
