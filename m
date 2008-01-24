From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Thu, 24 Jan 2008 15:40:24 +0300
Message-ID: <47988738.5090000@vlnb.net>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>	<20080117184052F.fujita.tomonori@lab.ntt.co.jp>	<478F246C.4040400@vlnb.net>	<20080117190558K.fujita.tomonori@lab.ntt.co.jp>	<20080117174542.GC29650@osc.edu>	<e2e108260801220204k4b914ea1o9b47c0b22c6d098b@mail.gmail.com>	<4795D4A7.5000105@vlnb.net>	<e2e108260801220432l353b1d76xd2707b5e6f336aef@mail.gmail.com>	<20080124070616.GA31633@porcupine.cita.utoronto.ca>	<e2e108260801240236o2273be0bw24a2a61dcc781222@mail.gmail.com>
	<20080124113215.GB26751@porcupine.cita.utoronto.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
In-Reply-To: <20080124113215.GB26751-Td5ZOp7sT3Xw02mFwxTg32+DJq1SqhBbsOSz5zK2v9k@public.gmane.org>
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: Robin Humble <robin.humble+stgt-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Robin Humble wrote:
> On Thu, Jan 24, 2008 at 11:36:45AM +0100, Bart Van Assche wrote:
> 
>>On Jan 24, 2008 8:06 AM, Robin Humble <robin.humble+stgt-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org> wrote:
>>
>>>On Tue, Jan 22, 2008 at 01:32:08PM +0100, Bart Van Assche wrote:
>>>
>>>>.............................................................................................
>>>>.                           .   STGT read     SCST read    .    STGT read      SCST read    .
>>>>.                           .  performance   performance   .   performance    performance   .
>>>>.                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB >MB/s)   (1 MB, MB/s)  .
>>>>.............................................................................................
>>>>. Ethernet (1 Gb/s network) .      77             78       .         77            89       .
>>>>. IPoIB    (8 Gb/s network) .     163            185       .        201           239       .
>>>>. iSER     (8 Gb/s network) .     250            N/A       .        360           N/A       .
>>>>. SRP      (8 Gb/s network) .     N/A            421       .        N/A           683       .
>>>>............................................................................................
>>>
>>>how are write speeds with SCST SRP?
>>>for some kernels and tests tgt writes at >2x the read speed.
>>>
>>>also I see much higher speeds that what you report in my DDR 4x IB tgt
>>>testing... which could be taken as inferring that tgt is scaling quite
>>>nicely on the faster fabric?
>>>  ib_write_bw of 1473 MB/s
>>>  ib_read_bw  of 1378 MB/s
>>>
>>>iSER to 7G ramfs, x86_64, centos4.6, 2.6.22 kernels, git tgtd,
>>>initiator end booted with mem=512M, target with 8G ram
>>>
>>> direct i/o dd
>>>  write/read  800/751 MB/s
>>>    dd if=/dev/zero of=/dev/sdc bs=1M count=5000 oflag=direct
>>>    dd of=/dev/null if=/dev/sdc bs=1M count=5000 iflag=direct
>>>
>>> buffered i/o dd
>>>  write/read 1109/350 MB/s
>>>    dd if=/dev/zero of=/dev/sdc bs=1M count=5000
>>>    dd of=/dev/null if=/dev/sdc bs=1M count=5000
>>>
>>>buffered i/o lmdd
>>> write/read  682/438 MB/s
>>>   lmdd if=internal of=/dev/sdc bs=1M count=5000
>>>   lmdd of=internal if=/dev/sdc bs=1M count=5000
> 
> 
>>The tests I performed were read performance tests with dd and with
>>buffered I/O. For this test you obtained 350 MB/s with STGT on a DDR
> 
> 
> ... and 1.1GB/s writes :)
> presumably because buffer aggregation works well.
> 
> 
>>4x InfiniBand network, while I obtained 360 MB/s on a SDR 4x
>>InfiniBand network. I don't think that we can call this "scaling up"
>>...
> 
> 
> the direct i/o read speed being twice the buffered i/o speed would seem
> to imply that Linux's page cache is being slow and confused with this
> particular set of kernel + OS + OFED versions.
> I doubt that this result actually says that much about tgt really.

Buffered dd read is, actually, one of the best benchmarks if you want to 
compare STGT vs SCST, because it's single threaded with one outstanding 
command most of the time, i.e. it's a latency bound workload. Plus, most 
of the applications reading files do exactly what dd does.

Both SCST and STGT suffer equally from possible problems on the 
initiator, but SCST bears it much better, because it has much less 
processing latency (e.g., because there are no extra user<->kernel 
spaces switches and other related overhead).

>>Regarding write performance: the write tests were performed with a
>>real target (three disks in RAID-0, write bandwidth about 100 MB/s). I
> 
> 
> I'd be interested to see ramdisk writes.
> 
> cheers,
> robin
> _______________________________________________
> Stgt-devel mailing list
> Stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
> https://lists.berlios.de/mailman/listinfo/stgt-devel
> 
