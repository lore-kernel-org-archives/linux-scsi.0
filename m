From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 41552] Performance of writing and reading from multiple
 drives decreases by 40% when going from Linux Kernel 2.6.36.4 to 2.6.37
 (and beyond)
Date: Tue, 23 Aug 2011 09:00:57 -0500
Message-ID: <1314108057.13645.8.camel@mulgrave>
References: <bug-41552-11613@https.bugzilla.kernel.org/>
	 <201108222107.p7ML767K019660@demeter2.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35389 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab1HWOBB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2011 10:01:01 -0400
In-Reply-To: <201108222107.p7ML767K019660@demeter2.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Mon, 2011-08-22 at 21:07 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> We were using the default CFQ scheduler.  I will change it to deadline and see
> what happens.  Also, we are not using a file system to perform the writes,
> rather we are sending SCSI commands directly to the devices, nor are we doing
> anything special to the disks with a device mapper.  We simply write to each
> one on a different thread one sector at a time.
> 
> I will attempt to get the trace and will add it if I can.

If you're just using a SG_IO type scsi command, then virtually nothing
we've done in block/scsi should affect this; certainly not the elevators
since we don't do merging on SG_IO, we just use them for queueing.
Since you say "write to each one on a different thread", it's possible
that some scheduler change may have impacted this.

James


