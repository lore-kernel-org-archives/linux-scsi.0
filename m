From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Thu, 22 May 2008 09:23:21 +0100
Message-ID: <1211444601.3956.8.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0805191106270.15266-100000@iolanthe.rowland.org>
	 <4831A60A.5010308@panasas.com>
	 <alpine.LFD.1.10.0805190929170.32253@woody.linux-foundation.org>
	 <4831B2E2.8030700@panasas.com>
	 <alpine.LFD.1.10.0805191026120.32253@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51071 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758916AbYEVXn3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2008 19:43:29 -0400
In-Reply-To: <alpine.LFD.1.10.0805191026120.32253@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Alan Stern <stern@rowland.harvard.edu>, Maciej Rutecki <maciej.rutecki@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2008-05-19 at 10:27 -0700, Linus Torvalds wrote:
> 
> On Mon, 19 May 2008, Boaz Harrosh wrote:
> > 
> > Sure, inspecting other places that emulate MODE_SENSE, (And inspecting the scsi
> > spec) all zeros is a very good scsi response. Alan do you want to send a fix for all
> > places that initiate a MODE_SENSE command, specifically at
> > scsi_scan.c::scsi_unlock_floptical() ? (Some other places do)
> 
> I was actualyl more thinking that the safest thing to do would be to just 
> pre-clear the sense buffer. Then, if some driver doesn't fill it 
> correctly, big deal..
> 
> It's not like pre-clearing the bugger is a performance issue.

It already is pre cleared, for precisely the reason that some devices
lie about returning sense, so we use the zero return to mean no sense
was collected.

James


