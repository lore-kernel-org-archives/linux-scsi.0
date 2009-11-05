From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi_lib_dma.c :  fix bug with dma maps on nested scsi
 objects - (2nd try)
Date: Thu, 05 Nov 2009 13:33:12 -0600
Message-ID: <1257449592.10355.26.camel@mulgrave.site>
References: <1257295546.5965.7.camel@wookie>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1257295546.5965.7.camel@wookie>
Sender: linux-next-owner@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, andrew.vasquez@qlogic.com, sfr@canb.auug.org.au
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-11-03 at 19:45 -0500, James Smart wrote:
> I had reminded James B of a patch for an issue with the scsi subsystem
> not properly finding the parent device for dma operations when we had
> nested scsi_hosts..
> http://marc.info/?l=linux-scsi&m=125372757108048&w=2
> 
> The patch was picked up, and integrated into linux-next, which started
> to see issues, and which James B cut an additional patch to deal with
> traversing too much of the tree (stopping when dev->parent == NULL)..
> The http://marc.info/?l=linux-scsi&m=125414973520985&w=2
> 
> The real issue was the traversal of a node that had "dev->type == NULL".
> Turns out standard PCI endpoint and bridge/domain objects have NULL types
> too - so every traversal went all the way to the root of the tree.
> 
> The attached patch, cut against scsi-misc-2.6 - replaces both of the
> patches above. Rather than making any assumptions about dev->type values,
> it now explicitly matches dev->type structures to known scsi or transport
> objects, and only traverses them if they are recognized. To get around
> symbol dependencies, and to allow transports as modules to come and go,
> a registration interface was put in place to register transport objects
> with the routine that does the matching.  The FC transport was converted
> to use a device_type structure for its objects (note: perhaps other
> transports should consider the same ?)
> 
> Please apply this patch as soon as possible.  At the current time,
> NPIV vport dma operation is severely broken.
> 
> Thanks
> 
> -- james s
> 
> 
> 
> 
>  Signed-off-by: James Smart <james.smart@emulex.com>
> 
>  ---
> 
>  drivers/scsi/hosts.c             |   72 +++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_lib.c          |    2 -
>  drivers/scsi/scsi_lib_dma.c      |    7 ++-
>  drivers/scsi/scsi_priv.h         |    2 +
>  drivers/scsi/scsi_transport_fc.c |   48 +++++++++++++++++++++++---
>  include/scsi/scsi_host.h         |   17 +++++++++
>  6 files changed, 141 insertions(+), 7 deletions(-)

141 lines plus a static list to solve a simple problem is getting a bit
icky to say the least.

What about being more simplistic and simply making the host cache a
pointer to the physical bus device?  I probably objected to this a long
time ago because using the parent pointers is more elegant, but I think
this patch demonstrates conclusively it's not worth this amount of code
for the sake of alleged elegance.

James

---
 drivers/scsi/hosts.c            |   13 ++++++++++---
 drivers/scsi/lpfc/lpfc_init.c   |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c |    3 ++-
 drivers/scsi/scsi_lib_dma.c     |    4 ++--
 include/scsi/scsi_host.h        |   16 +++++++++++++++-
 5 files changed, 30 insertions(+), 8 deletions(-)

---

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 5fd2da4..28a753d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -180,14 +180,20 @@ void scsi_remove_host(struct Scsi_Host *shost)
 EXPORT_SYMBOL(scsi_remove_host);
 
 /**
- * scsi_add_host - add a scsi host
+ * scsi_add_host_with_dma - add a scsi host with dma device
  * @shost:	scsi host pointer to add
  * @dev:	a struct device of type scsi class
+ * @dma_dev:	dma device for the host
+ *
+ * Note: You rarely need to worry about this unless you're in a
+ * virtualised host environments, so use the simpler scsi_add_host()
+ * function instead.
  *
  * Return value: 
  * 	0 on success / != 0 for error
  **/
