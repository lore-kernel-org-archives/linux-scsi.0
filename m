From: Pete Wyckoff <pw-pxmRpbKlMIQ@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Thu, 17 Jan 2008 12:45:42 -0500
Message-ID: <20080117174542.GC29650@osc.edu>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
	<20080117184052F.fujita.tomonori@lab.ntt.co.jp>
	<478F246C.4040400@vlnb.net>
	<20080117190558K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080117190558K.fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, vst-d+Crzxg7Rs0@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org wrote on Thu, 17 Jan 2008 19:05 +0900:
> On Thu, 17 Jan 2008 12:48:28 +0300
> Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:
> 
> > FUJITA Tomonori wrote:
> > > On Thu, 17 Jan 2008 10:27:08 +0100
> > > "Bart Van Assche" <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > 
> > > 
> > >>Hello,
> > >>
> > >>I have performed a test to compare the performance of SCST and STGT.
> > >>Apparently the SCST target implementation performed far better than
> > >>the STGT target implementation. This makes me wonder whether this is
> > >>due to the design of SCST or whether STGT's performance can be
> > >>improved to the level of SCST ?
> > >>
> > >>Test performed: read 2 GB of data in blocks of 1 MB from a target (hot
> > >>cache -- no disk reads were performed, all reads were from the cache).
> > >>Test command: time dd if=/dev/sde of=/dev/null bs=1M count=2000
> > >>
> > >>                              STGT read             SCST read
> > >>                           performance (MB/s)   performance (MB/s)
> > >>Ethernet (1 Gb/s network)        77                    89
> > >>IPoIB (8 Gb/s network)           82                   229
> > >>SRP (8 Gb/s network)            N/A                   600
> > >>iSER (8 Gb/s network)            80                   N/A
> > >>
> > >>These results show that SCST uses the InfiniBand network very well
> > >>(effectivity of about 88% via SRP), but that the current STGT version
> > >>is unable to transfer data faster than 82 MB/s. Does this mean that
> > >>there is a severe bottleneck  present in the current STGT
> > >>implementation ?
> > > 
> > > 
> > > I don't know about the details but Pete said that he can achieve more
> > > than 900MB/s read performance with tgt iSER target using ramdisk.
> > > 
> > > http://www.mail-archive.com/stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org/msg00004.html
> > 
> > Please don't confuse multithreaded latency insensitive workload with 
> > single threaded, hence latency sensitive one.
> 
> Seems that he can get good performance with single threaded workload:
> 
> http://www.osc.edu/~pw/papers/wyckoff-iser-snapi07-talk.pdf
> 
> But I don't know about the details so let's wait for Pete to comment
> on this.

Page 16 is pretty straight forward.  One command outstanding from
the client.  It is an OSD read command.  Data on tmpfs.  500 MB/s is
pretty easy to get on IB.

The other graph on page 23 is for block commands.  600 MB/s ish.
Still single command; so essentially a "latency" test.  Dominated by
the memcpy time from tmpfs to pinned IB buffer, as per page 24.

Erez said:

> We didn't run any real performance test with tgt, so I don't have
> numbers yet. I know that Pete got ~900 MB/sec by hacking sgp_dd, so all
> data was read/written to the same block (so it was all done in the
> cache). Pete - am I right?

Yes (actually just 1 thread in sg_dd).  This is obviously cheating.
Take the pread time to zero in SCSI Read analysis on page 24 to show
max theoretical.  It's IB theoretical minus some initiator and stgt
overheads.

The other way to get more read throughput is to throw multiple
simultaneous commands at the server.

There's nothing particularly stunning here.  Suspect Bart has
configuration issues if not even IPoIB will do > 100 MB/s.

		-- Pete
