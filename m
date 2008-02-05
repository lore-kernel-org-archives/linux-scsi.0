From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 05 Feb 2008 22:02:16 +0300
Message-ID: <47A8B2B8.2020108@vlnb.net>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com> <47A89889.9060701@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:56417 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756123AbYBETCN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 14:02:13 -0500
In-Reply-To: <47A89889.9060701@Voltaire.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erez Zilber <erezz@Voltaire.COM>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

Erez Zilber wrote:
> Bart Van Assche wrote:
> 
>>As you probably know there is a trend in enterprise computing towards
>>networked storage. This is illustrated by the emergence during the
>>past few years of standards like SRP (SCSI RDMA Protocol), iSCSI
>>(Internet SCSI) and iSER (iSCSI Extensions for RDMA). Two different
>>pieces of software are necessary to make networked storage possible:
>>initiator software and target software. As far as I know there exist
>>three different SCSI target implementations for Linux:
>>- The iSCSI Enterprise Target Daemon (IETD,
>>http://iscsitarget.sourceforge.net/);
>>- The Linux SCSI Target Framework (STGT, http://stgt.berlios.de/);
>>- The Generic SCSI Target Middle Level for Linux project (SCST,
>>http://scst.sourceforge.net/).
>>Since I was wondering which SCSI target software would be best suited
>>for an InfiniBand network, I started evaluating the STGT and SCST SCSI
>>target implementations. Apparently the performance difference between
>>STGT and SCST is small on 100 Mbit/s and 1 Gbit/s Ethernet networks,
>>but the SCST target software outperforms the STGT software on an
>>InfiniBand network. See also the following thread for the details:
>>http://sourceforge.net/mailarchive/forum.php?thread_name=e2e108260801170127w2937b2afg9bef324efa945e43%40mail.gmail.com&forum_name=scst-devel.
>>
>>  
> 
> Sorry for the late response (but better late than never).
> 
> One may claim that STGT should have lower performance than SCST because
> its data path is from userspace. However, your results show that for
> non-IB transports, they both show the same numbers. Furthermore, with IB
> there shouldn't be any additional difference between the 2 targets
> because data transfer from userspace is as efficient as data transfer
> from kernel space.

And now consider if one target has zero-copy cached I/O. How much that 
will improve its performance?

> The only explanation that I see is that fine tuning for iSCSI & iSER is
> required. As was already mentioned in this thread, with SDR you can get
> ~900 MB/sec with iSER (on STGT).
> 
> Erez
