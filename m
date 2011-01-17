From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [LSF/MM TOPIC] update on discard support & testing with vendors
Date: Mon, 17 Jan 2011 18:38:54 -0500
Message-ID: <yq18vyjdrsh.fsf@sermon.lab.mkp.net>
References: <4D345637.6000207@redhat.com>
	<AANLkTikihfUrLF3mMtMqYFsxqDgeQE=bv-=MN-ToY6R6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:59983 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1AQXlE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 18:41:04 -0500
In-Reply-To: <AANLkTikihfUrLF3mMtMqYFsxqDgeQE=bv-=MN-ToY6R6@mail.gmail.com>
	(Mike Snitzer's message of "Mon, 17 Jan 2011 18:18:30 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

I agree that it would be great to revisit these topics at the workshop.

Mike> One nagging sticking point for some storage vendors is the Linux
Mike> requirement that a LUN advertise itself as SPC-3 compliant (in
Mike> order for Linux's SCSI layer to issue a READ CAPACITY 16, etc).

Yeah, many vendors stick to reporting compliance with really old
revisions to prevent legacy operating systems from blowing up.

However, for arrays I don't think it would be unreasonably hard to
report a different rev. if the Linux personality is set for a given
LUN. I also think it's time to get with the program for many of these
vendors. SPC-3 is about 6 years old at this point. Not exactly a spring
chicken...

However, the SCSI folks are vehemently against having heuristics in the
first place (guess how many USB-ATA bridge vendors actively participate
in T10). T10's official policy is that the device can fail any command
with any (valid) arguments at any time. And that the OS stack should
always retry with less data, try a different command variant, etc. That
might be another good topic for discussion, actually. Because while we
do have some hacks in place (use_10, etc.) things will soon get more
complex.


Mike> Discard is more sexy so I'd expect a bit more discussion for that
Mike> topic. 

Yeah, I'm about to post another TP update with the changes that were
just approved.


Mike> And again, BLOCK LIMITS VPD PAGE requirements have kept some
Mike> vendors from implementing UNMAP support (sticking with WRITE SAME
Mike> w/ UNMAP bit set).

That's fine. We can't currently benefit from UNMAP anyway. And we're
about to get better metrics for WRITE SAME.

-- 
Martin K. Petersen	Oracle Linux Engineering
