From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RFC 1/9] [SCSI] Detect overflow of sense data buffer
Date: Fri, 18 Jan 2013 16:46:32 +0000
Message-ID: <1358527592.2345.35.camel@dabdike.int.hansenpartnership.com>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
	 <1358526434-1173-2-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60493 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052Ab3ARQqh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jan 2013 11:46:37 -0500
In-Reply-To: <1358526434-1173-2-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2013-01-18 at 11:27 -0500, Ewan D. Milne wrote:
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -241,6 +241,9 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>  	if (! scsi_command_normalize_sense(scmd, &sshdr))
>  		return FAILED;	/* no valid sense data */
>  
> +	if (sshdr.overflow)
> +		scmd_printk(KERN_WARNING, scmd, "Sense data overflow");
> +
>  	if (scsi_sense_is_deferred(&sshdr))
>  		return NEEDS_RETRY;
>  
> @@ -2059,14 +2062,18 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
>  			sshdr->asc = sense_buffer[2];
>  		if (sb_len > 3)
>  			sshdr->ascq = sense_buffer[3];
> +		if (sb_len > 4)
> +			sshdr->overflow = ((sense_buffer[4] & 0x80) != 0);
>  		if (sb_len > 7)
>  			sshdr->additional_length = sense_buffer[7];
>  	} else {
>  		/*
>  		 * fixed format
>  		 */
> -		if (sb_len > 2)
> +		if (sb_len > 2) {
> +			sshdr->overflow = ((sense_buffer[2] & 0x10) != 0);
>  			sshdr->sense_key = (sense_buffer[2] & 0xf);
> +		}
>  		if (sb_len > 7) {
>  			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
>  					 sb_len : (sense_buffer[7] + 8);

This isn't the right way to do it:  The overflow bit is a recent
introduction in SPC-4.  The correct way to tell if we have an overflow
or not is to look at the additional sense length and compare it to the
allocation length; this will work for everything.

I'm not even convinced that overflow is important: for a lot of the
sense probes, we deliberately induce overflows by giving the request
sense command a short buffer.  Printing a warning in scsi_check_sense
will get very noisy very fast.

James


