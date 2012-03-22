From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [isci PATCH v3 0/4] isci: suspend/resume support+
Date: Wed, 21 Mar 2012 23:48:01 -0700
Message-ID: <CAA9_cmeKmf-yPqmsa8fnbhS1xZRDg+7v2u2xqorL7+gRt8ZY-g@mail.gmail.com>
References: <20120314071312.7223.10946.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44856 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2CVGsC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Mar 2012 02:48:02 -0400
In-Reply-To: <20120314071312.7223.10946.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

On Wed, Mar 14, 2012 at 12:13 AM, Dan Williams <dan.j.williams@intel.co=
m> wrote:
> Changes since v2: http://marc.info/?l=3Dlinux-scsi&m=3D13314499972873=
7&w=3D2
>
> This topic has been rebased on top of the libsas topic / scsi-misc:
> http://marc.info/?l=3Dlinux-scsi&m=3D133170574921314&w=3D2
>
> 1/ Fixed handling of the 'device unplugged during suspend' case.
> =A0 sd_remove() sets up an ABBA deadlock with the driver-core device_=
lock()
> =A0 and async_synchronize_full(), so this version arranges for resume
> =A0 actions to be flushed before attempting removals.
>
> 2/ Add a new fix for a case where the isci driver inadvertently filte=
rs
> =A0 BCNs
>
> 3/ Fix up compile breakage in the CONFIG_PM=3Dn case
>
> 4/ Minor fixups for the rebase (sas_init_dev reindent collision)
>
> [isci PATCH v3 1/4] libata: export ata_port suspend/resume infrastruc=
ture for sas
> [isci PATCH v3 2/4] libsas: drop sata port multiplier infrastructure
> [isci PATCH v3 3/4] libsas: suspend / resume support
> [isci PATCH v3 4/4] isci: enable BCN in sci_port_add_phy()
>
> Full diffstat versus scsi-misc (cd8df93..isci-for-3.4-v3):

v4 of this topic is available here:

 git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git isci-for-3=
=2E4-v4

the only difference is that it has been rebased to move the libsas
patches (suspend/resume support) to libsas-eh-reworks-v12.  Patch
contents are identical

The following changes since commit f0238d3adfebb8a1f556fe0df5dfe2b3a93f=
e660:

  libsas: suspend / resume support (2012-03-21 21:59:45 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git isci-for-=
3.4-v4

Andrzej Jakowski (1):
      isci: Changes in COMSAS timings enabling ISCI to detect buggy dis=
c drives.

Artur Wojcik (1):
      isci: implement suspend/resume support

Dan Williams (10):
      isci: improve 'invalid state' warnings
      isci: kill ->is_direct_attached
      isci: kill sci_phy_protocol and sci_request_protocol
      isci: kill ->status, and ->state_lock in isci_host
      isci: kill isci_port.domain_dev_list
      isci: refactor initialization for S3/S4
      isci: fix controller stop
      isci: fix 'link-up' events occur after 'start-complete'
      isci: fix interrupt disable
      isci: kill isci_host.shost

Jesper Juhl (1):
      isci: Just #include "host.h" once in host.c

Maciej Trela (1):
      isci: enable BCN in sci_port_add_phy()

Tom Jackson (1):
      isci: Don't filter BROADCAST CHANGE primitives

 drivers/scsi/isci/host.c                      |  565 +++++++++--------=
--------
 drivers/scsi/isci/host.h                      |  118 ++----
 drivers/scsi/isci/init.c                      |  271 +++++++++++--
 drivers/scsi/isci/phy.c                       |   74 +++-
 drivers/scsi/isci/phy.h                       |    9 +-
 drivers/scsi/isci/port.c                      |   23 +-
 drivers/scsi/isci/port.h                      |    6 -
 drivers/scsi/isci/port_config.c               |   18 +-
 drivers/scsi/isci/probe_roms.c                |   12 -
 drivers/scsi/isci/probe_roms.h                |    2 -
 drivers/scsi/isci/registers.h                 |    8 +
 drivers/scsi/isci/remote_device.c             |   29 +-
 drivers/scsi/isci/remote_device.h             |    1 -
 drivers/scsi/isci/remote_node_context.c       |   60 ++--
 drivers/scsi/isci/request.c                   |   19 +-
 drivers/scsi/isci/request.h                   |    9 +-
 drivers/scsi/isci/unsolicited_frame_control.c |   30 +-
 drivers/scsi/isci/unsolicited_frame_control.h |    6 +-
 include/scsi/sas.h                            |    1 +
 19 files changed, 626 insertions(+), 635 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
