From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 23/37] cxlflash: Fix function prolog parameters and return codes
Date: Wed, 21 Oct 2015 15:14:40 -0500
Message-ID: <1445458480-56547-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:43620 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbbJUUQD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:16:03 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 16:16:02 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 9B7E56E804C
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:04:11 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKG03c58065060
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:16:00 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKFwO8002562
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:15:59 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

Several function prologs have incorrect parameter names and return
code descriptions. This can lead to confusion when reviewing the
source and creates inaccurate documentation.

To remedy, update the function prologs to properly reflect parameter
names and return codes.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 70 ++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 441e897..f37e968 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -314,7 +314,7 @@ write_rrin:
  * @cmd:	AFU command to send.
  *
  * Return:
- *	0 on success or SCSI_MLQUEUE_HOST_BUSY
+ *	0 on success, SCSI_MLQUEUE_HOST_BUSY on failure
  */
 static int send_cmd(struct afu *afu, struct afu_cmd *cmd)
 {
@@ -401,8 +401,7 @@ static void wait_resp(struct afu *afu, struct afu_cmd *cmd)
  * @tmfcmd:	TMF command to send.
  *
  * Return:
- *	0 on success
- *	SCSI_MLQUEUE_HOST_BUSY when host is busy
+ *	0 on success, SCSI_MLQUEUE_HOST_BUSY on failure
  */
 static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 {
@@ -491,9 +490,7 @@ static const char *cxlflash_driver_info(struct Scsi_Host *host)
  * @host:	SCSI host associated with device.
  * @scp:	SCSI command to send.
  *
- * Return:
- *	0 on success
- *	SCSI_MLQUEUE_HOST_BUSY when host is busy
+ * Return: 0 on success, SCSI_MLQUEUE_HOST_BUSY on failure
  */
 static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 {
@@ -597,7 +594,7 @@ out:
 
 /**
  * cxlflash_wait_for_pci_err_recovery() - wait for error recovery during probe
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  */
 static void cxlflash_wait_for_pci_err_recovery(struct cxlflash_cfg *cfg)
 {
@@ -611,7 +608,7 @@ static void cxlflash_wait_for_pci_err_recovery(struct cxlflash_cfg *cfg)
 
 /**
  * free_mem() - free memory associated with the AFU
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  */
 static void free_mem(struct cxlflash_cfg *cfg)
 {
@@ -633,7 +630,7 @@ static void free_mem(struct cxlflash_cfg *cfg)
 
 /**
  * stop_afu() - stops the AFU command timers and unmaps the MMIO space
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
  * Safe to call with AFU in a partially allocated/initialized state.
  */
@@ -655,7 +652,7 @@ static void stop_afu(struct cxlflash_cfg *cfg)
 
 /**
  * term_mc() - terminates the master context
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  * @level:	Depth of allocation, where to begin waterfall tear down.
  *
  * Safe to call with AFU/MC in partially allocated/initialized state.
@@ -691,7 +688,7 @@ static void term_mc(struct cxlflash_cfg *cfg, enum undo_level level)
 
 /**
  * term_afu() - terminates the AFU
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
  * Safe to call with AFU/MC in partially allocated/initialized state.
  */
@@ -751,7 +748,7 @@ static void cxlflash_remove(struct pci_dev *pdev)
 
 /**
  * alloc_mem() - allocates the AFU and its command pool
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
  * A partially allocated state remains on failure.
  *
@@ -804,12 +801,9 @@ out:
 
 /**
  * init_pci() - initializes the host as a PCI device
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
- * Return:
- *	0 on success
- *	-EIO on unable to communicate with device
- *	A return code from the PCI sub-routines
+ * Return: 0 on success, -errno on failure
  */
 static int init_pci(struct cxlflash_cfg *cfg)
 {
@@ -889,11 +883,9 @@ out_release_regions:
 
 /**
  * init_scsi() - adds the host to the SCSI stack and kicks off host scan
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
- * Return:
- *	0 on success
- *	A return code from adding the host
+ * Return: 0 on success, -errno on failure
  */
 static int init_scsi(struct cxlflash_cfg *cfg)
 {
@@ -1357,7 +1349,7 @@ out:
 
 /**
  * start_context() - starts the master context
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
  * Return: A success or failure value from CXL services.
  */
@@ -1375,12 +1367,10 @@ static int start_context(struct cxlflash_cfg *cfg)
 
 /**
  * read_vpd() - obtains the WWPNs from VPD
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  * @wwpn:	Array of size NUM_FC_PORTS to pass back WWPNs
  *
- * Return:
- *	0 on success
- *	-ENODEV when VPD or WWPN keywords not found
+ * Return: 0 on success, -errno on failure
  */
 static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 {
@@ -1468,7 +1458,7 @@ out:
 
 /**
  * init_pcr() - initialize the provisioning and control registers
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
  * Also sets up fast access to the mapped registers and initializes AFU
  * command fields that never change.
@@ -1507,7 +1497,7 @@ static void init_pcr(struct cxlflash_cfg *cfg)
 
 /**
  * init_global() - initialize AFU global registers
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  */
 static int init_global(struct cxlflash_cfg *cfg)
 {
@@ -1592,7 +1582,7 @@ out:
 
 /**
  * start_afu() - initializes and starts the AFU
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  */
 static int start_afu(struct cxlflash_cfg *cfg)
 {
@@ -1626,12 +1616,9 @@ static int start_afu(struct cxlflash_cfg *cfg)
 
 /**
  * init_mc() - create and register as the master context
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
- * Return:
- *	0 on success
- *	-ENOMEM when unable to obtain a context from CXL services
- *	A failure value from CXL services.
+ * Return: 0 on success, -errno on failure
  */
 static int init_mc(struct cxlflash_cfg *cfg)
 {
@@ -1715,15 +1702,12 @@ out:
 
 /**
  * init_afu() - setup as master context and start AFU
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
  * This routine is a higher level of control for configuring the
  * AFU on probe and reset paths.
  *
- * Return:
- *	0 on success
- *	-ENOMEM when unable to map the AFU MMIO space
- *	A failure value from internal services.
+ * Return: 0 on success, -errno on failure
  */
 static int init_afu(struct cxlflash_cfg *cfg)
 {
@@ -1876,9 +1860,7 @@ out:
  * afu_reset() - resets the AFU
  * @cfg:	Internal structure associated with the host.
  *
- * Return:
- *	0 on success
- *	A failure value from internal services.
+ * Return: 0 on success, -errno on failure
  */
 static int afu_reset(struct cxlflash_cfg *cfg)
 {
@@ -2363,7 +2345,7 @@ static void cxlflash_worker_thread(struct work_struct *work)
  * @pdev:	PCI device associated with the host.
  * @dev_id:	PCI device id associated with device.
  *
- * Return: 0 on success / non-zero on failure
+ * Return: 0 on success, -errno on failure
  */
 static int cxlflash_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *dev_id)
@@ -2597,7 +2579,7 @@ static struct pci_driver cxlflash_driver = {
 /**
  * init_cxlflash() - module entry point
  *
- * Return: 0 on success / non-zero on failure
+ * Return: 0 on success, -errno on failure
  */
 static int __init init_cxlflash(void)
 {
-- 
2.1.0

