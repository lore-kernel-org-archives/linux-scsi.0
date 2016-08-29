From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 13/17] smartpqi: remove timeout for cache flush operations
Date: Mon, 29 Aug 2016 11:39:41 +0200
Message-ID: <20160829093941.uuuoamnrzwjei3fs@c203.arch.suse.de>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222992420.31214.16768734205314588696.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33559 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756699AbcH2JkQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Aug 2016 05:40:16 -0400
Content-Disposition: inline
In-Reply-To: <147222992420.31214.16768734205314588696.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On Fri, Aug 26, 2016 at 11:45:24AM -0500, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microsemi.com>
> 
> Some cache flush operations can take longer than the
> timeout value. Best to not impose a time limit to
> handle all cases.
> 
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---
>  drivers/scsi/smartpqi/smartpqi_init.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 87eb603..e7d7e99 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -407,7 +407,6 @@ static int pqi_identify_physical_device(struct pqi_ctrl_info *ctrl_info,
>  }
>  
>  #define SA_CACHE_FLUSH_BUFFER_LENGTH	4
> -#define PQI_FLUSH_CACHE_TIMEOUT		(30 * 1000)
>  
>  static int pqi_flush_cache(struct pqi_ctrl_info *ctrl_info)
>  {
> @@ -434,7 +433,7 @@ static int pqi_flush_cache(struct pqi_ctrl_info *ctrl_info)
>  		goto out;
>  
>  	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
> -		0, NULL, PQI_FLUSH_CACHE_TIMEOUT);
> +		0, NULL, NO_TIMEOUT);
>  
>  	pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1,
>  		pci_direction);

IIRC I asked you to introduce this timeout, as you're calling
pqi_flush_cache() from the driver's shutdown callback and I still
doubt users like their shutdown's to hang indefinitely because cache
flush isn't working. Just my $0.02.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
