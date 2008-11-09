From: Dave Chinner <david@fromorbit.com>
Subject: Re: thin provisioned LUN support
Date: Mon, 10 Nov 2008 10:36:39 +1100
Message-ID: <20081109233639.GT4985@disturbed>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <yq1r65na5ll.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1r65na5ll.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 07, 2008 at 11:00:38AM -0500, Martin K. Petersen wrote:
> >>>>> "Chris" == Chris Mason <chris.mason@oracle.com> writes:
> 
> Chris> Hmmm, it's surprising to me that arrays who tell us please use
> Chris> the noop elevator suddenly want us to merge discard requests.
> Chris> The array really needs to be able to deal with this internally.
> 
> Let's also not forget that we're talking about merging discard
> requests for the purpose making internal array housekeeping efficient.
> That involves merging discards up to the internal array block sizes
> which may be on the order of 512/768/1024 KB.
> 
> If we were talking about merging discards up to a 4/8/16 KB boundary
> that might be something we'd have a chance to do within a reasonable
> amount of time (bigger than normal read/write I/O but not hours).
> 
> But keeping discard state around for long enough to attempt to
> aggregate 768KB (and 768KB-aligned) chunks is icky.

Agreed.

It also ignores the fact that as the filesystem ages they will have
fewer and fewer aligned free chunks as the free space fragments.
Over time, arrays using large allocation chunks are simply going to
be full of wasted space as filesystem allocation patterns degrade
if the array vendors ignore this problem.

And no matter what us filesystem developers do, there is always
going to be degradation in allocation patterns as the filesystems
fill up and age. While we can try to improve aging behaviour, it
doesn't solve the problem for array vendors - they need to be
smarter about their allocation and block mapping....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