-int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
+int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
+			   struct device *dma_dev)
 {
 	struct scsi_host_template *sht = shost->hostt;
 	int error = -EINVAL;
@@ -207,6 +213,7 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
 
 	if (!shost->shost_gendev.parent)
 		shost->shost_gendev.parent = dev ? dev : &platform_bus;
+	shost->dma_dev = dma_dev;
 
 	error = device_add(&shost->shost_gendev);
 	if (error)
@@ -262,7 +269,7 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
  fail:
 	return error;
 }
-EXPORT_SYMBOL(scsi_add_host);
+EXPORT_SYMBOL(scsi_add_host_with_dma);
 
 static void scsi_host_dev_release(struct device *dev)
 {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 562d8ce..f913f1e 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2408,7 +2408,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	vport->els_tmofunc.function = lpfc_els_timeout;
 	vport->els_tmofunc.data = (unsigned long)vport;
 
-	error = scsi_add_host(shost, dev);
+	error = scsi_add_host_with_dma(shost, dev, &phba->pcidev->dev);
 	if (error)
 		goto out_put_shost;
 
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fbcb82a..21e2bc4 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1654,7 +1654,8 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 			fc_vport_set_state(fc_vport, FC_VPORT_LINKDOWN);
 	}
 
-	if (scsi_add_host(vha->host, &fc_vport->dev)) {
+	if (scsi_add_host_with_dma(vha->host, &fc_vport->dev,
+				   &ha->pdev->dev)) {
 		DEBUG15(printk("scsi(%ld): scsi_add_host failure for VP[%d].\n",
 			vha->host_no, vha->vp_idx));
 		goto vport_create_failed_2;
diff --git a/drivers/scsi/scsi_lib_dma.c b/drivers/scsi/scsi_lib_dma.c
index ac6855c..dcd1285 100644
--- a/drivers/scsi/scsi_lib_dma.c
+++ b/drivers/scsi/scsi_lib_dma.c
@@ -23,7 +23,7 @@ int scsi_dma_map(struct scsi_cmnd *cmd)
 	int nseg = 0;
 
 	if (scsi_sg_count(cmd)) {
-		struct device *dev = cmd->device->host->shost_gendev.parent;
+		struct device *dev = cmd->device->host->dma_dev;
 
 		nseg = dma_map_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
 				  cmd->sc_data_direction);
@@ -41,7 +41,7 @@ EXPORT_SYMBOL(scsi_dma_map);
 void scsi_dma_unmap(struct scsi_cmnd *cmd)
 {
 	if (scsi_sg_count(cmd)) {
-		struct device *dev = cmd->device->host->shost_gendev.parent;
+		struct device *dev = cmd->device->host->dma_dev;
 
 		dma_unmap_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
 			     cmd->sc_data_direction);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 943f5df..68338be 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -683,6 +683,12 @@ struct Scsi_Host {
 	void *shost_data;
 
 	/*
+	 * Points to the physical bus device we'd use to do DMA
+	 * Needed just in case we have virtual hosts.
+	 */
+	struct device *dma_dev;
+
+	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
 	 * alignment to a long boundary.
@@ -726,7 +732,9 @@ extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
 extern void scsi_flush_work(struct Scsi_Host *);
 
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
-extern int __must_check scsi_add_host(struct Scsi_Host *, struct device *);
+extern int __must_check scsi_add_host_with_dma(struct Scsi_Host *,
+					       struct device *,
+					       struct device *);
 extern void scsi_scan_host(struct Scsi_Host *);
 extern void scsi_rescan_device(struct device *);
 extern void scsi_remove_host(struct Scsi_Host *);
@@ -737,6 +745,12 @@ extern const char *scsi_host_state_name(enum scsi_host_state);
 
 extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
 
+static inline int __must_check scsi_add_host(struct Scsi_Host *host,
+					     struct device *dev)
+{
+	return scsi_add_host_with_dma(host, dev, dev);
+}
+
 static inline struct device *scsi_get_device(struct Scsi_Host *shost)
 {
         return shost->shost_gendev.parent;
