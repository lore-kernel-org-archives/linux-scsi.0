From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: dc395x: CD writer causes endless "sg_to_virt failed" loop
Date: Sun, 28 Mar 2004 02:10:34 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040327161034.GA9963@twibble.org>
References: <c444p3$b3v$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:41954 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S261802AbUC0QKk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Mar 2004 11:10:40 -0500
Content-Disposition: inline
In-Reply-To: <c444p3$b3v$1@sea.gmane.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Schulman <andrex@alumni.utexas.net>
Cc: linux-scsi@vger.kernel.org, dc395x@twibble.org

On Sat, Mar 27, 2004 at 09:57:39AM -0500, Andrew Schulman wrote:
> I have a Tekram DC395UW card, running in Debian with kernel 2.6.3 and the
> dc395x driver from the kernel source.  Attached to the card are a Seagate
[...]
> by, for example, trying to mount or burn a CD-- my console and syslog
> begin to fill up with "dc395x: sg_to_virt failed!" messages-- several

Yeah, this has been reported a few months back for the original
driver in 2.4. I *think* I found and fixed what would have caused
this problem in the latest version included in 2.6 but since no one
has ever seen this issue in 2.6 it's been difficult to be certain.

[...]
> I'm frustrated by this problem because the drive worked fine with earlier
> kernels.  It definitely worked fine with 2.6.0-test4 and -test9.  I don't

There has been no changes to the in kernel dc395x driver between
2.6.0-test4 and 2.6.3.

> want to go back to an earlier kernel, because of other security and
> hardware issues.  My 2.6.3 kernel works perfectly, except that now my CD
> writer is broken.
> 
> Any help would be much appreciated.  I'm willing to try any patches or
> diagnostics.

First thing to try would be to upgrade to 2.6.5-rc1 (or newer) and
see if that works any better.

If it still has issues then you should edit drivers/scsi/dc395x.c and
uncomment the first "#define DEBUG_MASK" line, rebuild the dc395x
module and then reload the module. You should then gets lots of
debugging output in one of your log file which you can then gzip or
bzip2 and then send directly to me.

-- 
 Jamie Lenehan <lenehan@twibble.org>
