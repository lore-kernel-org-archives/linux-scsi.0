From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: Thu, 05 Sep 2002 18:13:45 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <100360000.1031271224@aslan.btc.adaptec.com>
References: <200209041613.g84GDtv02639@localhost.localdomain>
 <12750000.1031158209@aslan.btc.adaptec.com>
 <10209050239.ZM52086@classic.engr.sgi.com>
 <122900000.1031232923@aslan.scsiguy.com>
 <10209051656.ZM53302@classic.engr.sgi.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <10209051656.ZM53302@classic.engr.sgi.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@classic.engr.sgi.com>, James Bottomley <James.Bottomley@steeleye.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org

> But don't the controllers have to know which commands have been silently
> aborted by the target?

The controller drivers would need to know that the QErr policy is in
effect for a given device.  With that knowledge, the book keeping from
the controller's standpoint is really quite simple and no different than
if a lun reset, target reset, clear task set, bus reset or any other task
management function is executed.  In other words, the controller drivers
already need to understand the consequences of such events.

>  There are various resources allocated to a
> command, so if the command will never be completed, as a result of some
> other command getting "check condition", the controller would have to
> know.

The controller knows which commands are affected and just returns them
to the mid-layer with the appropriate error code.

> Or are you suggesting that the type drivers would tell the controllers to
> release those resources?

Not necessary.

> And would this change if the controller drivers were keeping track of
> timeouts, etc.?

This all assumes that the controllers are doing watchdog recovery.

--
Justin
