From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 7 Jan 2003 14:44:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030107194445.GC11402@redhat.com>
References: <3E1ADC9A.6090800@splentec.com> <20030107102127.B15528@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030107102127.B15528@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org

On Tue, Jan 07, 2003 at 10:21:27AM -0800, Patrick Mansfield wrote:
> On Tue, Jan 07, 2003 at 08:56:42AM -0500, Luben Tuikov wrote:
> > The three incremental patches which I posted got mutilated
> > when pasted into Mozilla from the X clipboard buffer.
> > (TAB char got 2 spaces.)
> > 
> > The patches are also available, in pristine form, here:
> > http://www.splentec.com/~luben/patches.html
> 
> For use with multi-path, it is very useful to have the path in the
> scsi_cmnd, and generally to not have the lldd's know about the scsi_device
> at all, such that we can pick a path, and send a scsi_cmnd to a lldd.
> 
> Putting path information only in scsi_device makes it hard to do
> multi-path below (or even in) the block layer, and makes it hard to
> multi-path non block devices (like tape).

Not true at all.  This is completely an implementation issue.  If you 
implement scsi multipath in certain ways, then this is true.  My preferred 
implementation for something like this wouldn't have this problem at all.  
My preferred implementation would have one scsi_device struct per path, 
but would only register the first/primary device with the block layer (or 
char layer as the case may be), and during scsi_scan detection the 
duplicate paths would be added to the primary path by using a list_struct 
item to link the devices.  Then you pick the path by picking the device 
struct you need.  The primary path goes away, you change the device 
registration to point to a new primary path scsi_device struct.  So I 
don't see the difficulty at all myself.

> I would prefer we keep the current scsi_cmnd with its
> host/channel/target[id]/lun.

One of the goals of this change is to eliminate scsi_build_commandblocks() 
entirely and do away with keeping a per-device list of pre-allocated and 
pre-filled in commands.  We could put the data items back into the struct, 
but that would then mean that scsi_get_command() would have to init the 
items from the device struct in question, then the lldd would init their 
command from these items.  In short, it would save us having to change all 
the lldd (which Luben has already done), but would cost us double init'ing 
items for no real purpose.  I would prefer to leave them out.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
