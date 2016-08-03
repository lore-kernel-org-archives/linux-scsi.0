From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 11/22] fcoe: inhibit writing invalid values into the
 'enabled' attribute
Date: Wed, 3 Aug 2016 10:25:28 -0700
Message-ID: <7fe5e2ef-23b8-4055-1599-70b5bbcdbb85@sandisk.com>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <1470230002-37737-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0088.outbound.protection.outlook.com ([104.47.38.88]:47136
	"EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750996AbcHCRnG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 13:43:06 -0400
In-Reply-To: <1470230002-37737-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.com>

On 08/03/2016 06:13 AM, Hannes Reinecke wrote:
> The 'enabled' sysfs attribute only accepts the values '0' and '1',
> so we should error out any other values.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/fcoe/fcoe_sysfs.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
> index 9e6baac..9cf3d56 100644
> --- a/drivers/scsi/fcoe/fcoe_sysfs.c
> +++ b/drivers/scsi/fcoe/fcoe_sysfs.c
> @@ -335,16 +335,24 @@ static ssize_t store_ctlr_enabled(struct device *dev,
>  				  const char *buf, size_t count)
>  {
>  	struct fcoe_ctlr_device *ctlr = dev_to_ctlr(dev);
> +	bool enabled;
>  	int rc;
>
> +	if (*buf == '1')
> +		enabled = true;
> +	else if (*buf == '0')
> +		enabled = false;
> +	else
> +		return -EINVAL;
> +
>  	switch (ctlr->enabled) {
>  	case FCOE_CTLR_ENABLED:
> -		if (*buf == '1')
> +		if (enabled)
>  			return count;
>  		ctlr->enabled = FCOE_CTLR_DISABLED;
>  		break;
>  	case FCOE_CTLR_DISABLED:
> -		if (*buf == '0')
> +		if (!enabled)
>  			return count;
>  		ctlr->enabled = FCOE_CTLR_ENABLED;
>  		break;

Hello Hannes,

Please use kstrtoint() or similar such that strings like "01" are parsed 
correctly.

Thanks,

Bart.
