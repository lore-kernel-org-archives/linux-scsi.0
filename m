From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Thu, 07 Aug 2014 15:58:40 +0000
Message-ID: <bug-80711-11613-2uDBjQpiY2@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34590 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217AbaHGP6o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2014 11:58:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 276B22017A
	for <linux-scsi@vger.kernel.org>; Thu,  7 Aug 2014 15:58:43 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8F994201DD
	for <linux-scsi@vger.kernel.org>; Thu,  7 Aug 2014 15:58:41 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

--- Comment #8 from Alan Stern <stern@rowland.harvard.edu> ---
On Wed, 6 Aug 2014, Christoph Hellwig wrote:

> On Wed, Aug 06, 2014 at 04:02:22PM -0400, Alan Stern wrote:
> > > I doubt either of them forces users to hack up flags for these cases.
> > 
> > Why was this change needed in the first place?  There's no explanation 
> > in the patch itself.
> 
> Which chance?  The one to not support SG_FLAG_LUN_INHIBIT?

No, the patch that started this Bugzilla entry.  Tiziano says it is 
needed in order to send vendor-specific commands that use the LUN bits 
in CDB[1].

> > > At least for windows I suspect it just never sends the LUN encoded
> > > in the CDB and treats USB devices special instead of our insistance
> > > on pretending they are SCSI-2.
> > 
> > We no longer pretend that USB mass-storage devices have any particular 
> > SCSI level.  See commit 09b6b51b0b6c.
> 
> So the origina reported device must report SCSI-2 all by itself if he's
> running a recent kernel, ok.
> 
> > > Maybe some of the USB people have on the wire traces or access to
> > > device or windows documentation on this?
> > 
> > Most likely it varies with the version of Windows and the INQUIRY data
> > returned by the device.
> > 
> > I can obtain hardware traces for the kinds of devices and computers 
> > lying around here.  But what sort of combinations should I test?
> 
> I'd mostly be interested to see if it actualy encodes the LUN in the CDB
> for any USB multi-LUN device.

I tried connecting a Linux mass-storage gadget with two logical units
to a host PC running Windows 7.  The host scanned the first logical
unit and completely ignored the second!  Didn't even send an INQUIRY 
command.

So the question remains unanswered...

Can someone tell me if anything special is needed to make Windows
recognize logical units beyond the first?

Alan Stern

-- 
You are receiving this mail because:
You are the assignee for the bug.
