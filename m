From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Wed, 19 Aug 2009 21:38:21 -0400
Message-ID: <4A8CA90D.6040001@interlog.com>
References: <20090816004705.GA7347@infradead.org> <20090819203916.GA25296@elte.hu> <20090820010552.GA22107@infradead.org> <20090820011004.GC14005@shareable.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59015 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZHTBiZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Aug 2009 21:38:25 -0400
In-Reply-To: <20090820011004.GC14005@shareable.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com

Jamie Lokier wrote:
> Christoph Hellwig wrote:
>>> So i'm torn about the 'syscall versus ioctl' issue, i'd 
>>> like to avoid making interface design mistakes and i'd 
>>> like to solicit some opinions about this. I've attached 
>>> the perfcounters ioctl patch below.
>> Only add a syscall if it has _one_ clear defined purpose,
>> which has kernel-wide meaning.
> 
> One clear defined purpose which comes to mind is a "trim" or "punch"
> system call, for making holes in files as well as trimming block
> devices.  Several other OSes have that capability on files.
> 
> I don't remember - does TRIM guarantee the blocks read zeros afterwards?
> 
> It would be tidy if it does, as it could have the same meaning with files.

Both ATA and SCSI leave it up to the device to decide
whether reads after a trim on a logical block are
determinate (i.e. zeroes are returned) or indeterminate.

In the case of ATA the IDENTIFY DEVICE data word 69 bit
14 gives the indication. In the case of SCSI the
READ CAPACITY(16) command response TPRZ bit gives the
indication. In both case a value of one indicates
determinate.

Doug Gilbert


