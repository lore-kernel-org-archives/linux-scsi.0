From: Jens Axboe <axboe@suse.de>
Subject: Re: I/O Request [Elevator; Clustering; Scatter-Gather]
Date: Tue, 4 Mar 2003 14:50:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030304135000.GA29990@suse.de>
References: <20030304133201.18619.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030304133201.18619.qmail@mail.com>
List-Id: linux-scsi@vger.kernel.org
To: David Anderson <david-anderson2003@mail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Mar 04 2003, David Anderson wrote:
> 
> Hi, I have been going through some documentation that talks of
> clustering, scatter-gather and elevator being used to improve
> performance. I am confused between these :
> 
> This is what I have understood : Elevator The job of the elevator is
> to sort I/O requests to disk drives in such a way that the disk head
> moving in the same direction for maximum performance. Have been able
> to locate the code for the same.
> 
> Clustering Combines multiple requests to adjecent blocks into a single
> request. Have not been able to find the code which carries this out.
> Any clue on where this is done in the linux source code ??

Both actions are performed by the elevator in Linux. You did not mention
which kernel you are looking at, for 2.4 you need to read
drivers/block/ll_rw_blk.c and drivers/block/elevator.c. For 2.5, read
the same files and drivers/block/deadline-iosched.c in addition.

> Do Clustering of request and scatter-gather mean the same ?? Confused
> to the core... Kindly help me ...

No, the elevator clustering refers to clustering request that are
contigious on disk. Scatter-gather may cluster sg entries that are
contigious in memory.

-- 
Jens Axboe

