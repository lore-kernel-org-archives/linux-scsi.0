From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Performance of SCST versus STGT
Date: Thu, 17 Jan 2008 12:48:28 +0300
Message-ID: <478F246C.4040400@vlnb.net>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com> <20080117184052F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:33731 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbYAQJs3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jan 2008 04:48:29 -0500
In-Reply-To: <20080117184052F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bart.vanassche@gmail.com, stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@hansenpartnership.com, erezz@voltaire.com

FUJITA Tomonori wrote:
> On Thu, 17 Jan 2008 10:27:08 +0100
> "Bart Van Assche" <bart.vanassche@gmail.com> wrote:
> 
> 
>>Hello,
>>
>>I have performed a test to compare the performance of SCST and STGT.
>>Apparently the SCST target implementation performed far better than
>>the STGT target implementation. This makes me wonder whether this is
>>due to the design of SCST or whether STGT's performance can be
>>improved to the level of SCST ?
>>
>>Test performed: read 2 GB of data in blocks of 1 MB from a target (hot
>>cache -- no disk reads were performed, all reads were from the cache).
>>Test command: time dd if=/dev/sde of=/dev/null bs=1M count=2000
>>
>>                              STGT read             SCST read
>>                           performance (MB/s)   performance (MB/s)
>>Ethernet (1 Gb/s network)        77                    89
>>IPoIB (8 Gb/s network)           82                   229
>>SRP (8 Gb/s network)            N/A                   600
>>iSER (8 Gb/s network)            80                   N/A
>>
>>These results show that SCST uses the InfiniBand network very well
>>(effectivity of about 88% via SRP), but that the current STGT version
>>is unable to transfer data faster than 82 MB/s. Does this mean that
>>there is a severe bottleneck  present in the current STGT
>>implementation ?
> 
> 
> I don't know about the details but Pete said that he can achieve more
> than 900MB/s read performance with tgt iSER target using ramdisk.
> 
> http://www.mail-archive.com/stgt-devel@lists.berlios.de/msg00004.html

Please don't confuse multithreaded latency insensitive workload with 
single threaded, hence latency sensitive one.

> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

