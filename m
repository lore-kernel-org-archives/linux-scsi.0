Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECC7C43215
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 02:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7A74206DA
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 02:25:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sTVu9Csq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfKVCZp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 21:25:45 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59328 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfKVCZo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 21:25:44 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAM2O45X129595;
        Fri, 22 Nov 2019 02:25:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=+IcW1brC9RRuMP8eAOD+qcqBkj+fn9n/g8hILFx4gso=;
 b=sTVu9CsqSD1I+39pMRFypx5e6502JPrLE4TiNzEu7KUZ1OnpHeftqKZ+ES6TXjP6e8sy
 fAQjpLHXhLaFA/92zdrrG7DXGSXedCbFOSswFH21JxlIYQ5x91ILVJ6wtqZ66Nz/JoGC
 IDcv3kmx1xCKRuPWiZfMwnkVS6ljIdOWM3KXrdPPCCjRnwUNoVhLA7jZ31Hf29XePPpH
 kkpj4SGOyk1DkIiLXrZZ7jtNtIp4v2Nv1+MfXuYnPhOZ6CKLlswuEMIa7rnBNIndXst0
 teSFhcFyMZjTe0+xEoyV1dUW3YCYQsHCANRSXL+FoIlR/vmHaLN2SyHz1JPr3U+Iytnu lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wa9rqyuyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 02:25:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAM2NHNN142965;
        Fri, 22 Nov 2019 02:25:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wdfrwexjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 02:25:31 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAM2PTqd005753;
        Fri, 22 Nov 2019 02:25:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 18:25:29 -0800
To:     "Ewan D. Milne" <emilne@redhat.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191118103117.978-1-ming.lei@redhat.com>
        <20191118103117.978-5-ming.lei@redhat.com>
        <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
        <9bbcbbb42b659c323c9e0d74aa9b062a3f517d1f.camel@redhat.com>
        <44644664-f7b6-facd-d1bb-f7cfc9524379@acm.org>
        <f5b78ec7c0e6fec69950cace8531eb342987c0b9.camel@redhat.com>
Date:   Thu, 21 Nov 2019 21:25:25 -0500
In-Reply-To: <f5b78ec7c0e6fec69950cace8531eb342987c0b9.camel@redhat.com> (Ewan
        D. Milne's message of "Wed, 20 Nov 2019 16:36:41 -0500")
Message-ID: <yq1tv6wbqay.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=986
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ewan,

> Delaying the queue re-run vs. a ramp down might negatively affect
> performance.  I'm not sure how accurate the ramp is at discovering the
> optimum though.

The optimum - as well as the actual limit - might change over time in a
multi-initiator setup as other hosts grab resources on the device.

I do think that the only way forward here, if we want to avoid counting
outstanding commands for performance reasons, is to ensure that the
BUSY/QUEUE_FULL/TASK_SET_FULL handling is relatively fast path and not
something deep in the bowels of error handling. Which it actually
isn't. But I do think we'll need to take a closer look.

-- 
Martin K. Petersen	Oracle Linux Engineering
