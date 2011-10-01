From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PULL] libsas updates for 3.2
Date: Fri, 30 Sep 2011 19:04:04 -0700
Message-ID: <CAA9_cmfVABbV5Y-tsn5BESmgoxiF=2cgUzmcmfDu0_M9v2dwqA@mail.gmail.com>
References: <1317261664.22593.15.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56392 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1JACEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2011 22:04:05 -0400
Received: by qadb15 with SMTP id b15so698022qad.19
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2011 19:04:05 -0700 (PDT)
In-Reply-To: <1317261664.22593.15.camel@dwillia2-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, Dave Jiang <dave.jiang@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Sep 28, 2011 at 7:01 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> The following changes since commit 41e9a69641fb3fa86fa9277a179f3ad261=
d072f7:
>
> =A0[SCSI] ipr: Stop reading adapter dump prematurely (2011-09-22 15:3=
0:28 +0400)
>
> are available in the git repository at:
> =A0git://github.com:djbw/linux.git libsas
>
> These have all appeared on the mailing list previously save for the l=
ast
> one "libsas: remove unused ata_task_resp fields" (just a cleanup).
>
> Just a convenience branch since isci's atapi support needed the lun
> scanning fixup as a baseline.
>

Given that none of the patches on the libsas-fixes branch would pass
Linus' "does this fix a known regression" test for late rc changes I
have gone ahead and moved those patches over to the libsas branch.  No
other changes have been made.

The locking fix might be a consideration, but since it has been this
way for quite a few releases we can wait for the 3.2 merge and submit
it to -stable.

--
Dan

The following changes since commit 41e9a69641fb3fa86fa9277a179f3ad261d0=
72f7:

  [SCSI] ipr: Stop reading adapter dump prematurely (2011-09-22 15:30:2=
8 +0400)

are available in the git repository at:
  git://github.com/djbw/linux.git libsas

Dan Williams (9):
      libsas: disable scanning lun > 0 on ata devices
      libsas: fix ->change_queue_{depth|type} for sata devices
      libsas: dynamic queue depth
      mvsas: remove mvs_slave_{alloc|configure}
      pm8001: remove pm8001_slave_{alloc|configure}
      libsas: fix try_test_sas_gpio_gp_bit() build error
      libsas: remove unused ata_task_resp fields
      libsas: fix warnings when checking sata/stp protocol
      libsas: fix port->dev_list locking

Jack Wang (1):
      libsas: set rphy sas_address and device type correctly

Luben Tuikov (1):
      libsas: Allow expander T-T attachments

 drivers/ata/libata-core.c           |    1 +
 drivers/ata/libata-scsi.c           |   44 +++++++++++++++++++++++----=
--------
 drivers/scsi/libsas/sas_ata.c       |    4 ---
 drivers/scsi/libsas/sas_discover.c  |   13 ++++++----
 drivers/scsi/libsas/sas_expander.c  |   37 +++++++++++++++++++--------=
-
 drivers/scsi/libsas/sas_scsi_host.c |   42 +++++++++++++++++++--------=
------
 drivers/scsi/mvsas/mv_init.c        |    4 +-
 drivers/scsi/mvsas/mv_sas.c         |   30 -----------------------
 drivers/scsi/mvsas/mv_sas.h         |    2 -
 drivers/scsi/pm8001/pm8001_init.c   |    4 +-
 drivers/scsi/pm8001/pm8001_sas.c    |   31 +-----------------------
 drivers/scsi/pm8001/pm8001_sas.h    |    2 -
 drivers/scsi/scsi_transport_sas.c   |   10 ++++++-
 include/linux/libata.h              |    2 +
 include/scsi/libsas.h               |   19 ++++++++------
 include/scsi/sas.h                  |   15 ++++++++++-
 16 files changed, 126 insertions(+), 134 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
