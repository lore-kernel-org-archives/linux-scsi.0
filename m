From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: Thu, 5 Sep 2002 16:56:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10209051656.ZM53302@classic.engr.sgi.com>
References: <200209041613.g84GDtv02639@localhost.localdomain>
	<12750000.1031158209@aslan.btc.adaptec.com>
	<10209050239.ZM52086@classic.engr.sgi.com>
	<122900000.1031232923@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
        "Re: aic7xxx sets CDR offline, how to reset?" (Sep  5,  7:35am)
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@steeleye.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org

On Sep 5,  7:35am, Justin T. Gibbs wrote:
> 
> > On Sep 4, 10:50am, Justin T. Gibbs wrote:
> >> 
> >>    This of course assumes that all transactions have a serial number and
> >>    that requeuing transactions orders them by serial number.  With QErr
> >>    set, the device closes the rest if the barrier race for you, but even
> >>    without barriers, full transaction ordering is required if you don't
> >>    want a read to inadvertantly pass a write to the same location during
> >>    recovery.
> > 
> > 
> > The original FCP (SCSI commands over Fibre) profile specified that QERR=1
> > was not available.  Unless that is changed, it would appear that you
> > cannot count on being able to set Qerr.
> > 
> > Qerr was one of those annoying little things in SCSI that forces host
> > adapter drivers to know a mode page setting.
> 
> It is not the controllers that know, but the type drivers.  The controller
> drivers should be conduits for commands, nothing more.  With the proper
> events and error codes, the type drivers can maintain mode parameters
> and only the type drivers know what parameters are appropriate for their
> type of service.

But don't the controllers have to know which commands have been silently
aborted by the target?  There are various resources allocated to a command,
so if the command will never be completed, as a result of some other command
getting "check condition", the controller would have to know.

Or are you suggesting that the type drivers would tell the controllers to
release those resources?

And would this change if the controller drivers were keeping track of
timeouts, etc.?

jeremy
