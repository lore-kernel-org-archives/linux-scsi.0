Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986CCC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 03:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EFBC238A0
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 03:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgLIDFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 22:05:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54294 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgLIDFc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 22:05:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B933vWE013387;
        Wed, 9 Dec 2020 03:04:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : mime-version :
 content-type; s=corp-2020-01-29;
 bh=im6KM1TeupZ7+OOqaL16g9WQ+py93dKnhY0FXeXUVrg=;
 b=CgT2u9G+DufvhAow7IPt573MPTsgelj/WTscwwx8qiipLPEte677SGvrA95oyHIIFtj1
 +3aR1DPmDfiFXTj8R7jfEEoEGfhshcE9Gx3L6Uo+9pfEEoMODoRGJZT0Lcj6RhSkp4Cb
 WIFVPvCeWshgSTiRQt7KK9u8u1zZCjvG0ImXHSnNpCGrIkXXRIuo+LM0uAL3AuMP+l3c
 gfAF4QZAXkme6Ee3vL2DjCy2x/3J9GHF7wL6u6tyPA+OqvqYgnAX0CbRpsEILyu//66a
 J/RvZqMLg7j+p1VGXFJgqMeh0BMS4ue9hQpCCkOzcvS02jsee+Wj38jGCf3JKgAapMr0 NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3581mqwxu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 03:04:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B92tiw1007609;
        Wed, 9 Dec 2020 03:04:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 358m4yujv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 03:04:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B934MK3021556;
        Wed, 9 Dec 2020 03:04:22 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 19:04:20 -0800
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        linux-nvme@lists.infradead.org, kbusch@kernel.org, axboe@kernel.dk,
        damien.lemoal@wdc.com, sagi@grimberg.me,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, snitzer@redhat.com, selvajove@gmail.com,
        nj.shetty@samsung.com, joshi.k@samsung.com,
        javier.gonz@samsung.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/2] add simple copy support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de> (Hannes Reinecke's
        message of "Mon, 7 Dec 2020 15:56:15 +0100")
Organization: Oracle Corporation
Message-ID: <yq1im9bsn0a.fsf@ca-mkp.ca.oracle.com>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
        <20201204094659.12732-1-selvakuma.s1@samsung.com>
        <20201207141123.GC31159@lst.de>
        <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
Date:   Tue, 08 Dec 2020 22:02:35 -0500
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1011 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

[Sorry I'm late to the discussion here, had a few fires going in
addition to the end of the kernel cycle]

> And we shouldn't forget that the main issue which killed all previous
> implementations was a missing QoS guarantee.

That and the fact that our arbitrary stacking situation was hard to
resolve.

The QoS guarantee was somewhat addressed by Fred in T10. But I agree we
need some sort of toggle.

-- 
Martin K. Petersen	Oracle Linux Engineering
