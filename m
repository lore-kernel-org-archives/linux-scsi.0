From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys regions [Re: 2.4 vs 2.6 versions of include/linux/ioport.h]
Date: Thu, 7 Aug 2003 15:40:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308071540.13493.gene.heskett@verizon.net>
References: <200308051041.08078.gene.heskett@verizon.net> <200308071434.21571.gene.heskett@verizon.net> <20030807114209.49d4539c.rddunlap@osdl.org>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop015pub.verizon.net ([206.46.170.172]:18937 "EHLO
	pop015.verizon.net") by vger.kernel.org with ESMTP id S270375AbTHGTkP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 15:40:15 -0400
In-Reply-To: <20030807114209.49d4539c.rddunlap@osdl.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org

On Thursday 07 August 2003 14:42, Randy.Dunlap wrote:
>On Thu, 7 Aug 2003 14:34:21 -0400 Gene Heskett 
<gene.heskett@verizon.net> wrote:
>| On Thursday 07 August 2003 05:47, Christoph Hellwig wrote:
>| >On Thu, Aug 07, 2003 at 05:33:10AM -0400, Gene Heskett wrote:
>| >> But I'm getting tired of repeating myself here Christoph, the
>| >> driver as built in the 2.6.0-test2-mm2, whether built as a
>| >> module, or in the kernel, IS BROKEN!  It gets into a bus reset
>| >> loop during the init, doing 2 of them, AND LOCKS THE MACHINE UP
>| >> TIGHT REQUIRING A HARDWARE RESET TO RECOVER, which of course is
>| >> by rebooting back to a 2.4 kernel.
>| >
>| >So how do you think replacing check_region by it's opencoded
>| > version is going to help you?
>|
>| I have no idea if request_region is the proper replacement call
>| Christoph.  But in tests here, it did restore what appears to be
>| normal operation.
>|
>| Randy Dunlop says check_region is "racy".  And I'm no kernel coder
>| unless I have complete hardware specs in front of me, which I do
>| not. Which is why I'm "pestering" this list for help and hopefully
>| some nuggets of wisdom.
>
>The real problem to be solved is why you are having problems
>with the stock 2.6.0-test driver.  It uses check_region(), which
>is deprecated, but that shouldn't stop it from working.
>Do you have any logs of the "bus reset loop" during init?
>You shouldn't have to change check_region() in the driver to
>make it work.
>
>--
>~Randy				For Linux-2.6, see:
>http://www.kernel.org/pub/linux/kernel/people/davej/misc/post-hallow
>een-2.5.txt

I do have some logs,  and I note that anytime I try to boot a 2.6, I 
get this:
----
Jul 31 10:42:41 coyote kernel: No module found in object
Jul 31 10:42:47 coyote wall[1242]: wall: user root broadcasted 1 lines 
(50 chars)
Jul 31 10:42:48 coyote kernel: warning: process `update' used the 
obsolete bdflush system call
Jul 31 10:42:48 coyote kernel: Fix your initscripts?
Jul 31 10:42:53 coyote kernel: warning: process `update' used the 
obsolete bdflush system call
Jul 31 10:42:53 coyote kernel: Fix your initscripts?

And here is one from after I built the stocker as a module:
----
Jul 30 19:15:35 coyote kernel: scsi0 : AdvanSys SCSI 3.3GJ: PCI Ultra: 
IO 0xD000-0xD00F, IRQ 0xB
Jul 30 19:15:41 coyote kernel: advansys: advansys_reset: board 0: SCSI 
bus reset started...
Jul 30 19:15:41 coyote kernel: advansys: advansys_reset: board 0: SCSI 
bus reset successful.
Jul 30 19:15:52 coyote kernel: scsi: Device offlined - not ready after 
error recovery: host 0 channel 0 id 0 lun 0
Jul 30 19:15:52 coyote kernel:   Vendor: ARCHIVE   Model: Python 
28849-XXX  Rev: 4.CM
Jul 30 19:15:52 coyote kernel:   Type:   Sequential-Access                  
ANSI SCSI revision: 02
Jul 30 19:15:52 coyote kernel: Attached scsi tape st0 at scsi0, 
channel 0, id 1, lun 0
Jul 30 19:15:52 coyote kernel: st0: try direct i/o: yes, max page 
reachable by HBA 131056
Jul 30 19:15:52 coyote kernel: Attached scsi generic sg0 at scsi0, 
channel 0, id 1, lun 0,  type 1
Jul 30 19:15:52 coyote kernel:   Vendor: ARCHIVE   Model: Python 
28849-XXX  Rev: 4.CM
Jul 30 19:15:52 coyote kernel:   Type:   Medium Changer                     
ANSI SCSI revision: 02
Jul 30 19:15:52 coyote kernel: Attached scsi generic sg1 at scsi0, 
channel 0, id 1, lun 1,  type 8
Jul 30 19:16:00 coyote kernel: advansys: advansys_reset: board 0: SCSI 
bus reset started...
Jul 30 19:16:00 coyote kernel: advansys: advansys_reset: board 0: SCSI 
bus reset successful.
Jul 30 19:16:20 coyote kernel: scsi: Device offlined - not ready after 
error recovery: host 0 channel 0 id 6 lun 0
### there is no device at this---^^^^ address.  Now back to your 
### regularly scheduled program
Jul 30 19:17:28 coyote su(pam_unix)[3556]: session opened for user 
amanda by root(uid=0)
Jul 30 19:18:38 coyote login(pam_unix)[1235]: session opened for user 
root by LOGIN(uid=0)
Jul 30 19:18:38 coyote  -- root[1235]: ROOT LOGIN ON tty2
Jul 30 19:19:16 coyote kernel: advansys: asc_isr_callback: scp 
0xc045ac80 has bad host pointer, host 0x0
Jul 30 19:19:16 coyote kernel: st0: Block limits 1 - 16777215 bytes.
Jul 30 19:20:00 coyote su(pam_unix)[3556]: session closed for user 
amanda
Jul 30 19:30:31 coyote shutdown: shutting down for system reboot
=====

And here is the log from when I had put in request_region and built it 
as a module:
----
Aug  5 16:36:38 coyote kernel: scsi0 : AdvanSys SCSI 3.3GJ: PCI Ultra: 
IO 0xD000-0xD00F, IRQ 0xB
Aug  5 16:36:38 coyote kernel:   Vendor: ARCHIVE   Model: Python 
28849-XXX  Rev: 4.CM
Aug  5 16:36:38 coyote kernel:   Type:   Sequential-Access                  
ANSI SCSI revision: 02
Aug  5 16:36:38 coyote kernel: Attached scsi tape st0 at scsi0, 
channel 0, id 1, lun 0
Aug  5 16:36:38 coyote kernel: st0: try direct i/o: yes, max page 
reachable by HBA 131056
Aug  5 16:36:38 coyote kernel: Attached scsi generic sg0 at scsi0, 
channel 0, id 1, lun 0,  type 1
Aug  5 16:36:38 coyote kernel:   Vendor: ARCHIVE   Model: Python 
28849-XXX  Rev: 4.CM
Aug  5 16:36:38 coyote kernel:   Type:   Medium Changer                     
ANSI SCSI revision: 02
Aug  5 16:36:38 coyote kernel: Attached scsi generic sg1 at scsi0, 
channel 0, id 1, lun 1,  type 8
====
And here is where I had built that same module into the kernel, after 
I had updated the version strings and some comments in it:
----
Aug  5 17:30:16 coyote kernel: scsi0 : AdvanSys SCSI 3.4MGH: PCI 
Ultra: IO 0xD000-0xD00F, IRQ 0xB
Aug  5 17:30:16 coyote kernel:   Vendor: ARCHIVE   Model: Python 
28849-XXX  Rev: 4.CM
Aug  5 17:30:16 coyote kernel:   Type:   Sequential-Access                  
ANSI SCSI revision: 02
Aug  5 17:30:16 coyote kernel:   Vendor: ARCHIVE   Model: Python 
28849-XXX  Rev: 4.CM
Aug  5 17:30:16 coyote kernel:   Type:   Medium Changer                     
ANSI SCSI revision: 02
Aug  5 17:30:16 coyote kernel: st: Version 20030622, fixed bufsize 
32768, s/g segs 256
Aug  5 17:30:16 coyote kernel: Attached scsi tape st0 at scsi0, 
channel 0, id 1, lun 0
Aug  5 17:30:16 coyote kernel: st0: try direct i/o: yes, max page 
reachable by HBA 131056
Aug  5 17:30:16 coyote kernel: Attached scsi generic sg0 at scsi0, 
channel 0, id 1, lun 0,  type 1
Aug  5 17:30:16 coyote kernel: Attached scsi generic sg1 at scsi0, 
channel 0, id 1, lun 1,  type 8

After this particular boot I repeatedly exersized the amanda and mt 
related stuff trying to break it, but I could not.

That is the total of the 2.6.0-test2-mm2 logging as most of the time 
it hung the machine before it could generate a syslog entry and flush 
it to the media.  I presume there is a var in the headers I could set 
that would make it do a much more verbose init?

-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

