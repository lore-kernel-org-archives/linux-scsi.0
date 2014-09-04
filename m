From: worley@alum.mit.edu (Dale R. Worley)
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Thu, 4 Sep 2014 16:49:22 -0400
Message-ID: <201409042049.s84KnMoQ029293@hobgoblin.ariadne.com>
References: <Pine.LNX.4.44L0.1409031459400.2156-100000@iolanthe.rowland.org> <1409774224.6571.18.camel@jarvis.lan>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta12.westchester.pa.mail.comcast.net ([76.96.59.227]:34722
	"EHLO qmta12.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbaIDUt0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2014 16:49:26 -0400
In-reply-to: <1409774224.6571.18.camel@jarvis.lan>
	(James.Bottomley@HansenPartnership.com)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: stern@rowland.harvard.edu, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

> From: James Bottomley <James.Bottomley@HansenPartnership.com>

> Before we embark on elaborate hacks, why don't we just make the capacity
> writeable (by root) in sysfs from userspace (will require block change)?
> We can then encode all the nasty heuristics (including gpt reading) in
> userspace as a udev rule.

Looking in from the outside, this makes sense to me.  All the nasty
hueristics can be put in userspace -- perhaps as even a
special-purpose program, where we can directly warn the user as to
what he's getting himself into.  (I do not demand that this all work
automatically.)  And the hueristics can be improved easily, without
kernel changes.

The only gotcha that I see is that once the recorded device size is
changed, the kernel may now consider the partition table to be valid,
and should now parse it and set up the special device numbers for the
partitions.  So that needs to get triggered properly.

I suppose there is some complexity if the block-handling layer already
has blocks cached and the device size is reduced below the addresses
of the cached blocks.  But as long as the kernel doesn't crash or
write blocks in incorrect places, I don't see that as a problem -- if
you set the device size as less than the block numbers you've already
written to, that's your problem.

Dale
