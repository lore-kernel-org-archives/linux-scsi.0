From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Mon, 27 Sep 2010 18:36:24 -0400
Message-ID: <yq18w2mddav.fsf@sermon.lab.mkp.net>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
	<4CA0CC38.5010804@fusionio.com> <yq1pqvzcddq.fsf@sermon.lab.mkp.net>
	<4CA118FF.1080100@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:22232 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558Ab0I0Wgn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2010 18:36:43 -0400
In-Reply-To: <4CA118FF.1080100@fusionio.com> (Jens Axboe's message of "Tue, 28
	Sep 2010 07:21:51 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:

Jens> So it's just the hint, not the actual hardware sector size. The
Jens> naming is pretty bad on that, physical and logic... 

This is the official T10/T13 terminology. Logical block size is the unit
used when talking to the device via ACS/SBC. Physical block size is the
unit used by the device internally. There's a pretty vague description
of what that means in SBC. But it was obviously conceived mainly to
handle disk drives with 512-byte logical and 4096-byte physical
(hardware) sectors.

The notion of using the physical block size as an indicator of erase
block size is something this unknown vendor came up with. And 1MB is
quite the ways out of range for what we expect in this field.

But my point is that devices with physical block sizes bigger than the
system page size are already out there.  So we need to do the right
thing here. And since this is not something affecting runtime behavior
I'm in favor of deferring the decision what to do about it to userland.


Jens> So that does look better, but in that case I don't think that sd
Jens> should dump a warning.

That's fine by me.


Jens> Does mkfs do the right thing?

Depends on which mkfs it is. Mike has tested things and can chip in
here...

-- 
Martin K. Petersen	Oracle Linux Engineering
