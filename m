From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [2/3] 2.6.22-rc3: known regressions v2
Date: Fri, 1 Jun 2007 23:23:44 +0530
Message-ID: <20070601175344.GA13721@in.ibm.com>
References: <465FED20.3090206@googlemail.com> <46600F27.1090202@googlemail.com> <20070601090115.3271a397.akpm@linux-foundation.org>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:33908 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760420AbXFASNQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jun 2007 14:13:16 -0400
Content-Disposition: inline
In-Reply-To: <20070601090115.3271a397.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-pcmcia@lists.infradead.org, Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>, Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Gregor Jasny <gjasny@googlemail.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Mark Salyzyn <aacraid@adaptec.com>, Yinghai Lu <yhlu.kernel@gmail.com>, Vivek Goyal <vgoyal@in.ibm.com>, sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>

On Fri, Jun 01, 2007 at 09:01:15AM -0700, Andrew Morton wrote:
> On Fri, 01 Jun 2007 14:20:55 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
> > SCSI
> > 
> > Subject    : aacraid: adapter kernel panic'd fffffffd (kexec)
> > References : http://lkml.org/lkml/2007/5/29/491
> > Submitter  : Yinghai Lu <yhlu.kernel@gmail.com>
> > Handled-By : Salyzyn, Mark <mark_salyzyn@adaptec.com>
> >              Vivek Goyal <vgoyal@in.ibm.com>
> > Status     : problem is being debugged
> 
> Mark's aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch is
> known to fix this, so we can move this to "known regressions with patches"

Hi Andrew,

aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch is meant
to ensure that we don't perform an unnecessary reset of the device
during a kexec boot. During kexec, we perform the device_shutdown()
which should bring the device to a known sane state and a reset is
not required while next kernel is coming up.

I think this fix just masks Yinghai's problem and as such does not
fix the root cause of the problem. In his case a software reset
of the card is not successful and this is a problem. This problem
will become visible during kdump.

So I would think that this regression is still there just that got
shifted from kexec to kdump.

But we do need above patch to make sure kexec boot is fast and does
not perform any unrequired device reset.

Thanks
Vivek


