From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [patch 12/17] ips.c: fix build warning
Date: Mon, 31 Mar 2008 08:57:30 +0900
Message-ID: <20080331085730T.fujita.tomonori@lab.ntt.co.jp>
References: <200803282148.m2SLmeDg012249@imap1.linux-foundation.org>
	<1206896842.4224.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:61008 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYC3X62 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Mar 2008 19:58:28 -0400
In-Reply-To: <1206896842.4224.46.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com, aacraid@adaptec.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org

On Sun, 30 Mar 2008 12:07:22 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > powerpc:
> > 
> > drivers/scsi/ips.c: In function 'ips_issue_copperhead':
> > drivers/scsi/ips.c:5436: warning: large integer implicitly truncated to unsigned type
> > 
> > it doesn't seem necessary to do outw(cpu_to_le32(...), ...) anyway.
> 
> Actually, it's not only not necessary ... it's an actual bug on BE
> platforms.  Both writeX and outX/inX automatically convert from native
> to bus endian (usually simply to LE since the bus is PCI).  Therefore if
> you add a cpu_to_leX, you actually write the wrong value on a BE system.
> 
> Mark, it looks like the correct fix is simply to strip all of these ...
> has this driver actually been tested on a BE platform (like parisc or
> PPC)?

I guess that it hasn't. ips.c includes:

#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
#warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
#endif
