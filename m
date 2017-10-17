From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V8 4/5] libsas: Align SMP req/resp to dma_get_cache_alignment()
Date: Tue, 17 Oct 2017 16:05:41 +0800
Message-ID: <1508227542-13165-4-git-send-email-chenhc@lemote.com>
References: <1508227542-13165-1-git-send-email-chenhc@lemote.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1508227542-13165-1-git-send-email-chenhc@lemote.com>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In non-coherent DMA mode, kernel uses cache flushing operations to
maintain I/O coherency, so libsas's SMP request/response should be
aligned to ARCH_DMA_MINALIGN. Otherwise, If a DMA buffer and a kernel
structure share a same cache line, and if the kernel structure has
dirty data, cache_invalidate (no writeback) will cause data corruption.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 drivers/scsi/libsas/sas_expander.c | 93 +++++++++++++++++++++++---------------
 1 file changed, 57 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 6b4fd23..124a44b 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -164,17 +164,17 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 
 /* ---------- Allocations ---------- */
 
-static inline void *alloc_smp_req(int size)
+static inline void *alloc_smp_req(int size, int align)
 {
-	u8 *p = kzalloc(size, GFP_KERNEL);
+	u8 *p = kzalloc(ALIGN(size, align), GFP_KERNEL);
 	if (p)
 		p[0] = SMP_REQUEST;
 	return p;
 }
 
-static inline void *alloc_smp_resp(int size)
+static inline void *alloc_smp_resp(int size, int align)
 {
-	return kzalloc(size, GFP_KERNEL);
+	return kzalloc(ALIGN(size, align), GFP_KERNEL);
 }
 
 static char sas_route_char(struct domain_device *dev, struct ex_phy *phy)
