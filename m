From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/16] scsi: respect unchecked_isa_dma for blk-mq
Date: Tue, 24 Jan 2017 12:06:48 +0100
Message-ID: <1a06f97c-5917-2bef-a017-3f2d800c075d@suse.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
 <1485185361-29786-11-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750807AbdAXLGv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Jan 2017 06:06:51 -0500
In-Reply-To: <1485185361-29786-11-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On 01/23/2017 04:29 PM, Christoph Hellwig wrote:
> Currently blk-mq always allocates the sense buffer using normal GFP_KERNEL
> allocation.  Refactor the cmd pool code to split the cmd and sense allocation
> and share the code to allocate the sense buffers as well as the sense buffer
> slab caches between the legacy and blk-mq path.
> 
> Note that this switches to lazy allocation of the sense slab caches - the
> slab caches (not the actual allocations) won't be destroy until the scsi
> module is unloaded instead of keeping track of hosts using them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/hosts.c     |  4 ++++
>  drivers/scsi/scsi.c      | 24 ++++---------------
>  drivers/scsi/scsi_lib.c  | 62 +++++++++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/scsi_priv.h |  5 ++++
>  4 files changed, 73 insertions(+), 22 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
