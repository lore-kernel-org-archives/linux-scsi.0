From: Gene Heskett <gene.heskett@verizon.net>
Subject: advansys driver vs 2.6 breakage
Date: Thu, 7 Aug 2003 04:22:41 -0400
Sender: kernel-janitor-discuss-admin@lists.sourceforge.net
Message-ID: <200308070422.41412.gene.heskett@verizon.net>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitor-discuss-admin@lists.sourceforge.net>
Content-Disposition: inline
Errors-To: kernel-janitor-discuss-admin@lists.sourceforge.net
List-Help: <mailto:kernel-janitor-discuss-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:kernel-janitor-discuss@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/kernel-janitor-discuss>,
	<mailto:kernel-janitor-discuss-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/kernel-janitor-discuss>,
	<mailto:kernel-janitor-discuss-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=kernel-janitor-discuss>
To: bfrey@turbolinux.com.cn
Cc: linux-scsi@vger.kernel.org, Janitors <kernel-janitor-discuss@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

Greetings Bob;

The advansys.c driver appears to have been broken by a change in the 
check_region() define in include/linux/ioports.h

The symptoms are:  on initing the module during bootup, or during a 
later insmod if built as a module, it gets into a bus reset loop and 
hangs the machine, requireing a hardware reset after reporting 
success on the second bus reset.

I had some success by replacing the two calls to check_region with 
request_region, in that the bus resets were gone and it did find my 
tape drive and its robot just fine.

However, others seemed to think it also needed a balancing call to 
release_region(), but that brought back the bus resets AND it 
couldn't find the tape drive or robot during the init, so I was back 
to square one minus 2 steps.

As you are probably 100x more famiiar with this code than I'll ever 
be, can you find the time to look it over again, making it compatible 
with 2.6.0-test2-mm2?

This is, FWIW, not the only code that is apparently broken by that 
ioports.h header redefinition.

I'm getting messages from other modules squawking about the 
__deprecated status of "check_region" during the compile too.

-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.



-------------------------------------------------------
This SF.Net email sponsored by: Free pre-built ASP.NET sites including
Data Reports, E-commerce, Portals, and Forums are available now.
Download today and enter to win an XBOX or Visual Studio .NET.
http://aspnet.click-url.com/go/psa00100003ave/direct;at.aspnet_072303_01/01