@@ -403,15 +403,17 @@ static int sas_ex_phy_discover_helper(struct domain_device *dev, u8 *disc_req,
 int sas_ex_phy_discover(struct domain_device *dev, int single)
 {
 	struct expander_device *ex = &dev->ex_dev;
-	int  res = 0;
+	int  res = 0, align;
 	u8   *disc_req;
 	u8   *disc_resp;
 
-	disc_req = alloc_smp_req(DISCOVER_REQ_SIZE);
+	align = dma_get_cache_alignment(&dev->phy->dev);
+
+	disc_req = alloc_smp_req(DISCOVER_REQ_SIZE, align);
 	if (!disc_req)
 		return -ENOMEM;
 
-	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE);
+	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE, align);
 	if (!disc_resp) {
 		kfree(disc_req);
 		return -ENOMEM;
@@ -480,14 +482,15 @@ static int sas_ex_general(struct domain_device *dev)
 {
 	u8 *rg_req;
 	struct smp_resp *rg_resp;
-	int res;
-	int i;
+	int i, res, align;
 
-	rg_req = alloc_smp_req(RG_REQ_SIZE);
+	align = dma_get_cache_alignment(&dev->phy->dev);
+
+	rg_req = alloc_smp_req(RG_REQ_SIZE, align);
 	if (!rg_req)
 		return -ENOMEM;
 
-	rg_resp = alloc_smp_resp(RG_RESP_SIZE);
+	rg_resp = alloc_smp_resp(RG_RESP_SIZE, align);
 	if (!rg_resp) {
 		kfree(rg_req);
 		return -ENOMEM;
@@ -552,13 +555,15 @@ static int sas_ex_manuf_info(struct domain_device *dev)
 {
 	u8 *mi_req;
 	u8 *mi_resp;
-	int res;
+	int res, align;
 
-	mi_req = alloc_smp_req(MI_REQ_SIZE);
+	align = dma_get_cache_alignment(&dev->phy->dev);
+
+	mi_req = alloc_smp_req(MI_REQ_SIZE, align);
 	if (!mi_req)
 		return -ENOMEM;
 
-	mi_resp = alloc_smp_resp(MI_RESP_SIZE);
+	mi_resp = alloc_smp_resp(MI_RESP_SIZE, align);
 	if (!mi_resp) {
 		kfree(mi_req);
 		return -ENOMEM;
@@ -593,13 +598,15 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 {
 	u8 *pc_req;
 	u8 *pc_resp;
-	int res;
+	int res, align;
+
+	align = dma_get_cache_alignment(&dev->phy->dev);
 
-	pc_req = alloc_smp_req(PC_REQ_SIZE);
+	pc_req = alloc_smp_req(PC_REQ_SIZE, align);
 	if (!pc_req)
 		return -ENOMEM;
 
-	pc_resp = alloc_smp_resp(PC_RESP_SIZE);
+	pc_resp = alloc_smp_resp(PC_RESP_SIZE, align);
 	if (!pc_resp) {
 		kfree(pc_req);
 		return -ENOMEM;
@@ -664,17 +671,19 @@ static int sas_dev_present_in_domain(struct asd_sas_port *port,
 #define RPEL_RESP_SIZE	32
 int sas_smp_get_phy_events(struct sas_phy *phy)
 {
-	int res;
+	int res, align;
 	u8 *req;
 	u8 *resp;
 	struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
 	struct domain_device *dev = sas_find_dev_by_rphy(rphy);
 
-	req = alloc_smp_req(RPEL_REQ_SIZE);
+	align = dma_get_cache_alignment(&phy->dev);
+
+	req = alloc_smp_req(RPEL_REQ_SIZE, align);
 	if (!req)
 		return -ENOMEM;
 
-	resp = alloc_smp_resp(RPEL_RESP_SIZE);
+	resp = alloc_smp_resp(RPEL_RESP_SIZE, align);
 	if (!resp) {
 		kfree(req);
 		return -ENOMEM;
@@ -709,7 +718,8 @@ int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
 			    struct smp_resp *rps_resp)
 {
 	int res;
-	u8 *rps_req = alloc_smp_req(RPS_REQ_SIZE);
+	int align = dma_get_cache_alignment(&dev->phy->dev);
+	u8 *rps_req = alloc_smp_req(RPS_REQ_SIZE, align);
 	u8 *resp = (u8 *)rps_resp;
 
 	if (!rps_req)
@@ -1398,7 +1408,7 @@ static int sas_check_parent_topology(struct domain_device *child)
 static int sas_configure_present(struct domain_device *dev, int phy_id,
 				 u8 *sas_addr, int *index, int *present)
 {
-	int i, res = 0;
+	int i, res = 0, align;
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *phy = &ex->ex_phy[phy_id];
 	u8 *rri_req;
@@ -1406,12 +1416,13 @@ static int sas_configure_present(struct domain_device *dev, int phy_id,
 
 	*present = 0;
 	*index = 0;
+	align = dma_get_cache_alignment(&dev->phy->dev);
 
-	rri_req = alloc_smp_req(RRI_REQ_SIZE);
+	rri_req = alloc_smp_req(RRI_REQ_SIZE, align);
 	if (!rri_req)
 		return -ENOMEM;
 
-	rri_resp = alloc_smp_resp(RRI_RESP_SIZE);
+	rri_resp = alloc_smp_resp(RRI_RESP_SIZE, align);
 	if (!rri_resp) {
 		kfree(rri_req);
 		return -ENOMEM;
@@ -1472,15 +1483,17 @@ static int sas_configure_present(struct domain_device *dev, int phy_id,
 static int sas_configure_set(struct domain_device *dev, int phy_id,
 			     u8 *sas_addr, int index, int include)
 {
-	int res;
+	int res, align;
 	u8 *cri_req;
 	u8 *cri_resp;
 
-	cri_req = alloc_smp_req(CRI_REQ_SIZE);
+	align = dma_get_cache_alignment(&dev->phy->dev);
+
+	cri_req = alloc_smp_req(CRI_REQ_SIZE, align);
 	if (!cri_req)
 		return -ENOMEM;
 
-	cri_resp = alloc_smp_resp(CRI_RESP_SIZE);
+	cri_resp = alloc_smp_resp(CRI_RESP_SIZE, align);
 	if (!cri_resp) {
 		kfree(cri_req);
 		return -ENOMEM;
@@ -1689,10 +1702,12 @@ int sas_discover_root_expander(struct domain_device *dev)
 static int sas_get_phy_discover(struct domain_device *dev,
 				int phy_id, struct smp_resp *disc_resp)
 {
-	int res;
+	int res, align;
 	u8 *disc_req;
 
-	disc_req = alloc_smp_req(DISCOVER_REQ_SIZE);
+	align = dma_get_cache_alignment(&dev->phy->dev);
+
+	disc_req = alloc_smp_req(DISCOVER_REQ_SIZE, align);
 	if (!disc_req)
 		return -ENOMEM;
 
@@ -1715,10 +1730,12 @@ static int sas_get_phy_discover(struct domain_device *dev,
 static int sas_get_phy_change_count(struct domain_device *dev,
 				    int phy_id, int *pcc)
 {
-	int res;
+	int res, align;
 	struct smp_resp *disc_resp;
 
-	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE);
+	align = dma_get_cache_alignment(&dev->phy->dev);
+
+	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE, align);
 	if (!disc_resp)
 		return -ENOMEM;
 
@@ -1733,11 +1750,13 @@ static int sas_get_phy_change_count(struct domain_device *dev,
 static int sas_get_phy_attached_dev(struct domain_device *dev, int phy_id,
 				    u8 *sas_addr, enum sas_device_type *type)
 {
-	int res;
+	int res, align;
 	struct smp_resp *disc_resp;
 	struct discover_resp *dr;
 
-	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE);
+	align = dma_get_cache_alignment(&dev->phy->dev);
+
+	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE, align);
 	if (!disc_resp)
 		return -ENOMEM;
 	dr = &disc_resp->disc;
@@ -1787,15 +1806,17 @@ static int sas_find_bcast_phy(struct domain_device *dev, int *phy_id,
 
 static int sas_get_ex_change_count(struct domain_device *dev, int *ecc)
 {
-	int res;
+	int res, align;
 	u8  *rg_req;
 	struct smp_resp  *rg_resp;
 
-	rg_req = alloc_smp_req(RG_REQ_SIZE);
+	align = dma_get_cache_alignment(&dev->phy->dev);
+
+	rg_req = alloc_smp_req(RG_REQ_SIZE, align);
 	if (!rg_req)
 		return -ENOMEM;
 
-	rg_resp = alloc_smp_resp(RG_RESP_SIZE);
+	rg_resp = alloc_smp_resp(RG_RESP_SIZE, align);
 	if (!rg_resp) {
 		kfree(rg_req);
 		return -ENOMEM;
-- 
2.7.0



