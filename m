From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [RFC]: performance improvement by coalescing requests?
Date: Mon, 20 Jun 2005 16:21:44 -0700
Message-ID: <OF86A2DD39.3B560847-ON88257026.007CE2A5-88257026.008058E6@us.ibm.com>
References: <60807403EABEB443939A5A7AA8A7458B01520EDD@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:9365 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261191AbVFTXVw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 19:21:52 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5KNLmOc013560
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2005 19:21:48 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5KNLmJp110676
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2005 19:21:48 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5KNLm8r007927
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2005 19:21:48 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B01520EDD@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

It's bad for a controller to suck in an arbitrarily large number of 
requests and queue them.  It makes it look to the initiator like the 
device is less busy than it is, which causes the initiator wrongly to 
conclude that coalescing would be a net loss.  The amount of I/O in flight 
from the initiator should be just enough to cover the reaction time 
between when the controller signals that it's (really) ready for more work 
and the initiator is able to deliver more, thus preventing the controller 
from running dry.

But I've run into this many times myself -- the controller looks like it 
can do I/O at channel speed for a while, and then it looks very slow for a 
while because of the tiny, poorly ordered chunks of work it was given. 
This causes people to propose various queue plugging algorithms where the 
initiator withholds work from a willing controller because it knows more 
about that controller's performance characteristics than the controller 
lets on.  I don't like any of these algorithms because they are so highly 
dependent on what goes on inside the controller and the work arrival 
pattern.  There's no heuristic you can choose that works for even all the 
common scenarios, let alone the scenarios that we haven't thought of yet. 
I generally override Linux block layer queue plugging (by explicitly 
unplugging every time I put something in the queue).

If you have a continual flow of work, you can solve the problem just by 
enlarging upstream queues to make sure you swamp whatever queue capacity 
the controller has.  I've done that by increasing the number of threads 
processing files, for example.  If you have a bursty 
response-time-sensitive workload (e.g. a small number of threads doing 
small synchronous reads, well below the capacity of the controller), it's 
much harder.

Of course, the cleanest thing to do is to reduce the size of the queue in 
the controller to the reaction time window I described above or have the 
controller adjust it dynamically.

But when you don't have that luxury, doing the same thing via the Linux 
driver queue depth (this patch) seems like a great substitute to me.

Why is it just for sequential?  If your pipeline (device driver -> 
controller -> device) is always full, what's to lose by backing up 
requests that can't be coalesced?


By the way, a disk controller in theory is a better place to do coalescing 
than a Linux queue -- the controller should know more about the ideal 
ordering and clustering of reads and writes.  Linux should have to 
coalesce only where small I/Os saturate the pipe to the controller.  But I 
assume we're talking about controllers that execute each received I/O 
separately.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems 
