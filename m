From: Arnd Bergmann <arnd@arndb.de>
Subject: [BACKPORT 4.14.y 0/8] candidates from spreadtrum 4.14 product kernel
Date: Fri, 22 Mar 2019 17:17:15 +0100
Message-ID: <20190322161727.1153278-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jingoohan1@gmail.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Bjorn Helgaas <bhelgaas@google.com>, Kishon Vijay Abraham I <kishon@ti.com>, Sebastian Reichel <sre@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Thierry Reding <thierry.reding@gmail.com>, Lee Jones <lee.jones@linaro.org>, Daniel Thompson <daniel.thompson@linaro.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>linu
List-Id: linux-scsi@vger.kernel.org

I took a scripted approach to look at some product kernels for patches
backported into vendor kernels. This is a set of (mostly) bugfixes I found
in Spreadtrum's linux-4.14 kernel that are missing in v4.14.107:

83dc7e3dea76 scsi: ufs: fix wrong command type of UTRD for UFSHCI v2.1
099a95f3591a PCI: designware-ep: dw_pcie_ep_set_msi() should only set MMC bits
1cab826b30c6 PCI: designware-ep: Read-only registers need DBI_RO_WR_EN to be writable
b330104fa76d PCI: endpoint: Use EPC's device in dma_alloc_coherent()/dma_free_coherent()
36d46cdb43ef rtc: Fix overflow when converting time64_t to rtc_time
1b5d43cfb697 sched/cpufreq/schedutil: Fix error path mutex unlock
5fb5caee92ba pwm-backlight: Enable/disable the PWM before/after LCD enable toggle.
f25a646fbe20 power: supply: charger-manager: Fix incorrect return value

Only a small number of patches here, the vendor tree is fairly close to
mainline. All commits apply cleanly through git-cherry-pick.

Baolin Wang (2):
  rtc: Fix overflow when converting time64_t to rtc_time
  power: supply: charger-manager: Fix incorrect return value

Enric Balletbo i Serra (1):
  pwm-backlight: Enable/disable the PWM before/after LCD enable toggle.

Jules Maselbas (1):
  sched/cpufreq/schedutil: Fix error path mutex unlock

Kishon Vijay Abraham I (1):
  PCI: endpoint: Use EPC's device in
    dma_alloc_coherent()/dma_free_coherent()

Niklas Cassel (2):
  PCI: designware-ep: dw_pcie_ep_set_msi() should only set MMC bits
  PCI: designware-ep: Read-only registers need DBI_RO_WR_EN to be
    writable

kehuanlin (1):
  scsi: ufs: fix wrong command type of UTRD for UFSHCI v2.1

 drivers/pci/dwc/pcie-designware-ep.c   | 12 +++++++++++-
 drivers/pci/dwc/pcie-designware.h      |  1 +
 drivers/pci/endpoint/pci-epc-core.c    | 10 ----------
 drivers/pci/endpoint/pci-epf-core.c    |  4 ++--
 drivers/power/supply/charger-manager.c |  3 +--
 drivers/rtc/rtc-lib.c                  |  6 ++----
 drivers/scsi/ufs/ufshcd.c              | 14 ++++++++------
 drivers/video/backlight/pwm_bl.c       |  9 +++++----
 kernel/sched/cpufreq_schedutil.c       |  3 +--
 9 files changed, 31 insertions(+), 31 deletions(-)


Cc: Jingoo Han <jingoohan1@gmail.com>
Cc: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: linux-rtc@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-pwm@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org

-- 
2.20.0
