From: Dan Williams <dan.j.williams@intel.com>
Subject: [set4 resend PATCH 0/5] libsas,
 libata: suspend / resume and "reset once"
Date: Mon, 09 Jul 2012 19:33:20 -0700
Message-ID: <20120710023241.26249.13718.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com, JBottomley@parallels.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jeff,

Let me know if any of these need reworking, otherwise I believe James is
waiting on your ack to take them (well, all except patch1) through scsi.git.

--
Dan


Original description:
Set4 of 5 patchsets to update scsi, libsas, and libata in
support of the isci driver.

Let libsas hook into the generic suspend resume infrastructure in
libata, and provide a common suspend/resume implementation for lldds to
reuse.

"Reset once" is not part of the suspend/resume work.  But it is relevant
to libsas users who need to wait for domain-wide ata error recovery and
want to limit the effort for known well-behaved devices.

These have been in -next for the past couple kernel cycles.

---

Artur Wojcik (1):
      isci: implement suspend/resume support

Dan Williams (4):
      libata: reset once
      libata: export ata_port suspend/resume infrastructure for sas
      libsas: suspend / resume support
      libsas, ipr: cleanup ata_host flags initialization via ata_host_init


 Documentation/kernel-parameters.txt |    3 +
 drivers/ata/libata-core.c           |   69 +++++++++++++++++++--------
 drivers/ata/libata-eh.c             |    2 +
 drivers/scsi/ipr.c                  |    3 -
 drivers/scsi/isci/host.c            |    2 -
 drivers/scsi/isci/host.h            |    2 -
 drivers/scsi/isci/init.c            |   58 ++++++++++++++++++++++
 drivers/scsi/libsas/sas_ata.c       |   91 +++++++++++++++++++++++++++++++++--
 drivers/scsi/libsas/sas_discover.c  |   69 +++++++++++++++++++++++----
 drivers/scsi/libsas/sas_dump.c      |    1 
 drivers/scsi/libsas/sas_event.c     |    4 +-
 drivers/scsi/libsas/sas_init.c      |   90 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/libsas/sas_internal.h  |    1 
 drivers/scsi/libsas/sas_phy.c       |   21 ++++++++
 drivers/scsi/libsas/sas_port.c      |   52 ++++++++++++++++++++
 include/linux/libata.h              |   15 +++++-
 include/scsi/libsas.h               |   20 ++++++--
 include/scsi/sas_ata.h              |   10 ++++
 18 files changed, 463 insertions(+), 50 deletions(-)
