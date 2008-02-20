From: "John LLOYD" <jal@mdacorporation.com>
Subject: Re: (fwd) Bug#11922: I/O error on blank tapes
Date: Wed, 20 Feb 2008 09:07:31 -0800
Message-ID: <57F67688A8D72449AC80164DA982083103BD31C9@VMXYVR1.ds.mda.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.mda.ca ([142.73.64.14]:34659 "EHLO MSXYVR1.ds.mda.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753581AbYBTRRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Feb 2008 12:17:05 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



> On Mon, 4 Feb 2008, James Bottomley wrote:
> 
> > 
> > On Mon, 2008-02-04 at 22:28 +0100, Borislav Petkov wrote:
> > > On Mon, Feb 04, 2008 at 03:22:06PM +0100, maximilian attems wrote:
> > > 
> > > (Added Bart to CC)
> > > 
> > > > hello borislav,
> > > > 
...
> > > > This does still occur with 2.6.22; with a blank tape in my HP
DDS-4 drive:
> > > > 
> > > > $ tar tzvf /dev/nst0
> > > > tar: /dev/nst0: Cannot read: Input/output error
> > 
> > That's a SCSI tape, not an IDE one.  I cc'd the SCSI list
> > 
> This is not a bug, it is a feature. There is _nothing_ on the tape and
if 
> you try to read something, you get an error. The same thing applies to

> reading after the last filemark. Note that after writing a filemark at
the 
> beginning of the tape, the situation is different. Now there is a file
and 
> the normal EOF semantics apply although there still is no data.
> 

The question then becomes -- How to detect blank tapes on a SCSI drive
without forcing an I/O error?

My own available systems do not include recent kernels, but there are at
least two behaviours:

 SLES9 SP3 contains st.c *verstr = "20040318" (plus or minus SUSE hacks)
and the following approach works:
   % mtst -f /dev/nst0 rewind
   % mtst -f /dev/nst0 eom
   % mtst -f /dev/nst0 status
 and you get both BOT and EOD status with a blank tape, and some other
combination for empty (just EOF) or data-full tapes.

 SLES10 SP1 contains st.c *verstr = "20050830" and that method does not
work.  You just get EOD and there is no way to tell what kind of tape it
is.

Why do we care?  Because our software has to be defensive, and check the
tape before writing to it.  The tapes are fed by a robot (no trustworthy
humans involved) so checking the tape is necessary.

Now, I fully understand what list I am posting to.  The question
remains: 

How to detect blank tapes on a SCSI drive without getting an I/O error?


cheers

John

