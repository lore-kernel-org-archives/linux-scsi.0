From: Matthew Wilcox <matthew@wil.cx>
Subject: READ CAPACITY 16
Date: Wed, 17 Dec 2008 09:42:10 -0700
Message-ID: <20081217164210.GC19967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58264 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbYLQQm1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2008 11:42:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I'm looking at the UNMAP support again, and we now have a bit that tells
us whether the device supports UNMAP or not, it's called TPE (Thin
Provisioning Enabled) and is found in byte 14 of the result from READ
CAPACITY 16.  The problem is that we do our best to avoid calling READ
CAPACITY 16.

Presumably, there are many devices which do not support RC16.  That
isn't a problem, we can try RC16 and fall back to RC10 if the device
returns an error.  The question is what to do about devices that either
hang or take a long time to respond to an RC16 command.

This kind of problem isn't going to be limited to UNMAP.  DIF/DIX
already has to use RC16 to get the protection type.  Once 4k sector size
drives become common, we're going to want the "LOGICAL BLOCKS PER
PHYSICAL BLOCK EXPONENT" and the "LOWEST ALIGNED LOGICAL BLOCK ADDRESS"
information that RC16 returns and RC10 doesn't.  There's another 16
bytes and a couple of reserved 4-bit fields to be assigned too, and I
can imagine them getting used for new features in the future.

So what strategy should we adopt for trying harder to issue RC16?

Algorithm A (a perfect world):

Issue RC16
 -> If it fails, issue RC10
 -> If it times out, reset the device, issue RC10

Algorithm B:

Issue RC10
Issue RC16
 -> If it succeeds, use its results in preference to those from RC10
 -> If it fails, carry on with the results from RC10
 -> If it times out, reset the device, carry on with the results from RC10

Algorithm C:

As algorithm B, except:
 -> If it succeeds, use the RC10 results for LBA unless the LBA is 0xffffffff
    but use the RC16 results for TPE, PROT, etc.

Algorithm D:

Go back to T10 and say "Excuse me, kind sirs, would you mind adding an
INQUIRY bit to indicate that the device supports UNMAP?  I know you've
added a bit to RC16, but there's this nasty real world out there where
devices are apt to blow up if you send them an RC16 when they're not
expecting it."


Critiques should be expressed in the form of new algorithms.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
