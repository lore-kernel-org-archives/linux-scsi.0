From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [BUG] modprobe qla2300 doesn't complete
Date: Sat, 13 Mar 2004 23:33:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314063321.GA30558@colo.lackof.org>
References: <20040305041850.GA9124@colo.lackof.org> <20040305071721.GA9684@praka.local.home> <20040305172147.GB17305@colo.lackof.org> <20040309164033.GA21648@praka.local.home> <20040310221241.GA7903@colo.lackof.org> <20040312061119.GA6402@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:34979 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S263306AbUCNGd0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 01:33:26 -0500
Content-Disposition: inline
In-Reply-To: <20040312061119.GA6402@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>, Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org

On Thu, Mar 11, 2004 at 10:11:19PM -0800, Andrew Vasquez wrote:
....
> So, I'm not entirely clear on what else is going on with your
> configuration....

Me either. Since this is clearly related to a HW bug or config issue,
I'll try to track down what's "uncouth" about my setup next week.
Hopefully I can figure that out and it will be an obvious clue why
qla2xxx isn't dealing with RSCNs or whatever is going on.

> Sorry about leaving your machine in such a borked state,

np. This is a crash-n-bash machine. It has remote mgt built-in
which supports remote console and remote reset/power control.

> but, could
> you reverify the test? I don't believe we'll need any extended error
> logging, so disable DEBUG2.  If that fails, then I just may need that
> SSH access.

I reverified with latest lia64.bkbits.net/linux-ia64-2.5 tree (2.6.4)
and DEBUG2 disabled. Console output appended.

Looks like loading the patched qla2300 (rscn_handling-v8.00.00b10_2.diff)
completely locks out any disk accesses.  An existing ssh login responds
until I attempt to touch something (eg shell completion) on disk.
I can't open a new ssh session to the box.

thanks,
grant


....
ohci_hcd 0000:00:01.1: new USB bus registered, assigned bus number 3
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
drivers/usb/core/usb.c: registered new driver usb-storage
USB Mass Storage support registered.
drivers/usb/core/usb.c: registered new driver hid
drivers/usb/input/hid-core.c: v2.0:USB HID core driver
mice: PS/2 mouse device common for all mice
i8042.c: i8042 controller self test timeout.
oprofile: using timer interrupt.
NET: Registered protocol family 2
IP: routing cache hash table of 131072 buckets, 2048Kbytes
TCP: Hash tables configured (established 4194304 bind 65536)
NET: Registered protocol family 1
NET: Registered protocol family 17
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 192kB freed
INIT: version 2.85 booting
Setting disc parameters: done.
Activating swap.
Adding 1534160k swap on /dev/sdb2.  Priority:-1 extents:1
Checking root file system...
fsck 1.35-WIP (31-Jan-2004)
/dev/sdb3: clean, 570623/4194304 files, 4274589/8377897 blocks
EXT3 FS on sdb3, internal journal
System time was Sun Mar 14 05:57:13 UTC 2004.
Setting the System Clock using the Hardware Clock as reference...
System Clock set. System local time is now Sun Mar 14 05:57:15 UTC 2004.
Calculating module dependencies... done.
Loading modules...
    tg3
tg3: no version for "per_cpu__local_per_cpu_offset" found: kernel tainted.
tg3.c:v2.9 (March 8, 2004)
PCI: Found IRQ 57 for device 0000:20:02.0
IOSAPIC: vector 57 -> CPU 0x0100, enabled
eth1: Tigon3 [partno(BCM95700A6) rev 0105 PHY(5701)] (PCI:66MHz:64-bit) 10/100/1000BaseT Ethernet 00:30:6e:1e:9e:e7
PCI: Found IRQ 62 for device 0000:60:01.0
IOSAPIC: vector 62 -> CPU 0x0000, enabled
eth2: Tigon3 [partno(A6847-60001) rev 0105 PHY(serdes)] (PCI:33MHz:64-bit) 10/100/1000BaseT Ethernet 00:04:76:de:51:a4
    e1000
Intel(R) PRO/1000 Network Driver - version 5.2.30.1-k2
Copyright (c) 1999-2004 Intel Corporation.
PCI: Found IRQ 58 for device 0000:40:01.0
IOSAPIC: vector 58 -> CPU 0x0100, enabled
eth3: Intel(R) PRO/1000 Network Connection
PCI: Found IRQ 59 for device 0000:40:01.1
IOSAPIC: vector 59 -> CPU 0x0000, enabled
eth4: Intel(R) PRO/1000 Network Connection
All modules loaded.
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
Checking all file systems...
fsck 1.35-WIP (31-Jan-2004)
Setting kernel variables..
Mounting local filesystems...
Cleaning /tmp /var/run /var/lock.
Running 0dns-down to make sure resolv.conf is ok...done.
Cleaning: /etc/network/ifstate.
ip_tables: (C) 2000-2002 Netfilter core team
Aborting iptables load: unknown ruleset, "active".
Setting up IP spoofing protection: rp_filter.
Configuring network interfaces...done.
Starting portmap daemon: portmap.

Setting the System Clock using the Hardware Clock as reference...
System Clock set. Local time: Sat Mar 13 21:57:20 PST 2004

