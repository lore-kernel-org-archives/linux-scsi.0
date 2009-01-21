From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: need help to merge (small) virtual scsi driver upstream.
Date: Thu, 22 Jan 2009 08:09:12 +0900
Message-ID: <20090122080807S.fujita.tomonori@lab.ntt.co.jp>
References: <4974CED2.9000900@hw0.org>
	<20090121151113X.fujita.tomonori@lab.ntt.co.jp>
	<4976D280.5000506@hw0.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:33699 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZAUXJ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2009 18:09:27 -0500
In-Reply-To: <4976D280.5000506@hw0.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: henrik@hw0.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Wed, 21 Jan 2009 08:45:04 +0100
Henrik Stokseth <henrik@hw0.org> wrote:

> FUJITA Tomonori wrote:
> >
> >
> > From a quick look at the patch, your driver links requests to a list
> > and then the user-space daemon reads the requests via the special
> > character device file and sends the response back to kernel space.
> >
> > If I correctly understand what you want, there are some possible
> > alternatives, I guess.
> >
> > Note that I'm not sure 2) and 3) is acceptable to the SCSI maintainer.
> >
> >
> > 1) use iSCSI initiator and target on the same machine
> >
> > First, set up iSCSI target software supporting CD/DVD. For example,
> > you can use tgt (http://stgt.berlios.de), user-space program.
> >
> > Then you set up the iSCSI initiator to connect the target. Basically,
> > the iSCSI initiator works like a virtual hba as you like. The iSCSI
> > initiator and target communicate via tcp while your software
> > communicates via the special character device.
> >
> > If you go with this setup, all you need are already in mainline.
> >   
> 
> It would be desirable for us to rely upon an interface already present
> in the mainstream kernel for practical reasons.
> 
> Pardon the dumb question but is it possible to talk to the TGT framework
> without using iSCSI?
>
> SCST has a nice user-space interface but I couldn't tell whether STGT
> had something similar (as documentation is pretty much non-existent).

tgt has such but I don't think that anyone needs to use tgt's
interface between user and kernel space so there is no documentation
(it's better to have such though). tgt user-space daemon supports sbc,
ssc, smc, mmc, and osd emulation. Why do you need to invent your own
user-space tgt daemon?


Why you can't simply use iSCSI? It should work for you.
