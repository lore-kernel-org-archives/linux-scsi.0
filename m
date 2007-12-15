From: "John Stoffel" <john@stoffel.org>
Subject: Re: 2.6.24-rc5-mm1:  kernel BUG at include/linux/scatterlist.h:59!
Date: Sat, 15 Dec 2007 12:49:08 -0500
Message-ID: <18276.5012.22786.410453@stoffel.org>
References: <18275.3156.745358.12056@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mycroft.westnet.com ([216.187.52.7]:62610 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbXLORtK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Dec 2007 12:49:10 -0500
In-Reply-To: <18275.3156.745358.12056@stoffel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


John> Just fired up 2.6.24-rc5-mm1 on a Dual CPU PIII 550mhz system
John> with 2gb of RAM.  Got the following error.  Let me know if you
John> need more details or want me to run tests or make changes.
John> Looks like something in the SCSI st driver, which makes sense
John> since I have a pair of DLT 7k drives hooked upto this system via
John> a Symbios PCI card.  I've also got a P1000 jukebox on there as
John> well.

John>   [  354.338667] kernel BUG at include/linux/scatterlist.h:59!
John>   [  354.403311] invalid opcode: 0000 [#1] SMP 
John>   [  354.452774] last sysfs file:
John>   /sys/devices/pci0000:00/0000:00:0d.1/host3/target3:0:3/3:0:3:0/vendor
John>   [  354.560099] Modules linked in:
John>   [  354.596859] 
John>   [  354.614753] Pid: 1795, comm: stinit Not tainted (2.6.24-rc5-mm1 #3)
John>   [  354.689825] EIP: 0060:[<c0356bd0>] EFLAGS: 00010213 CPU: 0
John>   [  354.755538] EIP is at st_do_scsi+0x2e0/0x340
John>   [  354.806668] EAX: 00000000 EBX: 00000000 ECX: c16e1f80 EDX: f7f87050
John>   [  354.881731] ESI: f7f877d0 EDI: 00001000 EBP: f7f87000 ESP: f7167db0
John>   [  354.956788]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
John>   [  355.021452] Process stinit (pid: 1795, ti=f7167000 task=f74d7030
John>   task.ti=f7167000)
John>   [  355.110028] Stack: 00000003 f7f87050 00000000 00000000 00d59f80
John>   00000000 f75cf9e0 c0359840 
John>   [  355.211879]        000000d0 f7167e54 f7d2bc00 f75cf9e0 f7d2bc18
John>   00000000 00000006 f7167e54 
John>   [  355.313757]        f7d2bc00 f7167e64 f7f87000 c0358730 00000006
John>   00000002 000dbba0 00000000 
John>   [  355.415639] Call Trace:
John>   [  355.447258]  [<c0359840>] st_sleep_done+0x0/0x70
John>   [  355.502773]  [<c0358730>] check_tape+0x510/0x640
John>   [  355.558284]  [<c0359c9b>] st_open+0x18b/0x220
John>   [  355.610677]  [<c0171850>] exact_match+0x0/0x10
John>   [  355.664113]  [<c0359b10>] st_open+0x0/0x220
John>   [  355.714429]  [<c0171f2f>] chrdev_open+0x9f/0x190
John>   [  355.769945]  [<c0171e90>] chrdev_open+0x0/0x190
John>   [  355.824418]  [<c016d685>] __dentry_open+0xb5/0x2a0
John>   [  355.882013]  [<c01762cb>] permission+0xdb/0x100
John>   [  355.936486]  [<c016d937>] nameidata_to_filp+0x47/0x60
John>   [  355.997200]  [<c017985d>] open_pathname+0x17d/0x740
John>   [  356.055831]  [<c011fa10>] update_curr+0x80/0x110
John>   [  356.111345]  [<c0123792>] scheduler_tick+0xe2/0x130
John>   [  356.169979]  [<c0177765>] getname+0xa5/0xc0
John>   [  356.220294]  [<c016d4bc>] do_sys_open+0x4c/0xe0
John>   [  356.274770]  [<c016d58c>] sys_open+0x1c/0x20
John>   [  356.326123]  [<c0103f6e>] syscall_call+0x7/0xb
John>   [  356.379559]  =======================
John>   [  356.422393] Code: 32 8b 54 24 28 89 44 24 2c 89 50 74 e9 ba fd ff ff 0f 0b eb fe 8d b6 00 00 00 00 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 8d 74 26 00 <0f> 0b eb fe 0f 0b eb fe 64 a1 00 50 6e c0 8b 40 04 8b 40 08 a8 
John>   [  356.661693] EIP: [<c0356bd0>] st_do_scsi+0x2e0/0x340 SS:ESP
John>   0068:f7167db0


Just to add some additional information, when I use Bacula to load a
new tape into a drive (using mtx really) I get yet another BUG on all
my screens:

jfsnew kernel: [60861.268812] ------------[ cut here ]------------
 jfsnew kernel: [60861.388789] invalid opcode: 0000 [#2] SMP 
 jfsnew kernel: [60861.438055] last sysfs file:
/sys/devices/pci0000:00/0000:00:13.0/0000:03:0e.0/local_cpus
 jfsnew kernel: [60862.019200] Process mt (pid: 8860, ti=c6967000
task=c6908570 task.ti=c6967000)
 jfsnew kernel: [60862.103613] Stack: 00000003 f745e050 00000000
00000000 00d59f80 00000000 f135bd60 c0359840 
 jfsnew kernel: [60862.204859]        000000d0 c6967e54 f7d2b600
f135bd60 f7d2b618 00000000 00000006 c6967e54 
 jfsnew kernel: [60862.305804]        f7d2b600 c6967e64 f745e000
c0358730 00000006 00000002 000dbba0 00000000 
 jfsnew kernel: [60862.406746] Call Trace:
 jfsnew kernel: [60862.438156]  [<c0359840>] st_sleep_done+0x0/0x70
 jfsnew kernel: [60862.493665]  [<c0358730>] check_tape+0x510/0x640
 jfsnew kernel: [60862.549179]  [<c0359c9b>] st_open+0x18b/0x220
 jfsnew kernel: [60862.601572]  [<c0359b10>] st_open+0x0/0x220
 jfsnew kernel: [60862.651886]  [<c0171f2f>] chrdev_open+0x9f/0x190
 jfsnew kernel: [60862.707402]  [<c0171e90>] chrdev_open+0x0/0x190
 jfsnew kernel: [60862.761876]  [<c016d685>] __dentry_open+0xb5/0x2a0
 jfsnew kernel: [60862.819469]  [<c01762cb>] permission+0xdb/0x100
 jfsnew kernel: [60862.873946]  [<c016d937>]
nameidata_to_filp+0x47/0x60
 jfsnew kernel: [60862.934659]  [<c017985d>] open_pathname+0x17d/0x740
 jfsnew kernel: [60862.993292]  [<c015d85f>]
handle_mm_fault+0xff/0x580
 jfsnew kernel: [60863.052966]  [<c0177765>] getname+0xa5/0xc0
 jfsnew kernel: [60863.103277]  [<c016d4bc>] do_sys_open+0x4c/0xe0
 jfsnew kernel: [60863.157752]  [<c016d58c>] sys_open+0x1c/0x20
 jfsnew kernel: [60863.209110]  [<c0103f6e>] syscall_call+0x7/0xb
 jfsnew kernel: [60863.262544]  [<c04e0000>]
sunrpc_cache_update+0x140/0x180
 jfsnew kernel: [60863.327413]  =======================
 jfsnew kernel: [60863.370246] Code: 32 8b 54 24 28 89 44 24 2c 89 50
74 e9 ba fd ff ff 0f 0b eb fe 8d b6 00 00 00 00 0f 0b eb fe 0f 0b eb
fe 0f 0b eb fe 8d 74 26 00 <0f> 0b eb fe 0f 0b eb fe 64 a1 00 50 6e c0
8b 40 04 8b 40 08 a8 
 jfsnew kernel: [60863.602895] EIP: [<c0356bd0>]
st_do_scsi+0x2e0/0x340 SS:ESP 0068:c6967db0

I wonder if this has something to do with sysfs stuff that Greg and
crew have been working on?  I'll try dropping back to 2.6.24-rc5 once
I get my backup done.

Hmm... now I can't even see any of my tape drives at all, even using
mt from the command line.  Oh well, time to reboot into plain
2.6.24-rc5 and see how it goes.

John
