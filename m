From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: disable VPD page check on error
Date: Mon, 13 Jun 2016 09:50:33 -0400
Message-ID: <1465825834.4088.8.camel@localhost.localdomain>
References: <1465822133-22143-1-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423299AbcFMNug (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2016 09:50:36 -0400
In-Reply-To: <1465822133-22143-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Mon, 2016-06-13 at 14:48 +0200, Hannes Reinecke wrote:
> If we encounter an error during VPD page scanning we should be
> setting the 'skip_vpd_pages' bit to avoid further accesses.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 1deb6ad..0359864 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -796,6 +796,7 @@ retry_pg0:
>  	result = scsi_vpd_inquiry(sdev, vpd_buf, 0, vpd_len);
>  	if (result < 0) {
>  		kfree(vpd_buf);
> +		sdev->skip_vpd_pages = 1;
>  		return;
>  	}
>  	if (result > vpd_len) {
> @@ -822,6 +823,7 @@ retry_pg80:
>  		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x80, vpd_len);
>  		if (result < 0) {
>  			kfree(vpd_buf);
> +			sdev->skip_vpd_pages = 1;
>  			return;
>  		}
>  		if (result > vpd_len) {
> @@ -851,6 +853,7 @@ retry_pg83:
>  		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x83, vpd_len);
>  		if (result < 0) {
>  			kfree(vpd_buf);
> +			sdev->skip_vpd_pages = 1;
>  			return;
>  		}
>  		if (result > vpd_len) {

So, this changes scsi_attach_vpd() but not scsi_get_vpd_page() ?

This particular implementation worries me.  If we get an error
performing a VPD inquiry, we will never, ever, attempt one again?  What
happens if a path is down at the time?  The idea behind getting updated
VPD info was that it might change, so if that does happen we don't want
to stop updating after an isolated error.

I think what we want to do is check if the VPD inquiry is supported on
the *initial* inquiry, and if that fails then suppress further updates.

-Ewan




