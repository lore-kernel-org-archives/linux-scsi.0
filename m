From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 10:27:36 -0600
Message-ID: <1226075256.8030.47.camel@localhost.localdomain>
References: <4913028B.6010405@redhat.com>
	 <1225984628.4703.80.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
	 <20081107120534.GO21867@kernel.dk>
	 <1226072970.15281.46.camel@think.oraclecorp.com>
	 <yq1r65na5ll.fsf@sermon.lab.mkp.net>
	 <1226074002.8030.33.camel@localhost.localdomain>
	 <1226074270.15281.50.camel@think.oraclecorp.com>
	 <1226074710.8030.43.camel@localhost.localdomain>
	 <49146B63.70208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49146B63.70208@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2008-11-07 at 11:22 -0500, Ric Wheeler wrote:
> James Bottomley wrote:
> >> Just testing it would be a fairly large challenge, spread out across N
> >> filesystems.  I think we need to keep discard as simple as we possibly
> >> can.
> >>     
> > I don't disagree with that ... I'm not saying we *should* merely that we
> > *could*.
> >
> I agree that simple and robust are key, but we will need to try and do 
> reasonable coalescing of the requests.
> 
> Depending on how vendors implement those unmap commands, sending down a 
> sequence of commands might cause a performance issue if done at too fine 
> a granularity. Easiest way to handle that is to make sure that we have a 
> way of disabling the unmap/discard support (mount option?).

I'd really think not.  The best way to handle this is through the block
options.  We'd give an interface to allow the user to change the
defaults (i.e. turn off discard on a discard supporting device but not
vice versa).  Providing every possible block option as a mount option is
asking for confused users.

James


