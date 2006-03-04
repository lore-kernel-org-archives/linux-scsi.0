From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] SCSI sym53c8xx_2: bigger transfer limits
Date: Sat, 4 Mar 2006 10:16:06 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0603041002140.9990@kai.makisara.local>
References: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local>
 <20060301152929.GZ4816@suse.de> <Pine.LNX.4.63.0603012230370.5789@kai.makisara.local>
 <20060301204345.GP4816@suse.de> <Pine.LNX.4.63.0603020011500.5789@kai.makisara.local>
 <20060302072941.GT4816@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:12875 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751569AbWCDIND (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Mar 2006 03:13:03 -0500
In-Reply-To: <20060302072941.GT4816@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

On Thu, 2 Mar 2006, Jens Axboe wrote:

> On Thu, Mar 02 2006, Kai Makisara wrote:
> > On Wed, 1 Mar 2006, Jens Axboe wrote:
> > 
> > > On Wed, Mar 01 2006, Kai Makisara wrote:
...
> > > And it definitely is unrelated to how many sectors you can support. As
> > > such, these two unrelated patches should submitted seperately. The
> > > clustering bit is potentially more dangerous, as the hardware can have
> > > all sorts of 'issues' related to the size and alignment of sg segments.
> > > 
> > They are related if in the sense that both are needed in order to support 
> > large requests. However, I don't mind if someone splits those changes into 
> > two patches if both go in. Otherwise I don't recommend sym53c8xx_2 and/or 
> > sym53c8xx chips for any serious work any more.
> 
> For debug and bisect reasons alone I think it should be two patches. The
> cluster change cannot go into 2.6.16, it's way too late for that (I
> would not personally be against the max_sectors changes...).
> 
The max_sectors change alone does not change anything for this driver. 
The maximum number of scatter/gather segments is set to 96 and this limits 
the transfers to 384 kB (with 4 kB pages) which is below the 1020 kB limit 
resulting from increasing max_sectors.

For tapes, I don't think it is worth investigating if the number of 
scatter/gather segments can be increased unless we get a specific user 
request. AFAIK, block sizes above 256 kB are rare and if some application 
needs larger size, it may well need beyond 1 MB.

> > > > >                                                     I seem to recall
> > > > > Gerard years ago talking about some sym chips that did not like
> > > > > clustering, hence it was disabled.
> > > > > 
> > > > Facts?
> > > 
> > > I'm just reporting what Gerald (who definitely knows this hardware very
> > > well) told me, when I submitted a patch to him enabling clustering a
> > > long time ago. This might have been about 5 years ago, I seem to recall
> > > it happening when I used a un ultra10 workstation which had a sym scsi
> > > board.
> > > 
> > A bit vague but I guess this is all we know. Unless Matthew knows more?
> 
> So I dig out the old mail from Gerard from April 2000, it's pasted
> below.
> 
[the long message cut from this reply]

Thanks for digging up this message. I read it so that most sym53c8xx chips 
have no problems with arbitrary page alignments and counts if the segment 
length is below 16 MB. However, there are legitimate questions suggesting 
that this may not apply to all chips and versions. It is best not to 
change the limits in the released kernel until the questions have been 
addressed (which will probably never happen considering the age of the 
chips series, number of different versions, etc.; sad but we have to 
accept this). Those who really need the changes (like me) can then edit 
the driver and take the risk.

-- 
Kai
