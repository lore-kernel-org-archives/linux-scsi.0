From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI core: better initialization for sdev->scsi_level
Date: Tue, 9 Jan 2007 09:52:17 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0701090943180.3102-100000@iolanthe.rowland.org>
References: <45A2DE12.4050603@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42925 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932118AbXAIOwY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jan 2007 09:52:24 -0500
In-Reply-To: <45A2DE12.4050603@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 8 Jan 2007, Douglas Gilbert wrote:

> Alan Stern wrote:
> > Both scsi_device and scsi_target include a scsi_level field, and the
> > SCSI core makes a half-hearted effort to keep the values equal.
> > Ultimately this effort may be doomed, since as far as I know there is
> > no reason why all LUNs in a target must report the same "ANSI-approved
> > version" number.  But for the most part it should work okay.
> > 
> > This patch (as834) changes the SCSI core so that after the first LUN
> > has been probed and the target's scsi_level is known, further LUNs
> > default to the target's scsi_level and not to SCSI_2.
> 
> Alan,
> Umm, scsi_level is a mangled value derived from the
> "version" field in an INQUIRY standard response. As
> such it is per logical unit ***. There is nothing to stop
> a single target (especially if it is a bridge that
> maps targets at the remote end to luns) having a wide
> variety of lus with different "version" values (and
> different peripheral device types).

Yes, I know.  In fact I said as much in the patch description.

> IMO scsi_level should only be per lu which means it
> should only exist in the scsi_device structure.

That would make sense.  But the current codebase has it in the scsi_target 
structure as well.  I don't know why.  The only place it seems to be used 
is in scsi_report_lun_scan().

> If the scsi mid level was really advanced it could
> track the "version" value in the INQUIRY response to
> "well known" logical units (see spc4r08.pdf section 8)
> because these really are per target. I don't expect
> that to happen any time soon (and there wouldn't be
> much benefit).

That would be the logical thing to do when scsi_level is removed from 
scsi_target.

> So the existing code seems broken but I'm not sure
> your patch advances things.

It does, because it prevents the core from sending an INQUIRY to higher
LUs with the LUN bits in CDB[1] set if LU-0 has already reported
scsi_level==0.

Alan Stern

