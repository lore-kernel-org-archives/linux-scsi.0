From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Performance of SCST versus STGT
Date: Thu, 17 Jan 2008 18:40:52 +0900
Message-ID: <20080117184052F.fujita.tomonori@lab.ntt.co.jp>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:58830 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbYAQJlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 04:41:07 -0500
In-Reply-To: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bart.vanassche@gmail.com
Cc: stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@hansenpartnership.com, erezz@voltaire.com, fujita.tomonori@lab.ntt.co.jp, vst@vlnb.net

On Thu, 17 Jan 2008 10:27:08 +0100
"Bart Van Assche" <bart.vanassche@gmail.com> wrote:

> Hello,
> 
> I have performed a test to compare the performance of SCST and STGT.
> Apparently the SCST target implementation performed far better than
> the STGT target implementation. This makes me wonder whether this is
> due to the design of SCST or whether STGT's performance can be
> improved to the level of SCST ?
> 
> Test performed: read 2 GB of data in blocks of 1 MB from a target (hot
> cache -- no disk reads were performed, all reads were from the cache).
> Test command: time dd if=/dev/sde of=/dev/null bs=1M count=2000
> 
>                               STGT read             SCST read
>                            performance (MB/s)   performance (MB/s)
> Ethernet (1 Gb/s network)        77                    89
> IPoIB (8 Gb/s network)           82                   229
> SRP (8 Gb/s network)            N/A                   600
> iSER (8 Gb/s network)            80                   N/A
> 
> These results show that SCST uses the InfiniBand network very well
> (effectivity of about 88% via SRP), but that the current STGT version
> is unable to transfer data faster than 82 MB/s. Does this mean that
> there is a severe bottleneck  present in the current STGT
> implementation ?

I don't know about the details but Pete said that he can achieve more
than 900MB/s read performance with tgt iSER target using ramdisk.

http://www.mail-archive.com/stgt-devel@lists.berlios.de/msg00004.html
