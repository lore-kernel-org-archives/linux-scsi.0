From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: advansys regions [Re: 2.4 vs 2.6 versions of
 include/linux/ioport.h]
Date: Thu, 7 Aug 2003 11:42:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030807114209.49d4539c.rddunlap@osdl.org>
References: <200308051041.08078.gene.heskett@verizon.net>
	<200308070533.10408.gene.heskett@verizon.net>
	<20030807104736.A4137@infradead.org>
	<200308071434.21571.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:31203 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267517AbTHGSqN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Aug 2003 14:46:13 -0400
In-Reply-To: <200308071434.21571.gene.heskett@verizon.net>
List-Id: linux-scsi@vger.kernel.org
To: gene.heskett@verizon.net
Cc: hch@infradead.org, linux-scsi@vger.kernel.org

On Thu, 7 Aug 2003 14:34:21 -0400 Gene Heskett <gene.heskett@verizon.net> wrote:

| On Thursday 07 August 2003 05:47, Christoph Hellwig wrote:
| >On Thu, Aug 07, 2003 at 05:33:10AM -0400, Gene Heskett wrote:
| >> But I'm getting tired of repeating myself here Christoph, the
| >> driver as built in the 2.6.0-test2-mm2, whether built as a module,
| >> or in the kernel, IS BROKEN!  It gets into a bus reset loop during
| >> the init, doing 2 of them, AND LOCKS THE MACHINE UP TIGHT
| >> REQUIRING A HARDWARE RESET TO RECOVER, which of course is by
| >> rebooting back to a 2.4 kernel.
| >
| >So how do you think replacing check_region by it's opencoded version
| >is going to help you?
| 
| I have no idea if request_region is the proper replacement call 
| Christoph.  But in tests here, it did restore what appears to be 
| normal operation.
| 
| Randy Dunlop says check_region is "racy".  And I'm no kernel coder 
| unless I have complete hardware specs in front of me, which I do not.
| Which is why I'm "pestering" this list for help and hopefully some 
| nuggets of wisdom.

The real problem to be solved is why you are having problems
with the stock 2.6.0-test driver.  It uses check_region(), which
is deprecated, but that shouldn't stop it from working.
Do you have any logs of the "bus reset loop" during init?
You shouldn't have to change check_region() in the driver to
make it work.

--
~Randy				For Linux-2.6, see:
http://www.kernel.org/pub/linux/kernel/people/davej/misc/post-halloween-2.5.txt
