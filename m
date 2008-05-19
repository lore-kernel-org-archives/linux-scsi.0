From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Mon, 19 May 2008 20:03:30 +0300
Message-ID: <4831B2E2.8030700@panasas.com>
References: <Pine.LNX.4.44L0.0805191106270.15266-100000@iolanthe.rowland.org> <4831A60A.5010308@panasas.com> <alpine.LFD.1.10.0805190929170.32253@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5592 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759523AbYESREG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 13:04:06 -0400
In-Reply-To: <alpine.LFD.1.10.0805190929170.32253@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Maciej Rutecki <maciej.rutecki@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Linus Torvalds wrote:
> 
> On Mon, 19 May 2008, Boaz Harrosh wrote:
> 
>> Alan Stern wrote:
>>> Yes, it never worked properly.  But now it fails in a bad way whereas 
>>> before it failed in a benign way.
>> You do realize that, that was pure lock to have a zero'ed buffer.
> 
> Umm. Maybe it SHOULD NOT HAVE BEEN!
> 
> The thing is, if we can get partial results back, we really *should* 
> either error out, or we should have at least cleared the buffer (either 
> beforehand or when seeing the partial result). Returning a buffer with the 
> old random contents is a bug.
> 
> And if clearing the buffer not only avoids any security holes and possible 
> undefined behavior, but _also_ ends up fixing the write protect sense 
> issue, all the better!
> 
> 		Linus
> --

Sure, inspecting other places that emulate MODE_SENSE, (And inspecting the scsi
spec) all zeros is a very good scsi response. Alan do you want to send a fix for all
places that initiate a MODE_SENSE command, specifically at
scsi_scan.c::scsi_unlock_floptical() ? (Some other places do)

Boaz

