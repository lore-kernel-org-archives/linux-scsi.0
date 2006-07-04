From: Jeremy Kerr <jk@ozlabs.org>
Subject: [PATCH 14/20] [powerpc,scsi] Constify & voidify get_property()
Date: Tue,  4 Jul 2006 16:47:17 +1000 (EST)
Message-ID: <48562.6546237201$1151995857@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: linuxppc-dev@ozlabs.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Now that get_property() returns a void *, there's no need to cast its
return value. Also, treat the return value as const, so we can
constify get_property later.

powerpc-specific scsi driver changes.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
---

 ibmvscsi/rpa_vscsi.c |   11 ++++-------
 mac53c94.c           |    2 +-
 mesh.c               |    5 +++--
 3 files changed, 8 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/scsi/mesh.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mesh.c
+++ linux-2.6/drivers/scsi/mesh.c
@@ -1850,7 +1850,8 @@ static int mesh_probe(struct macio_dev *
 {
 	struct device_node *mesh = macio_get_of_node(mdev);
 	struct pci_dev* pdev = macio_get_pci_dev(mdev);
-	int tgt, *cfp, minper;
+	int tgt, minper;
+	const int *cfp;
 	struct mesh_state *ms;
 	struct Scsi_Host *mesh_host;
 	void *dma_cmd_space;
@@ -1939,7 +1940,7 @@ static int mesh_probe(struct macio_dev *
 	       	ms->tgts[tgt].current_req = NULL;
        	}
 
-	if ((cfp = (int *) get_property(mesh, "clock-frequency", NULL)))
+	if ((cfp = get_property(mesh, "clock-frequency", NULL)))
        		ms->clk_freq = *cfp;
 	else {
        		printk(KERN_INFO "mesh: assuming 50MHz clock frequency\n");
Index: linux-2.6/drivers/scsi/mac53c94.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mac53c94.c
+++ linux-2.6/drivers/scsi/mac53c94.c
@@ -431,7 +431,7 @@ static int mac53c94_probe(struct macio_d
 	struct fsc_state *state;
 	struct Scsi_Host *host;
 	void *dma_cmd_space;
-	unsigned char *clkprop;
+	const unsigned char *clkprop;
 	int proplen, rc = -ENODEV;
 
 	if (macio_resource_count(mdev) != 2 || macio_irq_count(mdev) != 2) {
Index: linux-2.6/drivers/scsi/ibmvscsi/rpa_vscsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ibmvscsi/rpa_vscsi.c
+++ linux-2.6/drivers/scsi/ibmvscsi/rpa_vscsi.c
@@ -156,8 +156,8 @@ static void gather_partition_info(void)
 {
 	struct device_node *rootdn;
 
-	char *ppartition_name;
-	unsigned int *p_number_ptr;
+	const char *ppartition_name;
+	const unsigned int *p_number_ptr;
 
 	/* Retrieve information about this partition */
 	rootdn = find_path_device("/");
@@ -165,14 +165,11 @@ static void gather_partition_info(void)
 		return;
 	}
 
-	ppartition_name =
-		get_property(rootdn, "ibm,partition-name", NULL);
+	ppartition_name = get_property(rootdn, "ibm,partition-name", NULL);
 	if (ppartition_name)
 		strncpy(partition_name, ppartition_name,
 				sizeof(partition_name));
-	p_number_ptr =
-		(unsigned int *)get_property(rootdn, "ibm,partition-no",
-					     NULL);
+	p_number_ptr = get_property(rootdn, "ibm,partition-no", NULL);
 	if (p_number_ptr)
 		partition_number = *p_number_ptr;
 }
