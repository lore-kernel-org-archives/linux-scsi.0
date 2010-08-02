From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: linux-next: build failure after merge of the final tree (scsi-post-merge tree related)
Date: Mon, 2 Aug 2010 14:59:25 -0400
Message-ID: <20100802185925.GA32503@andromeda.dapyr.net>
References: <20100803024445.0bf7ec86.sfr@canb.auug.org.au> <20100803024701.b3dff69a.sfr@canb.auug.org.au> <1280768048.2843.242.camel@mulgrave.site> <4C570464.9010204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C570464.9010204@cs.wisc.edu>
Sender: linux-next-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Jayamohan Kallickal <jayamohank@serverengines.com>, Randy Dunlap <randy.dunlap@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 02, 2010 at 12:46:12PM -0500, Mike Christie wrote:
> On 08/02/2010 11:54 AM, James Bottomley wrote:
> >missing linux-scsi added to cc list.
> >
> >On Tue, 2010-08-03 at 02:47 +1000, Stephen Rothwell wrote:
> >>Hi all,
> >>
> >>On Tue, 3 Aug 2010 02:44:45 +1000 Stephen Rothwell<sfr@canb.auug.org.au>  
> >>wrote:
> >>>
> >>>After merging the final tree, today's linux-next build (powerpc 
> >>>allmodconfig)
> >>>failed like this:
> >>>
> >>>ERROR: ".iscsi_boot_destroy_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] 
> >>>undefined!
> >>>ERROR: ".iscsi_boot_create_host_kset" 
> >>>[drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
> >>>ERROR: ".iscsi_boot_create_target" [drivers/scsi/be2iscsi/be2iscsi.ko] 
> >>>undefined!
> >>>ERROR: ".iscsi_boot_create_initiator" 
> >>>[drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
> >>>ERROR: ".iscsi_boot_create_ethernet" [drivers/scsi/be2iscsi/be2iscsi.ko] 
> >>>undefined!
> >>>
> >>>Caused by commit a33e2a708b2e83ee6111e45c8d3d49a112c3c887 ("[SCSI]
> >>>be2iscsi: Add support for iscsi boot").  For some reason, commit
> >>>ed94aa526655d915076dcdbbf4fc962b2a67fcb5 ("[SCSI] be2iscsi: select
> >>>ISCSI_BOOT_SYSFS") was not sufficient to make sure that
> >>>CONFIG_ISCSI_BOOT_SYSFS is defined for this build.
> >>
> >>It turns out that drivers/firmware/Kconfig is only included on x86, ia64
> >>and blackfin.
> >
> >OK, we need to turn this around then and make be2iscsi only use iscsi
> >boot if it's enabled ... that's going to be some fun #ifdefing in the
> >driver.
> >
> 
> I think my mistake was to put iscsi_boot_sysfs in drivers/firmware. The 

Yikes. Last minute change, eh?

> interface is generic and should be used on any arch and with anything 
> (ibft or iscsi driver) that wants to export iscsi boot info. The 
> attached patch moves iscsi_boot_sysfs to drivers/scsi. It was made over 
> linux-next. I have only compile tested it.

did you compile test it with the x86 native iBFT driver?
