From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Mon, 1 Jul 2002 12:23:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0207011221020.62375-100000@beppo>
References: <20020701151553.G776@redhat.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020701151553.G776@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: =?iso-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>, Jeremy Higdon <jeremy@classic.engr.sgi.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org



On Mon, 1 Jul 2002, Doug Ledford wrote:

> On Mon, Jul 01, 2002 at 12:08:03PM -0700, Matthew Jacob wrote:
> > Yes, exponential backoff is good in a lot of cases. BTW- this is something I
> > want to put into cam_periph_error for FreeBSD- I want to make the retry after
> > selection timeout also have exponential delays up to retry count.
> 
> Hmmm...what's the purpose on this BTW?  Selection timeouts on what, fiber 
> or SPI or something else?

Fibre. Devices 'go away' for shortish to longish periods of time on Fibre (or
iSCSI for that matter). Lacking a sane framework that is USB-like about
hotpluggable that does *not* cause complete system spasm when this happens
(and it happens a lot), what one wants is a bit of hysteresis to give the
disks that went away a chance to log back into the fabric and thus appear
again (as if they had never gone).

> 
> > In private mail with Doug && Pete, I managed to put myself into an untenable
> > position. The problem here is that we don't have end-to-end flow control, so
> > we have to *guess* when it might be good to try again. 
> 
> Yep.  Experimentation can be your friend on that.  That's what I did to 
> come up with the alghorithm I was quoting.  However, I didn't try 
> exponential backoff so I make no claims that it wouldn't in fact be 
> better.

But the trouble with experimentation can be like what got me into trouble in
our private email- I was relying on stale information (like, 10 years old) in
my thinking. Bad matt.....


