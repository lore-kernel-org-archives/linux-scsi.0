From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys regions [Re: 2.4 vs 2.6 versions of include/linux/ioport.h]
Date: Wed, 6 Aug 2003 14:35:43 -0400
Sender: kernel-janitor-discuss-admin@lists.sourceforge.net
Message-ID: <200308061435.43458.gene.heskett@verizon.net>
References: <200308051041.08078.gene.heskett@verizon.net> <20030806104041.4a09f4f0.rddunlap@osdl.org> <20030806175954.GX22222@parcelfarce.linux.theplanet.co.uk>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitor-discuss-admin@lists.sourceforge.net>
In-Reply-To: <20030806175954.GX22222@parcelfarce.linux.theplanet.co.uk>
Content-Disposition: inline
Errors-To: kernel-janitor-discuss-admin@lists.sourceforge.net
List-Help: <mailto:kernel-janitor-discuss-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:kernel-janitor-discuss@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/kernel-janitor-discuss>,
	<mailto:kernel-janitor-discuss-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/kernel-janitor-discuss>,
	<mailto:kernel-janitor-discuss-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=kernel-janitor-discuss>
To: Matthew Wilcox <willy@debian.org>, "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, Janitors <kernel-janitor-discuss@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 06 August 2003 13:59, Matthew Wilcox wrote:
>On Wed, Aug 06, 2003 at 10:40:41AM -0700, Randy.Dunlap wrote:
>> | On Tuesday 05 August 2003 10:57, Randy.Dunlap wrote:
>> | >On Tue, 5 Aug 2003 10:41:08 -0400 Gene Heskett
>> |
>> | <gene.heskett@verizon.net> wrote:
>> | >| Greetings;
>> | >|
>> | >| In the 2.4 includes, find this in ioport.h
>> | >| ----
>> | >| /* Compatibility cruft */
>> | >| #define check_region(start,n)  
>> | >| __check_region(&ioport_resource, (start), (n))
>> | >| [snip]
>> | >| extern int __check_region(struct resource *, unsigned long,
>> | >| unsigned long);
>> | >| ----
>> | >| But in the 2.6 version, find this:
>> | >| ----
>> | >| /* Compatibility cruft */
>> | >| [snip]
>> | >| extern int __check_region(struct resource *, unsigned long,
>> | >| unsigned long);
>> | >| [snip]
>> | >| static inline int __deprecated check_region(unsigned long s,
>> | >| unsigned long n)
>> | >| {
>> | >|         return __check_region(&ioport_resource, s, n);
>> | >| }
>> | >| ----
>> | >| First, the define itself is missing in the 2.6 version.
>
>What define?  check_region() is still there, just as an inline
> function, not a macro.
>
I found that later.

>> | >| Many drivers seem to use this call, and in that which I'm
>> | >| trying to build, the nforce and advansys modules use it.  And
>> | >| while the modules seem to build, they do not run properly.
>
>Explain?  Has someone broken check_region?

Its now marked __deprecated.  The module builds while indicating the 
errors, but gets into a bus reset loop and hangs in the second 
iteration of it.

>
>> I'm not terribly interested in spending much time on this driver,
>> so the simplest thing to do IMO is to emulate check_region() with
>> pairs of request_region() and release_region() calls.  Yes, this
>> is still racy, just like check_region() was.  Is that a problem
>> in your machine environment?
>
>I think this is the wrong thig to do.  Leaving the check_region()
>calls there indicate this driver still needs to be fixed properly.
>Replacing them with unsafe uses of request & release_region leaves
> the driver racy and removes the indication.

What do you suggest doing?

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
