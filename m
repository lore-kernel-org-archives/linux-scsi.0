From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys driver vs 2.6 breakage
Date: Wed, 13 Aug 2003 22:51:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308132251.19841.gene.heskett@verizon.net>
References: <20030810224402.5c7fa063.rddunlap@osdl.org> <200308120328.38835.gene.heskett@verizon.net> <20030813132526.465b646e.rddunlap@osdl.org>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop015pub.verizon.net ([206.46.170.172]:19091 "EHLO
	pop015.verizon.net") by vger.kernel.org with ESMTP id S272168AbTHNCvW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Aug 2003 22:51:22 -0400
In-Reply-To: <20030813132526.465b646e.rddunlap@osdl.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, willy@debian.org

On Wednesday 13 August 2003 16:25, Randy.Dunlap wrote:
>On Tue, 12 Aug 2003 03:28:38 -0400 Gene Heskett 
<gene.heskett@verizon.net> wrote:
>| On Monday 11 August 2003 17:34, Randy.Dunlap wrote:
>| >On Mon, 11 Aug 2003 17:29:04 -0400 Gene Heskett
>|
>| <gene.heskett@verizon.net> wrote:
>| >| On Monday 11 August 2003 01:44, Randy.Dunlap wrote:
>| >| >Gene,
>| >| >
>| >| >This patch should make the advansys driver build on
>| >| > 2.6.0-test3 after you #define ADVANSYS_DEBUG so that run-time
>| >| > debug output can be generated.
>| >| >
>| >| >--
>| >|
>| >| Ok Randy, I have some logs, stripped down to about 1650 lines
>| >| from just under half a million.
>| >|
>| >| Should I send them privately?
>| >
>| >How many bytes?  If <= roughly 60 KB, I'd say just post them
>| > here.
>|
>| I've done some more trimming, taking it down to a single bootup as
>| a module, and its now 58k, so its attached.
>
>Gene,
>
>Both the 2.4 and 2.6 logs show lots of successful IOs and a few
>IO errors.  The IO errors look like this in both of them:
>
>Aug 11 13:48:28 coyote kernel: asc_isr_callback: QD_WITH_ERROR
>Aug 11 13:48:28 coyote kernel: asc_isr_callback: host_stat 0x11
>
>This is a timeout as I read the source file.
>Maybe I'm misreading the logs, but I don't see any other errors
>being reported.  What are the symptoms of the errors that you are
>seeing on 2.6.0-test?

Further report:

I rebooted to 2.6.0-test3-mm2 before I sent the last message, and now 
I'm back, the lawn mower taking too long to diagnose, I hit and 
buried the blade in the edge of a 2x12.  I've seperated things and 
put them back together, but the engine acts as if the decompressor is 
stuck on, virtually no compression.  And I have to cut the grass one 
last time before I head for Grand Junction Co. about monday.  Busy 
day tommorrow I suspect.

Anyway, I came by and changed the tapes, then launched an "su amanda 
-c 'amcheck DailySet1'", which sat there for several minutes without 
touching the tape drive or the changer.

Killing that, an "mtx -f /dev/sg1 load 1" did load that tape.
Then an "su amanda -c 'amcheck DailySet1'" found the tape as that was 
the correct tape.  So I had amtape load from slot 3, which worked, 
then reran amcheck which proceeded to scan the magazine and find the 
right tape for tonight.  So I'm a bit puzzled at the failure, 
followed by 100% success since.  Debugging isn't on unforch so 
there's not a thing in messages.

However I am seeing this in /var/log/messages, which looks like I need 
to update my initscripts or something?

Aug 13 19:01:16 coyote kernel: warning: process `update' used the 
obsolete bdflush system call
Aug 13 19:01:16 coyote kernel: Fix your initscripts?
Aug 13 19:01:21 coyote kernel: warning: process `update' used the 
obsolete bdflush system call
Aug 13 19:01:21 coyote kernel: Fix your initscripts?

As that would be something near the end of rc.local, here is the last 
few lines of that:
---------------------
mt -f /dev/nst0 setblk 32768
mt -f /dev/nst0 defblksize 32768
heyu setclock 2>&1 >> /var/log/heyu.log
heyu monitor 2>&1 >> /var/log/heyu.log &
echo Starting OSS sound
/usr/lib/oss/soundon
heyu turn a14 off
LATITUDE="39:41"
LONGITUDE="80:17"
export LATITUDE LONGITUDE
echo LATITUDE=$LATITUDE LONGITUDE=$LONGITUDE
xtend -f /etc/.xtendrc &
echo Starting Setibatch
rm -f /root/seti/pid.sah /root/seti/lock.sah 
rm -f /root/seti-units/.setibatch.pid
sh /root/bin/setibatch -run & 2&>1 >/dev/null &
sleep 3
ps -ea |grep seti
ps -ea |grep heyu
ps -ea |grep xtend
sleep 3 # so we can read any messages still on screen
----------------------

Also from dmesg, this:
Kernel command line: ro root=/dev/hda3 hdc=ide-scsi noapic vga=791
ide_setup: hdc=ide-scsi
Found and enabled local APIC!

and

scsi0 : AdvanSys SCSI 3.3GJ: PCI Ultra: IO 0xD000-0xD00F, IRQ 0xB
  Vendor: ARCHIVE   Model: Python 28849-XXX  Rev: 4.CM
  Type:   Sequential-Access                  ANSI SCSI revision: 02
  Vendor: ARCHIVE   Model: Python 28849-XXX  Rev: 4.CM
  Type:   Medium Changer                     ANSI SCSI revision: 02
scsi1 : SCSI host adapter emulation for IDE ATAPI devices
  Vendor: CREATIVE  Model: CD-RW RW1210E     Rev: LCS6
  Type:   CD-ROM                             ANSI SCSI revision: 02
st: Version 20030622, fixed bufsize 32768, s/g segs 256
Attached scsi tape st0 at scsi0, channel 0, id 1, lun 0
st0: try direct i/o: yes, max page reachable by HBA 131072
Attached scsi generic sg0 at scsi0, channel 0, id 1, lun 0,  type 1
Attached scsi generic sg1 at scsi0, channel 0, id 1, lun 1,  type 8
Attached scsi generic sg2 at scsi1, channel 0, id 0, lun 0,  type 

Since it had already found the cdrom at /dev/hdc, I assume the writer 
then is /dev/sg2.  I believe its 'out of order' as the writer used to 
be /dev/sg0.  So why is it finding the tape drive at sg0?  Thats new, 
I never had an sg2 before.

That probably has a good explanation, but I've not heard it yet. :)

For future comparisons, last nights run of amanda took 247 minutes 
total, running 2.4.22-rc2.

Other than that first time failure, I think now it might be able to 
live till someone gets on a good horse and goes on a search and 
destroy mission for the deprecated check_region() call all the way 
thru the system.  There's some of that in the i2c stuffs too, which 
although I'm building it, isn't working, and neither of the 2.7.0 or 
2.8.0 versions of i2c or lm_sensors will even build for 2.6.  

Something that might not happen before 2.6.8 maybe?  Heck, even that 
first time failure, then it works the next time might be a clue that 
something isn't properly initialized?

Next Q:  Has anyone managed to make their sound work (other than the 
beeper speaker) when its used to being driven by oss?  Its a via 
8233, ac97 compatible chipset on this biostar M7VIB board.  Oss 
refuses to build for 2.6.  A sample .config from a working 2.6 system 
would be super nice. :)

Thanks for the hand holding Randy, its certainly appreciated.  More 
later.

-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

