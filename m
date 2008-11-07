From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 7 Nov 2008 13:05:36 +0100
Message-ID: <20081107120534.GO21867@kernel.dk>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 06 2008, David Woodhouse wrote:
> On Thu, 6 Nov 2008, James Bottomley wrote:
> >The way to do this properly would be to run a chequerboard of partials,
> >but this would effectively have trim region tracking done in the block
> >layer ... is this worth it?
> >
> >By the way, the latest (from 2 days ago) version of the Thin
> >Provisioning proposal is here:
> >
> >http://www.t10.org/ftp/t10/document.08/08-149r4.pdf
> >
> >I skimmed it but don't see any update implying that trim might be
> >ineffective if we align wrongly ... where is this?
> 
> I think we should be content to declare such devices 'broken'.
> 
> They have to keep track of individual sectors _anyway_, and dropping 
> information for small discard requests is just careless.

I agree, seems pretty pointless. Lets let evolution take care of this
issue. I have to say I'm surprised that it really IS an issue to begin
with, are array firmwares really that silly?

It's not that it would be hard to support (and it would eliminate the
need to do discard merging in the block layer), but it seems like one of
those things that will be of little use in even in the near future.
Discard merging should be useful, I have no problem merging something
like that.

-- 
Jens Axboe

