From: Andries.Brouwer@cwi.nl
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Tue, 22 Apr 2003 19:08:30 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304221708.h3MH8Ue16420.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:54177 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S263239AbTDVQ5b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 12:57:31 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, alan@lxorguk.ukuu.org.uk
Cc: Andries.Brouwer@cwi.nl, afafc@rnl.ist.utl.pt, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, torvalds@transmeta.com, usb-storage@one-eyed-alien.net

> The relevant bugzilla bugs are

> http://bugzilla.kernel.org/show_bug.cgi?id=211
> (Mounting a SM/CF reader does not work and does not return)

Hmm. Let me start looking at this one to see whether there is
any indication that filtering might work.

First of all, this user seems to give the wrong command.
He complains
	When I try to mount /dev/sdc /mnt/ nothing happens
and later
	mount /dev/sdb /mnt

But these cards have a partition table, so he should have
tried to mount sdc1 or sdb1.

(And even straight IDE often fails when one tries to access
ridiculous sectors. Maybe I should submit a patch for that.)

So, even though it would be nicer if this user got a good
error message, there is no sign yet that there is anything
seriously wrong, I think. The inquiry works, the device is
recognized and gets the right size.

In this situation I always say "blockdev --rereadpt /dev/sdX"
to force reading of the partition table. Afterwards one can
mount if all is well. If something is bad, the blockdev command
will hang.

Andries

