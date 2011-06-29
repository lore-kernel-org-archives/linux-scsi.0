From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 3/3] PM: Limit race conditions between runtime PM and system sleep
Date: Wed, 29 Jun 2011 21:35:46 +0200
Message-ID: <201106292135.47147.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1106291004180.2064-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1106291004180.2064-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <tom.leiming@gmail.com>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday, June 29, 2011, Alan Stern wrote:
> On Tue, 28 Jun 2011, Rafael J. Wysocki wrote:
> 
> > On Tuesday, June 28, 2011, Ming Lei wrote:
> > > 
> > > Hi Rafael,
> > > 
> > > On Sun, 26 Jun 2011 00:56:31 +0200
> > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > Index: linux-2.6/Documentation/power/runtime_pm.txt
> > > > ===================================================================
> > > > --- linux-2.6.orig/Documentation/power/runtime_pm.txt
> > > > +++ linux-2.6/Documentation/power/runtime_pm.txt
> > > > @@ -567,6 +567,11 @@ this is:
> > > >  	pm_runtime_set_active(dev);
> > > >  	pm_runtime_enable(dev);
> > > >  
> > > > +The PM core always increments the run-time usage counter before calling the
> > > > +->suspend() callback and decrements it after calling the ->resume() callback.
> > > > +Hence disabling run-time PM temporarily like this will not cause any run-time
> > > > +suspend callbacks to be lost.
> > > 
> > > Could you explain why the above is that "this will not cause any run-time suspend
> > > callbacks to be lost"? 
> > > 
> > > Looks like it should be "this will not cause any run-time suspend callbacks to
> > > be called", but not sure.
> > 
> > You're right the wording is not perfect.  The problem is that if it's done
> > this way without incrementing the usage counter beforehand, the status may
> > change to "suspended" right before the pm_runtime_set_active() and then the
> > new status will not reflect the actual state of the device.
> > 
> > So, it may be better to say "Hence disabling runtime PM temporarily like this
> > will not cause the runtime PM status of the device to conflict with the actual
> > device state".
> > 
> > Alan, what do you think?
> 
> How about: "... will not cause any runtime suspend attempts to be 
> permanently lost.  If the usage count goes to zero following the return 
> of the ->resume() callback, the ->runtime_idle() callback will be 
> invoked as usual."

That's better, thanks!

Rafael
