From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Wed, 22 May 2002 20:06:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205230006.g4N06PL03133@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id RAA21028
	for <linux-scsi@vger.kernel.org>; Wed, 22 May 2002 17:06:32 -0700
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Wed, 22 May 2002 15:44:06 PDT." <20020522154406.A17222@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

patmans@us.ibm.com said:
> I applied your patch and successfuly ran with AIC + 2 disks (one the
> boot disk), plus with qla (modified v6.0b20 to remove io request lock)
> drivers attached to both Triton (disk array) and Seagate drives using
> block and raw io. 

That's great, thanks for testing it.

> Do you think the queue depth on some of the adapters/devices should be
> shrunk or the request queue increased with your patch? Some adapters
> set device queue depths above 200 (for example, aic set mine to 253),
> this seems like overkill, but today it means they can have 200 more
> IO's on the request queue, where freeing the request after the IO
> completes means the request queue (with your patch) means we sometimes
> would have 200 fewer entries. 

That's a tough one.  There are differing schools of thought on queue depth.  I 
incline to the one that says that for modern scsi devices, 4-8 is probably a 
good figure, but there are definitely people who disagree.  The IDE code uses 
32 as the queue depth.  One of the things I hope to get from standardising the 
TCQ interface is the ability to adjust the queue depth from user land.

To move to a standard implementation in the generic layer, I think that 
practically the queue depths have to be lower (at least than 253). the current 
TCQ generic code uses an arbitrary length bitmap to track outstanding tags 
which means it would scale OK for high queue depths, but as you say, we are 
limited by the number of available requests.

> I don't understand how/why the journaling file systems want to use a
> barrier, and how it helps their IO.

> Are the request barriers needed to prevent earlier IO from completing
> before the barrier, or later IO from completing before the barrier, or
> both?

There were several discussion threads on the topic, but this is the only one I 
can find:

http://marc.theaimsgroup.com/?t=101360488200004&r=1&w=2

Essentially, journalled fs can function more efficiently if they can rely on 
transaction ordering (within ordering "barriers") making it all the way to the 
medium.  There was also a thought that this might speed up jfs operations, but 
no conclusive data was produced.

The elevator is allowed to re-order and merge requests within the barrier, but 
requests may not cross the barrier (REQ_BARRIER).

So, for instance, a jfs wants to write to a file, so it journals the write, 
performs the write and erases the journal.  The write cannot start until the 
journal entry is committed for the fs to maintain integrity on recovery, so 
currently you have to wait for the journal before beginning the fs write.  In 
the barrier abstraction, you simply send the journal entry and write down 
together with a barrier separating them.  The transaction integrity is 
maintained by the barrier ordering guarantee.

The idea for SCSI was that we translate the barrier to an ordered queue tag.  
There are, unfortunately, pathological error cases in SCSI where I/Os can 
cross the barrier, but I'm hoping that "works right almost all the time" is 
good enough.

James


