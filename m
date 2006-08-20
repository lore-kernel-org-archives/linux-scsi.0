From: Andrew Morton <akpm@osdl.org>
Subject: Re: ybin on powerpc
Date: Sat, 19 Aug 2006 18:28:18 -0700
Message-ID: <20060819182818.bf3ff5bc.akpm@osdl.org>
References: <20060819111919.a60dca49.akpm@osdl.org>
	<1156024644.5803.73.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:34225 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750754AbWHTB23 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 21:28:29 -0400
In-Reply-To: <1156024644.5803.73.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org


(cc's added)

On Sun, 20 Aug 2006 07:57:24 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Sat, 2006-08-19 at 11:19 -0700, Andrew Morton wrote:
> > I notice that 2.6.18-rc4-mm1 and 2.6.18-rc4-mm2-candidate do this:
> > 
> > g5:/home/akpm> 0 ybin
> > ofpath: /dev/sdb: Device not configured
> > ybin: Unable to find OpenFirmware path for boot=/dev/sdb2
> > ybin: Please add ofboot=<path> where <path> is the OpenFirmware path to /dev/sdb2 to /etc/yaboot.conf
> > ofpath: /dev/sdb: Device not configured
> > ybin: Unable to determine OpenFirmware path for macosx=/dev/sdb3
> > ybin: Try specifying the real OpenFirmware path for macosx=/dev/sdb3 in /etc/yaboot.conf
> 
> Did the layout of scsi stuff in either /proc or sysfs change ?

Bisection shows that this brokenness is introduced by git-scsi-misc.patch.

Someone has gone in and made some ill-advised "improvements" to
/proc/scsi/scsi.  The switch from "Direct-Access" to "Direct access" broke
ofpath.  I fixed that (in ofpath) but it remains broken for other reasons.

James, this is a non-compatible change to the kernel->userspace interface.  Please
drop it like a hot potato.

