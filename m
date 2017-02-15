From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/6] scsi: always zero sshdr in scsi_normalize_sense
Date: Wed, 15 Feb 2017 08:59:23 +0100
Message-ID: <247fa6d0-ed72-e89b-ad36-8d004a2c9923@suse.de>
References: <20170214191600.17480-1-hch@lst.de>
 <20170214191600.17480-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51315 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751290AbdBOH7c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 02:59:32 -0500
In-Reply-To: <20170214191600.17480-2-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernek.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On 02/14/2017 08:15 PM, Christoph Hellwig wrote:
> This gives us a clear state even if a command didn't return sense data.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
> index b1383a71400e..a75673bb82b3 100644
> --- a/drivers/scsi/scsi_common.c
> +++ b/drivers/scsi/scsi_common.c
> @@ -137,11 +137,11 @@ EXPORT_SYMBOL(int_to_scsilun);
>  bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
>  			  struct scsi_sense_hdr *sshdr)
>  {
> +	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
> +
>  	if (!sense_buffer || !sb_len)
>  		return false;
>  
> -	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
> -
>  	sshdr->response_code = (sense_buffer[0] & 0x7f);
>  
>  	if (!scsi_sense_valid(sshdr))
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
