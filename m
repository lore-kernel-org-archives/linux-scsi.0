From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Bug 15565] SCSI Generic queueing completes commands in reverse
 order
Date: Thu, 18 Mar 2010 20:02:36 +0200
Message-ID: <4BA26ABC.3000908@panasas.com>
References: <bug-15565-11613@http.bugzilla.kernel.org/> <201003181721.o2IHLAFg009271@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:24634 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753755Ab0CRSCj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2010 14:02:39 -0400
In-Reply-To: <201003181721.o2IHLAFg009271@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

Please switch to mail ?

On 03/18/2010 07:21 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=15565
> 
> 
> 
> 
> 
> --- Comment #4 from Mike Hayward <mh-linux-kernel@loup.net>  2010-03-18 17:21:05 ---
> Hi Boaz,
> 
>  > I have fixed that for bsg long ago. There is a flag
>  > that you put:
>  >     sg.flags = BSG_FLAG_Q_AT_TAIL;
>  > Which will do the by order, queue at tail. Zero was kept compatible
>  > to sg meaning "queue at head" i.e. jump the line.
>  > 
>  > It could be added to sg as well if needed
> 
> I think that would be a huge improvement for disk drives.
> 
> Isn't BSG driven with a blocking ioctl?  Maybe I'm using old docs, but
> from the HOWTO's I've read, I was under the impression it would issue
> one SCSI command at a time and block until it completed.  Queueing
> would effectively only be possible then with multiple threads, right?
> 

There is a way to do write with multiple ios at once and then
do reads to get return status. (I have untested code that does
that but never needed it so badly as to finish it. But I know
of other people that did it)

bsg does not have all these mmap/shared buffers options like
sg does, though. Hell not even AIOs.

> Since sg allows multiple (only 16 right now) ios to be queued
> nonblocking to a block device from a single threaded process,
> an SG_FLAG_Q_AT_TAIL flag would seem particularly relevant.
> 

Yes. Currently the queue of 16 does nothing because in effect the
Kernel will completely drain the Q on each "Q_AT_HEAD". So the Q
does nothing for IO with current sg.

> Nonblocking behavior is the primary reason why I am using sg... it
> seems really inefficient and complex to use dozens of threads and ipc
> just to try to submit a queue of ios to the kernel and hence a device.
> 

There are surely other ways to do AIO, no?
(The A in AIO stands for Asynchronous)

> If bsg actually allowed tasks to be queued nonblocking like sg, I'd
> switch in a heart beat since having two filesystem names for the same
> device introduces locking problems, name translation complexity, and
> confusion in general for administrators.
> 

Well bsg has it's own naming translation. You do not use /dev/sdX1. You
need to open the bsg char-device corresponding the particular scsi-device
...

> - Mike
> 

Boaz
