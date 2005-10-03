From: Lukasz Kosewski <lkosewsk@gmail.com>
Subject: Re: [PATCH 2/3] Add disk hotswap support to libata RESEND #5
Date: Mon, 3 Oct 2005 11:19:51 -0400
Message-ID: <355e5e5e0510030819od4ef8e5l93708588990081da@mail.gmail.com>
References: <355e5e5e05092618018840fc3@mail.gmail.com>
	 <433AEAAE.2070003@pobox.com>
	 <1127949651.26686.11.camel@localhost.localdomain>
Reply-To: Lukasz Kosewski <lkosewsk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1127949651.26686.11.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hey Alan,

On 9/28/05, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> For PATA the requirements I'm aware of are
>
> -       Interface for user to say "am about to swap"

You mean something like "echo scsi-remove-single-device a b c d" >
/proc/scsi/scsi?  I guess the sysfs equivalent?

> -       Interface for user to say "have swapped"

I suppose ditto.

> -       Must quiesce both master and slave before swap (or one per cable)

The way I've written my infrastructure, this seems as if it'll just
require another carefully placed hook function.

> -       Must reset to PIO_SLOW and then recompute modes for both devices
> becuse it is possible that changing one changes the other timings

This shouldn't be hard since I already do a similar reset by resetting
udma_flags to a pre-init state.  Probably in an if (!(ap->flags &
ATA_FLAG_SATA)).

> -       The above is true for *unplug* too. A straight unplug may speed up the
> other drive!
> -       Post hotswap need to reconfigure both drives as if from scratch

Hmm, this seems far more complicated... basically during a swap
operation, we have to shut down all I/O to the other drive on the
cable (if there is one), if I read you correctly, and then reconfigure
both drives once one is plugged in.

>From what you're saying, it seems to me that the infrastructure I put
forth will work as is, plus some if statements and extraneous
PATA-only functions (and functionality like shutting down the other
disk on the cable until the user calls the 'warm-swap complete'
function').

How about this; I want this SATA hotswapping stuff to be tested, so
I'll commit my patches for 'SATA only' for the time being.  I'll stare
at them for a while and then see what kind of PATA-specific if
statements and hooks are necessary in the code?

Luke
