From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 04 Feb 2008 20:08:55 +0300
Message-ID: <47A746A7.1050005@vlnb.net>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	 <1201639331.3069.58.camel@localhost.localdomain>	 <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net> <e2e108260802040553j2f3bf8c2n9fae132e000990f7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:49498 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487AbYBDRI4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:08:56 -0500
In-Reply-To: <e2e108260802040553j2f3bf8c2n9fae132e000990f7@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

Bart Van Assche wrote:
> On Feb 4, 2008 1:27 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> 
>>So, James, what is your opinion on the above? Or the overall SCSI target
>>project simplicity doesn't matter much for you and you think it's fine
>>to duplicate Linux page cache in the user space to keep the in-kernel
>>part of the project as small as possible?
> 
> 
> It's too early to draw conclusions about performance. I'm currently
> performing more measurements, and the results are not easy to
> interpret. My plan is to measure the following:
> * Setup: target with RAM disk of 2 GB as backing storage.
> * Throughput reported by dd and xdd (direct I/O).
> * Transfers with dd/xdd in units of 1 KB to 1 GB (the smallest
> transfer size that can be specified to xdd is 1 KB).
> * Target SCSI software to be tested: IETD iSCSI via IPoIB, STGT iSCSI
> via IPoIB, STGT iSER, SCST iSCSI via IPoIB, SCST SRP, LIO iSCSI via
> IPoIB.
> 
> The reason I chose dd/xdd for these tests is that I want to measure
> the performance of the communication protocols, and that I am assuming
> that this performance can be modeled by the following formula:
> (transfer time in s) = (transfer setup latency in s) + (transfer size
> in MB) / (bandwidth in MB/s).

It isn't fully correct, you forgot about link latency. More correct one is:

(transfer time) = (transfer setup latency on both initiator and target, 
consisting from software processing time, including memory copy, if 
necessary, and PCI setup/transfer time) + (transfer size)/(bandwidth) + 
(link latency to deliver request for READs or status for WRITES) + 
(2*(link latency) to deliver R2T/XFER_READY request in case of WRITEs, 
if necessary (e.g. iSER for small transfers might not need it, but SRP 
most likely always needs it)). Also you should note that it's correct 
only in case of single threaded workloads with one outstanding command 
at time. For other workloads it depends from how well they manage to 
keep the "link" full in interval from (transfer size)/(transfer time) to 
bandwidth.

> Measuring the time needed for transfers
> with varying block size allows to compute the constants in the above
> formula via linear regression.

Unfortunately, it isn't so easy, see above.

> One difficulty I already encountered is that the performance of the
> Linux IPoIB implementation varies a lot under high load
> (http://bugzilla.kernel.org/show_bug.cgi?id=9883).
> 
> Another issue I have to look further into is that dd and xdd report
> different results for very large block sizes (> 1 MB).

Look at /proc/scsi_tgt/sgv (for SCST) and you will see, which transfer 
sizes are actually used. Initiators don't like sending big requests and 
often split them on smaller ones.

Look at this message as well, it might be helpful: 
http://lkml.org/lkml/2007/5/16/223

> Bart Van Assche.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

