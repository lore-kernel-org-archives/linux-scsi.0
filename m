From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH] [Target_Core_Mod/pSCSI]: Add optional legacy	scsi_execute_async()
 usage for Linux/SCSI passthrough
Date: Tue, 21 Apr 2009 16:15:43 +0400
Message-ID: <49EDB8EF.7040503@vlnb.net>
References: <1239930560.4176.577.camel@haakon2.linux-iscsi.org> <49EB036B.8090607@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:50606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZDUMQb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 08:16:31 -0400
In-Reply-To: <49EB036B.8090607@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jens.axboe@oracle.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Geoff Levand <geoffrey.levand@am.sony.com>, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, Paul Mundt <lethal@linux-sh.org>

Boaz Harrosh, on 04/19/2009 02:56 PM wrote:
> On 04/17/2009 04:09 AM, Nicholas A. Bellinger wrote:

[..]

> Are you aware that scsi_execute_async() has gone in 2.6.30-rc1?
> 
> I'm not sure what would be the best alternative for you. I would say
> a bio, but it is still being debated. Your current options are:
> 
> 1. bio_alloc then loop () bio_add_pc_page, and finally blk_rq_append_bio
>    (Which block people don't like)
> 2. sglist => page-pointers-array translation and blk_rq_map_user with 
>    struct rq_map_data mode. (not possible with all kind of sglists)
> 2. sglist => iovec translation and blk_rq_map_user_iov()
>    (Very very ugly mapping of pages to virtual pointers)
> 
> I have a similar situation with my OSD code.

Do you have somewhere in it a need to run an arbitrary CDB with data 
pages stored in an sglist? Is that code accepted in the mainline?

If yes, why not to resurrect the necessary bits of scsi_execute_async() 
(option (1) above)? It was deleted, because in 2.6.30 there are no users 
of it left, but if there are users (OSD), then why not to return it? 
Seems nothing better for the sg->bio case can be invented.

Vlad
