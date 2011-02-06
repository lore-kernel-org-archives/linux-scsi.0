From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over
 10GbE?
Date: Sun, 6 Feb 2011 08:46:08 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1102060817590.28109@p34.internal.lan>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan> <20110205220621.GB17347@gallifrey> <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan>
 <alpine.DEB.2.00.1102051753100.8518@p34.internal.lan> <4D4DE34E.7010308@hardwarefreak.com> <alpine.DEB.2.00.1102051958370.28109@p34.internal.lan> <4D4E127D.3060105@hardwarefreak.com> <alpine.DEB.2.00.1102060515230.28109@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1102060515230.28109@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>, Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org



On Sun, 6 Feb 2011, Justin Piszcz wrote:

>
>
> On Sat, 5 Feb 2011, Stan Hoeppner wrote:
>
>> Justin Piszcz put forth on 2/5/2011 7:08 PM:
>>


Hi,

1. Defaults below:
sysctl -w net.core.wmem_max=131071
sysctl -w net.core.rmem_max=131071
sysctl -w net.core.wmem_default=118784
sysctl -w net.core.rmem_default=118784
sysctl -w net.core.optmem_max=20480
sysctl -w net.ipv4.igmp_max_memberships=20
sysctl -w net.ipv4.tcp_mem="379104       505472  758208"
sysctl -w net.ipv4.tcp_wmem="4096        16384   4194304"
sysctl -w net.ipv4.tcp_rmem="4096        87380   4194304"
sysctl -w net.ipv4.udp_mem="379104       505472  758208"
sysctl -w net.ipv4.udp_rmem_min=4096
sysctl -w net.ipv4.udp_wmem_min=4096
sysctl -w net.core.netdev_max_backlog=1024

2. Optimized settings, for > 800MiB/:

# for 3ware raid, use 16384 readahead, > 16384 readahead, no improvement
blockdev --setra 16384 /dev/sda

# not sure if this helps much
ethtool -K eth0 lro on

# seems to get performance > 600-700MiB/s faster
sysctl -w net.core.wmem_max=4194304
sysctl -w net.core.rmem_max=4194304
sysctl -w net.core.wmem_default=4194304
sysctl -w net.core.rmem_default=4194304
sysctl -w net.core.optmem_max=20480
sysctl -w net.ipv4.igmp_max_memberships=20
sysctl -w net.ipv4.tcp_mem="4194304 4194304 4194304"
sysctl -w net.ipv4.tcp_wmem="4194304 4194304 4194304"
sysctl -w net.ipv4.tcp_rmem="4194304 4194304 4194304"
sysctl -w net.ipv4.udp_mem="4194304 4194304 4194304"
sysctl -w net.ipv4.udp_rmem_min=4096
sysctl -w net.ipv4.udp_wmem_min=4096
sysctl -w net.core.netdev_max_backlog=1048576

# the main option that makes all of the difference, the golden option
# is the rszie and wsize of 1megabyte below:
10.0.1.4:/r1    /nfs/box2/r1  nfs   tcp,bg,rw,hard,intr,nolock,nfsvers=3,rsize=1048576,wsize=1048576  0 0

CPU utilization:
   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  2069 root      20   0 18640 1304  688 R   91  0.0   0:15.50 cp
   703 root      20   0     0    0    0 S   25  0.0   2:46.95 kswapd0

With a single copy I get roughly 700-800MiB/s:

Device eth0 [10.0.1.3] (1/1):
================================================================================
Incoming:
######################     ####################  ####
######################     ####################  ####
######################     ####################  ####
######################     ####################  ####
######################     ####################  ####
######################     ####################  ####  Curr: 808.71 MByte/s
######################     ####################  ####  Avg: 706.11 MByte/s
######################     ####################  ####  Min: 0.00 MByte/s
######################     ####################  ####  Max: 860.17 MByte/s
######################     ####################  ####  Ttl: 344.70 GByte

With two copies I get up to 830-850MiB/s:

Device eth0 [10.0.1.3] (1/1):
================================================================================
Incoming:
############################################     ####
############################################     ####
############################################     ####
############################################     ####
############################################     ####
############################################     ####  Curr: 846.61 MByte/s
############################################     ####  Avg: 683.14 MByte/s
############################################     ####  Min: 0.00 MByte/s
############################################     ####  Max: 860.17 MByte/s
############################################     ####  Ttl: 305.71 GByte

Using a 4MiB r/w size with NFS improves performance to sustain > 750MiB/s
a little better I think:
10.0.1.4:/r1    /nfs/box2/r1  nfs   tcp,bg,rw,hard,intr,nolock,nfsvers=3,rsize=4194304,wsize=4194304 0

Anyhow, roughly 750-850MiB/s it would be nice to get 1Gbyte/sec but I guess
the kerrnel (or my HW, CPU not fast enough) is not there yet.

Also found a good doc from RedHat:
http://www.redhat.com/promo/summit/2008/downloads/pdf/Thursday/Mark_Wagner.pdf

Justin.
