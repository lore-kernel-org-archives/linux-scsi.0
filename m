From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: (fwd) Bug#11922: I/O error on blank tapes
Date: Sun, 10 Feb 2008 23:23:31 +0200 (EET)
Message-ID: <alpine.LSU.1.00.0802102319100.6303@kai.makisara.local>
References: <20080204142206.GB5532@stro.at>  <20080204212835.GA29286@gollum.tnic> <1202162213.3096.119.camel@localhost.localdomain> <alpine.LSU.1.00.0802051846230.8573@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.1.00.0802051846230.8573@kai.makisara.local>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: petkovbb@gmail.com, maximilian attems <max@stro.at>, linux-ide@vger.kernel.org, Stephen Kitt <steve@sk2.org>, bzolnier@gmail.com, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 5 Feb 2008, Kai Makisara wrote:

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
> > > > This does still occur with 2.6.22; with a blank tape in my HP DDS-4 drive:
> > > > 
> > > > $ tar tzvf /dev/nst0
> > > > tar: /dev/nst0: Cannot read: Input/output error
> > 
> > That's a SCSI tape, not an IDE one.  I cc'd the SCSI list
> > 
> This is not a bug, it is a feature. There is _nothing_ on the tape and if 
> you try to read something, you get an error. The same thing applies to 
> reading after the last filemark. Note that after writing a filemark at the 
> beginning of the tape, the situation is different. Now there is a file and 
> the normal EOF semantics apply although there still is no data.
> 
> I admit that the error return could be more descriptive but the st driver 
> tries to be compatible with other Unices.
> 
> The behavior can be changed if Linux does not match other Unices. I don't 
> remember if I have tested just this with other Unices. I will try to test 
> this with Tru64 tomorrow. If anyone has data on other Unices, it would be 
> helpful.
> 
None of our Tru64 boxes have a user-accessible tape drive any more. 
However, I have been able to test with a Solaris box. The behavior there 
matches the Linux behavior: blank tape -> i/o error when trying to read.

-- 
Kai
