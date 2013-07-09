From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 2/3] [SCSI] megaraid: Remove local pdev's
Date: Tue, 09 Jul 2013 14:39:39 -0600
Message-ID: <20130709203939.31676.34588.stgit@amt.stowe>
References: <20130709203927.31676.35169.stgit@amt.stowe>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130709203927.31676.35169.stgit@amt.stowe>
Sender: linux-kernel-owner@vger.kernel.org
To: megaraidlinux@lsi.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

With the driver now setup for default 32-bit DMA capabilities, remove the
broken make_local_pdev() implementation and usages.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/scsi/megaraid.c |   98 ++++++++---------------------------------------
 1 files changed, 16 insertions(+), 82 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 32cca61..316924c 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -2023,29 +2023,6 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 	return FALSE;
 }
 
-static inline int
-make_local_pdev(adapter_t *adapter, struct pci_dev **pdev)
-{
-	*pdev = alloc_pci_dev();
-
-	if( *pdev == NULL ) return -1;
-
-	memcpy(*pdev, adapter->dev, sizeof(struct pci_dev));
-
-	if( pci_set_dma_mask(*pdev, DMA_BIT_MASK(32)) != 0 ) {
-		kfree(*pdev);
-		return -1;
-	}
-
-	return 0;
-}
-
-static inline void
-free_local_pdev(struct pci_dev *pdev)
-{
-	kfree(pdev);
-}
-
 /**
  * mega_allocate_inquiry()
  * @dma_handle - handle returned for dma address
@@ -2209,13 +2186,10 @@ proc_show_rebuild_rate(struct seq_file *m, void *v)
 	adapter_t	*adapter = m->private;
 	dma_addr_t	dma_handle;
 	caddr_t		inquiry;
-	struct pci_dev	*pdev;
-
-	if( make_local_pdev(adapter, &pdev) != 0 )
-		return 0;
+	struct pci_dev	*pdev = adapter->dev;
 
 	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL )
-		goto free_pdev;
+		return 0;
 
 	if( mega_adapinq(adapter, dma_handle) != 0 ) {
 		seq_puts(m, "Adapter inquiry failed.\n");
@@ -2233,8 +2207,6 @@ proc_show_rebuild_rate(struct seq_file *m, void *v)
 
 free_inquiry:
 	mega_free_inquiry(inquiry, dma_handle, pdev);
-free_pdev:
-	free_local_pdev(pdev);
 	return 0;
 }
 
@@ -2252,14 +2224,11 @@ proc_show_battery(struct seq_file *m, void *v)
 	adapter_t	*adapter = m->private;
 	dma_addr_t	dma_handle;
 	caddr_t		inquiry;
-	struct pci_dev	*pdev;
+	struct pci_dev	*pdev = adapter->dev;
 	u8	battery_status;
 
-	if( make_local_pdev(adapter, &pdev) != 0 )
-		return 0;
-
 	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL )
-		goto free_pdev;
+		return 0;
 
 	if( mega_adapinq(adapter, dma_handle) != 0 ) {
 		seq_printf(m, "Adapter inquiry failed.\n");
@@ -2308,8 +2277,6 @@ proc_show_battery(struct seq_file *m, void *v)
 
 free_inquiry:
 	mega_free_inquiry(inquiry, dma_handle, pdev);
-free_pdev:
-	free_local_pdev(pdev);
 	return 0;
 }
 
@@ -2357,18 +2324,15 @@ proc_show_pdrv(struct seq_file *m, adapter_t *adapter, int channel)
 	char		*scsi_inq;
 	dma_addr_t	scsi_inq_dma_handle;
 	caddr_t		inquiry;
-	struct pci_dev	*pdev;
+	struct pci_dev	*pdev = adapter->dev;
 	u8	*pdrv_state;
 	u8	state;
 	int	tgt;
 	int	max_channels;
 	int	i;
 
-	if( make_local_pdev(adapter, &pdev) != 0 )
-		return 0;
-
 	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL )
-		goto free_pdev;
+		return 0;
 
 	if( mega_adapinq(adapter, dma_handle) != 0 ) {
 		seq_puts(m, "Adapter inquiry failed.\n");
@@ -2453,8 +2417,6 @@ free_pci:
 	pci_free_consistent(pdev, 256, scsi_inq, scsi_inq_dma_handle);
 free_inquiry:
 	mega_free_inquiry(inquiry, dma_handle, pdev);
-free_pdev:
-	free_local_pdev(pdev);
 	return 0;
 }
 
@@ -2533,17 +2495,14 @@ proc_show_rdrv(struct seq_file *m, adapter_t *adapter, int start, int end )
 	char		*disk_array;
 	dma_addr_t	disk_array_dma_handle;
 	caddr_t		inquiry;
-	struct pci_dev	*pdev;
+	struct pci_dev	*pdev = adapter->dev;
 	u8	*rdrv_state;
 	int	num_ldrv;
 	u32	array_sz;
 	int	i;
 
-	if( make_local_pdev(adapter, &pdev) != 0 )
-		return 0;
-
 	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL )
-		goto free_pdev;
+		return 0;
 
 	if( mega_adapinq(adapter, dma_handle) != 0 ) {
 		seq_puts(m, "Adapter inquiry failed.\n");
@@ -2694,8 +2653,6 @@ free_pci:
 			disk_array_dma_handle);
 free_inquiry:
 	mega_free_inquiry(inquiry, dma_handle, pdev);
-free_pdev:
-	free_local_pdev(pdev);
 	return 0;
 }
 
@@ -3164,6 +3121,7 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 			return (-ENODEV);
 
 		adapter = hba_soft_state[adapno];
+		pdev = adapter->dev;
 
 		/*
 		 * Deletion of logical drive is a special case. The adapter
@@ -3208,12 +3166,10 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 
 		/*
 		 * For all internal commands, the buffer must be allocated in
-		 * <4GB address range
+		 * <4GB address range.
+		 *
+		 * Is it a passthru command or a DCMD
 		 */
