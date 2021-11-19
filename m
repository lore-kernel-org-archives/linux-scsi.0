Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D86C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 15:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EBEF61B27
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 15:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbhKSPyM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 10:54:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:51056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229936AbhKSPyM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Nov 2021 10:54:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A92861221;
        Fri, 19 Nov 2021 15:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637337070;
        bh=TlDTq9AOv8FgH+en11enMFFGBmpJzRegCF+fD5onZjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bQeuXN4l1sz2ptHXt/d6W4TIuBCmMUS0qzRCLG2JD/OcSt3CWMjf4Kz9umEyD1Mnf
         sSoYa9EvfwrozqMXJmAWFC6ibMXKDdNcJ1i4SI49sZqWZBHEPRV0ZD7AozXVQE+IU0
         EzMQyJzLToEDD2KSF0UKITDIqDo4grbVTo9CDIcpWapmUvwbLfWN+O/dHAX6Sxf6nd
         UHHuN3UipIyG16hQ2b2UTuK8qG4j3heaexfNuzUAeZgikGs+VXBm0hhb2+G/TDwtM5
         sK4sguJxwE8PWRLdzTHlwVJ6JKtYTbavkglzBiWlscMyKruLREW97MhYaavX/CKMqF
         Te3gnmFDubS9w==
Date:   Fri, 19 Nov 2021 07:51:05 -0800
From:   Keith Busch <kbusch@kernel.org>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Vincent Fu <vincent.fu@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Message-ID: <20211119155105.GA3298398@dhcp-10-100-145-180.wdc.com>
References: <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
 <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
 <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
 <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
 <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
 <20211029081447.ativv64dofpqq22m@ArmHalley.local>
 <20211103192700.clqzvvillfnml2nu@mpHalley-2>
 <20211116134324.hbs3tp5proxootd7@ArmHalley.localdomain>
 <CA+1E3rJRT+89OCyqRtb5BFbez0BfkKvCGijd=nObMEB3_v6MyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rJRT+89OCyqRtb5BFbez0BfkKvCGijd=nObMEB3_v6MyA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 19, 2021 at 04:17:51PM +0530, Kanchan Joshi wrote:
> Given the multitude of things accumulated on this topic, Martin
> suggested to have a table/matrix.
> Some of those should go in the initial patchset, and the remaining are
> to be staged for subsequent work.
> Here is the attempt to split the stuff into two buckets. Please change
> if something needs to be changed below.
> 
> 1. Driver
> *********
> Initial: NVMe Copy command (single NS)

Does this point include implementing the copy command in the nvme target
driver or just the host side? Enabling the target should be pretty
straight forward, and would provide an in-kernel standard compliant
"device" that everyone could test future improvements against.
