From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/9] qla2xxx: don't break the bsg-lib abstractions
Date: Wed, 4 Oct 2017 08:20:24 +0200
Message-ID: <d6646d1e-e2e0-340c-534c-baf83c293ae3@suse.de>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171003104845.10417-5-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 10/03/2017 12:48 PM, Christoph Hellwig wrote:
> Always use bsg_job->reply instead of scsi_req(bsg_job->req)->sense), as
> they always point to the same memory.
> 
> Never set scsi_req(bsg_job->req)->result and we'll set that value through
> bsg_job_done.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/qla2xxx/qla_bsg.c | 10 ++++------
>  drivers/scsi/qla2xxx/qla_isr.c | 12 +++---------
>  drivers/scsi/qla2xxx/qla_mr.c  |  3 +--
>  3 files changed, 8 insertions(+), 17 deletions(-)
> 
[ .. ]
> @@ -2571,7 +2569,7 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
>  	}
>  	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
> -	scsi_req(bsg_job->req)->result = bsg_reply->result = -ENXIO;
> +	 bsg_reply->result = -ENXIO;
>  	return 0;
>  
>  done:
Whitespace issue ...

Otherwise:

Reviwed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
