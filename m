From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] Sanitize INQUIRY vendor, product and revision strings
Date: Mon, 14 Aug 2006 11:07:31 -0600
Message-ID: <20060814170730.GE4340@parisc-linux.org>
References: <Pine.LNX.4.44L0.0608141221520.7399-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:65487 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932268AbWHNRHd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Aug 2006 13:07:33 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0608141221520.7399-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Klaus Muth <muth@hagos.de>

On Mon, Aug 14, 2006 at 12:34:56PM -0400, Alan Stern wrote:
> Does anyone object to the patch below?  It would help at least one person; 
> I'm concerned that it might cause trouble somewhere else.

> @@ -526,6 +519,12 @@ static int scsi_probe_lun(struct scsi_de
>  		if (response_len > 255)
>  			response_len = first_inquiry_len;	/* sanity */
>  
> +		/* Sanitize the Vendor, Product, and Revision fields. */
> +		for (i = 8; i < 36; ++i) {
> +			if (inq_result[i] < 0x20 || inq_result[i] > 0x7e)
> +				inq_result[i] = ' ';
> +		}
> +
>  		/*

If we have one non-printable character, should we not overwrite all
subsequent characters with spaces?  I'm concerned that they may
NUL-terminate a string, then the remnants be garbage.  So in other
words, I'd like to see something like:

void scsi_inquiry_sanitise(unsigned char *inquiry, int start, int end)
{
	int i, unprintable = 0;
	for (i = start; i < end; i++) {
		unprintable |= (inq_result[i] < 0x20 || inq_result[i] > 0x7e)
		if (unprintable)
			inq_result[i] = ' ';
	}
}

and then call it:

	scsi_inquiry_sanitise(inq_result, 8, 16);
	scsi_inquiry_sanitise(inq_result, 16, 32);
	scsi_inquiry_sanitise(inq_result, 32, 36);

This of course begs the questions:
 - Do we want to mangle the inquiry return like this?
 - Should we simply copy out the strings from the raw inquiry result, and
   fix them at copy time
 - What about someone who just put a tab in there and now gets
   everything overwritten with spaces

That last one could be fixed with a more complex function ...

void scsi_inquiry_sanitise(unsigned char *inquiry, int start, int end)
{
	int i, terminated = 0;
	for (i = start; i < end; i++) {
		terminated |= (inq_result[i] == 0)
		if (terminated || inq_result[i] < 0x20 || inq_result[i] > 0x7e)
			inq_result[i] = ' ';
	}
}

