From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/1] scsi: fc: check for rport presence in
 fc_block_scsi_eh
Date: Tue, 26 Sep 2017 09:26:47 +0200
Message-ID: <e950c584-a32e-28a9-2f3c-301e801c23c3@suse.de>
References: <20170926065809.7980-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170926065809.7980-1-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 09/26/2017 08:58 AM, Johannes Thumshirn wrote:
> Coverity-scan recently found a possible NULL pointer dereference in
> fc_block_scsi_eh() as starget_to_rport() either returns the rport for
> the startget or NULL.
> 
> While it is rather unlikely to have fc_block_scsi_eh() called without
> an rport associated it's a good idea to catch potential misuses of the
> API gracefully.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
> ---
> 
> Changes since v1:
> - s/WARN_ON/WARN_ON_ONCE/ (Bart)
> 
> ---
>  drivers/scsi/scsi_transport_fc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index ba9d70f8a6a1..38abff7b5dbc 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3328,6 +3328,9 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
>  {
>  	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
>  
> +	if (WARN_ON_ONCE(!rport))
> +		return 0;
> +
>  	return fc_block_rport(rport);
>  }
>  EXPORT_SYMBOL(fc_block_scsi_eh);
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
