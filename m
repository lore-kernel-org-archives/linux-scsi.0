From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] virtio_blk: implement REQ_FLUSH/FUA support
Date: Tue, 17 Aug 2010 15:23:27 +0200
Message-ID: <20100817132327.GA3347@lst.de>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-3-git-send-email-tj@kernel.org> <20100816183317.GA28171@lst.de> <4C6A458B.5040407@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C6A458B.5040407@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 17, 2010 at 10:17:15AM +0200, Tejun Heo wrote:
> >> Remove now unused REQ_HARDBARRIER support and implement REQ_FLUSH/FUA
> >> support instead.  A new feature flag VIRTIO_BLK_F_FUA is added to
> >> indicate the support for FUA.
> > 
> > I'm not sure it's worth it.  The pure REQ_FLUSH path works not and is
> > well tested with kvm/qemu.   We can still easily add a FUA bit, and
> > even a pre-flush bit if the protocol roundtrips matter in real life
> > benchmarking.
> 
> Hmmm... the underlying storage could be md/dm RAIDs in which case FUA
> should be cheaper than FLUSH.

If someone ever wrote a virtio-blk backend that sits directly ontop
of the Linux block layer that would be true.  Of the five known
virtio-blk backends all operate on normal files using the Posix I/O
APIs, or the Linux aio API (optionally in qemu) or in-kernel
vfs_read/vfs_write (vhost-blk).

Given how little testing lguest gets compared to qemu I really don't
want a protocol addition for it unless it really buys us something.
Once we're done with this barrier conversion I plan into benchmarking
FUA and a pre-flush tag on the command for virtio in real life setups,
and see if it actually buys us anything.

