From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: [PATCH] SCSI Core patches
Date: Fri, 10 Jan 2003 04:35:47 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10301100432030.31168-100000@master.linux-ide.org>
References: <20030108211306.GG1112@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030108211306.GG1112@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org


How about just a simple two layer with looping between the tow to hang
personalities on, and finally hooking the HBA's to handle exceptions only
against a native bus-phase (want to say state machine) fuzzy mung of, erm
SAM3 ??

Oh well not that important to model the transport/physical boundaries.

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On Wed, 8 Jan 2003, Mike Anderson wrote:

> Luben Tuikov [luben@splentec.com] wrote:
> > >I'm arguing for a linked list of structs that hold the minimum data we
> > >need to use them as a path - much like a scsi_device with the redundant
> > >fields removed (and if needed it can also point to the actual
> > >scsi_device). And then plugging this data (or a pointer) into a scsi_cmnd
> > >for use by the LLDD.
> > 
> > This may be an easier approach, but a scsi_cmnd stands for SCSI command.
> > 
> 
> but struct scsi_device currently stands for more than the LLDD
> scsi_device. It stands for a block request queue, scsi mid data, and
> scsi host device data. 
> 
> While in the short term struct scsi_device already exists and appears to
> be the right next progression to use. Future progression of abstraction
> should look at some separation of the LLDD nexus device data and the
> other struct scsi_device data. Maybe in the future part of struct scsi_device
> will be a nexus handle given to the mid layer by the LLDD to represent
> its object which will be plugged into the scsi_cmnd.
> 
> > Its a good thing to have multipathing represented as an ADT (abstract
> > data type).  Say something like a linked list of structs with
> > cost/weight member and a pointer to an actual low-level device (the 
> > infrastructure
> > will be more involved since multipathing will need to be notified
> > when a device goes away, but read further...).  Now this ADT may be embeded
> > into a block device and char device structs -- i.e. highest hierarchy.
> > (The assumption is that there won't be a device which will present
> > a char and block interface at the same time.)
> > 
> > Now since this ADT is embeded into the block/char device, we do get
> > notification when it goes away. So this should be ok.
> > 
> > The effect is that when write(fd, buf, count) is done, somewhere along
> > the way *before* the actual physical device (ide,scsi,etc) is referenced
> > multipathing has already been accomplished.  This preserves as much as 
> > possible
> > the current infrastructure of the kernel.
> > 
> > So when a low-level device (LLD) says that it cannot satisfy the request,
> > you *may* try another path.
> > 
> > In effect a low-level device *as seen from the multipath code* is the tuple
> > (PATH, DEVICE), and this is where a request is sent, i.e. to the tuple
> > (PATH, DEVICE). Where for each PATH, there can be exactly one DEVICE, since
> > a PATH describes a device (or access to it), but the opposite is not 
> > necessarily
> > true. I.e. for each DEVICE there can be zero/one to many PATHs.
> > 
> > >As long as we have an interface (function or macro), I'm not strongly
> > >opposed to the above. We can keep the scsi_allocate_device (in dire need
> > >of a new name), and just have it allocate and init (or not) any fields as
> > >needed, so there is only one place to change the init of the allocated
> > >scsi_cmnd.
> > 
> > The SCSI Core has a well-defined funtion. I'm not so sure that we
> > should muck it up with other well-defined functions, like multipathing.
> > 
> 
> I would counter that moving device and transport knowledge into the
> upper level might also muck up that level.
> 
> While it is not difficult to link paths together inside an object it
> becomes more difficult to make good decisions on how to use the paths
> beyond simple fail-over. There are device and platform specific
> characteristics that effect performance and error policy. These
> personalities exist in multipath OS core support in AIX, MS, and
> DYNIX/ptx and vendor specific multi-path support drivers available for
> most OS's. While the implementation is unique to the OS environment the
> need for path personalities is common.
> 
> These type of issues are touched on in the mid-multipath document.
> 
> > It is *inevitable* that multipathing will be moved up into the
> > generic device char and block structs; sooner or later.
> 
> The inevitable hopefully will wait until we get a few more versions of
> the mid-level patch out and discuss code specific pro / cons of mid vs
> upper layer implementations.
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

