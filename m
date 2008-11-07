From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 10:18:30 -0600
Message-ID: <1226074710.8030.43.camel@localhost.localdomain>
References: <4913028B.6010405@redhat.com>
	 <1225984628.4703.80.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
	 <20081107120534.GO21867@kernel.dk>
	 <1226072970.15281.46.camel@think.oraclecorp.com>
	 <yq1r65na5ll.fsf@sermon.lab.mkp.net>
	 <1226074002.8030.33.camel@localhost.localdomain>
	 <1226074270.15281.50.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1226074270.15281.50.camel@think.oraclecorp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2008-11-07 at 11:11 -0500, Chris Mason wrote:
> On Fri, 2008-11-07 at 10:06 -0600, James Bottomley wrote:
> > On Fri, 2008-11-07 at 11:00 -0500, Martin K. Petersen wrote:
> > > >>>>> "Chris" == Chris Mason <chris.mason@oracle.com> writes:
> > > 
> > > Chris> Hmmm, it's surprising to me that arrays who tell us please use
> > > Chris> the noop elevator suddenly want us to merge discard requests.
> > > Chris> The array really needs to be able to deal with this internally.
> > > 
> > > Let's also not forget that we're talking about merging discard
> > > requests for the purpose making internal array housekeeping efficient.
> > > That involves merging discards up to the internal array block sizes
> > > which may be on the order of 512/768/1024 KB.
> > > 
> > > If we were talking about merging discards up to a 4/8/16 KB boundary
> > > that might be something we'd have a chance to do within a reasonable
> > > amount of time (bigger than normal read/write I/O but not hours).
> > > 
> > > But keeping discard state around for long enough to attempt to
> > > aggregate 768KB (and 768KB-aligned) chunks is icky.
> > 
> > Icky but possible.  It's the same rb tree affair we use to keep vma
> > lists (with the same characteristics).  The point is that technically we
> > can do this pretty easily ... all the way down to not losing any
> > potential discards that the array would ignore.  However, procedurally
> > it would certainly be sending the wrong message to the array vendors
> > (the message being "sure the OS will sanitise any crap you care to
> > dump").
> > 
> > On the other hand, if we have to do it for flash and MMC anyway ...
> 
> It doesn't seem like a good idea to maintain a ton of code that gets
> exercised so rarely, especially wrt filesystem crashes.

Heh, am I the only person here who deletes files on a regular basis
(principally to get my disk down from 99%)?

> Just testing it would be a fairly large challenge, spread out across N
> filesystems.  I think we need to keep discard as simple as we possibly
> can.

I don't disagree with that ... I'm not saying we *should* merely that we
*could*.

James


