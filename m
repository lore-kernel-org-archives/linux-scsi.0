From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Unaligned scatter-gather buffers and usb-storage
Date: Tue, 18 Nov 2003 14:37:20 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031118143720.A6411@beaverton.ibm.com>
References: <20031110095914.B22518@beaverton.ibm.com> <Pine.LNX.4.44L0.0311181001030.735-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:7299 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263805AbTKRWhj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 17:37:39 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0311181001030.735-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Tue, Nov 18, 2003 at 10:20:17AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@suse.de>, Douglas Gilbert <dougg@torque.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Tue, Nov 18, 2003 at 10:20:17AM -0500, Alan Stern wrote:

> Alignment to a 512-byte boundary would suffice and page alignment would be
> more than enough.  The cleanest way to fix the problem would be to have st
> and sg refuse to do direct I/O when the user's buffer isn't page aligned.  
> That's probably too draconian (but it would allow us to give the user
> process an appropriate error code right away).

The above restriction sounds reasonable to me, but I do not have
experience in this area. I thought that the raw and direct block
interfaces already had such restrictions.

Jens or Doug G can you comment on this?

You could add a scsi_host fields or bits specifying alignment
restrictions, and enforce them as needed in upper level drivers.

> So instead I'm going to change the usb-storage driver to make it reject
> any s-g transfer that doesn't meet the entry length requirements.  My
> question is this: What's the best way to inform the SCSI midlayer about
> what went wrong?  Return a DID_ABORT code?  Or would something else be
> better?
> 
> Alan Stern

Assuming a printk is OK, DID_ABORT is OK.

If there is an existing appropriate sense code, you could generate that
and pass it back. I searched the SPC3 spec and did not find any that have
"align" but there are some with "invalid" that might be OK, though you
might not be able to tell for certain if the sense was from the device or
not, it is less vague than a DID_ABORT.

-- Patrick Mansfield
