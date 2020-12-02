Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA54C64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 01:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B5172064B
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 01:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgLBBwX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 20:52:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53970 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgLBBwX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 20:52:23 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B21hktA155218;
        Wed, 2 Dec 2020 01:51:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Qya5jkpIZydBN99Q3SPRJm+6Ju3kFcGx69Wn8bkPHOU=;
 b=CJZ69BSW8hW3Vlf34bs79cUK1/KhQ0vLewqEFJFP4fgtujmK8kZ0ujcUavSo+YaqRSeI
 zdGWc3L3xAJwyXYFLy4cNxt7n+G1cQxLj/MOi+str36YrxYUJfKjb2VOEmXJTtg8c2f9
 tHabqRJCp76utC301ZOVbYVRt30hyF7i7GLY6yLNkFcxsed3zzaeU4Ti4Zj0ipksInyX
 QmUgM7/nIAt0o3QUfhB+Pz+upFNvpahCX2bgShPu1SLmPcVKBxhDrrQlWHoNPbeYMkKv
 W8FibY8pYwHHysge9TuI/DhMPKI8tqZj4cF7WaBjn5PZmTrAKgbxy64sxxMkfEBhby7Z 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 353dyqnq6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 01:51:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B21jMZV038174;
        Wed, 2 Dec 2020 01:51:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3540fxvday-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 01:51:27 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B21pMvO010270;
        Wed, 2 Dec 2020 01:51:22 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 17:51:21 -0800
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v4 0/9] Rework runtime suspend and SPI domain validation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0u1c6ye.fsf@ca-mkp.ca.oracle.com>
References: <20201130024615.29171-1-bvanassche@acm.org>
Date:   Tue, 01 Dec 2020 20:51:19 -0500
In-Reply-To: <20201130024615.29171-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Sun, 29 Nov 2020 18:46:06 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=850 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=862
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020008
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jens,

Any objections to me picking this up?

> The SCSI runtime suspend and SPI domain validation mechanisms both use
> scsi_device_quiesce(). scsi_device_quiesce() restricts
> blk_queue_enter() to BLK_MQ_REQ_PREEMPT requests. There is a conflict
> between the requirements of runtime suspend and SCSI domain
> validation: no requests must be sent to runtime suspended devices that
> are in the state RPM_SUSPENDED while BLK_MQ_REQ_PREEMPT requests must
> be processed during SCSI domain validation. This conflict is resolved
> by reworking the SCSI domain validation implementation.
>
> Hybernation, runtime suspend and SCSI domain validation have been
> retested.

-- 
Martin K. Petersen	Oracle Linux Engineering
