From: Ingvar Hagelund <ingvar@linpro.no>
Subject: oops in qlogicisp.c when running 2.4.27 with md RAID1 on Alpha
Date: 04 Oct 2004 13:08:08 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <ujcwty6lp0n.fsf@nfsd.linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from head.linpro.no ([80.232.36.1]:37600 "EHLO head.linpro.no")
	by vger.kernel.org with ESMTP id S267998AbUJDLIN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2004 07:08:13 -0400
Received: from nfsd.linpro.no ([80.232.36.130])
	by head.linpro.no with esmtp (Exim 4.14 #1 (Debian))
	id 1CEQhM-0005xT-Ck
	for <linux-scsi@vger.kernel.org>; Mon, 04 Oct 2004 13:08:08 +0200
Received: from ingvar by nfsd.linpro.no with local (Exim 3.35 #1 (Debian))
	id 1CEQhM-0005Nw-00
	for <linux-scsi@vger.kernel.org>; Mon, 04 Oct 2004 13:08:08 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We have a Compaq Alphaserver DS10 466 MHz running Debian Woody with a
self compiled 2.4.27 from kernel.org. We have not been able to make it
run stable on md RAID1. It always crashes in less than an hour
uptime. Running on single disks, it's rock stable. The disks are a
couple of Seagate ST373307LW. According to lspci, the scsi controller
is a "QLogic Corp. ISP1020 Fast-wide SCSI (rev 05)"

Earlier, I sent a previous version of this mail to lkml under the
subject "2.4.27: md RAID1 oops on alpha revisited", as I thought this
had something to do with the infamous md-raid1-gcc-bug. A couple of
friendly answers later, it seems clear that the problem lays within
qlogicisp.c. Therefore this repost, wich I hope reach the current
maintainers of the Qlogic ISP1020 driver. 

As the bootlog shows, we booted with degraded mirrors, and added the
other parts of the mirrors after booting. (This to make sure the box
doesn't oops till it's done booting.)

The machine locks up after the oops, so we had to run ksymoops after a
reboot without raid, but with the same kernel and same modules loaded.

Below is the oops run though ksymoops with some comments on the oops
by Ivan Kokshaysky. The oops was captured using a serial console. 

CC to Ivan and Norbert Preining who have kindly assisted me on this
problem. As Erik Moe and Michael A. Griffith are not listed in the
MAINTAINERS file, I've finally CC'ed the Linux SCSI list.

I have collected output from ver_linux, cpuinfo, meminfo, some output
from the gcc used to build the kernel, output from lsmod, lspci, and
the bootlog from dmesg. They are availble at
http://users.linpro.no/ingvar/alpha-stats.txt (Posting to the list
prohibited by message size)

Ingvar


ksymoops 2.4.5 on alpha 2.4.27-gcc334.  Options used
     -V (specified)
     -k /var/log/ksymoops/20040928000118.ksyms (specified)
     -l /var/log/ksymoops/20040928000118.modules (specified)
     -o /lib/modules/2.4.27-gcc334/ (default)
     -m /boot/System.map-2.4.27-gcc334 (default)

Warning (compare_maps): mismatch on symbol ip_conntrack_destroyed  , ip_conntrack says fffffffc00358680, /lib/modules/2.4.27-gcc334/kernel/net/ipv4/netfilter/ip_conntrack.o says fffffffc00352010.  Ignoring /lib/modules/2.4.27-gcc334/kernel/net/ipv4/netfilter/ip_conntrack.o entry
Warning (compare_maps): mismatch on symbol ip_conntrack_hash  , ip_conntrack says fffffffc003586a0, /lib/modules/2.4.27-gcc334/kernel/net/ipv4/netfilter/ip_conntrack.o says fffffffc00352030.  Ignoring /lib/modules/2.4.27-gcc334/kernel/net/ipv4/netfilter/ip_conntrack.o entry
Warning (compare_maps): mismatch on symbol ip_conntrack_htable_size  , ip_conntrack says fffffffc00358688, /lib/modules/2.4.27-gcc334/kernel/net/ipv4/netfilter/ip_conntrack.o says fffffffc00352018.  Ignoring /lib/modules/2.4.27-gcc334/kernel/net/ipv4/netfilter/ip_conntrack.o entry
Warning (compare_maps): mismatch on symbol ip_conntrack_lock  , ip_conntrack says fffffffc00358678, /lib/modules/2.4.27-gcc334/kernel/net/ipv4/netfilter/ip_conntrack.o says fffffffc00352008.  Ignoring /lib/modules/2.4.27-gcc334/kernel/net/ipv4/netfilter/ip_conntrack.o entry
Warning (compare_maps): mismatch on symbol vlan_default_dev_flags  , 8021q says fffffffc0033aaaa, /lib/modules/2.4.27-gcc334/kernel/net/8021q/8021q.o says fffffffc0033600a.  Ignoring /lib/modules/2.4.27-gcc334/kernel/net/8021q/8021q.o entry
Warning (compare_maps): mismatch on symbol vlan_group_lock  , 8021q says fffffffc0033aab8, /lib/modules/2.4.27-gcc334/kernel/net/8021q/8021q.o says fffffffc00336000.  Ignoring /lib/modules/2.4.27-gcc334/kernel/net/8021q/8021q.o entry
Warning (compare_maps): mismatch on symbol vlan_name_type  , 8021q says fffffffc0033aaa8, /lib/modules/2.4.27-gcc334/kernel/net/8021q/8021q.o says fffffffc00336008.  Ignoring /lib/modules/2.4.27-gcc334/kernel/net/8021q/8021q.o entry
Warning (compare_maps): mismatch on symbol tulip_debug  , tulip says fffffffc003326bc, /lib/modules/2.4.27-gcc334/kernel/drivers/net/tulip/tulip.o says fffffffc0032600c.  Ignoring /lib/modules/2.4.27-gcc334/kernel/drivers/net/tulip/tulip.o entry
Warning (compare_maps): mismatch on symbol tulip_max_interrupt_work  , tulip says fffffffc003326f8, /lib/modules/2.4.27-gcc334/kernel/drivers/net/tulip/tulip.o says fffffffc00326018.  Ignoring /lib/modules/2.4.27-gcc334/kernel/drivers/net/tulip/tulip.o entry
Warning (compare_maps): mismatch on symbol tulip_rx_copybreak  , tulip says fffffffc003326fc, /lib/modules/2.4.27-gcc334/kernel/drivers/net/tulip/tulip.o says fffffffc0032601c.  Ignoring /lib/modules/2.4.27-gcc334/kernel/drivers/net/tulip/tulip.o entry
Unable to handle kernel paging request at virtual address 0000000000000240
swapper(0): Oops 1
pc = [<fffffc000050da04>]  ra = [<fffffc000050da04>]  ps = 0007    Not tainted
Using defaults from ksymoops -t elf64-alpha -a alpha
v0 = 0000000000000000  t0 = 0000000000000000  t1 = fffffc000050dc10
t2 = 0000000000000000  t3 = fffffc001fdd6000  t4 = fffffc000064cdf8
t5 = fffffffffffffc18  t6 = ffffffffffffffff  t7 = fffffc0000600000
s0 = 0000000000000000  s1 = 0000000000000004  s2 = fffffc001ff86800
s3 = fffffc001ff868b8  s4 = 0000000000000004  s5 = fffffc00006eef40
s6 = 0000000000000000
a0 = fffffc001fdd60c0  a1 = 0000000000000000  a2 = fffffc0000603ec8
a3 = fffffc0000b70158  a4 = 000000011ffffa20  a5 = 0000000000000000
t8 = 000000012000e8ad  t9 = 00000200000ccf84  t10= 000000000000000b
t11= 0000000000000400  pv = fffffc000050d6b0  at = fffffc0000605000
gp = fffffc00006e1a00  sp = fffffc0000603df8
Trace:fffffc000050d6dc fffffc0000317ca4 fffffc0000318640 fffffc000031ff70 fffffc0000318c84 fffffc0000313308 fffffc00003148c0 fffffc0000320200 fffffc00003148a0 fffffc00003100a0 fffffc000031001c 
Code: 23bd4018  c3ffffc8  2ffe0000  47ff041f  2ffe0000  d3400049 <b0090240> c3ffffbd 


>>RA;  fffffc000050da04 <isp1020_intr_handler+304/420>

>>PC;  fffffc000050da04 <isp1020_intr_handler+304/420>   <=====

Trace; fffffc000050d6dc <do_isp1020_intr_handler+2c/50>
Trace; fffffc0000317ca4 <handle_IRQ_event+a4/120>
Trace; fffffc0000318640 <handle_irq+d0/190>
Trace; fffffc000031ff70 <dp264_srm_device_interrupt+30/50>
Trace; fffffc0000318c84 <do_entInt+f4/150>
Trace; fffffc0000313308 <ret_from_sys_call+0/10>
Trace; fffffc00003148c0 <cpu_idle+70/80>
Trace; fffffc0000320200 <do_check_pgt_cache+0/140>
Trace; fffffc00003148a0 <cpu_idle+50/80>
Trace; fffffc00003100a0 <rest_init+40/60>
Trace; fffffc000031001c <_stext+1c/20>

Code;  fffffc000050d9ec <isp1020_intr_handler+2ec/420>
0000000000000000 <_PC>:
Code;  fffffc000050d9ec <isp1020_intr_handler+2ec/420>
   0:   18 40 bd 23       lda  gp,16408(gp)
Code;  fffffc000050d9f0 <isp1020_intr_handler+2f0/420>
   4:   c8 ff ff c3       br   ffffffffffffff28 <_PC+0xffffffffffffff28> fffffc000050d914 <isp1020_intr_handler+214/420>
Code;  fffffc000050d9f4 <isp1020_intr_handler+2f4/420>
   8:   00 00 fe 2f       unop 
Code;  fffffc000050d9f8 <isp1020_intr_handler+2f8/420>
   c:   1f 04 ff 47       nop  
Code;  fffffc000050d9fc <isp1020_intr_handler+2fc/420>
  10:   00 00 fe 2f       unop 
Code;  fffffc000050da00 <isp1020_intr_handler+300/420>
  14:   49 00 40 d3       bsr  ra,13c <_PC+0x13c> fffffc000050db28 <isp1020_return_status+8/100>
Code;  fffffc000050da04 <isp1020_intr_handler+304/420>   <=====
  18:   40 02 09 b0       stl  v0,576(s0)   <=====
Code;  fffffc000050da08 <isp1020_intr_handler+308/420>
  1c:   bd ff ff c3       br   ffffffffffffff14 <_PC+0xffffffffffffff14> fffffc000050d900 <isp1020_intr_handler+200/420>

Kernel panic: Aiee, killing interrupt handler!

10 warnings issued.  Results may not be reliable.


Ivan Kokshaysky <ink@jurassic.park.msu.ru> writes:
> The problem seems to be in qlogic isp1020 driver, not in the RAID code.
> I've seen exactly the same oops report, but that had happened while
> writing to SCSI tape.
> 
> > Code;  fffffc000050da00 <isp1020_intr_handler+300/420>
> >   14:   49 00 40 d3       bsr  ra,13c <_PC+0x13c> fffffc000050db28 <isp1020_return_status+8/100>
> > Code;  fffffc000050da04 <isp1020_intr_handler+304/420>   <=====
> >   18:   40 02 09 b0       stl  v0,576(s0)   <=====
> 
> It's the line 1052 in drivers/scsi/qlogicisp.c:
> 
> 		if (sts->hdr.entry_type == ENTRY_STATUS)
> 			Cmnd->result = isp1020_return_status(sts);
> 
> The "Cmnd" pointer happened to be a NULL somehow...



-- 
Many that live deserve death. And some that die deserve life. Can you
give it to them? Then do not be too eager to deal out death in
judgement. For even the very wise cannot see all ends.
								Gandalf
