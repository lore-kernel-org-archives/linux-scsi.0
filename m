From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PATCH v4 0/2] libsas: eh reworks (ata-eh vs discovery,
 races, ...)
Date: Mon, 16 Jan 2012 09:00:10 -0800
Message-ID: <1326733212.2548.3.camel@ultramagnus.opencreations.com>
References: <20120110073647.4563.7504.stgit@localhost6.localdomain6>
	 <1326223752.3264.43.camel@dabdike.int.hansenpartnership.com>
	 <CABE8wwuBN45f2s-bcW3R=5VE1V3svtcrp93-9LW5zZ6VtZFqmQ@mail.gmail.com>
	 <1326703228.2872.5.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1326703228.2872.5.camel@dabdike>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jack_wang@usish.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-01-16 at 12:40 +0400, James Bottomley wrote:
> On Tue, 2012-01-10 at 12:18 -0800, Dan Williams wrote:
> > On Tue, Jan 10, 2012 at 11:29 AM, James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:
> > > On Mon, 2012-01-09 at 23:38 -0800, Dan Williams wrote:
> > >> The latest version of the patch kit is available here:
> > >>
> > >>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas-eh-reworks-v4
> > >>
> > >> Changes since v3: http://marc.info/?l=linux-scsi&m=132581455214789&w=2
> > >
> > > Just to check I'm not lost here. I think this is currently the only
> > > mergeable set of patches you have because you're reworking patches in
> > > all your other series and will repost ... is this correct?
> > 
> > There are two mergeable topics in isci.git:
> > libsas-eh-reworks-v4: mergeable
> > devel: mergeable, posted as "[GIT PATCH v2 00/15] isci update for 3.3
> > (part1)" [1].  This contains all the general updates to the driver
> > that were independent of the libsas churn.  It was rebased to
> > incorporate Ben's firmware removal patch, but is otherwise idle and
> > ready to merge.
> 
> 1/2 doesn't apply:
> 
> patching file drivers/scsi/libsas/sas_scsi_host.c
> Hunk #1 succeeded at 235 with fuzz 2 (offset -14 lines).
> Hunk #2 FAILED at 267.
> Hunk #3 succeeded at 505 with fuzz 2 (offset -25 lines).
> Hunk #4 succeeded at 512 with fuzz 1 (offset -34 lines).
> Hunk #5 FAILED at 655.
> 2 out of 5 hunks FAILED -- saving rejects to file
> drivers/scsi/libsas/sas_scsi_host.c.rej
> 

...and you have the pre-requisites to
drivers/scsi/libsas/sas_scsi_host.c?

d7ca96e libsas: kill sas_slave_destroy
eb4a9d3 libsas: fix domain_device leak
07ec747 libsas: remove ata_port.lock management duties from lldds
8f2c41b libsas: convert dev->gone to flags
2145ed7 libsas: close error handling vs sas_ata_task_done() race
9540580b libsas: prevent double completion of scmds from eh
630efd3 libsas: fix timeout vs completion race
41707de libsas: let libata handle command timeouts
6b7b289 libsas: defer SAS_TASK_NEED_DEV_RESET commands to libata
b13a7df libsas: sas_phy_enable via transport_sas_phy_reset
3b58c03 libsas: fix sas_find_local_phy(), take phy references

I managed to confuse things by posting only incremental series... the
full set is in git, and I can repost as needed.

...or:

