From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Serious regression caused by fix for [BUG 1/3] bsg queue oops
 with	iscsi logout
Date: Thu, 03 Apr 2008 10:58:54 +0300
Message-ID: <47F48E3E.20005@panasas.com>
References: <1206898777.4224.64.camel@localhost.localdomain>	<20080331092020R.fujita.tomonori@lab.ntt.co.jp>	<47F3D364.3050505@panasas.com> <20080403060033H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:56555 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927AbYDCH7w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 03:59:52 -0400
In-Reply-To: <20080403060033H.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, tomof@acm.org, michaelc@cs.wisc.edu, pw@osc.edu, linux-scsi@vger.kernel.org, erezz@voltaire.com, Jens.Axboe@oracle.com

On Thu, Apr 03 2008 at 0:00 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> No change since I submitted last time:
> 
> http://marc.info/?l=linux-scsi&m=120692552424155&w=2
> 
> They need to be applied to the latest Linus git (or scsi-fixes).
> 
> If you prefer a git tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git bsg
> 

Thanks for the git tree. The URLs inside the message above don't work for me.
They all point to the same email and without any patch inside. I don't
know if it is marc.info or my firefox that's bad.

Anyway the git tree is perfect, I will give them a spin.

> 
> James pointed out another race:
> 
> 1. we hold the bsg device open and remove it.
> 
> 2. we add a new device.
> 
> 3. we try to open the new device
> 
> 4. we get a ref to the removed device (but it's still hold open)
> instead of the new one.
> 
> 
> I overlooked this race (James, thanks a lot for pointing out
> it). Fortunately, the fourth patch fixes this race. I've confirmed it.
> 
> So when submitting the patchset, I said that only the first patch is
> crucial, however, the 4th patch is crucial too.
> 
> I'm fine with either via scsi-misc or scsi-fixes.
> --

Thanks
Boaz
