From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/17] scsi: add support for per-host cmd pools
Date: Fri, 07 Feb 2014 15:43:55 -0600
Message-ID: <52F5539B.8090202@cs.wisc.edu>
References: <20140205123930.150608699@bombadil.infradead.org> <20140205124019.946278511@bombadil.infradead.org> <52F4A8C4.8080602@cs.wisc.edu> <20140207124640.GC30510@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070309010209080503090105"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42370 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbaBGVoa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Feb 2014 16:44:30 -0500
In-Reply-To: <20140207124640.GC30510@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070309010209080503090105
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 02/07/2014 06:46 AM, Christoph Hellwig wrote:
> On Fri, Feb 07, 2014 at 03:35:00AM -0600, Mike Christie wrote:
>> It seems there is a issue with using the cmd_size to indicate the driver
>> has its own cmd pool and also using that for scsi mq enabled drivers to
>> indicate that we want the LLD's struct allocated by blk/scsi mq.
>>
>> If a driver sets cmd_size for only the scsi/blk mq purpose, this patch
>> wants the driver to also setup a cmd pool which I do not think is used
>> when doing scsi/blk mq.
> 
> I don't quite understand what you mean.  cmd_size means that each
> scsi_cmnd passed to the driver will have additional per-driver data.
> 
> For the old path it's implemented by creating a slab cache and storing
> it in the host template to easily find it, for blk-mq it is used to
> increase the allocation in the block core as scsi doesn't do it's own
> allocations in this case.
> 

Ah ok. There is a bug then. I thought you were doing something crazy and
trying to do both at the same time for the same host, and that is why in
the other thread I was asking for a way to figure out where per-driver
data is.

The problem is that if a driver is using scsi-mq and sets cmd_size,
scsi-ml is trying to also setup a shost->cmd_pool. We do:

scsi_add_host_with_dma->scsi_setup_command_freelist->scsi_get_host_cmd_pool->
scsi_find_host_cmd_pool

and that function uses cmd_size to determine if we are using the driver
allocated hostt->cmd_pool or the scsi-ml caches. In the case of where we
are setting cmd_size because we want the mq code to setup the per driver
data we do not want any cmd_pool and have not set one up. The problem is
that scsi_find_host_cmd_pool then returns NULL and
scsi_get_host_cmd_pool does scsi_alloc_host_cmd_pool.

Later when scsi_destroy_command_freelist calls scsi_put_host_cmd_pool,
scsi_find_host_cmd_pool returns NULL again and we oops when we access
the pool in there.

We need something like the attached patch which just prevents scsi-ml
from creating a host pool when mq is used. Note that when
scsi_destroy_command_freelist is called shost->cmd_pool will be NULL so
it will return immediately so no extra check is needed in there.

--------------070309010209080503090105
Content-Type: text/plain; charset=UTF-8;
 name="dont-setup-host-list.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dont-setup-host-list.patch"

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index f28ea07..2924252 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -213,9 +213,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto fail;
 	}
 
-	error = scsi_setup_command_freelist(shost);
-	if (error)
-		goto fail;
+	if (!sht->use_blk_mq) {
+		error = scsi_setup_command_freelist(shost);
+		if (error)
+			goto fail;
+	}
 
 	if (!shost->shost_gendev.parent)
 		shost->shost_gendev.parent = dev ? dev : &platform_bus;

--------------070309010209080503090105--
