From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC][PATCH] spinlock: Kill spin_unlock_wait()
Date: Fri, 7 Jan 2011 16:13:53 -0500
Message-ID: <AANLkTimA9VKO2bW0PtAVKhYdJ_cRi7mpsAC_QDZwrvAM@mail.gmail.com>
References: <20101224122338.172750730@chello.nl>
	<20101224123742.724459093@chello.nl>
	<AANLkTikGBsh0-QTe9CA2gwDtwzpdMi+fbDsTEKiJAL0P@mail.gmail.com>
	<1294054362.2016.74.camel@laptop>
	<20110104064542.GF3402@amd>
	<1294254867.2016.281.camel@laptop>
	<AANLkTi=URmD1GYqp+PfVf6rc0tXvRnAQG808LMnBRgG1@mail.gmail.com>
	<1294306353.2016.304.camel@laptop>
	<20110106103841.GA3493@amd>
	<1294338395.2016.381.camel@laptop>
	<20110107210152.GG7355@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34854 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1AGVNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2011 16:13:55 -0500
In-Reply-To: <20110107210152.GG7355@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <chris.mason@oracle.com>, Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>, Linux-Arch <linux-arch@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>

On Fri, Jan 7, 2011 at 4:01 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Jan 06, 2011 at 07:26:35PM +0100, Peter Zijlstra wrote:
>> Jeff, Tejun, could you look at the ata-eh thing, then I'll put sorti=
ng
>> through the futex thing on my todo list.
>
> Hmm... I think the ->eng_timeout path is already dead. =C2=A0We no lo=
nger
> have any in-kernel implementation, so killing spin_unlock_wait()
> should be fine. =C2=A0I'll follow up with removal of the unused callb=
ack.

Unfortunately...  libsas continues to avoid the new EH :(

It's a hairy mess to untangle, too.  libata does proper error handling
of ATA device errors, notably NCQ error handling, which libsas sorely
misses.  But libata new EH assumes a bit too much about "owning" the
entirety of the EH process.  These assumptions are proper for wholly
ATA drivers (drivers/ata/*) where new EH can drive the EH process, but
in the SAS situation, a phy in SATA mode is simply a subset of a
larger set of EH conditions that must be handled.

Thus libsas uses the ancient libata hook ->phy_reset and lacks ->error_=
handler.

I think libata's old-EH path is entirely SAS-specific at this point.

     Jeff


P.S.  Note that libsas and ipr are peers; thus ipr driver also uses old=
 EH.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
