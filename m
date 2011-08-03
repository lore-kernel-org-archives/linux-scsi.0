From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC PATCH] SCSI: Correct UA being ignored when notifying of
 media-changed
Date: Wed, 03 Aug 2011 17:22:08 -0500
Message-ID: <1312410128.2855.94.camel@mulgrave>
References: <1312378758-17308-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54546 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753626Ab1HCWWM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2011 18:22:12 -0400
In-Reply-To: <1312378758-17308-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Wed, 2011-08-03 at 09:39 -0400, Rob Evers wrote:
> Unit attention commands are getting ignored when a dvd is
> replaced, resulting in errors when accessing the new dvd.
> 
> This problem occurred when a system is booted in rescue
> mode via dvd and the dvd is then replaced with another dvd.
> Subsequent commands to a filesystem on the dvd, such as
> 'fsck' and 'restore' report errors.
> 
> Solution suggested by Mike Christie.
> 
> Signed-off-by: Rob Evers <revers@redhat.com>
> ---
>  drivers/scsi/scsi_error.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index a4b9cdb..725cc11 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -294,6 +294,10 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>  		 */
>  		if (scmd->device->expecting_cc_ua) {
>  			scmd->device->expecting_cc_ua = 0;
> +				if (sdev->removable) {
> +					sdev->changed = 1;
> +					return SUCCESS;
> +				}

Are you sure about this?  We only set expecting_cc_ua if the device was
reset in error handling ... and there we definitely *don't* want to
trigger a medium change.

Surely we want this at the end of the UA handling clause?

James


