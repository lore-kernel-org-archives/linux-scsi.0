From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/22] scsi: stop decoding if scsi_normalize_sense() fails
Date: Sun, 31 Aug 2014 15:00:36 -0700
Message-ID: <20140831220036.GB16432@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42573 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaHaWAk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 18:00:40 -0400
Content-Disposition: inline
In-Reply-To: <1409247216-76074-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On Thu, Aug 28, 2014 at 07:33:20PM +0200, Hannes Reinecke wrote:
> If scsi_normalize_sense() fails we couldn't decode the sense
> buffer, so we should not try to interpret the result.
> We should rather dump the sense buffer instead and stop decoding.

as far as I can tell the old code doesn't interpret it, it just does a
slightly more convoluted hexdump than your version.  Care to come up
with a better description for this patch?

>  static void
> +scsi_dump_sense_buffer(struct scsi_device *sdev, const char *name,
> +		       const unsigned char *sense_buffer, int sense_len)
>  {
> +	char linebuf[128];
> +	int i, linelen, remaining;
>  
> +	remaining = sense_len;
> +	for (i = 0; i < sense_len; i += 16) {
> +		linelen = min(remaining, 16);
> +		remaining -= 16;
> +
> +		hex_dump_to_buffer(sense_buffer + i, linelen, 16, 1,
> +				   linebuf, sizeof(linebuf), false);
> +		sdev_prefix_printk(KERN_INFO, sdev, name,
> +				   "Sense: %s\n", linebuf);
>  	}

This would be more readanle without the remaining variable:

	for (i = 0; i < sense_len; i += 16) {
		linelen = min(senselen - i, 16);
	
		...
	}

> @@ -1517,8 +1513,13 @@ void __scsi_print_sense(struct scsi_device *sdev, const char *name,
>  			const unsigned char *sense_buffer, int sense_len)
>  {
>  	struct scsi_sense_hdr sshdr;
> +	int res;
>  
> -	scsi_decode_sense_buffer(sense_buffer, sense_len, &sshdr);
> +	res = scsi_normalize_sense(sense_buffer, sense_len, &sshdr);
> +	if (res == 0) {
> +		scsi_dump_sense_buffer(sdev, name, sense_buffer, sense_len);
> +		return;
> +	}

no need for the res variable.  In fact due to the boolean-like return
value of scsi_normalize_sense it would be a lot more readable without
the variable.

