From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 0/6] cxlflash: Miscellaneous fixes
Date: Fri,  2 Sep 2016 15:36:52 -0500
Message-ID: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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
Cc: Christophe Lombard <clombard@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

This patch set contains miscellaneous fixes in the device cleanup and
EEH recovery paths. One of the patches simplifies the WWPN assignment
routine.

There are a couple of fixes that resolve regressions introduced by
Commit 704c4b0ddc03 ("cxlflash: Shutdown notify support for CXL Flash
cards") and Commit 888baf069f49 ("scsi: cxlflash: Add kref to context")

This series is based upon mkp's 4.9/scsi-queue and is bisectable.

Matthew R. Ochs (4):
  cxlflash: Fix to avoid EEH and host reset collisions
  cxlflash: Improve EEH recovery time
  cxlflash: Refactor WWPN setup
  cxlflash: Fix context reference tracking on detach

Uma Krishnan (2):
  cxlflash: Scan host only after the port is ready for I/O
  cxlflash: Remove the device cleanly in the system shutdown path

 drivers/scsi/cxlflash/main.c      | 81 +++++++++++++++++----------------------
 drivers/scsi/cxlflash/superpipe.c |  3 +-
 2 files changed, 37 insertions(+), 47 deletions(-)

-- 
2.1.0
