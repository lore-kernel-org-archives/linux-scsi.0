From: Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 4/5] [SCSI] Do not use platform_bus as a parent
Date: Fri, 25 Jul 2014 15:23:52 +0100
Message-ID: <1406298233-27876-4-git-send-email-pawel.moll@arm.com>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>, Catalin Marinas <Catalin.Marinas@arm.com>, paul@pwsan.com, Arnd Bergmann <arnd@arndb.de>, Peter De Schrijver <pdeschrijver@nvidia.com>, arm@kernel.org, linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The host devices without a parent were "forcefully adopted"
by platform bus. This patch removes this assignment. In
effect the dev_dev may be NULL now, which means ISA.

Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---

This patch is a part of effort to remove references to platform_bus
and make it static.

James, could you please have a look and advice if the change is
correct? Would you happen to know the "real reasons" behind
using the root platform_bus device a parent?

 drivers/scsi/hosts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3cbb57a..0c7389f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -218,7 +218,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto fail;
 
 	if (!shost->shost_gendev.parent)
-		shost->shost_gendev.parent = dev ? dev : &platform_bus;
+		shost->shost_gendev.parent = dev;
 	if (!dma_dev)
 		dma_dev = shost->shost_gendev.parent;
 
-- 
1.9.1
