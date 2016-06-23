From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Reported regressions for 4.7 as of Sunday, 2016-06-19
Date: Thu, 23 Jun 2016 09:35:42 -0700
Message-ID: <CA+55aFx96hD29q_BQ+W8tV08zkX3BSCxF9etAzTDxfAgO3e7MQ@mail.gmail.com>
References: <7cc588b7-f1cf-62a8-e45b-ec7d863ba51e@leemhuis.info>
 <CA+5PVA63r9xLXtiiVMxKPdgZD5VZ_8io1f=9MH520LAFBbe9kg@mail.gmail.com>
 <CA+55aFyyKjupjdd4tC82VEnZwb3AyEGJBVCJzdyvfgeUFGVfLw@mail.gmail.com>
 <yq1wpli2ewx.fsf@sermon.lab.mkp.net> <20160622115131.4bh7sh6uhmmhw44v@c203.arch.suse.de>
 <A19CCC3E-1B00-45A5-BA4B-2E082E98AF87@qlogic.com> <20160623072240.gt4wdjok27venxgr@c203.arch.suse.de>
 <1957A3C6-C4C2-4E7A-84E1-31A48F1469CD@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34629 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbcFWQfo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2016 12:35:44 -0400
In-Reply-To: <1957A3C6-C4C2-4E7A-84E1-31A48F1469CD@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Josh Boyer <jwboyer@fedoraproject.org>, Thorsten Leemhuis <regressions@leemhuis.info>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Jun 23, 2016 at 9:13 AM, Quinn Tran <quinn.tran@qlogic.com> wrote:
>
>
> QT: setting up the interrupt vector does not mean the interrupt starts firing immediately.

Actually, it very much can mean that. If the interrupt can possibly be
shared, there is a very real possibility of it fiding immediately.

Now, with MSI(-X) I guess that isn't a worry, so I suspect your patch
that handles just the legacy INTx case anyway is sufficient, but in
general I would like people to always act as if interrupts can happen
immediately after request_irq().

We have had *tons* of situations where the firmware left a device
active, for example. Or where some random interrupt controller ended
up having stale interrupts pending, even.

So in general, it's just good practice to say "spurious interrupts can
and do happen" - the shared irq case is the most obvious case, but
there have been other sources of unexpected spurious interrupts
firing.

                Linus
