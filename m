From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] IDEMA capacity adjustment
Date: Mon, 05 Jan 2009 12:46:28 -0500
Message-ID: <yq1d4f13atn.fsf@sermon.lab.mkp.net>
References: <yq1mye74hhu.fsf@sermon.lab.mkp.net>
	<1231171446.3324.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:25025 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbZAERqi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 12:46:38 -0500
In-Reply-To: <1231171446.3324.21.camel@localhost.localdomain> (James Bottomley's message of "Mon\, 05 Jan 2009 10\:04\:06 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> We already show the power of 10 size as GiB ... how does the
James> IDEMA spec actually differ from that?  

The intent was for the capacity printed to be exactly the same number as
on the drive label.


James> It's one thing to display the truth in a more positive light (as
James> in use power of 10 GiB etc.) it's quite another to display
James> incorrect sizes ... is the IDEMA spec just optimistic but not
James> unreasonable rounding, or is it actually inflating sizes wrongly?

It's slightly deflating the capacity compared to power of 10.  For new
drives that adhere to the IDEMA spec it's about 0.02%.  For older drives
with "proprietary" LBA counts the difference is bigger.

I tested the patch on a few SCSI drives before sending it out.  They
went from being printed as 73.4 GB to 73GB.

However, I just collected data from a bunch of recent drives and there
it doesn't make a difference at all thanks to your rounding in
string_get_size().

So maybe just drop this for now.  The code was initially done for a
different project.  I applied it to sd.c because I could and it made a
difference in my initial test case.

-- 
Martin K. Petersen	Oracle Linux Engineering
