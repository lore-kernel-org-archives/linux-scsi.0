From: Black_David@emc.com
Subject: thin provisioned LUN support - T10 activity
Date: Thu, 6 Nov 2008 18:32:12 -0500
Message-ID: <9FA859626025B64FBC2AF149D97C944A8A645E@CORPUSMX80A.corp.emc.com>
References: <4913028B.6010405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:54205 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbYKFXlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 18:41:10 -0500
Content-class: urn:content-classes:message
In-Reply-To: <4913028B.6010405@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, dwmw2@infradead.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: martin.petersen@oracle.com, coughlan@redhat.com, matthew@wil.cx, jens.axboe@oracle.com, Black_David@emc.com

Folks,

Ric didn't realize it, but he started this discussion on a day when
T10 was working on the thin provisioning support in SCSI.  Having been
in that T10, meeting, I'll use this message to describe what's happened
in T10 and use a separate message to discuss array implementation
concerns.

So, working my way through the messages in this thread ...

James Bottomley writes:
> By the way, the latest (from 2 days ago) version of the Thin
> Provisioning proposal is here:
> 
> http://www.t10.org/ftp/t10/document.08/08-149r4.pdf

Just in case it wasn't not clear, this is a moving target.  Expect
to see an r5 posted by the end of next week, and there are two
concalls between now and the T10 January meetings to work on it,
so it *will* change again.

> I skimmed it but don't see any update implying that trim might be
> ineffective if we align wrongly ... where is this?

The wording will be that an UNMAP command (f/k/a PUNCH, f/k/a TRIM)
requests an unmap operation, and the device can decide what if
anything to unmap.  In r4, this was in these two sentences in 5.x
in the middle of p.20:

	The UNMAP command requests alteration of the medium. The UNMAP
	command (see table x.1) provides information to the device
server
	that may be used by the device server to transition specified
	ranges of blocks to the unmapped state.

There will be a T10 discussion at some point about whether the UNMAP
command tells the device that it "may" unmap vs. "should" unmap.

Responding to Martin Petersen, Ric Wheeler writes:
>> I haven't had time to completely digest the latest (Nov. 4th) UNMAP
>> proposal yet.  However, I don't recall seeing any notion of blocks
>> bigger than the logical block length.  And the command clearly takes
>> (a list of) <start LBA, number of blocks>.   
>
> There is a proposal to expose this internal device size in a standard 
> way, but it has not been finalized.

Both Martin and Ric are correct, but the initial proposal to do this
isn't available yet. This is likely to be in a VPD (mode) page in a
future version of the 08-149 proposal, but it's not clear whether
this function will be in the block device characteristics VPD page
vs. a new page for thin provisioning.

jim owens writes:

> > And the vendors need to provide the device trim chunk size in
> > a standard way (like scsi geometry) to the filesystem.
>
> It may be that the READ CAPACITY (16) provides the trim chunk
> size via the "logical blocks per physical block exponent".

No, definitely not.  As James subsequently indicated, that exponent
is part of the 4k sector size support.  There is no intention that
I'm aware of to use it for thin provisioning.

James Bottomley writes:
>> In SCSI, they plan to zero those blocks so that you will always read
a 
>> block of zeros back if you try to read an unmapped sector.
>
> Actually, they left this up to the array in the latest spec.  If the
> TPRZ bit is set in the Block Device Characteristics VPD then, yes, it
> will return zeros.  If not, the return is undefined.

James is correct, and Ric's subsequent response is incorrect, in part
because I didn't update Ric on what's going on (mea culpa).  Here's
the full story ...

There is a very strong desire to be able to map ATA functionality (or
most
of it) into SCSI.  The initial ATA specification of TRIM was seriously
flawed; for an explanation, see T10/08-347r1:
	http://www.t10.org/ftp/t10/document.08/08-347r1.pdf

There has been significant effort made to do something about this, the
result of which is that T13 will be adding a Deterministic Read After
TRIM (DRAT !) bit to the ATA specification (T13/e08137r1):

http://www.t13.org/Documents/UploadedDocuments/docs2008/e08137r1-DRAT_-_
Deterministic_Read_After_Trim.pdf

The crucial language in that proposal is the red text near the bottom
of p.4, which allows any value as long as it has deterministic read
behavior (the DRAT bit will be word 69 bit 14 of the IDENTIFY DEVICE
data).  The SCSI standard will align to the ATA standard with the DRAT
bit set - that red language was apparently the most that T13 would
accept in the way of behavior requirements.

Thanks,
--David
----------------------------------------------------
David L. Black, Distinguished Engineer
EMC Corporation, 176 South St., Hopkinton, MA  01748
+1 (508) 293-7953             FAX: +1 (508) 293-7786
black_david@emc.com        Mobile: +1 (978) 394-7754
----------------------------------------------------

 

> -----Original Message-----
> From: Ric Wheeler [mailto:rwheeler@redhat.com] 
> Sent: Thursday, November 06, 2008 9:43 AM
> To: David Woodhouse; James Bottomley; 
> linux-scsi@vger.kernel.org; linux-fsdevel@vger.kernel.org
> Cc: Black, David; Martin K. Petersen; Tom Coughlan; Matthew 
> Wilcox; Jens Axboe
> Subject: thin provisioned LUN support
> 
> 
> After talking to some vendors, one issue that came up is that 
> the arrays 
> all have a different size that is used internally to track the SCSI 
> equivalent of TRIM commands (POKE/unmap).
> 
> What they would like is for us to coalesce these commands 
> into aligned 
> multiples of these chunks. If not, the target device will most likely 
> ignore the bits at the beginning and end (and all small requests).
> 
> I have been thinking about whether or not we can (and should) do 
> anything more than our current best effort to send down large chunks 
> (note that the "chunk" size can range from reasonable sizes 
> like 8KB or 
> so up to close to 1MB!).
> 
> One suggestion is that a modified defrag sweep could be used 
> periodically to update the device (a proposal I am not keen on).
> 
> Thoughts?
> 
> Ric
> 
> 
> 
