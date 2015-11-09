From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 00/32] HiSilicon SAS driver
Date: Tue, 10 Nov 2015 00:32:05 +0800
Message-ID: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This is the driver patchset for the HiSilicon SAS driver. The driver
is a platform driver.

The driver will support multiple revisions of HW. Currently only "v1"
HW is supported.

The driver uses libsas framework within the SCSI framework.

The v1 HW supports SSP and SMP, but not STP/SATA.

Differences to v2:
- update device tree bindings
- remove while loops when evaluating hba struct
- remove _lo and _hi DMA struct fields
- revised spinlock usage
- fix error handling for when CMPLT_HDR_ERR_RCRD_XFRD set
- general coding style and cosmetic fixes

Differences to v1:
- re-arch driver into main module and hw-specific driver module
- allocate hisi_hba in scsi_host_alloc
- use of_irq_count get irq count - depends on [1]
- use syscon to handle ctrl reg access
- get SAS address from device tree
- do not set cmd_per_lun to 1
- remove remove controller id
- use static wq in phy struct
- process control phy in caller context
- fix port->port_attached issue for rmmod

[1] http://www.spinics.net/lists/arm-kernel/msg452833.html

John Garry (32):
  [SCSI] sas: centralise ssp frame information units
  devicetree: bindings: scsi: HiSi SAS
  scsi: hisi_sas: add initial bare main driver
  scsi: hisi_sas: add scsi host registration
  scsi: hisi_sas: scan device tree
  scsi: hisi_sas: add HW DMA structures
  scsi: hisi_sas: allocate memories and create pools
  scsi: hisi_sas: add hisi_sas_remove
  scsi: hisi_sas: add slot init code
  scsi: hisi_sas: add cq structure initialization
  scsi: hisi_sas: add phy SAS ADDR initialization
  scsi: hisi_sas: set dev DMA mask
  scsi: hisi_sas: add hisi_hba workqueue
  scsi: hisi_sas: add hisi sas device type
  scsi: hisi_sas: add phy and port init
  scsi: hisi_sas: add timer and spinlock init
  scsi: hisi_sas: add v1 hw module init
  scsi: hisi_sas: add v1 hardware register definitions
  scsi: hisi_sas: add v1 HW initialisation code
  scsi: hisi_sas: add v1 hw interrupt init
  scsi: hisi_sas: add path from phyup irq to SAS framework
  scsi: hisi_sas: add ssp command function
  scsi: hisi_sas: add cq interrupt handler
  scsi: hisi_sas: add dev_found and dev_gone
  scsi: hisi_sas: add abnormal irq handler
  scsi: hisi_sas: add bcast interrupt handler
  scsi: hisi_sas: add smp protocol support
  scsi: hisi_sas: add scan finished and start
  scsi: hisi_sas: add tmf methods
  scsi: hisi_sas: add control phy handler
  scsi: hisi_sas: add fatal irq handler
  MAINTAINERS: add maintainer for HiSi SAS driver

 .../devicetree/bindings/scsi/hisilicon-sas.txt     |   81 +
 MAINTAINERS                                        |    7 +
 drivers/scsi/Kconfig                               |    1 +
 drivers/scsi/Makefile                              |    1 +
 drivers/scsi/aic94xx/aic94xx_sas.h                 |   49 +-
 drivers/scsi/hisi_sas/Kconfig                      |    6 +
 drivers/scsi/hisi_sas/Makefile                     |    2 +
 drivers/scsi/hisi_sas/hisi_sas.h                   |  347 ++++
 drivers/scsi/hisi_sas/hisi_sas_main.c              | 1362 ++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             | 1872 ++++++++++++++++++++
 include/scsi/sas.h                                 |   74 +
 11 files changed, 3759 insertions(+), 43 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
 create mode 100644 drivers/scsi/hisi_sas/Kconfig
 create mode 100644 drivers/scsi/hisi_sas/Makefile
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas.h
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_main.c
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c

-- 
1.9.1
