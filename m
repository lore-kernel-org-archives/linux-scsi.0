From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [Stgt-devel] Performance of SCST versus STGT
Date: Thu, 24 Jan 2008 11:36:45 +0100
Message-ID: <e2e108260801240236o2273be0bw24a2a61dcc781222@mail.gmail.com>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
	 <20080117184052F.fujita.tomonori@lab.ntt.co.jp>
	 <478F246C.4040400@vlnb.net>
	 <20080117190558K.fujita.tomonori@lab.ntt.co.jp>
	 <20080117174542.GC29650@osc.edu>
	 <e2e108260801220204k4b914ea1o9b47c0b22c6d098b@mail.gmail.com>
	 <4795D4A7.5000105@vlnb.net>
	 <e2e108260801220432l353b1d76xd2707b5e6f336aef@mail.gmail.com>
	 <20080124070616.GA31633@porcupine.cita.utoronto.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:47644 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYAXKgr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jan 2008 05:36:47 -0500
Received: by py-out-1112.google.com with SMTP id u52so293947pyb.10
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jan 2008 02:36:46 -0800 (PST)
In-Reply-To: <20080124070616.GA31633@porcupine.cita.utoronto.ca>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robin Humble <robin.humble+stgt@anu.edu.au>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, James.Bottomley@hansenpartnership.com, stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel@lists.sourceforge.net

On Jan 24, 2008 8:06 AM, Robin Humble <robin.humble+stgt@anu.edu.au> wrote:
> On Tue, Jan 22, 2008 at 01:32:08PM +0100, Bart Van Assche wrote:
> >
> >.............................................................................................
> >.                           .   STGT read     SCST read    .    STGT read      SCST read    .
> >.                           .  performance   performance   .   performance    performance   .
> >.                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB >MB/s)   (1 MB, MB/s)  .
> >.............................................................................................
> >. Ethernet (1 Gb/s network) .      77             78       .         77            89       .
> >. IPoIB    (8 Gb/s network) .     163            185       .        201           239       .
> >. iSER     (8 Gb/s network) .     250            N/A       .        360           N/A       .
> >. SRP      (8 Gb/s network) .     N/A            421       .        N/A           683       .
> >............................................................................................
>
> how are write speeds with SCST SRP?
> for some kernels and tests tgt writes at >2x the read speed.
>
> also I see much higher speeds that what you report in my DDR 4x IB tgt
> testing... which could be taken as inferring that tgt is scaling quite
> nicely on the faster fabric?
>   ib_write_bw of 1473 MB/s
>   ib_read_bw  of 1378 MB/s
>
> iSER to 7G ramfs, x86_64, centos4.6, 2.6.22 kernels, git tgtd,
> initiator end booted with mem=512M, target with 8G ram
>
>  direct i/o dd
>   write/read  800/751 MB/s
>     dd if=/dev/zero of=/dev/sdc bs=1M count=5000 oflag=direct
>     dd of=/dev/null if=/dev/sdc bs=1M count=5000 iflag=direct
>
>  buffered i/o dd
>   write/read 1109/350 MB/s
>     dd if=/dev/zero of=/dev/sdc bs=1M count=5000
>     dd of=/dev/null if=/dev/sdc bs=1M count=5000

Hello Robin,

The tests I performed were read performance tests with dd and with
buffered I/O. For this test you obtained 350 MB/s with STGT on a DDR
4x InfiniBand network, while I obtained 360 MB/s on a SDR 4x
InfiniBand network. I don't think that we can call this "scaling up"
...

Regarding write performance: the write tests were performed with a
real target (three disks in RAID-0, write bandwidth about 100 MB/s). I
did not yet publish these numbers because it is not yet clear to me
how much disk writing speed / InfiniBand transfer speed / target write
buffering each contribute in the results. The results I obtained in
the write tests (dd, buffered I/O) show the same trend as for the read
tests: for large data transfers over a Gigabit Ethernet network the
results for STGT and SCST are similar. For small transfer sizes (512
bytes) or fast network technology (SRP / iSER) the write performance
of SCST is significantly better than that of STGT.

Bart.

Bart.
