From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/16] scsi_dh_alua: use local buffer for VPD inquiry
Date: Fri, 17 Jan 2014 03:04:01 -0600
Message-ID: <52D8F201.80409@cs.wisc.edu>
References: <1387541621-54967-1-git-send-email-hare@suse.de> <1387541621-54967-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47820 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbaAQJEP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 04:04:15 -0500
In-Reply-To: <1387541621-54967-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>

On 12/20/2013 06:13 AM, Hannes Reinecke wrote:
> VPD inquiry need to be done only once, so we can be using
> a local buffer here.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 45 ++++++++++++++++++------------
>  1 file changed, 27 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index adc77ef..49952f4 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -322,16 +322,27 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
>   */
>  static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
>  {
> +	unsigned char *buff;
> +	unsigned char bufflen = 36;
>  	int len, timeout = ALUA_FAILOVER_TIMEOUT;
>  	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
>  	struct scsi_sense_hdr sense_hdr;
>  	unsigned retval;
>  	unsigned char *d;
>  	unsigned long expiry;
> +	int err;
>  
>  	expiry = round_jiffies_up(jiffies + timeout);
>   retry:
> -	retval = submit_vpd_inquiry(sdev, h->buff, h->bufflen, sense);
> +	buff = kmalloc(bufflen, GFP_ATOMIC);
> +	if (!buff) {
> 

Why GFP_ATOMIC? I think it can be less restrictive in this path. If you
need GFP_ATOMIC here, then there are places in this code path you would
want to change from GFP_KERNEL to GFP_ATOMIC.

