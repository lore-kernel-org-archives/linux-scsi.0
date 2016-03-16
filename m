From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH RFC 0/2] mempool based chained scatterlist alloc/free
	api api
Date: Wed, 16 Mar 2016 09:26:31 +0100
Message-ID: <20160316082631.GB6203@lst.de>
References: <1458081569-30953-1-git-send-email-mlin@kernel.org> <1458083523.2375.120.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458083523.2375.120.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ming Lin <mlin@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 15, 2016 at 04:12:03PM -0700, James Bottomley wrote:
> motion.  If you add in one patch and remove in another the code motion
> trackers don't see it.

Agreed, having the move in a single patch would be nice.

> Thirdly, are you sure the pool structure for NVMe should be the same as
> for SCSI?  We don't do buddy pools for 1,2 or 4 entry transactions in
> SCSI just basically because of heuristics, but the packetised io
> characteristics of NVMe make single entry lists more likely for it,
> don't they?

Not really.  NVMe doesn't really do packetized I/O.  And while people
were setting all kinds of nomerge flags early on we're getting rid
of them and are seeing similar I/O patterns to fast SCSI devices
now.

NVMe over PCIe still uses the crazy PRPs by default, which aren't
very suitable for this allocator (someone will have to come up
with a good mempool for it eventually, though), but we're developing
a set of new drivers transporting NVMe command which use SGLs very
similar to most SCSI controllers, so using the same SGL allocator
is a very natural choice.
