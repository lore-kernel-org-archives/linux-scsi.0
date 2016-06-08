From: Christoph Hellwig <hch@lst.de>
Subject: Re: NVMe over Fabrics target implementation
Date: Wed, 8 Jun 2016 14:19:32 +0200
Message-ID: <20160608121932.GA31316@lst.de>
References: <1465248177-17970-1-git-send-email-hch@lst.de> <1465280632.5365.58.camel@haakon3.risingtidesystems.com> <20160607105550.GB17113@lst.de> <1465363301.5365.81.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465363301.5365.81.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, keith.busch@intel.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 07, 2016 at 10:21:41PM -0700, Nicholas A. Bellinger wrote:
> *) Extensible to multiple types of backend drivers.
> 
> nvme-target needs a way to absorb new backend drivers, that
> does not effect existing configfs group layout or attributes.
> 
> Looking at the nvmet/configfs layout as-is, there are no multiple
> backend types defined, nor a way to control backend feature bits
> exposed to nvme namespaces at runtime.

And that's very much intentional.  We have a very well working block
layer which we're going to use, no need to reivent it.  The block
layer supports NVMe pass through just fine in case we'll need it,
as I spent the last year preparing it for that.

> Why does it ever make sense for $SUBSYSTEM_NQN_0 with $PORT_DRIVER_FOO
> to block operation of $SUBSYSTEM_NQN_1 with $PORT_DRIVER_BAR..?

Because it keeps the code simple.  If you had actually participated
on our development list you might have seen that until not too long
ago we have very fine grainded locks here.  In the end Armen convinced
me that it's easier to maintain if we don't bother with fine grained
locking outside the fast path, especially as it significantly simplifies
the discovery implementation.   If if it ever turns out to be an
issue we can change it easily as the implementation is well encapsulated.
