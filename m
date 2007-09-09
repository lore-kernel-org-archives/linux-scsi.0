From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 0/9] scsi_data_buffer structure (in preparation for
 bidi)
Date: Sun, 9 Sep 2007 22:47:06 +0900
Message-ID: <20070909045734Y.tomof@acm.org>
References: <20070906183448I.tomof@acm.org>
	<46E3AE15.1060204@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:56156 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXIINry (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Sep 2007 09:47:54 -0400
In-Reply-To: <46E3AE15.1060204@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: tomof@acm.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

On Sun, 09 Sep 2007 11:25:57 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On Fri, Sep 07 2007 at 0:50 +0300, FUJITA Tomonori <tomof@acm.org> wrote:
> > This patchset, which I submitted before, adds a new data structure, 
> > scsi_data_buffer, including everything for data transfer:
> > 
> > struct scsi_data_buffer { unsigned length; int resid; short sg_count;
> >  short __sg_count; struct scatterlist *sglist; };
> > 
> > One scsi_data_buffer structure is embedded in struct scsi_cmnd for 
> > uni-directional transfer. All the members are just moved from 
> > scsi_cmnd structure to scsi_data_buffer structure. So nothing is
> > added to scsi_cmnd structure.
> > 
> > After applying this patchset, llds must use the scsi data accessors.
> > This patchset includes some conversation patches (most of them are
> > patches that Boaz submitted before), however there is still some code
> > that is needed to be converted.
> > 
> > Boaz, if you still have other conversation patches, please submit 
> > them.
> > 
> > I suspect that nobody cares about some of unconverted llds, which
> > will be not compilable after this patchset. I'll fix ldds that people
> >  complain about.
> > 
> > It's difficult to test this patchset in -mm via scsi-misc. Jens, 
> > please send this to -mm via the block tree.
> 
> Sorry for the late response. Just am back from vacation.
> 
> Tomo please hold with these patches a bit longer the
> Tree is not ready for it. 

Then we have no chance to merge scsi_data_buffer into 2.6.24.


> Mainly you will totally break USB storage mid-layer. 
> There is one converted USB driver - microtek.c - that is 
> currently broken. This is because usb mid-layer still issues 
> a synchronous REQUEST_SENSE with use_sg == 0. 
> (And still bangs all over scsi_cmnd members) I have a 
> complete and somewhat tested solution for the USB stack
> and all the drivers. as well as lots of other drivers 
> (see list below). I will submit them group by group during
> this week and next week. The reason I did not release them
> yet is because I did not want to do this before the vacation
> and not be available for debugging.
> 
> Some of the files I have patches for are:
> 
> git-diff --stat
>  drivers/fc4/fc.c                    |   40 ++---

I think that I fixed fc4 (the patch is in scsi-misc).


>  drivers/scsi/NCR5380.c              |   39 ++--
>  drivers/scsi/NCR5380.h              |    7 +
>  drivers/scsi/NCR53C9x.c             |   40 ++---
>  drivers/scsi/NCR53C9x.h             |    2 -
>  drivers/scsi/a2091.c                |   36 +---
>  drivers/scsi/a3000.c                |   15 +--
>  drivers/scsi/aha1542.c              |   54 ++----
>  drivers/scsi/arm/acornscsi.c        |   14 +-
>  drivers/scsi/arm/fas216.c           |    5 +-
>  drivers/scsi/arm/fas216.h           |    3 +
>  drivers/scsi/arm/scsi.h             |   34 +---
>  drivers/scsi/atari_NCR5380.c        |   47 ++---
>  drivers/scsi/atp870u.c              |  102 ++---------
>  drivers/scsi/dec_esp.c              |   17 --
>  drivers/scsi/eata_pio.c             |   12 +-
>  drivers/scsi/fd_mcs.c               |   36 +---
>  drivers/scsi/gdth.c                 |    2 +-
>  drivers/scsi/imm.c                  |   13 +-
>  drivers/scsi/in2000.c               |   10 +-
>  drivers/scsi/oktagon_esp.c          |   14 --
>  drivers/scsi/pluto.c                |    2 +-
>  drivers/scsi/ppa.c                  |   12 +-
>  drivers/scsi/qla1280.c              |  348 +++++++++++++++--------------------

The patchset includes qla1280 conversion.


>  drivers/scsi/qlogicpti.c            |   54 +-----
>  drivers/scsi/scsi_error.c           |  114 ++++++++----

The patchset includes your patch to convert scsi_error.c. What else do
you want to change?


>  drivers/scsi/seagate.c              |   17 +-
>  drivers/scsi/sun3_NCR5380.c         |   42 ++---
>  drivers/scsi/sun3x_esp.c            |   21 +--
>  drivers/scsi/wd33c93.c              |   10 +-
>  drivers/usb/storage/freecom.c       |   14 +-
>  drivers/usb/storage/isd200.c        |    6 +-
>  drivers/usb/storage/protocol.c      |  120 +++++-------
>  drivers/usb/storage/sddr09.c        |    9 +-
>  drivers/usb/storage/shuttle_usbat.c |   54 +++---
>  drivers/usb/storage/transport.c     |   95 ++++------
>  drivers/usb/storage/transport.h     |    2 +
>  include/scsi/scsi_eh.h              |   17 ++-
>  38 files changed, 574 insertions(+), 905 deletions(-)
> 
> 
> If any of these are obsolete and should be removed please
> say so. Save me the work to submit them.

I think that nobody cares about some of these drivers and they might
be even broken. We need to merge the patchset to -mm and then we can
see what drivers people still care about. And if necessary, we can
blindly just convert drivers.
