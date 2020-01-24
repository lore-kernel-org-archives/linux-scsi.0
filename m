Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD85BC35240
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 01:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79772207FF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 01:22:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qpgDHEW2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgAXBWH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 20:22:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41576 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729151AbgAXBWG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2020 20:22:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O13lK0067647;
        Fri, 24 Jan 2020 01:21:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=HSNXIrkKWzqjrkxH38nhSRbK/7lFLmAHJTkSh4hVzYE=;
 b=qpgDHEW2UigTVKvxBVTCFbVPUrc9p0cqX5Z9c7d/3oQJOURzVv2cZt7RAUfn8jUmXMAC
 IhwBDobcUgModjU4f5BuRG8zCzTRjyhUmC8gwyHZ7HO8dGCn9SXtw5s2mZTteWB9VHUh
 5xPMdITQibqfXN621wNZzSB/kYheHPvpjaq6n0zoCaB4Dw/EDnCRN8/O3rjt2FdSnRwT
 +FQ8hZDGfUHwUeh2HhhmHSv9Wen6XMjXpBobP0tUBx3VZ1tEV62byIJjkKAr/t48cTbC
 e8B0pvYoUU4j8hsqOFiMijX8PxE/OwB0+rLJV78XXPBc1GAGY5fqIFjK5FGQIZoqCo0n vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseux6p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 01:21:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O12XYb049263;
        Fri, 24 Jan 2020 01:21:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xqmwbct90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 01:21:52 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00O1Lk3v001499;
        Fri, 24 Jan 2020 01:21:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 17:21:46 -0800
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 5/6] scsi: core: don't limit per-LUN queue depth for SSD when HBA needs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200119071432.18558-1-ming.lei@redhat.com>
        <20200119071432.18558-6-ming.lei@redhat.com>
        <yq1y2u1if7t.fsf@oracle.com> <20200123025429.GA5191@ming.t460p>
Date:   Thu, 23 Jan 2020 20:21:42 -0500
In-Reply-To: <20200123025429.GA5191@ming.t460p> (Ming Lei's message of "Thu,
        23 Jan 2020 10:54:29 +0800")
Message-ID: <yq1sgk5ejix.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240006
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ming,

> However, it depends on if the target device returns the congestion to
> host. From my observation, looks there isn't such feedback from NVMe
> target.

It happens all the time with SCSI devices. It is imperative that this
keeps working.

> Even if there was such SSD target which provides such congestion
> feedback, bypassing .device_busy won't cause big effect too since
> blk-mq's SCHED_RESTART will retry this IO returning STS_RESOURCE only
> after another in-flight one is completed.

The reason we back off is that it allows the device to recover by
temporarily reducing its workload. In addition, the lower queue depth
alleviates the risk of commands timing out leading to application I/O
failures.

> At least, Broadcom guys tests this patch on megaraid raid and the
> results shows that big improvement was got, that is why the flag is
> only set on megaraid host.

I do not question that it improves performance. That's not my point.

> In theory, .track_queue_depth may only improve sequential IO's
> performance for HDD., not very effective for SSD. Or just save a bit
> CPU cycles in case of SSD.

This is not about performance. This is about how the system behaves when
a device is starved for resources or experiencing transient failures.

-- 
Martin K. Petersen	Oracle Linux Engineering
