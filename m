From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_transport_sas: Fix error handling in
 sas_smp_request()
Date: Thu, 24 Aug 2017 14:21:28 +0200
Message-ID: <349346ee-bc08-a608-1c8f-0dcf0991686a@suse.de>
References: <20170823182558.15370-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170823182558.15370-1-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/23/2017 08:25 PM, Bart Van Assche wrote:
> sas_function_template.smp_handler implementations either return
> 0 or a Unix error code. Convert that error code into a SCSI
> result. This patch is what I came up with after having analyzed
> the following sparse warnings:
> 
> drivers/scsi/scsi_transport_sas.c:187:21: warning: incorrect type in assignment (different base types)
> drivers/scsi/scsi_transport_sas.c:187:21:    expected restricted blk_status_t [usertype] ret
> drivers/scsi/scsi_transport_sas.c:187:21:    got int
> drivers/scsi/scsi_transport_sas.c:188:39: warning: incorrect type in assignment (different base types)
> drivers/scsi/scsi_transport_sas.c:188:39:    expected int [signed] result
> drivers/scsi/scsi_transport_sas.c:188:39:    got restricted blk_status_t [usertype] ret
> 
> Fixes: commit 17d5363b83f8 ("scsi: introduce a result field in struct scsi_request")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/scsi_transport_sas.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 5006a656e16a..a318c46db7cc 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -173,7 +173,7 @@ static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
>  			    struct sas_rphy *rphy)
>  {
>  	struct request *req;
> -	blk_status_t ret;
> +	int ret;
>  	int (*handler)(struct Scsi_Host *, struct sas_rphy *, struct request *);
>  
>  	while ((req = blk_fetch_request(q)) != NULL) {
> @@ -185,7 +185,9 @@ static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
>  				blk_rq_bytes(req->next_rq);
>  		handler = to_sas_internal(shost->transportt)->f->smp_handler;
>  		ret = handler(shost, rphy, req);
> -		scsi_req(req)->result = ret;
> +		WARN_ONCE(ret != 0 && !IS_ERR_VALUE(ret + 0UL),
> +			  "%s: ret = %d\n", __func__, ret);
> +		scsi_req(req)->result = ret ? DID_ERROR << 16 : 0;
>  
>  		blk_end_request_all(req, 0);
>  
> 
Weelll ... I'd rather audit the handler so as to ensure that the correct
value is returned.
And this 'ret + 0UL' construct is decidedly ugly ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
