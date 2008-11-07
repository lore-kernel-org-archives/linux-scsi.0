From: Chris Mason <chris.mason@oracle.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 10:49:30 -0500
Message-ID: <1226072970.15281.46.camel@think.oraclecorp.com>
References: <4913028B.6010405@redhat.com>
	 <1225984628.4703.80.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
	 <20081107120534.GO21867@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081107120534.GO21867@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2008-11-07 at 13:05 +0100, Jens Axboe wrote:

> > >I skimmed it but don't see any update implying that trim might be
> > >ineffective if we align wrongly ... where is this?
> > 
> > I think we should be content to declare such devices 'broken'.
> > 
> > They have to keep track of individual sectors _anyway_, and dropping 
> > information for small discard requests is just careless.
> 
> I agree, seems pretty pointless. Lets let evolution take care of this
> issue. I have to say I'm surprised that it really IS an issue to begin
> with, are array firmwares really that silly?
> 
> It's not that it would be hard to support (and it would eliminate the
> need to do discard merging in the block layer), but it seems like one of
> those things that will be of little use in even in the near future.
> Discard merging should be useful, I have no problem merging something
> like that.
> 

Hmmm, it's surprising to me that arrays who tell us please use the noop
elevator suddenly want us to merge discard requests.  The array really
needs to be able to deal with this internally.

Not that discard merging is bad, but I agree that we need to push this
problem off on the array vendors.

-chris


