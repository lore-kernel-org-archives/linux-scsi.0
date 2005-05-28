From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sgp_dd uses alot of CPU time on FC3
Date: Sat, 28 May 2005 17:13:31 +1000
Message-ID: <42981A1B.9000207@torque.net>
References: <429762B7.5010905@datadirectnet.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:63129 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262358AbVE1HN3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 May 2005 03:13:29 -0400
In-Reply-To: <429762B7.5010905@datadirectnet.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin W. Schlining III" <mschlining@datadirectnet.com>
Cc: linux-scsi@vger.kernel.org

Martin W. Schlining III wrote:
> I posted this on the Fedora Forum. I thought this was also an 
> appropriate place as well.
> 
> I am trying to use my Dell 2850 Server as a data pump using sgp_dd to 
> perform large sequential read from my target through sg devices. One 
> instance of sgp_dd uses about 50% of the CPU, so running a second only 
> causes the CPU to become very busy and my read performance suffers as a 
> result. A third and a fourth instance only make matters worse.
> 
> I tried using sgm_dd, which is not multithreaded, to run the same test. 
> Though the speed is not quite as high as sgp_dd, it only uses a small 
> amount of CPU resources. That lead me to believe that either sgp_dd has 
> a problem in its multi-threading or maybe the POSIX threads. I'm really 
> not sure at this point what to do next.
> 
> Under Windows 2003 running IOMeter, my target can be saturated at my 
> expected bandwidth across 4 FC4 ports. That shows that my target and 
> server are capable of delivering the speed.
> 
> I tried both the SMP and non-SMP kernels with the same results.
> 
> Here's my configuration using the non-SMP kernel:
> 
> My target w/ 4 FC4 host ports
> Dell 2850 server Dual processor 1GB memory
> Fedora Core 3 Distro updated to kernel 2.6.11-1.27_FC3SMP and 
> 2.6.11-1.27_FC3
> swap size 2GB
> 
> 2 Emulex LP11000 FC4 Dual HBAs, each on independant PCI busses
> Emulex driver version: 2.6-8.0.16.6_x2 compiled and installed for the 
> new kernels.
> 
> uname -a
> Linux  2.6.11-1.27_FC3 #1 Tue May 17 20:27:37 EDT 2005 i686 i686 i386 
> GNU/Linux
> 
> gcc -v
> Reading specs from /usr/lib/gcc/i386-redhat-linux/3.4.3/specs
> Configured with: ../configure --prefix=/usr --mandir=/usr/share/man 
> --infodir=/usr/share/info --enable-shared --enable-threads=posix 
> --disable-checking --with-system-zlib --enable-__cxa_atexit 
> --disable-libunwind-exceptions --enable-java-awt=gtk 
> --host=i386-redhat-linux
> Thread model: posix
> gcc version 3.4.3 20050227 (Red Hat 3.4.3-22.fc3)
> 
> lsscsi -g
> [0:0:0:0] disk SEAGATE ST336607LC DS09 /dev/sda /dev/sg0
> [0:0:6:0] process PE/PV 1x6 SCSI BP 1.0 - /dev/sg1
> [14:0:0:0] disk E1.0 /dev/sdb /dev/sg2
> [15:0:0:0] disk E1.0 /dev/sdc /dev/sg3
> [16:0:0:0] disk E1.0 /dev/sdd /dev/sg4
> [17:0:0:0] disk E1.0 /dev/sde /dev/sg5
> 
> cat /proc/scsi/sg/allow_dio
> 0

Martin,
allow_dio only comes into play when the "dio=1" option
is used in sgp_dd (and sg_dd).

> I tried using a value of 1 for allow_dio, but it had no effect.
> 
> Using sg3_utils-1.14
> 
> Running sgp_dd like this:
> sgp_dd if=/dev/sg2 of=/dev/null bs=512 bpt=4096 thr=6 time=1
> 
> 6 threads, 2M transfers, actually gives 2M commands sizes

You didn't show what throughput you got.

I haven't done much timing on sgp_dd since lk 2.4
days. Here is one data point I just obtained with lk 2.6.11:

$ time sgp_dd if=/dev/sg20 of=. bs=512 bpt=4096 thr=6 time=1
time to transfer data was 558.082167 secs, 65.26 MB/sec
71132960+0 records in
71132960+0 records out
0.06user 23.95system 9:18.08elapsed 4%CPU
     (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+909minor)pagefaults 0swaps


That doesn't look too bad: 4% CPU utilization

Using a rebadged Seagate FC disk via a QLogic Corp.
QLA2312 Fibre Channel Adapter (qla2xxx LLD):

$ sdparm --page=co /dev/sg20
     /dev/sg20: HP 36.4G  ST336753FC        HP00
Control mode page:
   TST         0  [cha: n, def:  0, sav:  0]
   TMF_ONLY    0  [cha: n, def:  0, sav:  0]
   D_SENSE     0  [cha: n, def:  0, sav:  0]
   GLTSD       0  [cha: y, def:  0, sav:  0]
   RLEC        0  [cha: y, def:  0, sav:  0]
   QAM         1  [cha: y, def:  1, sav:  1]
   QERR        0  [cha: n, def:  0, sav:  0]
   RAC         0  [cha: n, def:  0, sav:  0]
   UA_INTLCK   0  [cha: n, def:  0, sav:  0]
   SWP         0  [cha: y, def:  0, sav:  0]
   ATO         0  [cha: n, def:  0, sav:  0]
   TAS         0  [cha: n, def:  0, sav:  0]
   AUTOLOAD    0  [cha: n, def:  0, sav:  0]
   BTP         0  [cha: n, def:  0, sav:  0]
   ESTCT       0  [cha: y, def:  0, sav:  0]

It is an SMP, 64 bit processor kernel:
$ cat /proc/cpuinfo
processor  : 0
vendor     : GenuineIntel
arch       : IA-64
family     : Itanium 2
model      : 1
revision   : 5
archrev    : 0
features   : branchlong
cpu number : 0
cpu regs   : 4
cpu MHz    : 1500.000000
itc MHz    : 1500.000000
BogoMIPS   : 2239.75

processor  : 1
dito


On the same disk, sgm_dd is no faster but shows
an impressive 0% CPU utilization
(0.00user 0.23system 9:18.07elapsed 0%CPU).

Doug Gilbert
