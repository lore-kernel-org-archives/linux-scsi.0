From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 3/3] hpsa: use ioremap_nocache instead of ioremap
Date: Thu, 26 Jul 2012 11:34:23 -0500
Message-ID: <20120726163422.25864.19285.stgit@beardog.cce.hp.com>
References: <20120726162726.25864.49510.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120726162726.25864.49510.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

I think ioremap() ends up being equivalent to ioremap_nocache
by default, but we should signal our intent that these mappings
should be non-cacheable.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 415db96..5ed5859 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3337,7 +3337,8 @@ static void __iomem *remap_pci_mem(ulong base, ulong size)
 {
 	ulong page_base = ((ulong) base) & PAGE_MASK;
 	ulong page_offs = ((ulong) base) - page_base;
-	void __iomem *page_remapped = ioremap(page_base, page_offs + size);
+	void __iomem *page_remapped = ioremap_nocache(page_base,
+		page_offs + size);
 
 	return page_remapped ? (page_remapped + page_offs) : NULL;
 }
