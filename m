From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v1.0 7/16] arcmsr: revise message_isr_bh_fn to delete
 duplicate code
Date: Fri, 2 May 2014 11:49:39 +0300
Message-ID: <20140502084939.GD4963@mwanda>
References: <1398855757.6930.25.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1398855757.6930.25.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: ching <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 30, 2014 at 07:02:37PM +0800, ching wrote:
> +	}
> +	atomic_inc(&acb->rq_map_token);

This patch is a nice cleanup but it would be even better if you flipped
this condition around.

> +	if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {

	if (readl(signature) != ARCMSR_SIGNATURE_GET_CONFIG)
		return;

> +		for (target = 0; target < ARCMSR_MAX_TARGETID - 1;
> +			target++) {
> +			temp = readb(devicemap);
> +			diff = (*acb_dev_map) ^ temp;
> +			if (diff != 0) {
> +				*acb_dev_map = temp;
> +				for (lun = 0; lun < ARCMSR_MAX_TARGETLUN;
> +					lun++) {
> +					if ((diff & 0x01) == 1 &&
> +						(temp & 0x01) == 1) {
> +						scsi_add_device(acb->host,
> +							0, target, lun);
> +					} else if ((diff & 0x01) == 1
> +						&& (temp & 0x01) == 0) {
> +						psdev =
> +							scsi_device_lookup(acb->host,
> +							0, target, lun);

The whitespace is weird here.  Do:

					psdev = scsi_device_lookup(acb->host,
							0, target, lun);

> +						if (psdev != NULL) {
> +							scsi_remove_device(psdev);
> +							scsi_device_put(psdev);
>  						}
>  					}
> -					devicemap++;
> -					acb_dev_map++;
> +					temp >>= 1;
> +					diff >>= 1;
>  				}
>  			}
> +			devicemap++;
> +			acb_dev_map++;
>  		}

regards,
dan carpenter
