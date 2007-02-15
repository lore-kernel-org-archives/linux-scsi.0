From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sg version 4 tools
Date: Thu, 15 Feb 2007 08:25:52 -0800
Message-ID: <45D48990.70607@torque.net>
References: <20070214153508Z.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57334 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966070AbXBOQ0G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Feb 2007 11:26:06 -0500
In-Reply-To: <20070214153508Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> I created a git tree for makeshift sg version 4 tools:
> 
> http://www.kernel.org/git/?p=linux/kernel/git/tomo/sgv4-tools.git;a=summary
> 
> # not synchronized yet.
> 
> The interface has changed continuously (and will do). After mainline
> inclusion, Doug's sg tools support sg v4, I think. Until then, I put
> tools that I use for sg v4 development.
> 
> Currently, there is only one tool, sgv4_dd, which can read/write
> from/to a device via the bsg interface (both ioctl and the read/write
> interfaces are supported).
> 
> Here are some examples:
> 
> # ./sgv4_dd -i /dev/sdb -o /dev/null --count 2
> succeeded (read/write interface)
> 
> # ./sgv4_dd -i /dev/sdb -o /dev/null --count 2 --sgio
> succeeded (SG_IO)
> 
> # ./sgv4_dd -i /dev/zero -o /dev/sdb --count 3 --sgio
> succeeded (SG_IO)
> 
> # ./sgv4_dd -i /dev/zero -o /dev/sdb --count 3
> succeeded (read/write interface)

Tomo,
Just a few points.

While the sgv4_dd command line interface (cli) looks
sensible, it diverges from the dd command (which is
non-unix like but reasonably "fit for service" for the
function that dd performs). So even though the Unix dd
command syntax takes a while to get used to, other testers
will be most likely to be comfortable with existing dd syntax.


Of the 41 utilities in (the main directory of) sg3_utils,
29 are ported to FreeBSD and Windows. This is done by
putting a generic pass-through layer between those 29
utilities and the OS specific pass-throughs ***. The
remaining 12 utilities are either:
  a) linux specific (e.g. sg_reset and sg_map26)
  b) or a bit too complicated due to other system
     calls (e.g. sg_dd) to convert
  c) both a) and b) (e.g. sgm_dd)
The generic pass through layer is defined with bi-directional
in mind.

It also should be relatively easy to allow for two linux
specific pass-throughs (i.e. sgv3 and sgv4) so that
the common 29 utilities "just work" on either pass-through
(by compile or run time switch).


In summary, I don't think that there needs to be a
sg4_utils. As you suggest, sgv4_dd can be incorporated
into the existing sg3_utils at a convenient time.
sg v4 represents an alternate interface for a linux
pass-through and the bulk of sg3_utils already supports
4 pass-throughs via a common code base. [The four are
linux (sg v3), FreeBSD, Tru64, Windows (from NT forward).]


*** smartmontools takes the same approach and it supports
    several pass-thoughs for Windows.

Doug Gilbert



