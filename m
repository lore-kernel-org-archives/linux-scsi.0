From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Wed, 18 Aug 2010 23:29:05 +0400
Message-ID: <4C6C3481.7000302@vlnb.net>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <4C6540C5.8070108@vlnb.net> <20100813131722.GB4140@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100813131722.GB4140@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig, on 08/13/2010 05:17 PM wrote:
> As far as playing with ordered tags it's just adding a new flag for
> it on the bio that gets passed down to the driver.  For a final version
> you'd need a queue-level feature if it's supported, but you don't
> even need that for the initial work.  Then you can implement a
> variant of blk_do_flush that does away with queueing additional requests
> once finish but queues all two or three at the same time with your
> new ordered flag set, at which point you are back to the level or
> ordered tag usage that the old code allows.  You're still left with
> all the hard problems of actually implementing error handling for it
> and using it higher up in the filesystem and generic page cache code.

But how about file systems doing internal local order-by-drain? Without 
converting them to use ordered commands it would be impossible to show 
full potential of them and to make the conversion one would need deep 
internal FS knowledge. That's my point. But if there's a trivial way to 
see all such places in the filesystems code and convert, then OK, I agree.

> I'd really love to see your results, up to the point of just trying
> that once I get a little spare time.  But my theory is that it won't
> help us - the problem with ordered tags is that they enforce global
> ordering while we currently have local ordering.  While it will reduce
> the latency for the process waiting for an fsync or similar it will
> affect other I/O going on in the background and reduce the devices
> ability to reorder that I/O.

The local ordering vs global ordering is relevant only if you have 
several applications/threads load. But how about a single 
application/thread?

Another point, for which, AFAIU, the ORDERED commands were invented, is 
that they make ordering on the _another_ side of the link _after_ all 
link/transfer latencies. This is why it's hard to see advantage of them 
on local disks.

Vlad
