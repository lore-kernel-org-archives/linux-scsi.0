From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 16:30:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015163057.A7687@eng2.beaverton.ibm.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <20021015130445.A829@eng2.beaverton.ibm.com> <20021015205218.GG4391@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021015205218.GG4391@redhat.com>; from dledford@redhat.com on Tue, Oct 15, 2002 at 04:52:18PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>, 'Dave Hansen' <haveblue@us.ibm.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Oct 15, 2002 at 04:52:18PM -0400, Doug Ledford wrote:
> On Tue, Oct 15, 2002 at 01:04:45PM -0700, Patrick Mansfield wrote:
> > 
> > I totally agree the queue depth should not be limited based on the number of
> > devices, but there should be a maximum limit - as Justin noted with the
> > aic driver, using a large default queue depth (he had 253 or so) is not
> > good with linux.
> 
> That's largely due to the scsi_request_fn() in its current form.

I don't understand that.

> 
> > The queue depth should be as small as possible without limiting the
> > performance.
> 
> Which happens to be a magic number that no one really knows I think ;-)  

Yes, but that implies that adapters should not be relied upon to set
the queue depth. If the adapter is setting queue depth based upon what
the adapter knows, that is completely wrong - a regular disk and disk
array can end up with the same queue depth (this is not ture for raid
cards like ips, where the adapter is the device).

> Current goals of the work I'm doing include making this adjustable so you
> aren't wasting queue depth on devices that have a hard limit less than

But, this won't lower it to some optimal magic number.

> your initial queue depth value and changing the scsi_request_fn() to be
> more fair with command allocation on a controller in the presence of
> starvation (and of course, starvation is only possible when the queue
> depth of all devices is greater than the depth of the controller, so
> obviously the starvation code in scsi_request_fn() is something
> controllers have been avoiding by limiting queue depths on individual
> devices).

It would nice to have more device model/kernfs device attributes.

With your new queueing code, if we expose and allow setting new_queue_depth,
user code can easily modify the queue depth.

I wanted to write some code in this area but don't have enoough time. It would
not be hard to have a scsi_sdev_attrs.c file, that using macros could
automagically create device attr files and functions for any selection of
Scsi_Device fields. Locking might be an issue - since we don't have a
Scsi_Device lock for queue depth, just one big lock, this is true for
some of the other Scsi_Device fields.

A single function could be called in scsi_scan.c to setup all Scsi_Device
device attribute files (i.e. calls device_create_file for multiple
xxx_attr_types).

-- Patrick Mansfield
