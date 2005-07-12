From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: RE: [PATCH] drivers/scsi/st.c: add reference count and related fixes
Date: Tue, 12 Jul 2005 11:10:06 -0400
Message-ID: <92952AEF1F064042B6EF2522E0EEF437348370@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub4.stratus.com ([134.111.1.17]:34242 "EHLO
	mailhub4.stratus.com") by vger.kernel.org with ESMTP
	id S261475AbVGLPKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2005 11:10:14 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org

I'll try porting my changes to a recent kernel, verify that the bugs I
found are still bugs, and get back to you with a new patch.

In the meantime, responses to your comments:

- using a new kref in the scsi_tape structure: I've given this some
thought, and I think using a new kref is defintely the best way to go.
If nothing else, this is the same way sd and sr do reference counting...
seems easier to maintain if the code in st is as similar as possible to
these other drivers.

- my changes to how last_SRpnt is used: I'll add a comment documenting
when last_SRpnt is valid (it's valid only for async IOs that have been
issued, nulled out by write_behind_check when they complete)

- Here's why I think the use of last_SRpnt in st_chk_result is bogus:
one of the inputs to st_chk_result is "struct scsi_request * SRpnt", and
it seems like this is the SRpnt you want to use, rather than last_SRpnt.
This input will be the command that st_do_scsi or write_behind_check
just waited on. This might not cause any problems with the current st
code, but it will definitely cause problems with the changes I made to
last_SRpnt. Let me know if I'm wrong about this, though, and I can
change my last_SRpnt code.

Nate Dailey



> -----Original Message-----
> From: Kai Makisara [mailto:Kai.Makisara@kolumbus.fi] 
> Sent: Thursday, July 07, 2005 7:12 AM
> To: Dailey, Nate
> Cc: Brian King; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] drivers/scsi/st.c: add reference count 
> and related fixes
> 
> 
> This is an area where st can be improved. I am happy to see 
> that people 
> (probably) having resources to test the changes are working on this.
> 
> On Tue, 5 Jul 2005, Dailey, Nate wrote:
> 
> > These patches (against a 2.6.9 kernel, Redhat AS 4) for st add a
> > reference count, and fix a few bugs I hit during testing 
> (administrative
> > removes and cable pulls with IO in progress).
> > 
> > The primary change is adding a kref to the Scsi_Tape 
> structure, to avoid
> > an oops when the tape drive is removed while open. This includes
> > scsi_tape_get/put routines and scsi_tape_release, and 
> changes to st_open
> > and st_release. This is all based on the SCSI disk & CD reference
> > counting code.
> > 
> You have added a new kref for this. Have you considered using the 
> existing cdev refcounting instead of a separate kref?
> 
> (When the new character device code was introduced, I got the 
> impression 
> that the proper way for the st would be to embed the struct 
> into struct 
> scsi_tape and make the destructor. The scsi_tapes[] array 
> would not be 
> necessary any more because the struct scsi_tape would be 
> accessible through 
> containerof(inode->i_cdev, struct scsi_tape, cdev).
> (An array would be still necessary for tape number allocation.)
> I did not implement this at that time because there was no 
> real need for 
> the change and it seemed too complex to test just for fun.)
> 
> > 
> > I hit some bugs while I was testing this code. Fixes for 
> these are also
> > included in the patch:
> > 
> > - When an IO gets a "dead device" error, we need to check 
> the rq_status
> > to determine if the request actually completed (scsi_wait_req does
> > this)... else there's no notification to the caller that 
> the IO failed.
> > There are two changes for this, one in st_do_scsi and one in
> > write_behind_check.
> >   
> OK
> 
> > - When an async IO gets a "dead device" error, we're notified of the
> > completion by the block layer (end_that_request_last), so last_SRpnt
> > doesn't get set (as it would if the complete were done by
> > st_sleep_done). So I changed how last_SRpnt is used to get around
> > this... it's now set only for async IOs, just before the IO 
> is issued
> > (and nulled out when the IO comes back). 
> > 
> Fine. Could you add a comment somewhere documenting when 
> last_SRpnt is 
> valid?
> 
> > 
> > I also hit the following problem when I briefly tested on a 
> SUSE kernel
> > (it wasn't in the Redhat kernel I did most of my testing 
> with, but it is
> > in 2.6.12):
> > 
> > - In these kernels, we no longer get a "complete" from
> > end_that_request_last when a device goes away and an IO is 
> rejected. I
> > therefore added to st_do_scsi (but it's commented in this 
> patch) setting
> > SRpnt->sr_request->end_io to blk_end_sync_rq, which will do the
> > complete. Since blk_end_sync_rq nulls out rq->waiting, I changed
> > st_do_scsi to wait on a local variable, and added a check 
> for null in
> > st_sleep_done (just in case).
> > 
> Looks OK as far as I can see. This area will change if/when 
> all ULDs are 
> converted to using blk_* functions directly (a change some people are 
> pushing for 2.6.13).
> 
> > 
> > And just one more thing:
> > 
> > - I noticed that in 2.6.12, there is what appears to be a 
> bogus use of
> > last_SRpnt in st_chk_result (this doesn't exist in the 
> kernels I tested
> > with). This would cause problems if these patches are 
> ported to 2.6.12,
> > because of how I changed the use of last_SRpnt. Either my 
> code has to
> > change, or st_chk_result shouldn't use last_SRpnt.
> > 
> This use is not bogus unless I have missed something. 
> Handling of sense 
> data in st was changed to use the generic functions 
> introduced by Doug 
> Gilbert. At the same time I moved pieces of error handling 
> around so that 
> as much as possible was done in the context of the calling process.
> 
> last_SRpnt is used to access the sense data from the previous 
> command. It 
> is currently used with scsi_request_normalize_sense() that requires a 
> struct scsi_request pointer but scsi_normalize_sense() could 
> be used as 
> well if the sense data is accessible otherwise.
> 
> > 
> > Anyway... as I said, these are against a 2.6.9 kernel 
> (Redhat AS 4). If
> > you're interested, I could port these changes to 2.6.12... 
> can't promise
> > I'll be able to test with that kernel, though.
> > 
> Testing in any fairly recent kernel helps a lot.
> 
> > Nate Dailey
> > Stratus Technologies
> > 
> > 
> > Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
> > 
> 
> -- 
> Kai
> 
