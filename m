From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: PROBLEM: module a100u2w (SCSI, Initio) on ppc
Date: Tue, 15 Jul 2008 23:30:27 +0900
Message-ID: <20080715233044N.fujita.tomonori@lab.ntt.co.jp>
References: <20080712033040.GA8086@h42136.pems.adfa.edu.au>
	<20080711220901.e1b69adb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36168 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbYGOOa4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 10:30:56 -0400
In-Reply-To: <20080711220901.e1b69adb.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: s.harker@adfa.edu.au, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 11 Jul 2008 22:09:01 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> (cc linux-scsi)
> 
> On Sat, 12 Jul 2008 13:30:41 +1000 Stephen Harker <s.harker@adfa.edu.au> wrote:
> 
> > The SCSI Initio a100u2w driver compiles as a module, loads, but
> > hangs on a powerpc machine.  
> > 
> > I am running linux (YellowDog 5.0) on a PowerMac 7600.  I am using
> > self-compiled kernels.  The initio a100u2w card runs successfully
> > under Mac OSX and OS9.  In the past when I tried the a100u2w module
> > under kernel 2.4 and early 2.6 it would hang for at least 30 minutes
> > (in the end I rebooted the machine).
> > 
> > I thought I would try again recently using 2.6.23.14 and 2.6.25.4
> > kernels.  This was more successful in that the machine did not hang
> > seemingly forever.  However, the module seems to fail in
> > initialisation and no drive partitions are seen/mounted.  I tried
> > removing the module (rmmod), the reloading it (modprobe) and similar
> > issues are noted.  Output from dmesg shows the problems.  The
> > following is the output from dmesg under 2.6.25.4, look for scsi2 and
> > initio and inia100.  I am afraid that I am away from home at present
> > and  don't have all the information that may be desirable.  I hope the
> > following is adequate.  The kernel and system run well except for this
> > one module.

Seems that this driver has some bugs on big endian architectures
(though I've not looked at the patch):

http://marc.info/?l=linux-scsi&m=121613124207253&w=2
