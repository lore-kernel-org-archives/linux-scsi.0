Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E2FC4741F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 13:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AC6E20731
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 13:40:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P4xRbjYY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbgKINju (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 08:39:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731333AbgKINjs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 08:39:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604929187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=30aIpkoGzLQHi4d8TJdTBFjnhZT9ynIM5RTZ6XC00zY=;
        b=P4xRbjYYF9Rq1R6U/1wS9DabyewhT73Wyg+vaeLpsBgz2hI3aRlxIe1Toqn0Gk7DulGKyu
        bm49f6HvJWrhaE/HALEHvWv3Y4rRu4P6abXlLjI1m7+APsHfNFM1Ze2kiltXksb4y1Ra04
        n36meL+tTNZMFz06I/9IhfaL2hhp9EA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-3IWVd2ImOieWVOr-t6U6bA-1; Mon, 09 Nov 2020 08:39:41 -0500
X-MC-Unique: 3IWVd2ImOieWVOr-t6U6bA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 101E1425D4;
        Mon,  9 Nov 2020 13:39:39 +0000 (UTC)
Received: from ovpn-113-119.rdu2.redhat.com (ovpn-113-119.rdu2.redhat.com [10.10.113.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 324EB5DA6B;
        Mon,  9 Nov 2020 13:39:32 +0000 (UTC)
Message-ID: <06a1a6bde51a66461d7b3135349641856315401d.camel@redhat.com>
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
From:   Qian Cai <cai@redhat.com>
To:     John Garry <john.garry@huawei.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        don.brace@microsemi.com, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>, dgilbert@interlog.com,
        paolo.valente@linaro.org, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        esc.storagedev@microsemi.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        chenxiang66@hisilicon.com, luojiaxing@huawei.com,
        Hannes Reinecke <hare@suse.com>
Date:   Mon, 09 Nov 2020 08:39:32 -0500
In-Reply-To: <0c75b881-3096-12cf-07cc-1119ca6a453e@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
         <1597850436-116171-18-git-send-email-john.garry@huawei.com>
         <fe3dff7dae4494e5a88caffbb4d877bbf472dceb.camel@redhat.com>
         <385d5408-6ba2-6bb6-52d3-b59c9aa9c5e5@huawei.com>
         <193a0440eed447209c48bda042f0e4db102355e7.camel@redhat.com>
         <519e0d58-e73e-22ce-0ddb-1be71487ba6d@huawei.com>
         <d8fd51b11d5d54e6ec7e4e9a4f7dcc83f1215cd3.camel@redhat.com>
         <d4f86cccccc3bffccc4eda39500ce1e1fee2109a.camel@redhat.com>
         <7624d3fe1613f19af5c3a77f4ae8fe55@mail.gmail.com>
         <d1040c06-74ea-7016-d259-195fa52196a9@huawei.com>
         <CAL2rwxoAAGQDud1djb3_LNvBw95YoYUGhe22FwE=hYhy7XOLSw@mail.gmail.com>
         <aaf849d38ca3cdd45151ffae9b6a99fe6f6ea280.camel@redhat.com>
         <0c75b881-3096-12cf-07cc-1119ca6a453e@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-11-09 at 08:49 +0000, John Garry wrote:
> On 07/11/2020 00:17, Qian Cai wrote:
> > On Sat, 2020-11-07 at 00:55 +0530, Sumit Saxena wrote:
> > > I am able to hit the boot hang and similar kind of stack traces as
> > > reported by Qian with shared .config on x86 machine.
> > > In my case the system boots after a hang of 40-45 mins. Qian, is it
> > > true for you as well ?
> > I don't know. I had never waited for that long.
> > 
> > .
> > 
> 
> Hi Qian,
> 
> By chance do have an equivalent arm64 .config, enabling the same RH 
> config options?
> 
> I suppose I could try do this myself also, but an authentic version 
> would be nicer.
The closest one I have here is:
https://cailca.coding.net/public/linux/mm/git/files/master/arm64.config

but it only selects the Thunder X2 platform and needs to manually select
CONFIG_MEGARAID_SAS=m to start with, but none of arm64 systems here have
megaraid_sas.

