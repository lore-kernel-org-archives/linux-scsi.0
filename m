From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Fri, 13 Aug 2010 15:48:59 +0200
Message-ID: <4C654D4B.1030507@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100813114858.GA31937@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100813114858.GA31937@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

Hello, Christoph.

On 08/13/2010 01:48 PM, Christoph Hellwig wrote:
> The patchset looks functionally correct to me, and with a small patch
> to make use of WRITE_FUA_FLUSH survives xfstests, and instrumenting the
> underlying qemu shows that we actually get the flush requests where we should.

Great.

> No performance or power fail testing done yet.
>
> But I do not like the transition very much.  The new WRITE_FUA_FLUSH
> request is exactly what filesystems expect from a current barrier
> request, so I'd rather move to that functionality without breaking stuff
> inbetween.
> 
> So if it was to me I'd keep patches 1, 2, 4 and 5 from your series, than
> a main one to relax barrier semantics, then have the renaming patches 7
> and 8, and possible keep patch 11 separate from the main implementation
> change, and if absolutely also a separate one to introduce REQ_FUA and
> REQ_FLUSH in the bio interface, but keep things working while doing
> this.

There are two reason to avoid changing the meaning of REQ_HARDBARRIER
and just deprecate it.  One is to avoid breaking filesystems'
expectations underneath it.  Please note that there are out-of-tree
filesystems too.  I think it would be too dangerous to relax
REQ_HARDBARRIER.

Another is that pseudo block layer drivers (loop, virtio_blk,
md/dm...) have assumptions about REQ_HARDBARRIER behavior and things
would be broken in obscure ways between REQ_HARDBARRIER semantics
change and updates to each of those drivers, so I don't really think
changing the semantics while the mechanism is online is a good idea.

> Then we can patches do disable the reiserfs barrier "optimization" as
> the very first one, and DM/MD support which I'm currently working on
> as the last one and we can start doing the heavy testing.

Oops, I've already converted loop, virtio_blk/lguest and am working on
md/dm right now too.  I'm almost done with md and now doing dm. :-)
Maybe we should post them right now so that we don't waste too much
time trying to solve the same problems?

Thanks.

-- 
tejun
