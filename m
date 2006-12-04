From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Mon, 04 Dec 2006 15:07:12 -0600
Message-ID: <1165266433.3242.63.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.44L0.0612041507410.2443-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:48112 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937161AbWLDVHS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2006 16:07:18 -0500
In-Reply-To: <Pine.LNX.4.44L0.0612041507410.2443-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2006-12-04 at 15:11 -0500, Alan Stern wrote:
> Can you please take a look at this entry in Bugzilla:
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=7026
> 
> The important part starts at Comment 21; in particular the last two 
> comments from Joerg Schilling and me are relevant to the SG driver.

The only comment I'd have is that your last path is too convoluted.  For
any cdrecord -dev=/dev/<block dev>

Then 

/sys/block/<block dev>/queue/max_sectors_kb 

should work just fine.

For the corner cases where /dev/<block dev> isn't the canonical name,
you can find the actual /sys/block/<name> by getting the major:minor and
scanning through /sys/block/*/dev

The only other thing I'd note is that there's no connection between this
value and the one returned by SG_GET_RESERVED_SIZE.  The former is the
max sectors per request.  The latter is the size of the internal buffer
used to build sg lists.

James


