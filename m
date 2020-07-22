Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C232C433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 03:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 796B9207D0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 03:05:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ert4ww4q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731877AbgGVDF4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 23:05:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35800 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731837AbgGVDF4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 23:05:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M2kTjo191446;
        Wed, 22 Jul 2020 02:55:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=01BXubBTTggiGme5bAGTUB+IF85y9Gt5mJRvOB950ac=;
 b=Ert4ww4qHWKQEvayACm71Ls9WksxesZoOaQuXn1rooMPeky0Jrb3Txsjhfab7151opH+
 +ba9k2HaDjO+952t0cWNI9dQ5WIUYlfWf21ewpsJhWYjcp3N0pcTJv58VOOiL/rw4ZJ6
 iz8Tt3rOrUGPL774E+aOOMdpr1AJ4rPAQVYkJ8tuwulHR8WsPhlqGNhCTMtVwJGZI8Su
 HIBl9tQrmPPnenq/MvlY3LRHb4yzdgqsGtAjLjY176yMEaePZyb/9GiUf2AUdZxzL18+
 SsUZlrUq97Om51YkiNCIV1uh+Ie3EhzxivvOSUhEO/vIHZqNevq4QRm6YstexeMtuoCD CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32brgrgmt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jul 2020 02:55:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M2m6rK048369;
        Wed, 22 Jul 2020 02:55:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32e9usdjva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jul 2020 02:55:23 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06M2tDDp005896;
        Wed, 22 Jul 2020 02:55:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jul 2020 02:55:13 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        "open list:BLOCK LAYER" <linux-block@vger.kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        "open list:SCSI CDROM DRIVER" <linux-scsi@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ajay Joshi <ajay.joshi@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "open list:SONY MEMORYSTICK SUBSYSTEM" <linux-mmc@vger.kernel.org>,
        Satya Tangirala <satyat@google.com>,
        "open list:NETWORK BLOCK DEVICE (NBD)" <nbd@other.debian.org>,
        Hou Tao <houtao1@huawei.com>, Jens Axboe <axboe@fb.com>,
        "open list:VIRTIO CORE AND NET DRIVERS" 
        <virtualization@lists.linux-foundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 02/10] block: virtio-blk: check logical block size
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zh7sfedj.fsf@ca-mkp.ca.oracle.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
        <20200721105239.8270-3-mlevitsk@redhat.com>
        <20200721151437.GB10620@lst.de>
Date:   Tue, 21 Jul 2020 22:55:07 -0400
In-Reply-To: <20200721151437.GB10620@lst.de> (Christoph Hellwig's message of
        "Tue, 21 Jul 2020 17:14:37 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=1 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1011 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Hmm, I wonder if we should simply add the check and warning to
> blk_queue_logical_block_size and add an error in that case.  Then
> drivers only have to check the error return, which might add a lot
> less boiler plate code.

Yep, I agree.

-- 
Martin K. Petersen	Oracle Linux Engineering
