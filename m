From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Sat, 7 Aug 2010 01:38:42 +0200
Message-ID: <20100806233842.GC14751@lst.de>
References: <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100802173930.GP16630@think> <4C5AB89C.5080700@vlnb.net> <20100805133225.GF29846@think> <4C5B1583.6070706@vlnb.net> <20100805195048.GA19030@lst.de> <4C5B19A0.9070200@vlnb.net> <4C5C22B8.9040109@suse.de> <4C5C56B6.9020309@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C5C56B6.9020309@vlnb.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, Chris Mason <chris.mason@oracle.com>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 06, 2010 at 10:38:46PM +0400, Vladislav Bolkhovitin wrote:
> Are there still any people thinking that tagged queuing doesn't have any 
> meaningful use?
> 
> Or 350% performance increase doesn't matter? (If the system was more 
> powerful, the difference would be even bigger.)
> 
> As you can see on external storage even with 128K commands the queue 
> should have at least 2 entries queued to go with full performance.

Vlad, no one disagrees that draining the queue is really bad for
performance.  That's in fact what started the whole thread.  The
question is wether it's worth to deal with the complexities of using
tagged queing all the way through the I/O and filesystem stack, or
wether to keep the existing perfectly working code to wait on individual
I/O requests in the filesystem.  The latter won't be able to keep the
queue filled for the case where we try to max out the I/O subsystem
with a single synchronous writer thread, so tagged queueing would be
a clear win for that.  It's not exactly the typical use case for high
end storage, though - and once you have multiple threads keeping the
queue busy the advantage of the tagging shrinks.

Of course all this is just talking and someone would need to actually
do the work of using tagged queueing in a useful (and non-buggy) way
and benchmark it.

