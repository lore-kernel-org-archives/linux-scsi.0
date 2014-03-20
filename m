From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 6/6] Invalidate VPD page data
Date: Thu, 20 Mar 2014 13:37:56 +0000
Message-ID: <1395322675.2244.7.camel@dabdike.int.hansenpartnership.com>
References: <1394873512-102073-1-git-send-email-hare@suse.de>
	 <1394873512-102073-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:33453 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109AbaCTNh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2014 09:37:57 -0400
In-Reply-To: <1394873512-102073-7-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <56B204BBD04D2C498B52A30836D8BE6B@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sat, 2014-03-15 at 09:51 +0100, Hannes Reinecke wrote:
> Add a flag 'vpd_invalid' to the SCSI device to indicate that
> the VPD data needs to be refreshed. This is required if either
> a manual rescan is triggered or if the sense code INQUIRY DATA
> HAS CHANGED has been received.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi.c        | 91 ++++++++++++++++++++++++++++++++++------------
>  drivers/scsi/scsi_error.c  |  1 +
>  drivers/scsi/scsi_scan.c   |  7 +++-
>  drivers/scsi/scsi_sysfs.c  |  6 ++-
>  drivers/scsi/ses.c         |  2 +-
>  include/scsi/scsi_device.h |  2 +
>  6 files changed, 82 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 2669cb8..971b099 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -1056,10 +1056,11 @@ void scsi_attach_vpd(struct scsi_device *sdev)
>  	int vpd_len = 255;
>  	int pg80_supported = 0;
>  	int pg83_supported = 0;
> -	unsigned char *vpd_buf;
> +	unsigned char *vpd_buf, *tmp_pg;
>  
>  	if (sdev->skip_vpd_pages)
>  		return;
> +
>  retry_pg0:
>  	vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
>  	if (!vpd_buf)
> @@ -1087,45 +1088,89 @@ retry_pg0:
>  	}
>  	kfree(vpd_buf);
>  
> -	if (pg80_supported) {
>  retry_pg80:
> +	if (pg80_supported) {
>  		vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
>  		if (!vpd_buf)
> -			return;
> -
> -		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x80, vpd_len);
> +			result = -ENOMEM;
> +		else
> +			result = scsi_vpd_inquiry(sdev, vpd_buf,
> +						  0x80, vpd_len);
>  		if (result < 0) {
>  			kfree(vpd_buf);
> +			spin_lock(&sdev->reconfig_lock);
> +			tmp_pg = sdev->vpd_pg80;
> +			sdev->vpd_pg80 = NULL;
> +			sdev->vpd_pg80_len = result;
> +			kfree(tmp_pg);
> +			spin_unlock(&sdev->reconfig_lock);
> +			/*
> +			 * An unexpected error occurred,
> +			 * do not clear vpd_invalid flag
> +			 */
>  			return;
> +		} else {
> +			if (result > vpd_len) {
> +				vpd_len = result;
> +				kfree(vpd_buf);
> +				goto retry_pg80;
> +			}
> +			spin_lock(&sdev->reconfig_lock);
> +			sdev->vpd_pg80 = vpd_buf;
> +			sdev->vpd_pg80_len = result;
> +			spin_unlock(&sdev->reconfig_lock);
>  		}
> -		if (result > vpd_len) {
> -			vpd_len = result;
> -			kfree(vpd_buf);
> -			goto retry_pg80;
> -		}
> -		sdev->vpd_pg80_len = result;
> -		sdev->vpd_pg80 = vpd_buf;
> +	} else {
> +		spin_lock(&sdev->reconfig_lock);
> +		tmp_pg = sdev->vpd_pg80;
> +		sdev->vpd_pg80 = NULL;
> +		sdev->vpd_pg80_len = -ENOENT;
> +		kfree(tmp_pg);
> +		spin_unlock(&sdev->reconfig_lock);

Actually, this reconfig lock thing doesn't work.  If you look in ses,
we're looping over the vpd_lengths and taking offsets into the data
while the data is changing, regardless of the lock.

Firstly, you can just do a kfree on sdev->vpd_pgxx; no need for the
tmp_pg.  Secondly, we would now need a helper to return the vpd_pgxx
which sees the lock and probably copies the data to make sure we can't
get a change while using the data.

I've dropped this patch for now.

James

