From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.5.73 add mode sense 10 byte to aacraid driver
Date: 25 Jun 2003 12:58:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056563910.2786.36.camel@mulgrave>
References: <1056561660.747.7.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:28676 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264869AbTFYRo2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2003 13:44:28 -0400
In-Reply-To: <1056561660.747.7.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2003-06-25 at 12:21, Mark Haverkamp wrote:
> The aacraid driver didn't have a case for the 10 byte mode sense
> command.  This was causing the driver to fail.  I added a case in
> aac_scsi_cmd for the 10 byte mode sense.  I also replaced the aacraid
> definitions for scsi commands with the ones from scsi.h.  I have tested
> this on my aacraid hardware here at osdl.

This:

> +	case MODE_SENSE_10:
> +	{
> +		char *mode_buf;
> +
> +		dprintk((KERN_DEBUG "MODE SENSE 10 command.\n"));
> +		mode_buf = scsicmd->request_buffer;
> +		mode_buf[0] = 0;	/* Mode data length (MSB) */
> +		mode_buf[1] = 10;	/* Mode data length (LSB) */
> +		mode_buf[2] = 0;	/* Medium type - default */
> +		mode_buf[3] = 0;	/* Device-specific param, bit 8: 0/1 = write enabled/protected */
> +		mode_buf[4] = 0;	/* reserved */
> +		mode_buf[5] = 0;	/* reserved */
> +		mode_buf[6] = 0;	/* Block descriptor length (MSB) */
> +		mode_buf[7] = 0;	/* Block descriptor length (LSB) */
> +
> +		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | GOOD;
> +		__aac_io_done(scsicmd);
> +
> +		return 0;
> +	}

Looks incorrect.  MODE_SENSE is supposed to return page code data.  If
none is provided, the commands which use this data are going to do wrong
things (since most of them assume a successful command execution means
that the data was returned).

Also, the header length is wrong.  Traditionally, the length field in
SCSI commands counts from the first byte after the length field, so the
length field of the MODE SENSE(6) for just returning the 4 byte header
should be 3; Likewise for MODE SENSE(10) which has an eight byte header,
it should be 6.

GOOD is also one of those infernal old status codes that need to be
shifted one bit to the right (fortunately, it's actually zero so in this
one instance it doesn't matter).  You should probably use SAM_STAT_GOOD
instead (the SAM_STAT_ codes don't need shifting).

I also reluctantly noticed that the current MODE_SENSE case is, in fact,
actually returning a MODE SENSE(10) header...

Now I notice it's returning unshifted CHECK_CONDIDIONTS too..

I'll stop looking now.

James


