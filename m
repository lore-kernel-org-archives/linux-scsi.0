From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v3 00/41] cxlflash: OCXL transport support and miscellaneous
 fixes
Date: Mon, 26 Mar 2018 11:29:19 -0500
Message-ID: <1522081759-57431-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

This patch series adds OCXL support to the cxlflash driver. With this
support, new devices using the OCXL transport will be supported by the
cxlflash driver along with the existing CXL devices. An effort is made
to keep this transport specific function independent of the existing
core driver that communicates with the AFU.

The first three patches contain a minor fix and staging improvements.

This series is intended for 4.17 and is bisectable.

v3 Changes:
- Addressed comments by Frederic Barrat
- Resolved IDR initialization bug
- Properly identify functions that do not have an AFU defined
- Added 3 new patches to the end of the series which resolve corner cases

v2 Changes:
- Replaced OpenCXL with OCXL in the commit messages and comments

Matthew R. Ochs (1):
  cxlflash: Avoid clobbering context control register value

Uma Krishnan (40):
  cxlflash: Preserve number of interrupts for master contexts
  cxlflash: Add argument identifier names
  cxlflash: Introduce OCXL backend
  cxlflash: Hardware AFU for OCXL
  cxlflash: Read host function configuration
  cxlflash: Setup function acTag range
  cxlflash: Read host AFU configuration
  cxlflash: Setup AFU acTag range
  cxlflash: Setup AFU PASID
  cxlflash: Adapter context support for OCXL
  cxlflash: Use IDR to manage adapter contexts
  cxlflash: Support adapter file descriptors for OCXL
  cxlflash: Support adapter context discovery
  cxlflash: Support image reload policy modification
  cxlflash: MMIO map the AFU
  cxlflash: Support starting an adapter context
  cxlflash: Support process specific mappings
  cxlflash: Support AFU state toggling
  cxlflash: Support reading adapter VPD data
  cxlflash: Setup function OCXL link
  cxlflash: Setup OCXL transaction layer
  cxlflash: Support process element lifecycle
  cxlflash: Support AFU interrupt management
  cxlflash: Support AFU interrupt mapping and registration
  cxlflash: Support starting user contexts
  cxlflash: Support adapter context polling
  cxlflash: Support adapter context reading
  cxlflash: Support adapter context mmap and release
  cxlflash: Support file descriptor mapping
  cxlflash: Introduce object handle fop
  cxlflash: Setup LISNs for user contexts
  cxlflash: Setup LISNs for master contexts
  cxlflash: Update synchronous interrupt status bits
  cxlflash: Introduce OCXL context state machine
  cxlflash: Register for translation errors
  cxlflash: Support AFU reset
  cxlflash: Enable OCXL operations
  cxlflash: Synchronize reset and remove ops
  cxlflash: Remove commmands from pending list on timeout
  cxlflash: Handle spurious interrupts

 drivers/scsi/cxlflash/Kconfig     |    2 +-
 drivers/scsi/cxlflash/Makefile    |    2 +-
 drivers/scsi/cxlflash/backend.h   |   50 +-
 drivers/scsi/cxlflash/common.h    |   11 +-
 drivers/scsi/cxlflash/cxl_hw.c    |   13 +
 drivers/scsi/cxlflash/main.c      |   86 ++-
 drivers/scsi/cxlflash/main.h      |    1 +
 drivers/scsi/cxlflash/ocxl_hw.c   | 1436 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/ocxl_hw.h   |   77 ++
 drivers/scsi/cxlflash/sislite.h   |   41 +-
 drivers/scsi/cxlflash/superpipe.c |   14 +
 11 files changed, 1682 insertions(+), 51 deletions(-)
 create mode 100644 drivers/scsi/cxlflash/ocxl_hw.c
 create mode 100644 drivers/scsi/cxlflash/ocxl_hw.h

-- 
2.1.0
