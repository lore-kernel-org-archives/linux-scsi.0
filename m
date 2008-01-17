From: "Bart Van Assche" <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Performance of SCST versus STGT
Date: Thu, 17 Jan 2008 10:27:08 +0100
Message-ID: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Cc: Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hello,

I have performed a test to compare the performance of SCST and STGT.
Apparently the SCST target implementation performed far better than
the STGT target implementation. This makes me wonder whether this is
due to the design of SCST or whether STGT's performance can be
improved to the level of SCST ?

Test performed: read 2 GB of data in blocks of 1 MB from a target (hot
cache -- no disk reads were performed, all reads were from the cache).
Test command: time dd if=/dev/sde of=/dev/null bs=1M count=2000

                              STGT read             SCST read
                           performance (MB/s)   performance (MB/s)
Ethernet (1 Gb/s network)        77                    89
IPoIB (8 Gb/s network)           82                   229
SRP (8 Gb/s network)            N/A                   600
iSER (8 Gb/s network)            80                   N/A

These results show that SCST uses the InfiniBand network very well
(effectivity of about 88% via SRP), but that the current STGT version
is unable to transfer data faster than 82 MB/s. Does this mean that
there is a severe bottleneck  present in the current STGT
implementation ?

Details about the test equipment:
 - Ethernet controller: Intel 80003ES2LAN Gigabit Ethernet controller
(copper) in full duplex mode.
- InfiniBand controller: Mellanox MT25204 [InfiniHost III Lx HCA].
According to ib_rdma_bw and ib_rdma_lat, the InfiniBand peak bandwith
on this system is 675 MB/sec and its latency is 3 microseconds.
- CPU: one CPU, an Intel Xeon CPU 5130 @ 2.00GHz.
 - RAM: 2 GB in the initiator, 8 GB in the target. According to
lmbench, memory read bandwidth is 2960 MB/s and write bandwidth is
1080 MB/s.
 - Software: 64-bit Ubuntu 7.10 server edition + OFED 1.2.5.4
userspace components + SCST revision 242 (January 4, 2008) + TGT
version 20071227.

Regards,

Bart Van Assche.
