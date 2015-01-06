From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: block: remove artifical max_hw_sectors cap
Date: Tue, 06 Jan 2015 14:39:16 -0800
Message-ID: <1420583956.6927.61.camel@haakon3.risingtidesystems.com>
References: <5497F319.20802@profihost.ag> <20141223082805.GA2303@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20141223082805.GA2303@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-12-23 at 09:28 +0100, Christoph Hellwig wrote:
> On Mon, Dec 22, 2014 at 11:31:53AM +0100, Stefan Priebe - Profihost AG wrote:
> > Hi,
> > 
> > since the below patch i've some problems with iscsi.
> > 
> > The LIO based iscsi Server is full of messages like this:
> > SCSI OP 2ah with too big sectors 8344 exceeds fabric_max_sectors: 8192
> > 
> > And the client says:
> > Buffer I/O error on device sdd, logical block 38861907
> > lost page write due to I/O error on sdd
> > 
> > May be some code fixes for iscsi client is missing?
> 
> No, the problem seems that the the target is enforcing a size limit
> without communicating it through the block limits EVPD page.
> 
> Nic, can you fix LIO to expose the proper max xfer size?

The fabric_max_sectors=8192 value is already being exposed by target in
block limits EVPD as MAXIMUM TRANSFER LENGTH.

I'm guessing that since the host side support was not added until June
2014 in commit bcdb247c by MKP, Stefan is likely using an earlier
initiator that is not honoring this value.

However, this same issue has been reported elsewhere [1] with an MSFT FC
host sending I/Os of 8 MB that also doesn't appear to honor block limits
MAXIMUM TRANSFER LENGTH either.

So that said, I think it's about time to go ahead and drop the arbitrary
limitation of fabric_max_sectors, and simply enforce a sane limit (eg:
not UINT_MAX) for hw_max_sectors.

The only limitations for backends that I'm aware of is the FILEIO
FD_MAX_BYTES limit for the number of iovecs per vfs_[writev,readv] call,
and for IBLOCK what queue_max_hw_sectors() reports for raw block
make_request() based drivers that aren't able to 

I'll put together a patch soon to drop the fabric_max_sectors stuff, and
use the existing hw_max_sectors to enforce any backend specific I/O size
limitations.

--nab

[1] http://www.spinics.net/lists/target-devel/msg08024.html
