From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] streamline block SG_IO error processing
Date: Thu, 20 Jan 2005 11:13:30 +0000
Message-ID: <20050120111330.GB32550@infradead.org>
References: <41E88F84.4000304@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:21418 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262114AbVATLNb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 06:13:31 -0500
Content-Disposition: inline
In-Reply-To: <41E88F84.4000304@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James.Bottomley@SteelEye.com

On Sat, Jan 15, 2005 at 01:35:32PM +1000, Douglas Gilbert wrote:
> I am working on the assumption that users of the
> SG_IO ioctl in the block layer (or via st or osst)
> want SCSI status and sense data returned
> via the ioctl immediately without:
>   - the error/warning silently disappearing and/or being
>     hidden by a retry (e.g. UNIT ATTENTION, lu becoming
>     ready)
>   - noise in the log (or console)
>   - any other side effects (save clearing expecting_cc_ua
>     if a UNIT ATTENTION was expected)

that's probably the right assumption.

> Changelog:
>   - cleanup scsi_end_request() documentation
>   - shorten path for block SG_IO through scsi_io_completion()
>   - for non-SG_IO sense processing in scsi_io_completion():
>      - ignore deferred errors (report + retry should suffice)
>      - consolidate into a cleaner switch statement

The patch looks extremly nice to me!

One extremly tiny nitpick though:

+	if (sense_valid && (! sense_deferred)) {

Both the space between ! and the variable and the superflous additional
bracket are against normal kernel style:

	if (sense_valid && !sense_deferred) {

But I think we can fix this while or after applying ;-)

