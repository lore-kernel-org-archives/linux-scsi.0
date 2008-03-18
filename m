From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 6/8] Fix spi initialisation failure
Date: Tue, 18 Mar 2008 09:39:41 -0500
Message-ID: <1205851181.2900.3.camel@localhost.localdomain>
References: <20080318133228.6DFD9159159@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52635 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037AbYCSTYr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 15:24:47 -0400
In-Reply-To: <20080318133228.6DFD9159159@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-03-18 at 14:32 +0100, Hannes Reinecke wrote:
> With the target rework we cannot set the attribute of the
> sysfs files as the sysfs object is not registered yet. So
> just modify the attribute itself.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_transport_spi.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
> index bc12b5d..4f9c98c 100644
> --- a/drivers/scsi/scsi_transport_spi.c
> +++ b/drivers/scsi/scsi_transport_spi.c
> @@ -1473,13 +1473,13 @@ static int spi_target_configure(struct transport_container *tc,
>  		 * to ignore, sysfs also does a WARN_ON and dumps a trace,
>  		 * which is bad, so temporarily, skip attributes that are
>  		 * already visible (the revalidate one) */
> -		if (j && attr != &dev_attr_revalidate.attr)
> +		if (j && attr != &dev_attr_revalidate.attr) {
> +			if ((j & 1))
> +				attr->mode |= S_IWUSR;
> +
>  			rc = sysfs_add_file_to_group(kobj, attr,
>  						target_attribute_group.name);
> -		/* and make the attribute writeable if we have a set
> -		 * function */
> -		if ((j & 1))
> -			rc = sysfs_chmod_file(kobj, attr, attr->mode | S_IWUSR);
> +		}
>  	}

We can't do it like this, I'm afraid.  The attribute passed in is global
to the entire transport class.  You'd basically make every following
revalidate attribute writeable.

My initial reaction is that the target should obviously be visible when
we call configure, the same way the device is.  Could this be fixed just
by moving the configure event?

James


