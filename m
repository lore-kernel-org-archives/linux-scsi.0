From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] scsi: rescan VPD attributes
Date: Fri, 24 Jul 2015 16:38:34 +0200
Message-ID: <20150724143834.GA28970@lst.de>
References: <1436353788-104911-1-git-send-email-hare@suse.de> <1436353788-104911-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55791 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbbGXOig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2015 10:38:36 -0400
Content-Disposition: inline
In-Reply-To: <1436353788-104911-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Wed, Jul 08, 2015 at 01:09:44PM +0200, Hannes Reinecke wrote:
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -264,8 +264,11 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  	int device_id_size, device_id_type = 0;
>  	struct alua_port_group *tmp_pg, *pg = NULL;
>  
> -	if (!sdev->vpd_pg83)
> +	rcu_read_lock();
> +	if (!rcu_dereference(sdev->vpd_pg83)) {
> +		rcu_read_unlock();
>  		return SCSI_DH_DEV_UNSUPP;
> +	}
>  
>  	/*
>  	 * Look for the correct descriptor.
> @@ -281,8 +284,8 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  	 */
>  	memset(device_id_str, 0, 256);
>  	device_id_size = 0;
> -	d = sdev->vpd_pg83 + 4;
> -	while (d < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
> +	d = rcu_dereference(sdev->vpd_pg83) + 4;
> +	while (d < rcu_dereference(sdev->vpd_pg83) + sdev->vpd_pg83_len) {

Seem like this code would benefit from a local variable in favor of the
repeated rcu_dereference() calls.

> @@ -803,7 +803,7 @@ void scsi_attach_vpd(struct scsi_device *sdev)

I think this function could use a new name, e.g. scsi_read_vpd_pages?

> @@ -563,8 +563,9 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
>  	if (!sdev->vpd_pg83_len)
>  		return;
>  
> -	desc = sdev->vpd_pg83 + 4;
> -	while (desc < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
> +	rcu_read_lock();
> +	desc = rcu_dereference(sdev->vpd_pg83) + 4;
> +	while (desc < rcu_dereference(sdev->vpd_pg83) + sdev->vpd_pg83_len) {

A local variable or two would help here as well.
