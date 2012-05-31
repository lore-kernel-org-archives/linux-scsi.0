From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 00/18] libsas, sas_ata: update for 3.5
Date: Thu, 31 May 2012 11:12:54 -0700
Message-ID: <CAA9_cmchJKzNkHFgjTGTYxy_DYkHaJVH4s6m-jYH0whNhf-D7Q@mail.gmail.com>
References: <20120506181611.17912.3798.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120506181611.17912.3798.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, Jack Wang <jack_wang@usish.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, May 6, 2012 at 11:17 AM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> 1/ libsas suspend/resume support
>
> 2/ finish off the conversion of the strategy handlers to enforce only
> =A0 invoking them in eh context (to meet libata's expectations).
>
> 3/ a collection of discovery fixes, error handling fixes, and
> =A0 miscellaneous cleanups
>
> All of these patches, save for patch 18, are on their 2nd or 3rd rese=
nd.
> These have been soaking in -next since before the 3.4 merge window
> opened.

=2E..and it seems these will get to sit out another kernel

Please comment on these, I'd like to know which are NAK'd vs just ran
out of time to be integrated this round.  Jeff, some comments about
patch 12 and 14 below for you.

Can we at least get libsas suspend / resume support applied for 3.5?
If that's agreeable I'll put together a pared down pull-request??

> [PATCH 01/18] libsas: cleanup spurious calls to scsi_schedule_eh

A misuse of scsi_schedule_eh(), part of the effort to make sure
host_eh_scheduled is managed properly, but for now it's just cleanup
material because I have not root caused a test failure back to this
misuse.

> [PATCH 02/18] libata, libsas: introduce sched_eh and end_eh port ops

This was acked-by Jeff, not sure what the hold up is.

> [PATCH 03/18] scsi: fix eh wakeup (scsi_schedule_eh vs scsi_restart_o=
perations)

You had comments about this patch, I responded and then the
communication stopped.

> [PATCH 04/18] scsi_transport_sas: fix delete vs scan race

I have a new version under test after review feedback from Mike.

> [PATCH 05/18] libsas: enforce eh strategy handlers only in eh context
> [PATCH 06/18] libsas: add sas_eh_abort_handler
> [PATCH 07/18] libsas: use ->lldd_I_T_nexus_reset for ->eh_bus_reset_h=
andler
> [PATCH 08/18] isci: use sas eh strategy handlers

These are fixups to make sure the eh strategy handlers are called in
the proper context and that tasks are not terminated outside of
visibilty of the lldd.

> [PATCH 09/18] libsas: trim sas_task of slow path infrastructure
> [PATCH 10/18] libsas: sas_rediscover_dev did not look at the SMP exec=
 status.
> [PATCH 11/18] mvsas: remove unused variable in mvs_task_exec()

Minor clean up and fixlets.

> [PATCH 12/18] libata: reset once

Jeff, any objections on this one?

> [PATCH 13/18] libsas: continue revalidation

Discovery ends too early in some configurations, this could be -stable =
material.

> [PATCH 14/18] libata: export ata_port suspend/resume infrastructure f=
or sas

This plus patch 17 and a small enabling patch for isci and we have our
first tested libsas suspend / resume implementation in the kernel.
Needs an ack from Jeff.

> [PATCH 15/18] libsas: drop sata port multiplier infrastructure

Minor cleanup.

> [PATCH 16/18] scsi, sd: limit the scope of the async probe domain

Yea! 1 for 18 going upstream!  Sorry, couldn't resist :-).

> [PATCH 17/18] libsas: suspend / resume support

The aforementioned suspend / resume support.  I believe pm8001 is
ready to take advantage of this because their current hack is not
reliably working.

> [PATCH 18/18] scsi: cleanup setting task state in scsi_error_handler(=
)

Just a cleanup, whenever it goes in is fine.

--
Dan
