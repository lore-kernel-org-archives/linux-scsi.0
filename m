From: "Martin W. Schlining III" <mschlining@datadirectnet.com>
Subject: sgp_dd uses alot of CPU time on FC3
Date: Fri, 27 May 2005 14:11:03 -0400
Message-ID: <429762B7.5010905@datadirectnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postoffice.datadirectnet.com ([64.213.193.141]:59282 "EHLO
	postoffice.datadirectnet.com") by vger.kernel.org with ESMTP
	id S261955AbVE0SLH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 14:11:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by postoffice.datadirectnet.com (Postfix) with ESMTP id AB6DC340717C
	for <linux-scsi@vger.kernel.org>; Fri, 27 May 2005 11:11:06 -0700 (PDT)
Received: from postoffice.datadirectnet.com ([127.0.0.1])
 by localhost (postoffice.datadirectnet.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 16358-01 for <linux-scsi@vger.kernel.org>;
 Fri, 27 May 2005 11:11:06 -0700 (PDT)
Received: from [192.168.1.127] (www.ddneng.com [70.88.130.31])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by postoffice.datadirectnet.com (Postfix) with ESMTP id BC28C3405B8C
	for <linux-scsi@vger.kernel.org>; Fri, 27 May 2005 11:11:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I posted this on the Fedora Forum. I thought this was also an 
appropriate place as well.

I am trying to use my Dell 2850 Server as a data pump using sgp_dd to 
perform large sequential read from my target through sg devices. One 
instance of sgp_dd uses about 50% of the CPU, so running a second only 
causes the CPU to become very busy and my read performance suffers as a 
result. A third and a fourth instance only make matters worse.

I tried using sgm_dd, which is not multithreaded, to run the same test. 
Though the speed is not quite as high as sgp_dd, it only uses a small 
amount of CPU resources. That lead me to believe that either sgp_dd has 
a problem in its multi-threading or maybe the POSIX threads. I'm really 
not sure at this point what to do next.

Under Windows 2003 running IOMeter, my target can be saturated at my 
expected bandwidth across 4 FC4 ports. That shows that my target and 
server are capable of delivering the speed.

I tried both the SMP and non-SMP kernels with the same results.

Here's my configuration using the non-SMP kernel:

My target w/ 4 FC4 host ports
Dell 2850 server Dual processor 1GB memory
Fedora Core 3 Distro updated to kernel 2.6.11-1.27_FC3SMP and 
2.6.11-1.27_FC3
swap size 2GB

2 Emulex LP11000 FC4 Dual HBAs, each on independant PCI busses
Emulex driver version: 2.6-8.0.16.6_x2 compiled and installed for the 
new kernels.

uname -a
Linux  2.6.11-1.27_FC3 #1 Tue May 17 20:27:37 EDT 2005 i686 i686 i386 
GNU/Linux

gcc -v
Reading specs from /usr/lib/gcc/i386-redhat-linux/3.4.3/specs
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man 
--infodir=/usr/share/info --enable-shared --enable-threads=posix 
--disable-checking --with-system-zlib --enable-__cxa_atexit 
--disable-libunwind-exceptions --enable-java-awt=gtk 
--host=i386-redhat-linux
Thread model: posix
gcc version 3.4.3 20050227 (Red Hat 3.4.3-22.fc3)

lsscsi -g
[0:0:0:0] disk SEAGATE ST336607LC DS09 /dev/sda /dev/sg0
[0:0:6:0] process PE/PV 1x6 SCSI BP 1.0 - /dev/sg1
[14:0:0:0] disk E1.0 /dev/sdb /dev/sg2
[15:0:0:0] disk E1.0 /dev/sdc /dev/sg3
[16:0:0:0] disk E1.0 /dev/sdd /dev/sg4
[17:0:0:0] disk E1.0 /dev/sde /dev/sg5

cat /proc/scsi/sg/allow_dio
0

I tried using a value of 1 for allow_dio, but it had no effect.

Using sg3_utils-1.14

Running sgp_dd like this:
sgp_dd if=/dev/sg2 of=/dev/null bs=512 bpt=4096 thr=6 time=1

6 threads, 2M transfers, actually gives 2M commands sizes

[root@racerx proc]# cat cpuinfo
processor : 0
vendor_id : GenuineIntel
cpu family : 15
model : 4
model name : Intel(R) Xeon(TM) CPU 3.00GHz
stepping : 1
cpu MHz : 2993.167
cache size : 1024 KB
fdiv_bug : no
hlt_bug : no
f00f_bug : no
coma_bug : no
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat 
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm pni monitor 
ds_cpl cid cx16 xtpr
bogomips : 5947.39
