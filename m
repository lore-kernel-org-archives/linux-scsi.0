From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tgt: fix scsi command leak
Date: Wed, 7 Mar 2007 11:10:08 +0900 (JST)
Message-ID: <20070307104132B.fujita.tomonori@lab.ntt.co.jp>
References: <45E9A92B.5040507@torque.net>
	<20070305143222H.fujita.tomonori@lab.ntt.co.jp>
	<45EC38EF.6000603@torque.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:37173 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161180AbXCGCL3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2007 21:11:29 -0500
In-Reply-To: <45EC38EF.6000603@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 3/3] tgt: fix scsi command leak
Date: Mon, 05 Mar 2007 10:36:15 -0500

> >> What about an option for descriptor sense format? With SAT now
> >> a standard, we now have one more reason to support
> >> descriptor format when required. The ATA PASS-THROUGH SCSI
> >> commands in SAT use descriptor sense format to return
> >> ATA registers.
> > 
> > tgt's kernel-space code doesn't know anything about SCSI devices that
> > initiators talks to. So it's difficult to send proper sense buffer.
> > Nomally, we don't have this problem because tgt user-space code builds
> > sense buffer.
> > 
> > The bug that we are trying to fix is that the scsi command leak due to
> > the user-space's bugs. So we can't rely on the user-space for this.
> > 
> > Not that, like open-iscsi, the user-space bugs are pretty critical for
> > tgt as the kernel-space bugs. We don't think target mode drivers can
> > continue to work. However, tgt should tell target mode drivers that
> > unrecoverable problems happen and we should cleanly unload the kernel
> > modules.
> 
> Tomo,
> If I understand correctly, there is a target SCSI command
> interpreter in a user space daemon (plus lu support) and the
> target transport end point in kernel space (roughly speaking).
> So if there is some problem in the kernel module, or
> the user space daemon goes away (or won't respond) then what
> you have is a transport error at the target end.

Yeah.


> The error should be lower level than SCSI commands (i.e.
> transport level). The kernel module doesn't know the state
> of target SCSI command interpreter (by design). For example
> the application client may have set the D_SENSE bit in the
> control mode page prior to the failure that your code is
> addressing. So the application client won't be expecting
> fixed sense data format thereafter.
> 
> So what the code is doing is definitely better than nothing,
> but IMO it isn't quite right either.

It should work. The initiators probably sends tmf requests and finally
gives up the device.

Could a lld do something better if tgt notifies the lld that tgt can't
handle the command via host->transfer_response? Even though the
initiator must give up the device in the end because the user-space
deamon can't continue.

If so, one possible option is that tgt notifies a lld of tgt's
original status via host->transfer_response though currently
host->transfer_response uses only SAM_STAT_*.
