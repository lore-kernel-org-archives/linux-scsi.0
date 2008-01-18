From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Performance of SCST versus STGT
Date: Fri, 18 Jan 2008 15:08:50 +0300
Message-ID: <479096D2.8090003@vlnb.net>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com> <20080117184052F.fujita.tomonori@lab.ntt.co.jp> <478F246C.4040400@vlnb.net> <20080117190558K.fujita.tomonori@lab.ntt.co.jp> <20080117174542.GC29650@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:33007 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652AbYARMIv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jan 2008 07:08:51 -0500
In-Reply-To: <20080117174542.GC29650@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bart.vanassche@gmail.com, stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@hansenpartnership.com, erezz@voltaire.com

Pete Wyckoff wrote:
>>>>>I have performed a test to compare the performance of SCST and STGT.
>>>>>Apparently the SCST target implementation performed far better than
>>>>>the STGT target implementation. This makes me wonder whether this is
>>>>>due to the design of SCST or whether STGT's performance can be
>>>>>improved to the level of SCST ?
>>>>>
>>>>>Test performed: read 2 GB of data in blocks of 1 MB from a target (hot
>>>>>cache -- no disk reads were performed, all reads were from the cache).
>>>>>Test command: time dd if=/dev/sde of=/dev/null bs=1M count=2000
>>>>>
>>>>>                             STGT read             SCST read
>>>>>                          performance (MB/s)   performance (MB/s)
>>>>>Ethernet (1 Gb/s network)        77                    89
>>>>>IPoIB (8 Gb/s network)           82                   229
>>>>>SRP (8 Gb/s network)            N/A                   600
>>>>>iSER (8 Gb/s network)            80                   N/A
>>>>>
>>>>>These results show that SCST uses the InfiniBand network very well
>>>>>(effectivity of about 88% via SRP), but that the current STGT version
>>>>>is unable to transfer data faster than 82 MB/s. Does this mean that
>>>>>there is a severe bottleneck  present in the current STGT
>>>>>implementation ?
>>>>
>>>>
>>>>I don't know about the details but Pete said that he can achieve more
>>>>than 900MB/s read performance with tgt iSER target using ramdisk.
>>>>
>>>>http://www.mail-archive.com/stgt-devel@lists.berlios.de/msg00004.html
>>>
>>>Please don't confuse multithreaded latency insensitive workload with 
>>>single threaded, hence latency sensitive one.
>>
>>Seems that he can get good performance with single threaded workload:
>>
>>http://www.osc.edu/~pw/papers/wyckoff-iser-snapi07-talk.pdf
>>
>>But I don't know about the details so let's wait for Pete to comment
>>on this.
> 
> Page 16 is pretty straight forward.  One command outstanding from
> the client.  It is an OSD read command.  Data on tmpfs. 

Hmm, I wouldn't say it's pretty straight forward. It has data for 
"InfiniBand" and it's unclear if it's using iSER or some IB performance 
test tool. I would rather interpret those data as for IB, not iSER.

> 500 MB/s is
> pretty easy to get on IB.
> 
> The other graph on page 23 is for block commands.  600 MB/s ish.
> Still single command; so essentially a "latency" test.  Dominated by
> the memcpy time from tmpfs to pinned IB buffer, as per page 24.
> 
> Erez said:
> 
> 
>>We didn't run any real performance test with tgt, so I don't have
>>numbers yet. I know that Pete got ~900 MB/sec by hacking sgp_dd, so all
>>data was read/written to the same block (so it was all done in the
>>cache). Pete - am I right?
> 
> Yes (actually just 1 thread in sg_dd).  This is obviously cheating.
> Take the pread time to zero in SCSI Read analysis on page 24 to show
> max theoretical.  It's IB theoretical minus some initiator and stgt
> overheads.

Yes, that's obviously cheating and its result can't be compared with 
what Bart had. Full data footprint on target fit in the CPU cache, so 
you had rather results for NULLIO (SCST term).

So, seems I understood your slides correctly: the more valuable data for 
our SCST SRP vs STGT iSER comparison should be on page 26 for 1 command 
read (~480MB/s, i.e. ~60% from Bart's result on the equivalent hardware).

> The other way to get more read throughput is to throw multiple
> simultaneous commands at the server.
> 
> There's nothing particularly stunning here.  Suspect Bart has
> configuration issues if not even IPoIB will do > 100 MB/s.
> 
> 		-- Pete
> 
> 

