From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Mon, 1 Jul 2002 13:17:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0207011310310.62375-100000@beppo>
References: <20020701155928.H776@redhat.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020701155928.H776@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: =?iso-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>, Jeremy Higdon <jeremy@classic.engr.sgi.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org


> On Mon, Jul 01, 2002 at 12:23:56PM -0700, Matthew Jacob wrote:
> > Fibre. Devices 'go away' for shortish to longish periods of time on Fibre (or
> > iSCSI for that matter). Lacking a sane framework that is USB-like about
> > hotpluggable that does *not* cause complete system spasm when this happens
> > (and it happens a lot), what one wants is a bit of hysteresis to give the
> > disks that went away a chance to log back into the fabric and thus appear
> > again (as if they had never gone).
> 
> (I knew this, but it had slipped my mind).  This reminds me of something I 
> was thinking about for the mid layer code stuff.  Does FreeBSD have it's 
> drivers declare their connection method anywhere?  It seems to me there 
> are a limited number of connection specific details that the mid layer 
> would benefit from being aware of (for example > 8 luns on SCSI-2 fiber 
> devices, but not on SCSI-2 SPI devices,

Eh? You can have &way& > 8 luns on normal SCSI-2 SPI- you just have to have a
cooperating target that uses the target routine bits. The QLogic 12160 Ultra3
cards have firmware for 32 or 64 luns.

> the selection timeout issue you 
> just raised with transient disk loss which should not happen on SPI, 
> things like that).  Does the FreeBSD mid layer do anything with that sort 
> of information?

The -current version has a bunch of rewritten code (that isn't the default
yet) that specifically addresses this issue. It allows you to have plug in
transport methods. That allows you to do transport specific things. For
example, speed negotiation is meaningless for FC and ATAPI transports, but
crucial for SPI.

In terms of the 'selection timeout'- what I've wanted more recently is really
a hack. The problem is that you really *do* need to reflect upward that as far
as *you* (the HBA/SIM) can tell, the device has *left* the fabric. It may in
fact reappear instantaneously, but it has left. So, ultimately, you need a
framework that can accomdate this sensibly.

So, rather than the selection timeout hack, you need something which can
sensibly follow a settable policy when the async event of devices leaving
occurs. The policy might be fielded by the midlayer to stop queueing for a
policy set period of time- and then you start EIO'ing commands when that
expires (this is more than normal device command timeouts, which are really
meant to reflect how long a command should take on the device itself, not that
*plus* whatever transmission troubles keep you from actually starting the
command).

At any rate, the selection timeout hack is a good interim solution for those
of us who don't have the time or the moxie to rewrite as much as actually
*needs* to be rewritten.

-matt


