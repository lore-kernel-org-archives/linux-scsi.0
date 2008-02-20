From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: (fwd) Bug#11922: I/O error on blank tapes
Date: Wed, 20 Feb 2008 22:16:08 +0200 (EET)
Message-ID: <alpine.LSU.1.00.0802202159290.5347@kai.makisara.local>
References: <57F67688A8D72449AC80164DA982083103BD31C9@VMXYVR1.ds.mda.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:49017 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYBTUQM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Feb 2008 15:16:12 -0500
In-Reply-To: <57F67688A8D72449AC80164DA982083103BD31C9@VMXYVR1.ds.mda.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John LLOYD <jal@mdacorporation.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 20 Feb 2008, John LLOYD wrote:

> 
> 
> > On Mon, 4 Feb 2008, James Bottomley wrote:
> > 
> > > 
> > > On Mon, 2008-02-04 at 22:28 +0100, Borislav Petkov wrote:
...
> > > > > This does still occur with 2.6.22; with a blank tape in my HP
> DDS-4 drive:
> > > > > 
> > > > > $ tar tzvf /dev/nst0
> > > > > tar: /dev/nst0: Cannot read: Input/output error
> > > 
> > > That's a SCSI tape, not an IDE one.  I cc'd the SCSI list
> > > 
> > This is not a bug, it is a feature. There is _nothing_ on the tape and
> if 
> > you try to read something, you get an error. The same thing applies to
> 
> > reading after the last filemark. Note that after writing a filemark at
> the 
> > beginning of the tape, the situation is different. Now there is a file
> and 
> > the normal EOF semantics apply although there still is no data.
> > 
> 
> The question then becomes -- How to detect blank tapes on a SCSI drive
> without forcing an I/O error?
> 
> My own available systems do not include recent kernels, but there are at
> least two behaviours:
> 
>  SLES9 SP3 contains st.c *verstr = "20040318" (plus or minus SUSE hacks)
> and the following approach works:
>    % mtst -f /dev/nst0 rewind
>    % mtst -f /dev/nst0 eom
>    % mtst -f /dev/nst0 status
>  and you get both BOT and EOD status with a blank tape, and some other
> combination for empty (just EOF) or data-full tapes.
> 
>  SLES10 SP1 contains st.c *verstr = "20050830" and that method does not
> work.  You just get EOD and there is no way to tell what kind of tape it
> is.
> 
The behaviour has changed because a bug has been fixed. The BOT status is 
derived from file and block number being zero. Positioning to EOD is done 
by spacing over files and this means that we don't know the number of 
blocks been spaced over. This is why the block number is invalidated 
(i.e., set to -1).

However, I think your approach can be used with small modification. Most 
(all?) current drives can tell the tape position (mt tell). If I insert a 
blank tape, with my drive I get

makisara@kai:~> mt rewi
makisara@kai:~> mt eod
makisara@kai:~> mt status
SCSI 2 tape drive:
File number=0, block number=-1, partition=0.
Tape block size 0 bytes. Density code 0x26 (DDS-4 or QIC-4GB).
Soft error count since last status=0
General status bits on (9010000):
 EOD ONLINE IM_REP_EN
makisara@kai:~> mt tell
At block 0.

i.e, if the EOD status is set at block zero after 'mt eod', we have blank 
tape. Now, if you have enabled logical block reporting (scsi2logical), the 
filemarks are also counted as blocks. If the tape has only a filemark 
(blank tape initialised with 'mt weof'), I get

makisara@kai:~> mt rewi
makisara@kai:~> mt eod
makisara@kai:~> mt status
SCSI 2 tape drive:
File number=1, block number=-1, partition=0.
Tape block size 0 bytes. Density code 0x26 (DDS-4 or QIC-4GB).
Soft error count since last status=0
General status bits on (9010000):
 EOD ONLINE IM_REP_EN
makisara@kai:~> mt tell
At block 1.

Now eod is set at file 1 (after filemark) at block 1 (there is only the 
filemark).

By combining these two results, you can tell that there is no data on the 
tape.

-- 
Kai
