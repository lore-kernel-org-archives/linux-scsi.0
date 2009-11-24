From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 02/38] move atp870u_remove to .devexit.text
Date: Tue, 24 Nov 2009 15:38:16 -0600
Message-ID: <1259098696.4549.643.camel@mulgrave.site>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934158AbZKXViW@vger.kernel.org>
In-Reply-To: <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Yang Hongyang <yanghy@cn.fujitsu.com>, Alan Cox <alan@linux.intel.com>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-11-24 at 22:06 +0100, Uwe Kleine-K=C3=B6nig wrote:
> The function atp870u_remove is used only wrapped by __devexit_p so de=
fine
> it using __devexit.

But there's really no point to this.  HOTPLUG is always defined on SCSI
systems that have these drivers, which means that _devinit/exit are
nops.  That makes the change purely cosmetic and not worth churning two
dozen drivers for.

Even for the EMBEDDED cases that should care about this, the maintainer=
s
have indicated that the memory savings simply aren't worth the hassle o=
f
tracking the sectional updates.

James