Running ntpdate to synchronize clock.
Initializing random number generator...done.
Recovering nvi editor sessions... done.
Setting up X server socket directory /tmp/.X11-unix...done.
INIT: Entering runlevel: 2
Starting system log daemon: syslogd.
Starting kernel log daemon: klogd.
Starting firewall (iptables):........ip_conntrack version 2.1 (8192 buckets, 65536 max) - 440 bytes per conntrack
.........................
..Starting NAT:........
Starting web server: Apache2tg3: eth1: Link is up at 1000 Mbps, full duplex.
tg3: eth1: Flow control is off for TX and off for RX.
.
STARTDISTCC is set to NO in /etc/default/distcc
/usr/bin/distccd not starting
Starting disk temperature monitoring daemon: disabled.
Starting internet superserver: inetd.
Starting mail transport agent: Postfix.
rsync daemon not enabled in /etc/default/rsync
Starting OpenBSD Secure Shell server: sshd.
Starting the system activity data collector: sadc.
Starting NFS common utilities: statd lockd.
Starting ProFTPD ftp daemon: proftpd.
Starting periodic command scheduler: cron.
Configuring for Hazard/etc/rc2.d/S99hazard: line 26: /tmp/hazard/rawrebind: No such file or directory
Starting S.M.A.R.T. daemon: smartd.

Debian GNU/Linux testing/unstable gsyprf3.external.hp.com ttyS0

gsyprf3.external.hp.com login: root
Password: 
Last login: Sat Mar 13 21:44:43 2004 on ttyS0
Linux gsyprf3.external.hp.com 2.6.4 #1 SMP Sat Mar 13 20:12:56 PST 2004 ia64 GNU/Linux

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
gsyprf3:~# sync
gsyprf3:~# modprobe qla2300
QLogic Fibre Channel HBA Driver (a000000200314bb0)
PCI: Found IRQ 66 for device 0000:80:01.0
IOSAPIC: vector 66 -> CPU 0x0100, enabled
qla2300 0000:80:01.0: Found an ISP2312, irq 66, iobase 0xc0000000c8041000
qla2300 0000:80:01.0: Configuring PCI space...
qla2300 0000:80:01.0: Configure NVRAM parameters...
qla2300 0000:80:01.0: Verifying loaded RISC code...
scsi(4): Verifying Checksum of loaded RISC code.
scsi(4): Checksum OK, start firmware.
scsi(4): Issue init firmware.
qla2300 0000:80:01.0: LIP reset occured (f7f7).
qla2300 0000:80:01.0: Waiting for LIP to complete...
scsi(4): Port database changed 0000 0004.
qla2300 0000:80:01.0: LOOP UP detected (2 Gbps).
scsi(4): F/W Ready - OK 
scsi(4): fw_state=3 curr time=fffed60b.
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80040
scsi(4): RSCN queue entry[0] = [00/000000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[0] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[2] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[3] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[5] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[11] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[12] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[20] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[27] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[28] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[3] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[5] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[13] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[15] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[21] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[22] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[23] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[30] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[31] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[7] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[16] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
IN=eth0 OUT= MAC=00:30:6e:1e:ce:0a:00:10:2f:6b:e8:88:08:00 SRC=63.195.118.181 DST=192.6.38.17 LEN=44 TOS=0x00 PREC=0x00 TTL=13 ID=56298 PROTO=UDP SPT=1093 DPT=38293 LEN=24 
IN=eth0 OUT= MAC=00:30:6e:1e:ce:0a:00:10:2f:6b:e8:88:08:00 SRC=63.195.118.181 DST=192.6.38.17 LEN=44 TOS=0x00 PREC=0x00 TTL=13 ID=56299 PROTO=UDP SPT=1093 DPT=38293 LEN=24 
IN=eth0 OUT= MAC=00:30:6e:1e:ce:0a:00:10:2f:6b:e8:88:08:00 SRC=63.195.118.181 DST=192.6.38.17 LEN=44 TOS=0x00 PREC=0x00 TTL=13 ID=56300 PROTO=UDP SPT=1093 DPT=38293 LEN=24 
IN=eth0 OUT= MAC=00:30:6e:1e:ce:0a:00:10:2f:6b:e8:88:08:00 SRC=63.195.118.181 DST=192.6.38.17 LEN=44 TOS=0x00 PREC=0x00 TTL=13 ID=56301 PROTO=UDP SPT=1093 DPT=38293 LEN=24 
IN=eth0 OUT= MAC=00:30:6e:1e:ce:0a:00:10:2f:6b:e8:88:08:00 SRC=63.195.118.181 DST=192.6.38.17 LEN=44 TOS=0x00 PREC=0x00 TTL=13 ID=56302 PROTO=UDP SPT=1093 DPT=38293 LEN=24 
IN=eth0 OUT= MAC=00:30:6e:1e:ce:0a:00:10:2f:6b:e8:88:08:00 SRC=63.195.118.181 DST=192.6.38.17 LEN=44 TOS=0x00 PREC=0x00 TTL=13 ID=56303 PROTO=UDP SPT=1093 DPT=38293 LEN=24 
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[17] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[27] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[28] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[6] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[13] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[15] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[21] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[22] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[28] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[30] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[6] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[7] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[14] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[22] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[23] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[31] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): RSCN database changed -- 010b 1000.
...
