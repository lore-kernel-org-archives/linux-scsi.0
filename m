From: Poul Petersen <petersp@roguewave.com>
Subject: What's the "right" qla2100 driver?
Date: Wed, 21 Jan 2004 16:32:23 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F888C30C3021D411B9DA00B0D0209BE8038F9BD1@cvo-exchange.cvo.roguewave.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cvo-ext.roguewave.com ([12.22.36.198]:8422 "EHLO
	cvo-exchange.cvo.roguewave.com") by vger.kernel.org with ESMTP
	id S266152AbUAVAc6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2004 19:32:58 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

	I've got a Qlogic qla2100 card connected via copper to an array
of 28 ~18GB disks. I'm trying to create two raid level 5 md devices with
13disk+1spare each. What I'm experiencing is a lot of hangs and strange
disk failures that appear to be related to the drivers for the 2100. As
there 
seems to be many different drivers to choose from for the qla2100, I've
tried them all and collected my (all bad) experiences, a summary of which I 
have attached below. 

	What I am wondering is if anyone else is using this card with Linux
and if so what driver are they using? More importantly, which driver is
actively being worked on (if any) so that I might contribute some failure
information? 

	It's possible that I am experiencing a hardware problem, since these
disks
and controller are a few years old now, but I doubt it since most of the
errors
seem inconsistent with bad hardware (all disks failing, etc). If nothing
else,
if I get feedback saying that someone else is successfully using a certain
driver, then I can start playing with hardware using the same driver and
maybe
get to the bottom of this...

Many thanks for any help,

-poul

Oh, machine specs:

Dell Optiplex GX110
PIII-1GHz w/ 260MB RAM
RedHat 9


Summary of tests results:

---
Test #1
kernel 2.4.24 with kernel qlogicfc driver
---

# modprobe qlogicfc
# mkraid /dev/md0

At this point the system hangs with:

qlogicfc0: no handle slots, this should not happen
hostdata->queued is 58, in_ptr: 77

---
Test #2
kernel 2.4.24 with Qlogic 4.46.12b
---

I am unable to find a recent driver on the Qlogic site as support for
this card has been discontinued. I just happened to have this 4.x
series driver around.

# modprobe qla2x00
# mkraid /dev/md0
# mkraid /dev/md1

# cat /proc/mdstat | grep speed

      [=>...................]  resync =  5.1% (904396/17671424)
finish=7654.5min speed=35K/sec
      [====>................]  resync = 22.1% (3919392/17671424)
finish=34.8min speed=6577K/sec

The driver seems to work, but the ability of the driver to balance requests
between the two
raid sets seems very poor. Watching the activity lights reflects the stats
showed above: the
second raid set blinks once or twice, then hangs for 5~10 seconds, blinks,
hangs, etc.
I haven't tried running with this driver much longer than the mkraid...

---
Test #3
kernel 2.4.24 with kernel qlogicfc driver + backported patches
---

	In doing a bunch of google searching, I found the following threads
that seem to be related
to the "no handle slots" problem:

http://www.ussg.iu.edu/hypermail/linux/kernel/0101.2/0267.html
http://groups.google.com/groups?selm=linux.scsi.1019759258.2413.1.camel%40lv
adp.fc.hp.com

	Since one of these patches was for a 2.5 kernel, I "massaged" the
patch into the 2.4.24
kernel.

# modprobe qlogicfc
# mkraid /dev/md0
# mkraid /dev/md1

	The resync operation got to about 1% done, then stopped. Cat
/proc/mdstat shows no activity.
dd if=/dev/sda of=/dev/null shows disk is still responsive. MD is hung.
Strange.

---
Test #4
2.6.1 with kernel qlogicfc driver
---

# modprobe qlogicfc
# mkraid /dev/md0

qlogicfc0: no handle slots, this should not happen
hostdata->queued is 49, in_ptr: f8

	Same as 2.4.24 qlogicfc driver (Test #2)

---
Test #5
2.6.1 with sourceforge qlogic driver 8.00.00.b8 (
http://sourceforge.net/projects/linux-qla2xxx/ )
---

# modprobe qla2xxx
# mkraid /dev/md0
# mkraid /dev/md1
# mkfs.ext3 /dev/md0

 	After awhile, the mkfs hung and when I tried to reboot the machine,
I got a bunch of errors like the following for all 28 disks:

qla2xxx_eh_abort scsi(1:0:12:0) cmd_timeout_in_sec=0x1e.
qla2xxx_eh_abort Exiting: status=Failed

---
Test #6
RHAS 2.1 Update 3 kernel (2.4.9-e3)
---

# modprobe qlogicfc
# mkraid /dev/md0

At this point the system hangs with a bunch of:

qlogicfc0: no handle slots, this should not happen
hostdata->queued is 58, in_ptr: 77

etc.

	So, the RedHat kernel qlogicfc driver appears to be no more
functional than the
2.4.24 driver.


---
Test #7
RHAS 2.1 Update 3 kernel (2.4.9-e3) + patches from Test #3
---

# modprobe qlogicfc
# mkraid /dev/md0
# mkraid /dev/md1
# mkfs.ext3 /dev/md0

	This has been the most successful test setup, but the machine has
revealed strange behavior under load tests. At one point issuing a "raidstop
/dev/md0" led to a kernel panic. Another time, tar-copying 100GB of data
began failing disks. Pretty weird stuff.

---
2.6.1 with qlogicfc + patches from Test #3
---

# modprobe qlogicfc
# mkraid /dev/md0
# mkraid /dev/md1
# mkfs.ext3
 
	At this point, the machine hung with no error messages. 

