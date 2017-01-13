From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] scsi: use blk_rq_payload_bytes
Date: Fri, 13 Jan 2017 12:43:24 +0100
Message-ID: <2043a73a-c616-948a-6484-faefe13ef024@suse.de>
References: <1484306953-3194-1-git-send-email-hch@lst.de>
 <1484306953-3194-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58263 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751733AbdAMLn0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Jan 2017 06:43:26 -0500
In-Reply-To: <1484306953-3194-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: Dexuan Cui <decui@microsoft.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org

On 01/13/2017 12:29 PM, Christoph Hellwig wrote:
> Without that we'll pass a wrong payload size in cmd->sdb, which
> can lead to hangs with drivers that need the total transfer size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Chris Valean <v-chvale@microsoft.com>
> Reported-by: Dexuan Cui <decui@microsoft.com>
> Fixes: f9d03f96 ("block: improve handling of the magic discard payload")
> ---
>  drivers/scsi/scsi_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index c35b6de..ad4ff8f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1018,7 +1018,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb)
>  	count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
>  	BUG_ON(count > sdb->table.nents);
>  	sdb->table.nents = count;
> -	sdb->length = blk_rq_bytes(req);
> +	sdb->length = blk_rq_payload_bytes(req);
>  	return BLKPREP_OK;
>  }
>  
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
