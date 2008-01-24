From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Performance of SCST versus STGT
Date: Thu, 24 Jan 2008 14:10:06 +0300
Message-ID: <4798720E.4020802@vlnb.net>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>	<20080117184052F.fujita.tomonori@lab.ntt.co.jp>	<478F246C.4040400@vlnb.net>	<20080117190558K.fujita.tomonori@lab.ntt.co.jp>	<20080117174542.GC29650@osc.edu>	<e2e108260801220204k4b914ea1o9b47c0b22c6d098b@mail.gmail.com>	<4795D4A7.5000105@vlnb.net>	<e2e108260801220432l353b1d76xd2707b5e6f336aef@mail.gmail.com>	<20080124070616.GA31633@porcupine.cita.utoronto.ca> <e2e108260801240236o2273be0bw24a2a61dcc781222@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:34881 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397AbYAXLJ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jan 2008 06:09:59 -0500
In-Reply-To: <e2e108260801240236o2273be0bw24a2a61dcc781222@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Robin Humble <robin.humble+stgt@anu.edu.au>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, scst-devel@lists.sourceforge.net

Bart Van Assche wrote:
> On Jan 24, 2008 8:06 AM, Robin Humble <robin.humble+stgt@anu.edu.au> wrote:
> 
>>On Tue, Jan 22, 2008 at 01:32:08PM +0100, Bart Van Assche wrote:
>>
>>>.............................................................................................
>>>.                           .   STGT read     SCST read    .    STGT read      SCST read    .
>>>.                           .  performance   performance   .   performance    performance   .
>>>.                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB >MB/s)   (1 MB, MB/s)  .
>>>.............................................................................................
>>>. Ethernet (1 Gb/s network) .      77             78       .         77            89       .
>>>. IPoIB    (8 Gb/s network) .     163            185       .        201           239       .
>>>. iSER     (8 Gb/s network) .     250            N/A       .        360           N/A       .
>>>. SRP      (8 Gb/s network) .     N/A            421       .        N/A           683       .
>>>............................................................................................
>>
>>how are write speeds with SCST SRP?
>>for some kernels and tests tgt writes at >2x the read speed.

Robin,

There is a fundamental difference between regular dd-like reads and 
writes: reads are sync, i.e. latency sensitive, but writes are async, 
i.e. latency insensitive. You should use O_DIRECT dd writes for the fair 
comparison.

Vlad
