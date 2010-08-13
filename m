From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Fri, 13 Aug 2010 16:55:33 +0400
Message-ID: <4C6540C5.8070108@vlnb.net>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1281616891-5691-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

Tejun Heo, on 08/12/2010 04:41 PM wrote:
> Each filesystem needs to be updated to enforce request
> ordering themselves and then to use REQ_FLUSH/FUA mechanism.

I generally agree with the patchset, but I believe this particular move 
is a really bad move.

I'm not mentioning the obvious that a common functionality (enforcing 
requests ordering in this case) should be handled by a common library, 
but not internally by a zillion file systems Linux has.

The worst in this move is that it would hide all the requests ordering 
semantic inside file systems in, most likely, a very much unclear way. 
That would lead that if I or someone else decide to implement the 
"hardware offload" of requests ordering (ORDERED requests), I or he/she 
would not be able to see any improvement until at least one file system 
be changed to be able to use it. Worse, if the implementor can't 
demonstrate the improvement, how can he encourage file systems 
developers to update their file systems? Which, basically, would mean 
that only a person with *BOTH* deep storage and file systems internals 
knowledge can do the job. How many do you know such people? Both storage 
and file systems topics are very wide and tricky, so nearly always 
people specialize in one of them, not both.

Thus, this move would basically mean that the proper ordered queuing 
would probably never be implemented in Linux.

I believe, much better would be to create a common interface, which file 
systems would use to enforce requests order, when they need it.

Advantages of this approach:

1. The ordering requirements of file systems would be clear.

2. They would be handled in one place by a common code.

3. Any storage level expert can try to implement ordered queuing without 
a deep dive into file systems design and implementation.

I already suggested such interface in 
http://marc.info/?l=linux-scsi&m=128077574815881&w=2. Internally for the 
moment it can be implemented using existing REQ_FLUSH/FUA/etc. and 
waiting for all the requests in the group to finish. As a nice side 
effect, if a device doesn't support FUA, it would be possible to issue 
SYNC_CACHE command(s) only for required blocks, not for the whole device 
as it is done now.

If requested, I can develop the interface further.

Vlad
