From: Bryan Henderson <hbryan@us.ibm.com>
Subject: RE: Scsi midlayer question - small I/O transfers
Date: Fri, 16 Jul 2004 13:53:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF6E1B0616.98D49C93-ON85256ED3.00700D20-88256ED3.0072ACC0@us.ibm.com>
References: <47F3C2BE74738E4683574107469DFA204CC501@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:50157 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266617AbUGPU46 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jul 2004 16:56:58 -0400
In-Reply-To: <47F3C2BE74738E4683574107469DFA204CC501@XYUSEX01.xyus.xyratex.com>
List-Id: linux-scsi@vger.kernel.org
To: Frank Borich <Frank_Borich@us.xyratex.com>
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

>>>I can see from a fibre channel trace that my 1 MB I/O transfers are 
>>>getting cut up into little chunks.
>I am generating this transfer using a c program using read/write system
>calls with the open flag
>O_WRONLY to sd driver.

OK, so you're doing 1MB transfers to and from the buffer/page cache.  The 
system, in a separate undertaking, transfers data between the cache and 
the disk in sizes of its own choosing.

There are a lot of things that control what size transfers the memory 
manager or buffer cache manager uses to fill and clean the cache, but 
maybe what you're really after is a more direct transfer between your 1MB 
buffer and the disk.  For that, you could use a raw device (e.g. 
/dev/rsda).  I think you can alternatively open the block device with 
O_DIRECT, but I'm not sure.

The I/O scheduler still has some leeway in deciding what SCSI reads and 
writes to use in satisfying the various block read/write requests it gets, 
but chances are high that it will use 1MB in this case.

If you _really_ want to be in control of what goes out on the wire, 
building your own SCSI read and write requests and submitting them through 
the Sg driver is the way to do it.

In any case, it doesn't sound like the SCSI midlayer is involved in the 
small sizes seen on the fibre channel.  I think the SCSI midlayer is just 
executing the commands it's given.


You mentioned a performance problem.  Is it that the disk (or network) is 
saturated with small transfers and could process more data if they were 
bigger?

I once saw what appeared to be a problem with the system doing too-small 
I/Os, but it turned out the disk was just faster than the CPU; bigger I/Os 
wouldn't have changed anything.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems
