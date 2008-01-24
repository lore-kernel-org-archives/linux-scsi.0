From: Robin Humble <robin.humble+stgt-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Thu, 24 Jan 2008 02:06:16 -0500
Message-ID: <20080124070616.GA31633@porcupine.cita.utoronto.ca>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
	<20080117184052F.fujita.tomonori@lab.ntt.co.jp>
	<478F246C.4040400@vlnb.net>
	<20080117190558K.fujita.tomonori@lab.ntt.co.jp>
	<20080117174542.GC29650@osc.edu>
	<e2e108260801220204k4b914ea1o9b47c0b22c6d098b@mail.gmail.com>
	<4795D4A7.5000105@vlnb.net>
	<e2e108260801220432l353b1d76xd2707b5e6f336aef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e2e108260801220432l353b1d76xd2707b5e6f336aef-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 22, 2008 at 01:32:08PM +0100, Bart Van Assche wrote:
>On Jan 22, 2008 12:33 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:
>> What are the new SRPT/iSER numbers?
>You can find the new performance numbers below. These are all numbers for
>reading from the remote buffer cache, no actual disk reads were performed.
>The read tests have been performed with dd, both for a block size of 512
>bytes and of 1 MB. The tests with small block size learn more about latency,
>while the tests with large block size learn more about the maximal possible
>throughput.
>
>.............................................................................................
>.                           .   STGT read     SCST read    .    STGT read      SCST read    .
>.                           .  performance   performance   .   performance    performance   .
>.                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB >MB/s)   (1 MB, MB/s)  .
>.............................................................................................
>. Ethernet (1 Gb/s network) .      77             78       .         77            89       .
>. IPoIB    (8 Gb/s network) .     163            185       .        201           239       .
>. iSER     (8 Gb/s network) .     250            N/A       .        360           N/A       .
>. SRP      (8 Gb/s network) .     N/A            421       .        N/A           683       .
>............................................................................................

how are write speeds with SCST SRP?
for some kernels and tests tgt writes at >2x the read speed.

also I see much higher speeds that what you report in my DDR 4x IB tgt
testing... which could be taken as inferring that tgt is scaling quite
nicely on the faster fabric?
  ib_write_bw of 1473 MB/s
  ib_read_bw  of 1378 MB/s

iSER to 7G ramfs, x86_64, centos4.6, 2.6.22 kernels, git tgtd,
initiator end booted with mem=512M, target with 8G ram

 direct i/o dd
  write/read  800/751 MB/s
    dd if=/dev/zero of=/dev/sdc bs=1M count=5000 oflag=direct
    dd of=/dev/null if=/dev/sdc bs=1M count=5000 iflag=direct

 buffered i/o dd
  write/read 1109/350 MB/s
    dd if=/dev/zero of=/dev/sdc bs=1M count=5000
    dd of=/dev/null if=/dev/sdc bs=1M count=5000

 buffered i/o lmdd
  write/read  682/438 MB/s
    lmdd if=internal of=/dev/sdc bs=1M count=5000
    lmdd of=internal if=/dev/sdc bs=1M count=5000

which goes to show that a) buffered i/o makes reads suck and writes fly
b) most benchmarks are unreliable c) at these high speeds you get all
sorts of weird effects which can easily vary with kernel, OS, ... and
d) that IMHO really we shouldn't get too caught up in these very
artificial tests to ramdisks/ram because it's the speed of real
applications to actual spinning rust that matters.

having said that, if you know of a way to clock my IB cards down to your
SDR rates then let me know and I'll be happy to re-run the tests.

cheers,
robin

>My conclusion from the above numbers: the performance difference between
>STGT and SCST is small for a Gigabit Ethernet network. The faster the
>network technology, the larger the difference between SCST and STGT.
>
>Bart.

>_______________________________________________
>Stgt-devel mailing list
>Stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
>https://lists.berlios.de/mailman/listinfo/stgt-devel
