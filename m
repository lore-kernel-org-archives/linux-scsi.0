From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] mvumi: use GFP_ATOMIC under spin lock
Date: Sat, 29 Sep 2012 10:14:24 +0300
Message-ID: <20120929071424.GF10993@elgon.mountain>
References: <20120928113022.GW13767@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120928113022.GW13767@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is called from the interrupt handler and with spin_locks held.  Use
GFP_ATOMIC.  The call tree looks like:
  mvumi_isr_handler() <- takes a spin lock
  -> mvumi_handshake()
     -> mvumi_init_data()
        -> mvumi_alloc_mem_resource() <- GFP_KERNEL

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 783edc7..5ad8da4 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -118,7 +118,7 @@ static int mvumi_map_pci_addr(struct pci_dev *dev, void **addr_array)
 static struct mvumi_res *mvumi_alloc_mem_resource(struct mvumi_hba *mhba,
 				enum resource_type type, unsigned int size)
 {
-	struct mvumi_res *res = kzalloc(sizeof(*res), GFP_KERNEL);
+	struct mvumi_res *res = kzalloc(sizeof(*res), GFP_ATOMIC);
 
 	if (!res) {
 		dev_err(&mhba->pdev->dev,
@@ -128,7 +128,7 @@ static struct mvumi_res *mvumi_alloc_mem_resource(struct mvumi_hba *mhba,
 
 	switch (type) {
 	case RESOURCE_CACHED_MEMORY:
-		res->virt_addr = kzalloc(size, GFP_KERNEL);
+		res->virt_addr = kzalloc(size, GFP_ATOMIC);
 		if (!res->virt_addr) {
 			dev_err(&mhba->pdev->dev,
 				"unable to allocate memory,size = %d.\n", size);
