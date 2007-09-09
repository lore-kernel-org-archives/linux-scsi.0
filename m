From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/9] scsi_data_buffer structure (in preparation for bidi)
Date: Sun, 09 Sep 2007 11:25:57 +0300
Message-ID: <46E3AE15.1060204@panasas.com>
References: <20070906183448I.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:28283 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751271AbXIII01 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 04:26:27 -0400
In-Reply-To: <20070906183448I.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com
Cc: James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

On Fri, Sep 07 2007 at 0:50 +0300, FUJITA Tomonori <tomof@acm.org> wrote:
> This patchset, which I submitted before, adds a new data structure, 
> scsi_data_buffer, including everything for data transfer:
> 
> struct scsi_data_buffer { unsigned length; int resid; short sg_count;
>  short __sg_count; struct scatterlist *sglist; };
> 
> One scsi_data_buffer structure is embedded in struct scsi_cmnd for 
> uni-directional transfer. All the members are just moved from 
> scsi_cmnd structure to scsi_data_buffer structure. So nothing is
> added to scsi_cmnd structure.
> 
> After applying this patchset, llds must use the scsi data accessors.
> This patchset includes some conversation patches (most of them are
> patches that Boaz submitted before), however there is still some code
> that is needed to be converted.
> 
> Boaz, if you still have other conversation patches, please submit 
> them.
> 
> I suspect that nobody cares about some of unconverted llds, which
> will be not compilable after this patchset. I'll fix ldds that people
>  complain about.
> 
> It's difficult to test this patchset in -mm via scsi-misc. Jens, 
> please send this to -mm via the block tree.

Sorry for the late response. Just am back from vacation.

Tomo please hold with these patches a bit longer the
Tree is not ready for it. 

Mainly you will totally break USB storage mid-layer. 
There is one converted USB driver - microtek.c - that is 
currently broken. This is because usb mid-layer still issues 
a synchronous REQUEST_SENSE with use_sg == 0. 
(And still bangs all over scsi_cmnd members) I have a 
complete and somewhat tested solution for the USB stack
and all the drivers. as well as lots of other drivers 
(see list below). I will submit them group by group during
this week and next week. The reason I did not release them
yet is because I did not want to do this before the vacation
and not be available for debugging.

Some of the files I have patches for are:

git-diff --stat
 drivers/fc4/fc.c                    |   40 ++---
 drivers/scsi/NCR5380.c              |   39 ++--
 drivers/scsi/NCR5380.h              |    7 +
 drivers/scsi/NCR53C9x.c             |   40 ++---
 drivers/scsi/NCR53C9x.h             |    2 -
 drivers/scsi/a2091.c                |   36 +---
 drivers/scsi/a3000.c                |   15 +--
 drivers/scsi/aha1542.c              |   54 ++----
 drivers/scsi/arm/acornscsi.c        |   14 +-
 drivers/scsi/arm/fas216.c           |    5 +-
 drivers/scsi/arm/fas216.h           |    3 +
 drivers/scsi/arm/scsi.h             |   34 +---
 drivers/scsi/atari_NCR5380.c        |   47 ++---
 drivers/scsi/atp870u.c              |  102 ++---------
 drivers/scsi/dec_esp.c              |   17 --
 drivers/scsi/eata_pio.c             |   12 +-
 drivers/scsi/fd_mcs.c               |   36 +---
 drivers/scsi/gdth.c                 |    2 +-
 drivers/scsi/imm.c                  |   13 +-
 drivers/scsi/in2000.c               |   10 +-
 drivers/scsi/oktagon_esp.c          |   14 --
 drivers/scsi/pluto.c                |    2 +-
 drivers/scsi/ppa.c                  |   12 +-
 drivers/scsi/qla1280.c              |  348 +++++++++++++++--------------------
 drivers/scsi/qlogicpti.c            |   54 +-----
 drivers/scsi/scsi_error.c           |  114 ++++++++----
 drivers/scsi/seagate.c              |   17 +-
 drivers/scsi/sun3_NCR5380.c         |   42 ++---
 drivers/scsi/sun3x_esp.c            |   21 +--
 drivers/scsi/wd33c93.c              |   10 +-
 drivers/usb/storage/freecom.c       |   14 +-
 drivers/usb/storage/isd200.c        |    6 +-
 drivers/usb/storage/protocol.c      |  120 +++++-------
 drivers/usb/storage/sddr09.c        |    9 +-
 drivers/usb/storage/shuttle_usbat.c |   54 +++---
 drivers/usb/storage/transport.c     |   95 ++++------
 drivers/usb/storage/transport.h     |    2 +
 include/scsi/scsi_eh.h              |   17 ++-
 38 files changed, 574 insertions(+), 905 deletions(-)


If any of these are obsolete and should be removed please
say so. Save me the work to submit them.

Thanks
Boaz
 
