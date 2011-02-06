From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over
 10GbE?
Date: Sat, 5 Feb 2011 20:08:02 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1102051958370.28109@p34.internal.lan>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan> <20110205220621.GB17347@gallifrey> <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan>
 <alpine.DEB.2.00.1102051753100.8518@p34.internal.lan> <4D4DE34E.7010308@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D4DE34E.7010308@hardwarefreak.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>, Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org



On Sat, 5 Feb 2011, Stan Hoeppner wrote:

> Justin Piszcz put forth on 2/5/2011 4:56 PM:
>
>> Not sure how to copy/paste from an IPMI window, but I made my own
>> kernel for 2.6.37 in CentOS 5.5 (a pain) and now it is doing ~482-500MiB/s
>> sustained with a single copy (netcat from A->B).  Poor performance with the
>> default 2.6.18 kernel.  Seems to also slow down over time, down to 434MiB/s now,
>> but it started very quick and it remains between 420-500MiB/s sustained.  Now
>> 435-445MiB/s..
>
> I forgot you mentioned CentOS.  Their kernel and apps are always very old.
> 2.6.18 was release in Sept 2006 IIRC--4+ years ago.  It was the "pirate themed"
> release.
>
> With 2.6.37 what do you get with 4 concurrent nfs copy ops?  If the aggregate
> nfs throughput doesn't increase, you need to tweak your nfs server (and possibly
> client).  With that hardware and a recent kernel you should be able to fill that
> 10 GbE pipe, or come really close.

Hi,

I installed Debian Testing & my own kernel again (2.6.37):

One thread:

# get bigfile.1
`bigfile.1' at 1168441344 (5%) 493.10M/s eta:38s [Receiving data] 
`bigfile.1' at 2226847744 (10%) 557.16M/s eta:32s [Receiving data] 
`bigfile.1' at 3274768384 (15%) 578.57M/s eta:29s [Receiving data] 
`bigfile.1' at 4781113344 (22%) 585.02M/s eta:26s [Receiving data] 
`bigfile.1' at 6294077440 (30%) 588.96M/s eta:24s [Receiving data] 
`bigfile.1' at 9318563840 (44%) 592.87M/s eta:19s [Receiving data] 
`bigfile.1' at 12805996544 (61%) 592.46M/s eta:13s [Receiving data] 
20971520000 bytes transferred in 34 seconds (592.72M/s)

Two threads:
[0] get bigfile.1
         `bigfile.1' at 3225878528 (15%) 306.51M/s eta:55s [Receiving data]
[1] get bigfile.2
         `bigfile.2' at 3200516096 (15%) 306.49M/s eta:55s [Receiving data]

Seems like some problem achieving > 600MiB/s now.

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  0  0      0  34184    112 3875676    0    0 622592     0 49060 9798  0  5 95  0
  0  0      0  32820    112 3876976    0    0 622592     0 49043 9745  0  5 95  0
  0  0      0  34184    112 3876188    0    0 622592     0 48997 9714  0  5 95  0
  1  0      0  32572    112 3877780    0    0 606208     0 48815 9537  0  5 95  0
  0  0      0  32820    112 3878104    0    0 622592     0 48968 9741  0  5 95  0
  0  0      0  31456    112 3878024    0    0 622592     0 49051 9773  0  5 95  0
  0  0      0  31952    112 3877448    0    0 622592     4 49076 9804  0  5 95  0
  3  0      0  30836    112 3871364    0    0 606208     0 48901 9650  0  5 95  0

But much better than 250MiB/s.

[0] Done (get bigfile.1)
         20971520000 bytes transferred in 64 seconds (312.95M/s)
[1] Done (get bigfile.2)
         20971520000 bytes transferred in 64 seconds (312.78M/s)

So approx 624MiB/s..

With three threads:

[0] get bigfile.1
         `bigfile.1' at 6659241132 (31%) 222.41M/s eta:61s [Receiving data]
[1] get bigfile.2
         `bigfile.2' at 6620446720 (31%) 222.00M/s eta:62s [Receiving data]
[2] get bigfile.3
         `bigfile.3' at 6601441280 (31%) 222.17M/s eta:62s [Receiving data]

vmstat:

  0  0      0  33028    112 3877856    0    0 704512     0 53859 13108  0  6 94  0
  1  0      0  32532    112 3877476    0    0 688128     0 54063 12484  0  6 94  0
  1  0      0  33276    112 3877128    0    0 704512     0 54143 12548  0  6 94  0
  1  0      0  33284    112 3868860    0    0 700672     0 54200 12398  0  6 94  0

[0] Done (get bigfile.1)
         20971520000 bytes transferred in 90 seconds (221.70M/s)
[1] Done (get bigfile.2)
         20971520000 bytes transferred in 90 seconds (221.50M/s)
[2] Done (get bigfile.3)
         20971520000 bytes transferred in 90 seconds (221.42M/s)

A little better, 663MiB/s.

Four threads:

[0] get bigfile.1
         `bigfile.1' at 2641887232 (12%) 162.77M/s eta:2m [Receiving data]
[1] get bigfile.2
         `bigfile.2' at 2601254912 (12%) 161.97M/s eta:2m [Receiving data]
[2] get bigfile.3
         `bigfile.3' at 2592931840 (12%) 162.05M/s eta:2m [Receiving data]
[3] get bigfile.4
         `bigfile.4' at 2546794496 (12%) 159.92M/s eta:2m [Receiving data]


vmstat:

  1  0      0  34492    112 3859748    0    0 678144     0 58816 11481  0  7 93  0
  0  0      0  35360    112 3871060    0    0 681728     0 58889 11344  0  6 94  0
  1  0      0  33872    112 3874252    0    0 688128     0 59052 11560  0  6 94  0
  0  0      0  34492    112 3871400    0    0 688128     0 59079 11564  0  7 93  0
  1  0      0  32136    112 3874888    0    0 688128     0 59089 11432  0  6 93  0
  2  0      0  35360    112 3872436    0    0 655360     0 56672 10943  0  7 93  0


[0] Done (get bigfile.1)
         20971520000 bytes transferred in 120 seconds (166.72M/s)
[1] Done (get bigfile.2)
         20971520000 bytes transferred in 120 seconds (166.42M/s)
[2] Done (get bigfile.3)
         20971520000 bytes transferred in 120 seconds (166.40M/s)
[3] Done (get bigfile.4)
         20971520000 bytes transferred in 120 seconds (166.30M/s)

664MiB/s, so it appears this is the best it can do without any major tweaking
other than setting the blockdev readahead to 16384.

Overall performance is good, but now I need to figure out how to tweak the
network and/or disk paths so I can achieve > 1Gbyte/sec, as the RAID-0s can
read and write > 1.2Gbyte/sec.

Has anyone with 10GbE <-> 10GbE been able to transfer at or near line rate
with a single connection, or > 700MiB/s with multiple connections?  Problem
I worry about with creating multiple connections between two machines it will
create contention within the RAID that is being read from..

Justin.
