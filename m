From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 17/17] drivers/scsi/device_handler/scsi_dh_emc.c:
 suppress warning
Date: Tue, 23 Sep 2008 10:50:53 -0700
Message-ID: <20080923105053.7642acaf.akpm@linux-foundation.org>
References: <200809222156.m8MLur8U032313@imap1.linux-foundation.org>
	<1222181939.3301.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbYIWRwo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2008 13:52:44 -0400
In-Reply-To: <1222181939.3301.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de, schwidefsky@de.ibm.com, Chandra Seetharaman <sekharan@us.ibm.com>

On Tue, 23 Sep 2008 07:58:59 -0700 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Mon, 2008-09-22 at 14:56 -0700, akpm@linux-foundation.org wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > s390:
> > 
> > drivers/scsi/device_handler/scsi_dh_emc.c: In function 'parse_sp_info_reply':
> > drivers/scsi/device_handler/scsi_dh_emc.c:179: warning: comparison is always false due to limited range of data type
> > 
> > because chars are unsigned, I assume.
> 
> Actually, no, they're architecture implementation defined (another
> cockup of the C standard) ... which must be why we don't see this on any
> of the other architectures I compile on.

that's what I said ;)

> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/scsi/device_handler/scsi_dh_emc.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff -puN drivers/scsi/device_handler/scsi_dh_emc.c~drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning drivers/scsi/device_handler/scsi_dh_emc.c
> > --- a/drivers/scsi/device_handler/scsi_dh_emc.c~drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning
> > +++ a/drivers/scsi/device_handler/scsi_dh_emc.c
> > @@ -176,7 +176,7 @@ static int parse_sp_info_reply(struct sc
> >  		err = SCSI_DH_DEV_TEMP_BUSY;
> >  		goto out;
> >  	}
> > -	if (csdev->buffer[4] < 0 || csdev->buffer[4] > 2) {
> > +	if (csdev->buffer[4] & ~3) {
> 
> I'm afraid this isn't quite correct: ~3 will pass if csdev->buffer[4] ==
> 3 which is beyond the range of the original comparison.
> 
> How about this: it doesn't depend on the architecture to define the
> signedness and it covers the original range?
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
> index ef693e8..a4055c4 100644
> --- a/drivers/scsi/device_handler/scsi_dh_emc.c
> +++ b/drivers/scsi/device_handler/scsi_dh_emc.c
> @@ -84,7 +84,7 @@ struct clariion_dh_data {
>  	/*
>  	 * I/O buffer for both MODE_SELECT and INQUIRY commands.
>  	 */
> -	char buffer[CLARIION_BUFFER_SIZE];
> +	unsigned char buffer[CLARIION_BUFFER_SIZE];
>  	/*
>  	 * SCSI sense buffer for commands -- assumes serial issuance
>  	 * and completion sequence of all commands for same multipath.
> @@ -176,7 +176,7 @@ static int parse_sp_info_reply(struct scsi_device *sdev,
>  		err = SCSI_DH_DEV_TEMP_BUSY;
>  		goto out;
>  	}
> -	if (csdev->buffer[4] < 0 || csdev->buffer[4] > 2) {
> +	if (csdev->buffer[4] > 2) {
>  		/* Invalid buffer format */
>  		sdev_printk(KERN_NOTICE, sdev,
>  			    "%s: invalid VPD page 0xC0 format\n",
> 

looks good to me.

