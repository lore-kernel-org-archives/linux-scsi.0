From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PATCH 0/5] isci updates for 3.2
Date: Fri, 30 Sep 2011 18:55:42 -0700
Message-ID: <CAA9_cmdA6DFpJi57BjVPpr2o_Wzy_-eyv+u_r=PRazv7Zo6cwA@mail.gmail.com>
References: <20110929013717.23617.3675.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35924 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1JABzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2011 21:55:43 -0400
Received: by qadb15 with SMTP id b15so696505qad.19
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2011 18:55:42 -0700 (PDT)
In-Reply-To: <20110929013717.23617.3675.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: dmilburn@redhat.com, dave.jiang@intel.com, hare@suse.de, linux-scsi@vger.kernel.org

On Wed, Sep 28, 2011 at 6:47 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> This series functionally depends on the pending libsas fix for ata lu=
n
> scanning. =A0For convenience those updates have been queued to
> "git://github.com:djbw/linux.git libsas".
>
> The following changes since commit 7705375e944ea94be7941b740efd0a77bb=
109cb1:
>
> =A0libsas: remove unused ata_task_resp fields (2011-09-28 18:06:10 -0=
700)
>
> are available in the git repository at:
> =A0git://github.com:djbw/linux.git isci
>
> The prominent update in this set is atapi support. =A0The rest are sm=
all
> bug fixes and feature enhancements. =A0More error handling and comman=
d
> termination fixes are in the works.
>

Reflowed with the fixed version of the atapi patch.

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index cb3dd6e..565a9f0 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -3106,7 +3106,8 @@ static void
sci_request_started_state_enter(struct sci_base_state_machine *sm)
                        state =3D SCI_REQ_STP_PIO_WAIT_H2D;
                }
        } else {
-               BUG();
+               /* SSP or NCQ are fully accelerated, no substates */
+               return;
        }
        sci_change_state(sm, state);
 }

New diffstat below.

The following changes since commit a265fbf9a7c4321a71394bdce22da2be119f=
dba1:

  libsas: set rphy sas_address and device type correctly (2011-09-30
18:35:16 -0700)

are available in the git repository at:
  git://github.com/djbw/linux.git isci

Dan Williams (2):
      isci: atapi support
      isci: export phy events via ->lldd_control_phy()

Jeff Skirvin (3):
      isci: SATA/STP I/O is only returned in the normal path to libsas
      isci: fix decode of DONE_CRC_ERR TC completion status
      isci: The port state should be set to stopping on the last phy.

 drivers/scsi/aic94xx/aic94xx_scb.c  |    1 +
 drivers/scsi/isci/phy.c             |   11 ++
 drivers/scsi/isci/port.c            |    2 +-
 drivers/scsi/isci/remote_device.c   |   24 +++
 drivers/scsi/isci/remote_device.h   |    9 +
 drivers/scsi/isci/request.c         |  331 +++++++++++++++++++++++++++=
++++++--
 drivers/scsi/isci/request.h         |   28 +++-
 drivers/scsi/isci/task.h            |   19 ++
 drivers/scsi/libsas/sas_init.c      |   13 +-
 drivers/scsi/libsas/sas_scsi_host.c |    2 +-
 drivers/scsi/mvsas/mv_sas.c         |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c    |    2 +-
 include/scsi/libsas.h               |    5 +
 include/scsi/sas.h                  |    1 +
 14 files changed, 425 insertions(+), 25 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
