From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
 kmem_cache_create+0x1a9/0x330()
Date: Sun, 27 Jul 2014 12:09:41 +0400
Message-ID: <20140727080941.GA23811@esperanza>
References: <53C8DF7F.5060707@gmail.com>
 <53C8FD95.5020302@gmail.com>
 <20140718132104.GK27940@esperanza>
 <20140718141747.GA23272@lst.de>
 <53C97D34.5040707@gmail.com>
 <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
 <20140719164454.GA24530@lst.de>
 <53CCDFC3.5010802@gmail.com>
 <20140726162102.GA7126@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:51660 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaG0IKB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Jul 2014 04:10:01 -0400
Content-Disposition: inline
In-Reply-To: <20140726162102.GA7126@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: poma <pomidorabelisima@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>, Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org

On Sat, Jul 26, 2014 at 06:21:02PM +0200, Christoph Hellwig wrote:
> Here's a formal one.
> 
> James, can I get your signoff for it?
> 
> Vladimir, can I get a reviewed-by from you (or anyone else)?
> 
> ---
> From 73b1034ab1418e2dea75ccf642bc85c728b57313 Mon Sep 17 00:00:00 2001
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Sat, 26 Jul 2014 12:21:26 -0400
> Subject: scsi: use short driver name for per-driver cmd slab caches
> 
> hostt->name might contain space, so use the ->proc_name short name instead
> when creating per-driver command slabs.
> 
> Reported-by: Vladimir Davydov <vdavydov@parallels.com>
> Tested-by: Vladimir Davydov <vdavydov@parallels.com>

Actually, it was "poma <pomidorabelisima@gmail.com>", not me, who
reported the issue and tested the patch. Please fix the tags.

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>

> ---
>  drivers/scsi/scsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 33318f5..df33060 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -365,8 +365,8 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
>  	if (!pool)
>  		return NULL;
>  
> -	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->name);
> -	pool->sense_name = kasprintf(GFP_KERNEL, "%s_sense", hostt->name);
> +	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->proc_name);
> +	pool->sense_name = kasprintf(GFP_KERNEL, "%s_sense", hostt->proc_name);
>  	if (!pool->cmd_name || !pool->sense_name) {
>  		scsi_free_host_cmd_pool(pool);
>  		return NULL;
> -- 
> 1.9.1
> 
