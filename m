From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Wed, 8 Feb 2006 23:54:15 +0000
Message-ID: <20060208235415.GL27946@ftp.linux.org.uk>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk> <43EA8128.9000205@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:27324 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1422658AbWBHXyQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 18:54:16 -0500
Content-Disposition: inline
In-Reply-To: <43EA8128.9000205@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Thu, Feb 09, 2006 at 12:39:20AM +0100, Stefan Richter wrote:
> Could the fact that Linux reboots (if sbp2 does not mangle the SCSI 
> commands) mean that the SBP-2 target is overwriting memory outside of a 
> data buffer? Or does the SCSI stack perform reckless things like jumps 
> based on pointer tables, using unchecked data? Or...?

Interesting...  What's the last command sent before reboot?  Note that
original driver would remap 6byte commands to 10byte ones, but new one
should not _get_ those commands.  At all.  What happens if you take old
driver, put
        sdev->use_10_for_rw = 1;
        sdev->use_10_for_ms = 1;
into sbp2scsi_slave_configure() and leave remapping code alone?  Then
see if remapper is ever triggered - if it does, we have a problem in
midlayer.  If not...  I'd love to see the last commands.

BTW, I've seen PL3507-based enclosure <spit> with the following lovely
bug: if it _ever_ got INQUIRY (any INQUIRY) other than immediately in
the beginning of session, it got 8 bytes stuck in FIFO.  All subsequeunt
reads got shifted by 8 bytes, no matter what.  With old driver, new driver...
Just scsiinfo -i would be enough to screw it.  With massive fs corruption,
obviously...
