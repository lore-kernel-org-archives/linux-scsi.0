From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH 04/11] megaraid_sas : Firmware crash dump feature support
Date: Thu, 11 Sep 2014 14:32:37 +0530
Message-ID: <a5608d878571884cb460c7c36a2082c9@mail.gmail.com>
References: <201409061328.s86DS6lO012975@palmhbs0.lsi.com> <540F22A2.3040906@redhat.com>
 <55ba5d7cdee7dbcce18dc1a2bbbefc03@mail.gmail.com> <94D0CD8314A33A4D9D801C0FE68B402958C70F51@G9W0745.americas.hpqcorp.net>
 <54106E28.1030807@redhat.com> <20140910154643.GC2166@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og121.obsmtp.com ([64.18.2.20]:58178 "EHLO
	exprod7og121.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaIKJCl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2014 05:02:41 -0400
Received: by mail-lb0-f182.google.com with SMTP id v6so6330757lbi.13
        for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2014 02:02:38 -0700 (PDT)
In-Reply-To: <20140910154643.GC2166@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, Tomas Henzl <thenzl@redhat.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, aradford@gmail.com, Michal Schmidt <mschmidt@redhat.com>, amirv@mellanox.com, axboe@kernel.dk, scameron@beardog.cce.hp.com

> -----Original Message-----
> From: Vivek Goyal [mailto:vgoyal@redhat.com]
> Sent: Wednesday, September 10, 2014 9:17 PM
> To: Tomas Henzl
> Cc: Elliott, Robert (Server Storage); Sumit Saxena;
linux-scsi@vger.kernel.org;
> martin.petersen@oracle.com; hch@infradead.org;
> jbottomley@parallels.com; Kashyap Desai; aradford@gmail.com; Michal
> Schmidt; amirv@mellanox.com; Jens Axboe <axboe@kernel.dk>
> (axboe@kernel.dk); scameron@beardog.cce.hp.com
> Subject: Re: [PATCH 04/11] megaraid_sas : Firmware crash dump feature
> support
>
> On Wed, Sep 10, 2014 at 05:28:40PM +0200, Tomas Henzl wrote:
> > On 09/10/2014 05:06 PM, Elliott, Robert (Server Storage) wrote:
> > >> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > >> owner@vger.kernel.org] On Behalf Of Sumit Saxena
> > >>
> > >>> From: Tomas Henzl [mailto:thenzl@redhat.com]
> > >>>
> > >>> With several controllers in a system this may take a lot memory,
> > >>> could you also in case when a kdump kernel is running lower it, by
> > >>> not using this feature?
> > >>>
> > >> Agreed, we will disable this feature for kdump kernel by adding
> > >> "reset_devices" global varaiable.
> > >> That check is required for only one place, throughout the code,
> > >> this feature will remain disabled.  Code snippet for the same-
> > >>
> > >>         instance->crash_dump_drv_support = (!reset_devices) &&
> > >> crashdump_enable &&
> > >>                                 instance->crash_dump_fw_support &&
> > >>                                 instance->crash_dump_buf);
> > >>         if(instance->crash_dump_drv_support) {
> > >>                 printk(KERN_INFO "megaraid_sas: FW Crash dump is
> > >> supported\n");
> > >>                 megasas_set_crash_dump_params(instance,
> > >> MR_CRASH_BUF_TURN_OFF);
> > >>
> > >>         } else {
> > >> ..
> > >>         }
> > > Network drivers have been running into similar problems.
> > >
> > > There's a new patch from Amir coming through net-next to make
> > > is_kdump_kernel() (in crash_dump.h) accessible to modules.
> > > That may be a better signal than reset_devices that the driver
> > > should use minimal resources.
> > >
> > > http://comments.gmane.org/gmane.linux.network/324737
> > >
> > > I'm not sure about the logistics of a SCSI patch depending on a
> > > net-next patch.
> >
> > Probably better to start with reset_devices and switch to
> > is_kdump_kernel() later.
> > This is not a discussion about reset_devices versus is_kdump_kernel,
> > but while it looks good to have it distinguished - is the
> > reset_devices actually used anywhere else than in kdump kernel?
>
> I think usage of reset_devices for lowering memory footprint of driver
is
> plain wrong. It tells driver to only reset the device as BIOS might not
have
> done it right or we skipped BIOS completely.
>
> Using is_kdump_kernel() is also not perfect either but atleast better
than
> reset_devices.

We will use is_kdump_kernel() not to enable this feature in Kdump kernel.

MegaRaid Driver will not allocate Host memory (which is used to collect
complete FW crash image) until and unless associated FW is crashed/IO
timeout.
Driver do allocation only if required. Also, it will break the function
immediately after memory allocation is failed and operate on available
memory.

To be on safer side, we can disable this feature in Kdump mode.

~ Kashyap
>
> Thanks
> Vivek
