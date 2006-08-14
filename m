From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Sanitize INQUIRY vendor, product and revision strings
Date: Mon, 14 Aug 2006 16:05:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0608141556520.7399-100000@iolanthe.rowland.org>
References: <44E0C589.5080602@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:6929 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932692AbWHNUFN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Aug 2006 16:05:13 -0400
In-Reply-To: <44E0C589.5080602@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Philip R. Auld" <pauld@egenera.com>, Matthew Wilcox <matthew@wil.cx>, SCSI development list <linux-scsi@vger.kernel.org>, Klaus Muth <muth@hagos.de>

On Mon, 14 Aug 2006, Stefan Richter wrote:

> >> On Mon, Aug 14, 2006 at 12:34:56PM -0400, Alan Stern wrote:
> >>> Does anyone object to the patch below?  It would help at least one person; 
> >>> I'm concerned that it might cause trouble somewhere else.
> >>> @@ -526,6 +519,12 @@ static int scsi_probe_lun(struct scsi_de
> >>>  		if (response_len > 255)
> >>>  			response_len = first_inquiry_len;	/* sanity */
> >>>  
> >>> +		/* Sanitize the Vendor, Product, and Revision fields. */
> >>> +		for (i = 8; i < 36; ++i) {
> >>> +			if (inq_result[i] < 0x20 || inq_result[i] > 0x7e)
> >>> +				inq_result[i] = ' ';
> >>> +		}
> >>> +
> >>>  		/*
> 
> This does affect all subsequent usage of the inquiry data, doesn't it? I.e.
>   - comparison against blacklist entries for device flags,
>   - readout in dmesg,
>   - contents of sysfs attributes,
>   - text in procfs?

Indeed it will.  In fact, the main purpose of the patch was to change the
comparison against blacklist entries for device flags.  The device in
question returns a NUL character in the Vendor string, making it
impossible for a dynamic blacklist entry (which is always padded to 8
characters) to match.

For the blacklist, I think really is what we want.  For everything else, I
think the change should be harmless -- expect perhaps that it replaces
NULs with spaces.  This will cause text beyond the NUL to show up where it
did not before; if it happens to contain garbage then the users will see
that garbage.  At least the garbage won't include any weird unprintable or
non-ASCII characters.

Remember, the standard says that these fields must not contain any 
non-graphic characters and must be padded with spaces.  Only non-compliant 
devices would be affected, and for the most part the effect will be 
minimal.

In fact, I can't think up a scenario where this would cause unfixable 
damage.  Of course that doesn't mean such scenarios don't exist.  :-)

Alan Stern

