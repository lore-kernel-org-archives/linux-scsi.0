From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 3/4] ch: remove debug noise in ch_do_scsi
Date: Mon, 19 Jan 2015 10:32:55 -0500
Message-ID: <1421681575.3891.217.camel@localhost.localdomain>
References: <1421593891-19984-1-git-send-email-hch@lst.de>
	 <1421593891-19984-3-git-send-email-hch@lst.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbbASPdB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 10:33:01 -0500
In-Reply-To: <1421593891-19984-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On Sun, 2015-01-18 at 16:11 +0100, Christoph Hellwig wrote:
> The midlayer logging already prints the cdb details if the logging
> level is high enough, no need to duplicate this in the ch driver.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/ch.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
> index 79e462f..0045742 100644
> --- a/drivers/scsi/ch.c
> +++ b/drivers/scsi/ch.c
> @@ -194,18 +194,10 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
>  
>   retry:
>  	errno = 0;
> -	if (debug) {
> -		char logbuf[SCSI_LOG_BUFSIZE];
> -
> -		__scsi_format_command(logbuf, sizeof(logbuf), cmd, cmd_len);
> -		DPRINTK("command: %s", logbuf);
> -	}
> -
>  	result = scsi_execute_req(ch->device, cmd, direction, buffer,
>  				  buflength, &sshdr, timeout * HZ,
>  				  MAX_RETRIES, NULL);
>  
> -	DPRINTK("result: 0x%x\n",result);
>  	if (driver_byte(result) & DRIVER_SENSE) {
>  		if (debug)
>  			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


