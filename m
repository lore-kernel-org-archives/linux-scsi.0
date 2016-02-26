From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] scsi: storvsc: Fix a build issue reported by kbuild test
 robot
Date: Fri, 26 Feb 2016 15:45:14 -0800
Message-ID: <1456530314-22250-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

tree:   https://na01.safelinks.protection.outlook.com/?url=https%3a%2f%2fgit.kernel.org%2fpub%2fscm%2flinux%2fkernel%2fgit%2ftorvalds%2flinux.git&data=01%7c01%7ckys%40microsoft.com%7ce2e0622715844b79ad7108d32796ec3c%7c72f988bf86f141af91ab2d7cd011db47%7c1&sdata=ubr4GbBaNS%2ftOz%2buJBk0CL9N0UNG9x2TidLgy6Yovg4%3d master
head:   03c21cb775a313f1ff19be59c5d02df3e3526471
commit: dac582417bc449b1f7f572d3f1dd9d23eec15cc9 storvsc: Properly support Fibre Channel devices
date:   3 weeks ago
config: x86_64-randconfig-s3-01281016 (attached as .config)
reproduce:
        git checkout dac582417bc449b1f7f572d3f1dd9d23eec15cc9
        # save the attached .config to linux build tree
        make ARCH=x86_64

All errors (new ones prefixed by >>):

   drivers/built-in.o: In function `storvsc_remove':
>> storvsc_drv.c:(.text+0x213af7): undefined reference to `fc_remove_host'
   drivers/built-in.o: In function `storvsc_drv_init':
>> storvsc_drv.c:(.init.text+0xcbcc): undefined reference to `fc_attach_transport'
>> storvsc_drv.c:(.init.text+0xcc06): undefined reference to `fc_release_transport'
   drivers/built-in.o: In function `storvsc_drv_exit':
>> storvsc_drv.c:(.exit.text+0x123c): undefined reference to `fc_release_transport'

With this commit, the storvsc driver depends on FC atttributes. Make this
dependency explicit.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/scsi/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 64eed87..24365c3 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -594,6 +594,7 @@ config XEN_SCSI_FRONTEND
 config HYPERV_STORAGE
 	tristate "Microsoft Hyper-V virtual storage driver"
 	depends on SCSI && HYPERV
+	depends on SCSI_FC_ATTRS
 	default HYPERV
 	help
 	  Select this option to enable the Hyper-V virtual storage driver.
-- 
1.7.4.1
