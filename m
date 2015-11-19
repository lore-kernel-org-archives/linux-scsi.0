From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/71] ncr5380: Split NCR5380_init() into two functions
Date: Thu, 19 Nov 2015 14:30:55 +0100
Message-ID: <564DCF0F.6030601@suse.de>
References: <20151118083455.331768508@telegraphics.com.au> <20151118083457.131801599@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151118083457.131801599@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 11/18/2015 09:35 AM, Finn Thain wrote:
> This patch splits the NCR5380_init() function into two parts, similar
> to the scheme used with atari_NCR5380.c. This avoids two problems.
>=20
> Firstly, NCR5380_init() may perform a bus reset, which would cause th=
e
> chip to assert IRQ. The chip is unable to mask its bus reset interrup=
t.
> Drivers can't call request_irq() before calling NCR5380_init(), becau=
se
> initialization must happen before the interrupt handler executes. If
> driver initialization causes an interrupt it may be problematic on so=
me
> platforms. To avoid that, first move the bus reset code into
> NCR5380_maybe_reset_bus().
>=20
> Secondly, NCR5380_init() contains some board-specific interrupt setup=
 code
> for the NCR53C400 that does not belong in the core driver. In moving =
this
> code, better not re-order interrupt initialization and bus reset. Aga=
in,
> the solution is to move the bus reset code into NCR5380_maybe_reset_b=
us().
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