The following changes since commit 5c41dc3a79150e93e5d050871a10b761be8281a1:

  [SCSI] lpfc 8.3.28: Update driver version to 8.3.28 (2011-12-15 10:57:45 +0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas-eh-reworks-v4

Dan Williams (36):
      libsas: remove unused ata_task_resp fields
      libsas: kill sas_slave_destroy
      libsas: fix domain_device leak
      libsas: fix leak of dev->sata_dev.identify_[packet_]device
      libsas: replace event locks with atomic bitops
      libsas: convert ha->state to flags
      libsas: introduce sas_drain_work()
      libsas: remove ata_port.lock management duties from lldds
      libsas: convert dev->gone to flags
      libsas: prevent domain rediscovery competing with ata error halibsas-eh-reworks-v4ndling
      libsas: use ->set_dmamode to notify lldds of NCQ parameters
      libsas: kill invocation of scsi_eh_finish_cmd from sas_ata_task_done
      libsas: close error handling vs sas_ata_task_done() race
      libsas: prevent double completion of scmds from eh
      libsas: fix timeout vs completion race
      libsas: let libata handle command timeouts
      libsas: defer SAS_TASK_NEED_DEV_RESET commands to libata
      libsas: use libata-eh-reset for sata rediscovery fis transmit failures
      libsas: perform sas-transport resets in shost->workq context
      libsas: execute transport link resets with libata-eh via host workqueue
      libsas: sas_phy_enable via transport_sas_phy_reset
      libsas: async ata-eh
      libsas: poll for ata device readiness after reset
      libsas: don't mark expanders as gone when a child device is removed
      libsas: check for 'gone' expanders in smp_execute_task()
      libsas: fix sas_find_local_phy(), take phy references
      libsas: don't recover 'gone' devices in sas_ata_hard_reset()
      isci: kill iphy->isci_port lookups
      isci: kill isci_port->status
      isci: fix interpretation of "hard" reset
      isci: stop interpreting ->lldd_lu_reset() as an ata soft-reset
      isci: ->lldd_ata_check_ready handler
      isci: remove bus and reset handlers
      isci: remove IDEV_EH hack to disable "discovery-time" ata resets
      libsas: pre-clean commands that won the eh vs completion race
      libsas: feed the scsi_block_when_processing_errors() meter

Jeff Skirvin (2):
      libsas: Remove redundant phy state notification calls.
      libsas: add mutex for SMP task execution

 Documentation/scsi/libsas.txt       |   15 -
 drivers/ata/libata-eh.c             |    1 +
 drivers/ata/libata.h                |    1 -
 drivers/scsi/aic94xx/aic94xx.h      |    2 +
 drivers/scsi/aic94xx/aic94xx_dev.c  |   38 ++-
 drivers/scsi/aic94xx/aic94xx_init.c |    5 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c  |    9 +-
 drivers/scsi/isci/host.c            |    8 +-
 drivers/scsi/isci/host.h            |   19 +-
 drivers/scsi/isci/init.c            |   13 +-
 drivers/scsi/isci/phy.c             |   18 +-
 drivers/scsi/isci/phy.h             |    1 -
 drivers/scsi/isci/port.c            |  217 ++++++------
 drivers/scsi/isci/port.h            |   11 +-
 drivers/scsi/isci/remote_device.c   |   32 +--
 drivers/scsi/isci/remote_device.h   |    7 +-
 drivers/scsi/isci/request.c         |  198 +----------
 drivers/scsi/isci/request.h         |    9 +-
 drivers/scsi/isci/task.c            |  158 ++-------
 drivers/scsi/isci/task.h            |   40 --
 drivers/scsi/libsas/sas_ata.c       |  692 +++++++++++++++--------------------
 drivers/scsi/libsas/sas_discover.c  |  152 +++++++--
 drivers/scsi/libsas/sas_event.c     |   89 +++++-
 drivers/scsi/libsas/sas_expander.c  |  113 ++++--
 drivers/scsi/libsas/sas_init.c      |  192 +++++++++-
 drivers/scsi/libsas/sas_internal.h  |   73 ++--
 drivers/scsi/libsas/sas_phy.c       |   12 +-
 drivers/scsi/libsas/sas_port.c      |   26 +-
 drivers/scsi/libsas/sas_scsi_host.c |  320 +++++++---------
 drivers/scsi/mvsas/mv_init.c        |    1 -
 drivers/scsi/mvsas/mv_sas.c         |   11 +-
 drivers/scsi/pm8001/pm8001_init.c   |    1 -
 drivers/scsi/pm8001/pm8001_sas.c    |   29 +-
 drivers/scsi/scsi_transport_sas.c   |   59 +++-
 include/linux/libata.h              |    1 +
 include/scsi/libsas.h               |   67 ++--
 include/scsi/sas_ata.h              |   26 +-
 include/scsi/scsi_transport_sas.h   |   12 +-
 38 files changed, 1321 insertions(+), 1357 deletions(-)


