From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over
 10GbE?
Date: Sat, 5 Feb 2011 15:18:52 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1102051510080.8518@p34.internal.lan>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <1296934967.2599.2.camel@jeff-ubuntu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1296934967.2599.2.camel@jeff-ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
To: Jean Gobin <jf@gobinjf.be>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org



On Sat, 5 Feb 2011, Jean Gobin wrote:

> Hi Justin,
>
> When you run the copy over the network, could you issue a "vmstat 1" on
> both machines?
>
> Thanks,
> J.

iperf & nload:

# ./iperf -c 10.0.1.2
------------------------------------------------------------
Client connecting to 10.0.1.2, TCP port 5001
TCP window size: 27.7 KByte (default)
------------------------------------------------------------
[  3] local 10.0.1.1 port 34935 connected with 10.0.1.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  11.5 GBytes  9.90 Gbits/sec

Device eth0 [10.0.1.2] (1/5):
================================================================================
Incoming:
                                               #######
                                               #######
                                               #######
                                               #######
                                               #######
                                               #######  Curr: 1188.69 MByte/s
                                               #######  Avg: 510.87 MByte/s
                                               #######  Min: 0.00 MByte/s
                                               #######  Max: 1188.82 MByte/s
                                               #######  Ttl: 26.76 GByte
Outgoing:


                                                 #####
                                                 #####
                                                 #####
                                                 #####  Curr: 1.01 MByte/s
                                                ######  Avg: 0.43 MByte/s
                                                ######  Min: 0.00 MByte/s
                                                ######  Max: 1.01 MByte/s
                                                ######  Ttl: 23.20 MByte

Read from RAID-0: (1.4Gbyte/sec)

# dd if=bigfile3 of=/dev/null bs=1M
  1  0
  1  0      0 1049192    440 2795456    0    0 1400832     0 11274 2868  0  5 94  1  0
  1  0      0 1049072    440 2789112    0    0 1359872     0 10947 2728  0  5 94  2  0
  1  0      0 1049196    440 2795736    0    0 1228800     0 9931 2749  0  4 94  2  0
  1  0      0 1049196    440 2795736    0    0 1392640     0 11144 2773  0  5 94  1  0
  0  1      0 1049320    440 2795748    0    0 1220608     0 9971 2760  0  4 94  2  0
  0  1      0 1049320    440 2795748    0    0 1392640     0 11163 2785  0  5 94

Write to RAID-0: (1.4Gbyte/sec)
  2  0      0 1995352   4604 1798940    0    0     8 1443783 12074 4957  0  9 86  5  0
  1  1      0 1995268   4604 1798828    0    0     0 1494872 12410 5127  0  9 86  5  0
  1  1      0 1995492   4604 1799132    0    0     0 1463364 12239 5031  0  9 86  5  0
  1  2      0 1995432   4604 1798656    0    0     0 1431832 11993 4697  0  9 86

Everything > 1 Gbyte/sec but when you use the network, 250MiB/s, it does not
make sense.

Justin.
