From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] advansys: fix overrun_buf aligned bug
Date: Fri, 08 Feb 2008 10:16:41 +0900
Message-ID: <20080208101641R.fujita.tomonori@lab.ntt.co.jp>
References: <20080208095008V.fujita.tomonori@lab.ntt.co.jp>
	<1202432515.3171.55.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:36694 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYBHBQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 20:16:58 -0500
In-Reply-To: <1202432515.3171.55.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: fujita.tomonori@lab.ntt.co.jp, skogtun.linux@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, tomof@acm.org

On Thu, 07 Feb 2008 19:01:55 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> 
> On Fri, 2008-02-08 at 09:50 +0900, FUJITA Tomonori wrote:
> > struct asc_dvc_var needs overrun buffer to be placed on an 8 byte
> > boundary. advansys defines struct asc_dvc_var:
> > 
> > struct asc_dvc_var {
> > 	...
> > 	uchar overrun_buf[ASC_OVERRUN_BSIZE] __aligned(8);
> > 
> > The problem is that struct asc_dvc_var is placed on
> > shost->hostdata. So if the hostdata is not on an 8 byte boundary, the
> > advansys crashes. The hostdata is placed on a sizeof(unsigned long)
> > boundary so the 8 byte boundary is not garanteed with x86_32.
> > 
> > With 2.6.23 and 2.6.24, the hostdata is on an 8 byte boundary by
> > chance, but with the current git, it's not.
> > 
> > This patch removes overrun_buf static array and use kzalloc.
> 
> It's a bit of a waste of a kmallocs.  The usual way of fixing this type
> of cockup is to float the structure until it becomes aligned, but I
> suppose that involves changing all calls to shost_priv in the driver ...

Yeah, agreed. It's better but I'm not familiar with the driver so I
use kmalloc. It's not so bad as a short-term solution, I think.

Any chance to push it to final SCSI updates for 2.6.24 merge window?
Though we can push it any time since it's a bug fix.

Anyway, I'm fine with dropping it if Matthew will fix the driver in a
better way. I'm happy unless people blame my IOMMU or sense buffer
patch for this bug. :)
