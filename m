From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 22:32:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021016023231.GA4690@redhat.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <20021015130445.A829@eng2.beaverton.ibm.com> <20021015205218.GG4391@redhat.com> <20021015163057.A7687@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015163057.A7687@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>, 'Dave Hansen' <haveblue@us.ibm.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Oct 15, 2002 at 04:30:57PM -0700, Patrick Mansfield wrote:
> On Tue, Oct 15, 2002 at 04:52:18PM -0400, Doug Ledford wrote:
> > On Tue, Oct 15, 2002 at 01:04:45PM -0700, Patrick Mansfield wrote:
> > > 
> > > I totally agree the queue depth should not be limited based on the number of
> > > devices, but there should be a maximum limit - as Justin noted with the
> > > aic driver, using a large default queue depth (he had 253 or so) is not
> > > good with linux.
> > 
> > That's largely due to the scsi_request_fn() in its current form.
> 
> I don't understand that.

The current scsi_request_fn() sucks rocks when it comes to any sort of 
fair load balancing in a host queue starvation scenario.

> > > The queue depth should be as small as possible without limiting the
> > > performance.
> > 
> > Which happens to be a magic number that no one really knows I think ;-)  
> 
> Yes, but that implies that adapters should not be relied upon to set
> the queue depth.

I draw exactly the opposite conclusion (look at the email from Lubon 
Tuikov for several valid reasons why).

> If the adapter is setting queue depth based upon what
> the adapter knows, that is completely wrong

I strongly disagree here.  Only the adapter driver knows if the card 
itself has a hard limit of X commands at a time (so that deeper queues are 
wasted).  Only the adapter driver knows if the particular interconnect has 
any inherent queue limitations or speed limitations.  There are a thousand 
things only the adapter driver knows that should be factored into a sane 
queue depth.

> - a regular disk and disk
> array can end up with the same queue depth (this is not ture for raid
> cards like ips, where the adapter is the device).

I don't see a problem here.  I have yet to meet a reasonable SCSI disk 
that doesn't do well with deep queues.  Raid devices I'm not so sure of, 
but I'll give them the benefit of the doubt and let them have a deep queue 
as well.  I would say the maximum speed of the interconnect combined with 
the maximum size of each command is a better guage upon which to determine 
queue depth than whether it's a real disk or logical disk.

> > Current goals of the work I'm doing include making this adjustable so you
> > aren't wasting queue depth on devices that have a hard limit less than
> 
> But, this won't lower it to some optimal magic number.

No, the controller driver in question should already have it's "optimum" 
number in mind, set the drive to that, then if it's too high it can come 
down.  There is no magical "Hey, send me more commands" status code, so 
you have to start high and go low, not the other way around.  That, of 
course, is why an adjustable depth is important.  The controller should 
set this "optimum" number based upon it's own capabilities and assume the 
drive is just as capable.

> > your initial queue depth value and changing the scsi_request_fn() to be
> > more fair with command allocation on a controller in the presence of
> > starvation (and of course, starvation is only possible when the queue
> > depth of all devices is greater than the depth of the controller, so
> > obviously the starvation code in scsi_request_fn() is something
> > controllers have been avoiding by limiting queue depths on individual
> > devices).
> 
> It would nice to have more device model/kernfs device attributes.
> 
> With your new queueing code, if we expose and allow setting new_queue_depth,
> user code can easily modify the queue depth.

No.  For the reasons that the driver knows what it's capable of, there 
really is *very* little tunability here.  But, should you really need it, 
the drivers should provide it (both mine and Justin's aic7xxx drivers do 
so run time via module options or boot command options).  Make the default 
a good common default, let users override if necessary.  But I wouldn't 
make it a fiddle knob that people can tweak without thinking.  Regardless 
of where you make it adjustable though, it has to be passed through the 
low level drivers so that they can adjust their internal data structs as 
needed (some won't have to do anything, some will have to do allocations 
or frees on every adjustment, so you *have* to pass all adjustments 
through them).

> I wanted to write some code in this area but don't have enoough time. It would
> not be hard to have a scsi_sdev_attrs.c file, that using macros could
> automagically create device attr files and functions for any selection of
> Scsi_Device fields. Locking might be an issue - since we don't have a
> Scsi_Device lock for queue depth, just one big lock, this is true for
> some of the other Scsi_Device fields.
> 
> A single function could be called in scsi_scan.c to setup all Scsi_Device
> device attribute files (i.e. calls device_create_file for multiple
> xxx_attr_types).
> 
> -- Patrick Mansfield
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
