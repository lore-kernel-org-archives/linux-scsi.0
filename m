From: Dave Hansen <haveblue@us.ibm.com>
Subject: Re: Degraded I/O performance, since 2.5.41
Date: Thu, 10 Oct 2002 16:48:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DA611DF.3000206@us.ibm.com>
References: <Pine.LNX.4.44.0210092015170.9790-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay05.boulder.ibm.com (westrelay05.boulder.ibm.com [9.17.193.33])
	by e32.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id g9ANmrpw058232
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2002 19:48:53 -0400
Received: from nighthawk.sr71.net (dyn9-47-17-248.beaverton.ibm.com [9.47.17.248])
	by westrelay05.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g9ANnD4K118730
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2002 17:49:13 -0600
Received: from us.ibm.com (nighthawk [127.0.0.1])
	by nighthawk.sr71.net (8.11.6/8.11.6) with ESMTP id g9ANmlU00939
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2002 16:48:47 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Linus Torvalds wrote:
 > In article <3DA4D34F.3070106@us.ibm.com> you write:
 >
 >>When I run a certain large webserver benchmark, I prefer to warm the
 >>pagecache up with the file set first, to cheat a little :)  I grep
 >>through 20 different 500MB file sets in parallel to do this.  It is 
 >>a _lot_ slower in the BK snapshot than in plain 2.5.41.
 >
 > Can you pinpont where this started happening? There aren't that many
 > changes since 2.5.41 that I'd consider suspicious, and it would 
help > to try to pinpoint it a bit.

Using stupid brute force, I narrowed it down to 12 patches.  The only
one that touches generic SCSI code is the queue length one.
1.704.1.2, in my tree from dledford@redhat.com.  Backing it out fixed
my problem.  CC'ing him...

I would guess that it's just making stupid, er.... suboptimal,
decisions about the length for my hardware.  With a controller as
"smart" as the ServeRAID, I would imagine the best approach is to just
throw as many requests at it at one time as you can, then let the
controller sort it out.  Doug, I noticed that you changed a bunch of
code to the aic7xxx_old driver, is this just a lack of optimization in
the ServeRAID driver?

-- 
Dave Hansen
haveblue@us.ibm.com


