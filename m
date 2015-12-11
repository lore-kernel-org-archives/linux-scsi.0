From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] [PATCH 0/15] copy offload patches
Date: Thu, 10 Dec 2015 23:06:04 -0600
Message-ID: <566A59BC.9060305@cs.wisc.edu>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com> <yq1r3iuylwd.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1r3iuylwd.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/10/2015 04:33 PM, Martin K. Petersen wrote:
>>>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:
> 
> Mikulas,
> 
> Mikulas> This patch series adds copy offload (the XCOPY command) to the
> Mikulas> block layer, SCSI subsystems and device mapper.
> 
> Now that the VFS stuff appears to stabilize I agree it's a good time to
> revisit all this. I just merged the required VPD patches from Hannes so
> those will be in 4.5.
> 
> I have a bunch of changes to the SCSI code that I worked on over the
> spring/summer based on a feedback from the array vendors after
> discussions we started at LSF/MM. Generally speaking, their comments
> didn't make things easier, nor prettier :( But your two bio approach is
> a requirement to accommodate those needs (token-based copy) so I'll work
> on consolidating your changes with mine.
> 
> That said, we still need Mike Christie's patches to go in first.
> 
> Mike: What's your status? I'm afraid I didn't get a chance to dig very
> deep in your series since it coincided with me scrambling to sort out
> SCSI for 4.4. Do you think there's a chance we could get your patches in
> shape for 4.5? Is there an up-to-date tree I can look at?
> 

It looks like my original mail did not make it due to an attachment.


I just had 2 review comments left:

1. Originally, I had left REQ_FLUSH a flag. Christoph suggested to break
it up into a op and flag:

http://marc.info/?l=linux-scsi&m=144689113106515&w=2

I started this and messed up  Was going to retry next week.


2. Start REQ_OP_READ off at non-zero to try and shake out code that was
not converted.

There are a several places where we assume reads are zero and writes are
1 for things like indexing in arrays (like blktrace's ddir_act or dm
starts), passing into block functions (like nvme_alloc_request's call of
blk_mq_alloc_request), and if/else's. I am not done fixing all of them
and testing.

Ok, 3 comments. One I gave myself:

3. Also, the btrfs patch is really large (1000 lines) because that code
base is so large and there were so many places we passed around rw to
through multiple functions. I wanted to try and break it up, so it would
be easier for those guys to review.


I uploaded a git tree here:

https://github.com/mikechristie/kernel.git

The patches are in the for-next-req-op.

I made this over Jens's for-next branch in his linux-block tree.
