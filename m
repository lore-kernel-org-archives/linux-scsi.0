From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH] spinlock: Kill spin_unlock_wait()
Date: Fri, 7 Jan 2011 16:33:02 -0500
Message-ID: <20110107213302.GI7355@mtj.dyndns.org>
References: <AANLkTikGBsh0-QTe9CA2gwDtwzpdMi+fbDsTEKiJAL0P@mail.gmail.com>
 <1294054362.2016.74.camel@laptop>
 <20110104064542.GF3402@amd>
 <1294254867.2016.281.camel@laptop>
 <AANLkTi=URmD1GYqp+PfVf6rc0tXvRnAQG808LMnBRgG1@mail.gmail.com>
 <1294306353.2016.304.camel@laptop>
 <20110106103841.GA3493@amd>
 <1294338395.2016.381.camel@laptop>
 <20110107210152.GG7355@mtj.dyndns.org>
 <AANLkTimA9VKO2bW0PtAVKhYdJ_cRi7mpsAC_QDZwrvAM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimA9VKO2bW0PtAVKhYdJ_cRi7mpsAC_QDZwrvAM@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <chris.mason@oracle.com>, Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>, Linux-Arch <linux-arch@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello, Jeff.

On Fri, Jan 07, 2011 at 04:13:53PM -0500, Jeff Garzik wrote:
> > Hmm... I think the ->eng_timeout path is already dead. =A0We no lon=
ger
> > have any in-kernel implementation, so killing spin_unlock_wait()
> > should be fine. =A0I'll follow up with removal of the unused callba=
ck.
>=20
> Unfortunately...  libsas continues to avoid the new EH :(
>=20
> It's a hairy mess to untangle, too.  libata does proper error handlin=
g
> of ATA device errors, notably NCQ error handling, which libsas sorely
> misses.  But libata new EH assumes a bit too much about "owning" the
> entirety of the EH process.  These assumptions are proper for wholly
> ATA drivers (drivers/ata/*) where new EH can drive the EH process, bu=
t
> in the SAS situation, a phy in SATA mode is simply a subset of a
> larger set of EH conditions that must be handled.
>=20
> Thus libsas uses the ancient libata hook ->phy_reset and lacks ->erro=
r_handler.
>=20
> I think libata's old-EH path is entirely SAS-specific at this point.

Hmm... but they don't use ata_scsi_error() and ->eng_timeout() at all,
no?  We can't remove phy_reset() and need to keep the silly "if
(->error_handler)" tests around but should be able to remove those
from ata_scsi_error() and other EH routines, at least.  Am I missing
something?

Thanks.

--=20
tejun
