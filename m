From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys driver vs 2.6 breakage
Date: Mon, 11 Aug 2003 09:31:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308110931.04221.gene.heskett@verizon.net>
References: <20030810224402.5c7fa063.rddunlap@osdl.org>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop016pub.verizon.net ([206.46.170.173]:46491 "EHLO
	pop016.verizon.net") by vger.kernel.org with ESMTP id S272570AbTHKNbH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 09:31:07 -0400
In-Reply-To: <20030810224402.5c7fa063.rddunlap@osdl.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: rddunlap@osdl.org, willy@debian.org

On Monday 11 August 2003 01:44, Randy.Dunlap wrote:
>Gene,
>
>This patch should make the advansys driver build on 2.6.0-test3
>after you #define ADVANSYS_DEBUG so that run-time debug output
>can be generated.
>
>--
>~Randy

I've applied that patch, and the ide_scsi patch in the previous 
message, and have it under reconstruction now with ide-scsi also 
turned on, and atapi-cd stuffs turned off as no writer soft could 
find my burner.

One more question though.  I have a script that appends about 100 megs 
worth of stuff to the end of the tape amanda generates, doing it in 2 
more files written with dd.  After kicking up the nice to -10 on all 
the amanda stuff, it did finish in a bit over 4 hours, about an hour 
longer than usual.  But then the extra script reported 4 lines of
/dev/nst0 input/output error
instead of success.

Since that script is run as the user amanda, I'm wondering if the 
device perms are treated differently for 2.6.x?  Its (/dev/nst0) 
owned by root:disk and dated a year ago now.

I've reloaded that tape, and doing an seod on it now, to see if root 
can write those files.  Odd, the seod went to block 115600, the error 
report said:
DailySet1-22 <---the tape label-number
At block 105210.  <-----------it uses this to see if the tape has 
available space, there is plenty
tar: Removing leading `/' from member names
tar: Removing leading `/' from member names
/dev/nst0: Input/output error
/dev/nst0: Input/output error
/dev/nst0: Input/output error
/dev/nst0: Input/output error

and as root, the first of those files is writing now...
and as amanda, the second file also wrote just fine??????

But here is another head-scratcher; mt status said file=49, which is 
correct if no additional data was written.  But now, after writing 2 
more files, status says file=53!  We've got a snilmerg. sure as heck.

No, wait, damned dummy Gene, that was the wrong tape, that one was 21!
Repeat after loading 22.  Humm, did that, now dd is a zombie and 
cannot be killed, even after killing its parent console.  Reboot time 
I guess, which will bring in the debugging as thats now built.

A cat of /proc/interrupts:
           CPU0
  0:   36601029          XT-PIC  timer
  1:      22850          XT-PIC  i8042
  2:          0          XT-PIC  cascade
  3:         34          XT-PIC  serial
  4:     159952          XT-PIC  serial
  5:          0          XT-PIC  btaudio
  9:     406838          XT-PIC  uhci-hcd, uhci-hcd, uhci-hcd
 11:    2226206          XT-PIC  advansys, nvidia
 12:     120257          XT-PIC  VIA8233, eth0
 14:     240933          XT-PIC  ide0
 15:    1324916          XT-PIC  ide1
NMI:          0
LOC:   36603425
ERR:      30639
MIS:          0

Any ideas what might be at work there?  Do I need to sleep to let the 
drives buffer flush?  I would think the time that script takes to tar 
up those 2 files, a bit over 86 megs, would handle that.

Again, many thanks for the patch.  I assume the output will goto 
syslog (/var/log/messages) as usual?

[snip patch]

-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

