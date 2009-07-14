From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH v2]: New implementation of scsi_execute_async()
Date: Tue, 14 Jul 2009 22:24:56 +0400
Message-ID: <4A5CCD78.6090709@vlnb.net>
References: <4A563368.5040407@vlnb.net> <4A5CAFB5.1000901@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50777 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbZGNSYx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2009 14:24:53 -0400
In-Reply-To: <4A5CAFB5.1000901@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Joe Eykholt <jeykholt@cisco.com>

Vladislav Bolkhovitin, on 07/14/2009 08:17 PM wrote:
> This patch reimplements scsi_execute_async(). In the new version it's a lot less
> hackish and also has additional features. Namely:
> 
> 1. Possibility to insert commands both in tail and in head of the queue.
> 
> 2. Possibility to explicitly specify if the last SG element has space for padding.
> 
> This patch based on the previous patches posted by Tejun Heo. Comparing to them
> it has the following improvements:
> 
> 1. It uses BIOs chaining instead of kmalloc()ing the whole bio.
> 
> 2. It uses SGs chaining instead of kmalloc()ing one big SG in case if direct
> mapping failed (e.g. because of DMA alignment or padding).
> 
> 3. If direct mapping failed, if possible, it copies only the last SG element,
> not the whole SG.
> 
> 4. When needed, copy_page() is used instead of memcpy() to copy the whole pages.
> 
> Also this patch adds and exports functions sg_copy() and sg_copy_elem(), which
> cop one SG to another and one SG element to another respectively.
> 
> At the moment SCST is the only user of this functionality. It needs it, because
> its target drivers, which are, basically, SCSI drivers, can deal only with SGs,
> not with BIOs. But, according the latest discussions, there are other potential
> users for of this functionality, so I'm sending this patch in a hope that it will be
> also useful for them and eventually will be merged in the mainline kernel.
> 
> This patch requires previously sent patch with subject "[PATCH]: Rename REQ_COPY_USER
> to more descriptive REQ_HAS_TAIL_SPACE_FOR_PADDING".
> 
> It's against 2.6.30.1, but if necessary, I can update it to any necessary
> kernel version.
> 
> Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
> 
>  block/blk-map.c             |  408 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_lib.c     |  108 +++++++++++
>  include/linux/blkdev.h      |    3 
>  include/linux/scatterlist.h |    7 
>  include/scsi/scsi_device.h  |   11 +
>  lib/scatterlist.c           |  147 +++++++++++++++
>  6 files changed, 683 insertions(+), 1 deletion(-)

Oops, sorry, forgot to write the change log from v1. V2 has fixes 
according to comments made by Joe Eykholt and Boaz Harrosh.

Vlad