-		if( make_local_pdev(adapter, &pdev) != 0 )
-			return -EIO;
-
-		/* Is it a passthru command or a DCMD */
 		if( uioc.uioc_rmbox[0] == MEGA_MBOXCMD_PASSTHRU ) {
 			/* Passthru commands */
 
@@ -3221,10 +3177,8 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 					sizeof(mega_passthru),
 					&pthru_dma_hndl);
 
-			if( pthru == NULL ) {
-				free_local_pdev(pdev);
+			if( pthru == NULL )
 				return (-ENOMEM);
-			}
 
 			/*
 			 * The user passthru structure
@@ -3241,8 +3195,6 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 						sizeof(mega_passthru), pthru,
 						pthru_dma_hndl);
 
-				free_local_pdev(pdev);
-
 				return (-EFAULT);
 			}
 
@@ -3260,8 +3212,6 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 							pthru,
 							pthru_dma_hndl);
 
-					free_local_pdev(pdev);
-
 					return (-ENOMEM);
 				}
 
@@ -3331,8 +3281,6 @@ freemem_and_return:
 			pci_free_consistent(pdev, sizeof(mega_passthru),
 					pthru, pthru_dma_hndl);
 
-			free_local_pdev(pdev);
-
 			return rval;
 		}
 		else {
@@ -3345,10 +3293,8 @@ freemem_and_return:
 				data = pci_alloc_consistent(pdev,
 						uioc.xferlen, &data_dma_hndl);
 
-				if( data == NULL ) {
-					free_local_pdev(pdev);
+				if( data == NULL )
 					return (-ENOMEM);
-				}
 
 				uxferaddr = MBOX(uioc)->xferaddr;
 			}
@@ -3367,8 +3313,6 @@ freemem_and_return:
 							uioc.xferlen,
 							data, data_dma_hndl);
 
-					free_local_pdev(pdev);
-
 					return (-EFAULT);
 				}
 			}
@@ -3391,8 +3335,6 @@ freemem_and_return:
 							data_dma_hndl);
 				}
 
-				free_local_pdev(pdev);
-
 				return rval;
 			}
 
@@ -3413,8 +3355,6 @@ freemem_and_return:
 						data_dma_hndl);
 			}
 
-			free_local_pdev(pdev);
-
 			return rval;
 		}
 
@@ -4068,22 +4008,18 @@ mega_internal_dev_inquiry(adapter_t *adapter, u8 ch, u8 tgt,
 	dma_addr_t	pthru_dma_handle;
 	megacmd_t	mc;
 	int		rval;
-	struct pci_dev	*pdev;
+	struct pci_dev	*pdev = adapter->dev;
 
 
 	/*
 	 * For all internal commands, the buffer must be allocated in <4GB
 	 * address range
 	 */
-	if( make_local_pdev(adapter, &pdev) != 0 ) return -1;
-
 	pthru = pci_alloc_consistent(pdev, sizeof(mega_passthru),
 			&pthru_dma_handle);
 
-	if( pthru == NULL ) {
-		free_local_pdev(pdev);
+	if( pthru == NULL )
 		return -1;
-	}
 
 	pthru->timeout = 2;
 	pthru->ars = 1;
@@ -4117,8 +4053,6 @@ mega_internal_dev_inquiry(adapter_t *adapter, u8 ch, u8 tgt,
 	pci_free_consistent(pdev, sizeof(mega_passthru), pthru,
 			pthru_dma_handle);
 
-	free_local_pdev(pdev);
-
 	return rval;
 }
 #endif
