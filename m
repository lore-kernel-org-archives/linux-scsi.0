From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 04/11] megaraid_sas : Firmware crash dump feature support
Date: Wed, 10 Sep 2014 11:46:43 -0400
Message-ID: <20140910154643.GC2166@redhat.com>
References: <201409061328.s86DS6lO012975@palmhbs0.lsi.com>
 <540F22A2.3040906@redhat.com>
 <55ba5d7cdee7dbcce18dc1a2bbbefc03@mail.gmail.com>
 <94D0CD8314A33A4D9D801C0FE68B402958C70F51@G9W0745.americas.hpqcorp.net>
 <54106E28.1030807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbaIJPsZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 11:48:25 -0400
Content-Disposition: inline
In-Reply-To: <54106E28.1030807@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Sumit Saxena <sumit.saxena@avagotech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@infradead.org" <hch@infradead.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, Kashyap Desai <kashyap.desai@avagotech.com>, "aradford@gmail.com" <aradford@gmail.com>, Michal Schmidt <mschmidt@redhat.com>, "amirv@mellanox.com" <amirv@mellanox.com>, "Jens Axboe <axboe@kernel.dk> (axboe@kernel.dk)" <axboe@kernel.dk>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>

On Wed, Sep 10, 2014 at 05:28:40PM +0200, Tomas Henzl wrote:
> On 09/10/2014 05:06 PM, Elliott, Robert (Server Storage) wrote:
> >> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> >> owner@vger.kernel.org] On Behalf Of Sumit Saxena
> >>
> >>> From: Tomas Henzl [mailto:thenzl@redhat.com]
> >>>
> >>> With several controllers in a system this may take a lot memory,
> >>> could you also in case when a kdump kernel is running lower it,
> >>> by not using this feature?
> >>>
> >> Agreed, we will disable this feature for kdump kernel by adding
> >> "reset_devices" global varaiable.
> >> That check is required for only one place, throughout the code, this
> >> feature will remain disabled.  Code snippet for the same-
> >>
> >>         instance->crash_dump_drv_support = (!reset_devices) &&
> >> crashdump_enable &&
> >>                                 instance->crash_dump_fw_support &&
> >>                                 instance->crash_dump_buf);
> >>         if(instance->crash_dump_drv_support) {
> >>                 printk(KERN_INFO "megaraid_sas: FW Crash dump is
> >> supported\n");
> >>                 megasas_set_crash_dump_params(instance,
> >> MR_CRASH_BUF_TURN_OFF);
> >>
> >>         } else {
> >> ..
> >>         }
> > Network drivers have been running into similar problems.
> >
> > There's a new patch from Amir coming through net-next to make 
> > is_kdump_kernel() (in crash_dump.h) accessible to modules.
> > That may be a better signal than reset_devices that the
> > driver should use minimal resources.
> >
> > http://comments.gmane.org/gmane.linux.network/324737
> >
> > I'm not sure about the logistics of a SCSI patch depending
> > on a net-next patch.
> 
> Probably better to start with reset_devices and switch to is_kdump_kernel()
> later. 
> This is not a discussion about reset_devices versus is_kdump_kernel, but
> while it looks good to have it distinguished - is the reset_devices actually
> used anywhere else than in kdump kernel?

I think usage of reset_devices for lowering memory footprint of driver
is plain wrong. It tells driver to only reset the device as BIOS might
not have done it right or we skipped BIOS completely.

Using is_kdump_kernel() is also not perfect either but atleast better than
reset_devices.

Thanks
Vivek
