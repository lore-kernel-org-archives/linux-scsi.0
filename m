From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 16:25:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031212559.GJ30047@redhat.com>
References: <20021031170337.GO574@lapi0061> <798370000.1036087399@aslan.btc.adaptec.com> <20021031200758.GB30047@redhat.com> <20021031203857.GV574@lapi0061>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021031203857.GV574@lapi0061>
List-Id: linux-scsi@vger.kernel.org
To: Mike Brown <mbrown@emc.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org

On Thu, Oct 31, 2002 at 03:38:57PM -0500, Mike Brown wrote:
> Hi,
> 
> > The whole "support more than 8 luns on SCSI-2 devices" is a hack anyway, I 
> > would be more likely to just remove it instead of changing other things.
> 
> This would break production environments.  Symmetrix isn't the only
> storage array that supports this hack.  DG, Dell, HP, and others also
> support this hack.  If its taken out in 2.5 and replaced with
> REPORT_LUNS that'd be ok, but taking it out of 2.4 without replacing
> it with REPORT_LUNS is going to break people.

Note, these hacks have caused more more bug reports and more crap in the 
last 2 years than anything else when it comes to device scanning in linux.  
If it were up to me, I'm so fed up with them I'd yank *all* the hacks that 
make us scan for non-compliant devices and instead tell the vendors to fix 
their firmware to be SCSI compliant.

> > > 3) Linux should be using the Report Luns command to determine how
> > >    many luns are on a device and at what locations.  This might
> > >    even allow you to never probe more than 8 luns on a SCSI 2
> > >    device unless they support this command.  Does the Symetrix support
> > >    it?  Going beyond 8 luns on a SCSI2 device is really a hack
> > >    otherwise.
> > 
> > We currently only do report luns on SCSI-3 devices.  I didn't think this 
> > was a supported command on SCSI-2, but I hadn't checked the spec 
> > recently...hmmm...nope, not supported in SCSI-2, so using report luns on 
> > SCSI-2 devices is just as much a hack as going above lun 7 on SCSI-2 
> > devices without specific knowledge of transfer interconnect.
> 
> Symmetrix supports Report Luns despite reporting SCSI_2 Units.  The

Can you comment on why Symmetrix reports SCSI-2 units then?  Report Luns
is an optional SCSI-3 command.  If you don't have all the required SCSI-3
items implemented yet so that you can't report SCSI-3, then I would think
you need to not worry about optional commands until the required ones are
done.  On the other hand, if you've got all the required SCSI-3 items
implemented, then why aren't you reporting SCSI-3?

>  I don't know
> what the right fix is for 2.4.  We need a hack akin to something like:

The right fix doesn't exist.  Hack is exactly what it's going to take to 
fix this.  Once again, it's a case of some vendor wanting SCSI-3 features 
on a device that they only report as being SCSI-2 causing breakage.

I'm currently working in 2.5, not 2.4.  This will be fixed in 2.5 by using 
report luns.  My goal for 2.5 is to make the whitelist as small as 
possible though, so fixing up your firmware to report the proper SCSI 
version would be appreciated.  If not, then it will have to be a report 
luns whitelist entry.  For 2.4, I don't have an answer and I'm not sure 
when I would get around to looking at it personally.  Not this week 
anyway, maybe next.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
