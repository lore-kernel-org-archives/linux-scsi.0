From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys regions [Re: 2.4 vs 2.6 versions of include/linux/ioport.h]
Date: Wed, 6 Aug 2003 15:18:27 -0400
Sender: kernel-janitor-discuss-admin@lists.sourceforge.net
Message-ID: <200308061518.27936.gene.heskett@verizon.net>
References: <200308051041.08078.gene.heskett@verizon.net> <200308061435.43458.gene.heskett@verizon.net> <20030806115035.24c8f03b.rddunlap@osdl.org>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitor-discuss-admin@lists.sourceforge.net>
In-Reply-To: <20030806115035.24c8f03b.rddunlap@osdl.org>
Content-Disposition: inline
Errors-To: kernel-janitor-discuss-admin@lists.sourceforge.net
List-Help: <mailto:kernel-janitor-discuss-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:kernel-janitor-discuss@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/kernel-janitor-discuss>,
	<mailto:kernel-janitor-discuss-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/kernel-janitor-discuss>,
	<mailto:kernel-janitor-discuss-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=kernel-janitor-discuss>
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: willy@debian.org, linux-scsi@vger.kernel.org, kernel-janitor-discuss@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Wednesday 06 August 2003 14:50, Randy.Dunlap wrote:
>On Wed, 6 Aug 2003 14:35:43 -0400 Gene Heskett
> <gene.heskett@verizon.net> wrote:
>
>...
>
>| >> | >| ----
>| >> | >| First, the define itself is missing in the 2.6 version.
>| >
>| >What define?  check_region() is still there, just as an inline
>| > function, not a macro.
>|
>| I found that later.
>|
>| >> | >| Many drivers seem to use this call, and in that which I'm
>| >> | >| trying to build, the nforce and advansys modules use it. 
>| >> | >| And while the modules seem to build, they do not run
>| >> | >| properly.
>| >
>| >Explain?  Has someone broken check_region?
>|
>| Its now marked __deprecated.  The module builds while indicating
>| the errors, but gets into a bus reset loop and hangs in the second
>| iteration of it.
>
>So the kernel driver, without mods, is broken?
>I didn't realize this earlier.

Yes.  I've said as much 2-3 times although it could have been 
ambiguous once the translation from WV to english was made. :-)

My patch I sent worked 'nominally' in that ANAICT, all functions were 
restored,  and the memory useage wandered around mainly because 
setiathome is also running, started in rc.local here.  I did not seem 
to successively lose 50k for everytime I accessed something thru the 
patched driver, but I've now added the release_region calls as you 
suggested.  I'll test it later today.

>| >> I'm not terribly interested in spending much time on this
>| >> driver, so the simplest thing to do IMO is to emulate
>| >> check_region() with pairs of request_region() and
>| >> release_region() calls.  Yes, this is still racy, just like
>| >> check_region() was.  Is that a problem in your machine
>| >> environment?
>| >
>| >I think this is the wrong thig to do.  Leaving the check_region()
>| >calls there indicate this driver still needs to be fixed
>| > properly. Replacing them with unsafe uses of request &
>| > release_region leaves the driver racy and removes the
>| > indication.
>
>--
>~Randy				For Linux-2.6, see:
>http://www.kernel.org/pub/linux/kernel/people/davej/misc/post-hallow
>een-2.5.txt

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
