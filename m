From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 20/71] ncr5380: Introduce unbound workqueue
Date: Wed, 18 Nov 2015 19:35:15 +1100
Message-ID: <20151118083500.591953271@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline; filename=ncr5380-new-workqueue
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Allocate a work queue that will permit busy waiting and sleeping. This
means NCR5380_init() can potentially fail, so add this error path.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

In subsequent patches, the work function adopts this work queue so it
can sleep while polling, which allows the removal of some flawed and
complicated code in NCR5380_select() in NCR5380.c.

---
 drivers/scsi/NCR5380.c       |   15 +++++++++++----
 drivers/scsi/NCR5380.h       |    1 +
 drivers/scsi/arm/cumana_1.c  |    8 ++++++--
 drivers/scsi/arm/oak.c       |    8 ++++++--
 drivers/scsi/atari_NCR5380.c |    8 +++++++-
 drivers/scsi/atari_scsi.c    |    5 ++++-
 drivers/scsi/dmx3191d.c      |   17 +++++++++++------
 drivers/scsi/dtc.c           |   11 +++++++++--
 drivers/scsi/g_NCR5380.c     |   31 +++++++++++++++----------------
 drivers/scsi/mac_scsi.c      |    5 ++++-
 drivers/scsi/pas16.c         |   10 ++++++++--
 drivers/scsi/sun3_scsi.c     |    5 ++++-
 drivers/scsi/t128.c          |   13 ++++++++++---
 13 files changed, 96 insertions(+), 41 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:33:25.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:33:27.000000000 +1100
@@ -514,7 +514,7 @@ static int should_disconnect(unsigned ch
 static void NCR5380_set_timer(struct NCR5380_hostdata *hostdata, unsigned long timeout)
 {
 	hostdata->time_expires = jiffies + timeout;
-	schedule_delayed_work(&hostdata->coroutine, timeout);
+	queue_delayed_work(hostdata->work_q, &hostdata->coroutine, timeout);
 }
 
 
@@ -791,7 +791,12 @@ static int NCR5380_init(struct Scsi_Host
 	hostdata->disconnected_queue = NULL;
 	
 	INIT_DELAYED_WORK(&hostdata->coroutine, NCR5380_main);
-	
+	hostdata->work_q = alloc_workqueue("ncr5380_%d",
+	                        WQ_CPU_INTENSIVE | WQ_UNBOUND | WQ_MEM_RECLAIM,
+	                        1, instance->host_no);
+	if (!hostdata->work_q)
+		return -ENOMEM;
+
 	/* The CHECK code seems to break the 53C400. Will check it later maybe */
 	if (flags & FLAG_NCR53C400)
 		hostdata->flags = FLAG_HAS_LAST_BYTE_SENT | flags;
@@ -872,6 +877,7 @@ static void NCR5380_exit(struct Scsi_Hos
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
 	cancel_delayed_work_sync(&hostdata->coroutine);
+	destroy_workqueue(hostdata->work_q);
 }
 
 /**
@@ -932,7 +938,7 @@ static int NCR5380_queue_command_lck(str
 
 	/* Run the coroutine if it isn't already running. */
 	/* Kick off command processing */
-	schedule_delayed_work(&hostdata->coroutine, 0);
+	queue_delayed_work(hostdata->work_q, &hostdata->coroutine, 0);
 	return 0;
 }
 
@@ -1128,7 +1134,8 @@ static irqreturn_t NCR5380_intr(int dumm
 		}	/* if BASR_IRQ */
 		spin_unlock_irqrestore(instance->host_lock, flags);
 		if(!done)
-			schedule_delayed_work(&hostdata->coroutine, 0);
+			queue_delayed_work(hostdata->work_q,
+			                   &hostdata->coroutine, 0);
 	} while (!done);
 	return IRQ_HANDLED;
 }
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-11-18 19:33:21.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-11-18 19:33:27.000000000 +1100
@@ -284,6 +284,7 @@ struct NCR5380_hostdata {
 	unsigned spin_max_r;
 	unsigned spin_max_w;
 #endif
+	struct workqueue_struct *work_q;
 };
 
 #ifdef __KERNEL__
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2015-11-18 19:33:26.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2015-11-18 19:33:27.000000000 +1100
@@ -238,7 +238,9 @@ static int cumanascsi1_probe(struct expa
 
 	host->irq = ec->irq;
 
-	NCR5380_init(host, 0);
+	ret = NCR5380_init(host, 0);
+	if (ret)
+		goto out_unmap;
 
 	NCR5380_maybe_reset_bus(host);
 
@@ -250,7 +252,7 @@ static int cumanascsi1_probe(struct expa
 	if (ret) {
 		printk("scsi%d: IRQ%d not free: %d\n",
 		    host->host_no, host->irq, ret);
-		goto out_unmap;
+		goto out_exit;
 	}
 
 	ret = scsi_add_host(host, &ec->dev);
@@ -262,6 +264,8 @@ static int cumanascsi1_probe(struct expa
 
  out_free_irq:
 	free_irq(host->irq, host);
+ out_exit:
+	NCR5380_exit(host);
  out_unmap:
 	iounmap(priv(host)->base);
 	iounmap(priv(host)->dma);
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2015-11-18 19:33:10.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2015-11-18 19:33:27.000000000 +1100
@@ -143,17 +143,21 @@ static int oakscsi_probe(struct expansio
 	host->irq = NO_IRQ;
 	host->n_io_port = 255;
 
-	NCR5380_init(host, 0);
+	ret = NCR5380_init(host, 0);
+	if (ret)
+		goto out_unmap;
 
 	NCR5380_maybe_reset_bus(host);
 
 	ret = scsi_add_host(host, &ec->dev);
 	if (ret)
-		goto out_unmap;
+		goto out_exit;
 
 	scsi_scan_host(host);
 	goto out;
 
+ out_exit:
+	NCR5380_exit(host);
  out_unmap:
 	iounmap(priv(host)->base);
  unreg:
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:24.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:27.000000000 +1100
@@ -643,7 +643,7 @@ static inline void queue_main(struct NCR
 		   queue it on the 'immediate' task queue, to be processed
 		   immediately after the current interrupt processing has
 		   finished. */
-		schedule_work(&hostdata->main_task);
+		queue_work(hostdata->work_q, &hostdata->main_task);
 	}
 	/* else: nothing to do: the running NCR5380_main() will pick up
 	   any newly queued command. */
@@ -832,6 +832,11 @@ static int __init NCR5380_init(struct Sc
 	hostdata->flags = flags;
 
 	INIT_WORK(&hostdata->main_task, NCR5380_main);
+	hostdata->work_q = alloc_workqueue("ncr5380_%d",
+	                        WQ_CPU_INTENSIVE | WQ_UNBOUND | WQ_MEM_RECLAIM,
+	                        1, instance->host_no);
+	if (!hostdata->work_q)
+		return -ENOMEM;
 
 	prepare_info(instance);
 
@@ -907,6 +912,7 @@ static void NCR5380_exit(struct Scsi_Hos
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
 	cancel_work_sync(&hostdata->main_task);
+	destroy_workqueue(hostdata->work_q);
 }
 
 /**
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2015-11-18 19:33:15.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2015-11-18 19:33:27.000000000 +1100
@@ -885,7 +885,9 @@ static int __init atari_scsi_probe(struc
 #endif
 	host_flags |= setup_toshiba_delay > 0 ? FLAG_TOSHIBA_DELAY : 0;
 
-	NCR5380_init(instance, host_flags);
+	error = NCR5380_init(instance, host_flags);
+	if (error)
+		goto fail_init;
 
 	if (IS_A_TT()) {
 		error = request_irq(instance->irq, scsi_tt_intr, 0,
@@ -947,6 +949,7 @@ fail_host:
 		free_irq(instance->irq, instance);
 fail_irq:
 	NCR5380_exit(instance);
+fail_init:
 	scsi_host_put(instance);
 fail_alloc:
 	if (atari_dma_buffer)
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2015-11-18 19:33:10.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2015-11-18 19:33:27.000000000 +1100
@@ -95,7 +95,9 @@ static int dmx3191d_probe_one(struct pci
 	 */
 	shost->irq = NO_IRQ;
 
-	NCR5380_init(shost, FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E);
+	error = NCR5380_init(shost, FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E);
+	if (error)
+		goto out_host_put;
 
 	NCR5380_maybe_reset_bus(shost);
 
@@ -103,11 +105,15 @@ static int dmx3191d_probe_one(struct pci
 
 	error = scsi_add_host(shost, &pdev->dev);
 	if (error)
-		goto out_release_region;
+		goto out_exit;
 
 	scsi_scan_host(shost);
 	return 0;
 
+out_exit:
+	NCR5380_exit(shost);
+out_host_put:
+	scsi_host_put(shost);
  out_release_region:
 	release_region(io, DMX3191D_REGION_LEN);
  out_disable_device:
@@ -119,15 +125,14 @@ static int dmx3191d_probe_one(struct pci
 static void dmx3191d_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	unsigned long io = shost->io_port;
 
 	scsi_remove_host(shost);
 
 	NCR5380_exit(shost);
-
-	release_region(shost->io_port, DMX3191D_REGION_LEN);
-	pci_disable_device(pdev);
-
 	scsi_host_put(shost);
+	release_region(io, DMX3191D_REGION_LEN);
+	pci_disable_device(pdev);
 }
 
 static struct pci_device_id dmx3191d_pci_tbl[] = {
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2015-11-18 19:33:26.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2015-11-18 19:33:27.000000000 +1100
@@ -230,12 +230,13 @@ static int __init dtc_detect(struct scsi
 found:
 		instance = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
 		if (instance == NULL)
-			break;
+			goto out_unmap;
 
 		instance->base = addr;
 		((struct NCR5380_hostdata *)(instance)->hostdata)->base = base;
 
-		NCR5380_init(instance, 0);
+		if (NCR5380_init(instance, 0))
+			goto out_unregister;
 
 		NCR5380_maybe_reset_bus(instance);
 
@@ -275,6 +276,12 @@ found:
 		++count;
 	}
 	return count;
+
+out_unregister:
+	scsi_unregister(instance);
+out_unmap:
+	iounmap(base);
+	return count;
 }
 
 /*
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-11-18 19:33:25.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-11-18 19:33:27.000000000 +1100
@@ -239,9 +239,6 @@ static int __init do_DTC3181E_setup(char
  *	and DTC436(ISAPnP) controllers. If overrides have been set we use
  *	them.
  *
- *	The caller supplied NCR5380_init function is invoked from here, before
- *	the interrupt line is taken.
- *
  *	Locks: none
  */
 
@@ -404,15 +401,8 @@ static int __init generic_NCR5380_detect
 		}
 #endif
 		instance = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
-		if (instance == NULL) {
-#ifndef SCSI_G_NCR5380_MEM
-			release_region(overrides[current_override].NCR5380_map_name, region_size);
-#else
-			iounmap(iomem);
-			release_mem_region(base, NCR5380_region_size);
-#endif
-			continue;
-		}
+		if (instance == NULL)
+			goto out_release;
 
 #ifndef SCSI_G_NCR5380_MEM
 		instance->io_port = overrides[current_override].NCR5380_map_name;
@@ -429,7 +419,8 @@ static int __init generic_NCR5380_detect
 		((struct NCR5380_hostdata *)instance->hostdata)->iomem = iomem;
 #endif
 
-		NCR5380_init(instance, flags);
+		if (NCR5380_init(instance, flags))
+			goto out_unregister;
 
 		if (overrides[current_override].board == BOARD_NCR53C400)
 			NCR5380_write(C400_CONTROL_STATUS_REG, CSR_BASE);
@@ -461,6 +452,17 @@ static int __init generic_NCR5380_detect
 		++count;
 	}
 	return count;
+
+out_unregister:
+	scsi_unregister(instance);
+out_release:
+#ifndef SCSI_G_NCR5380_MEM
+	release_region(overrides[current_override].NCR5380_map_name, region_size);
+#else
+	iounmap(iomem);
+	release_mem_region(base, NCR5380_region_size);
+#endif
+	return count;
 }
 
 /**
@@ -477,15 +479,12 @@ static int generic_NCR5380_release_resou
 	if (instance->irq != NO_IRQ)
 		free_irq(instance->irq, instance);
 	NCR5380_exit(instance);
-
 #ifndef SCSI_G_NCR5380_MEM
 	release_region(instance->io_port, instance->n_io_port);
 #else
 	iounmap(((struct NCR5380_hostdata *)instance->hostdata)->iomem);
 	release_mem_region(instance->base, NCR5380_region_size);
 #endif
-
-
 	return 0;
 }
 
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2015-11-18 19:33:15.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2015-11-18 19:33:27.000000000 +1100
@@ -382,7 +382,9 @@ static int __init mac_scsi_probe(struct
 #endif
 	host_flags |= setup_toshiba_delay > 0 ? FLAG_TOSHIBA_DELAY : 0;
 
-	NCR5380_init(instance, host_flags);
+	error = NCR5380_init(instance, host_flags);
+	if (error)
+		goto fail_init;
 
 	if (instance->irq != NO_IRQ) {
 		error = request_irq(instance->irq, macscsi_intr, IRQF_SHARED,
@@ -407,6 +409,7 @@ fail_host:
 		free_irq(instance->irq, instance);
 fail_irq:
 	NCR5380_exit(instance);
+fail_init:
 	scsi_host_put(instance);
 	return error;
 }
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2015-11-18 19:33:26.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2015-11-18 19:33:27.000000000 +1100
@@ -378,11 +378,12 @@ static int __init pas16_detect(struct sc
 
 	instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
 	if(instance == NULL)
-		break;
+		goto out;
 		
 	instance->io_port = io_port;
 
-	NCR5380_init(instance, 0);
+	if (NCR5380_init(instance, 0))
+		goto out_unregister;
 
 	NCR5380_maybe_reset_bus(instance);
 
@@ -418,6 +419,11 @@ static int __init pas16_detect(struct sc
 	++count;
     }
     return count;
+
+out_unregister:
+	scsi_unregister(instance);
+out:
+	return count;
 }
 
 /*
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2015-11-18 19:33:15.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2015-11-18 19:33:27.000000000 +1100
@@ -557,7 +557,9 @@ static int __init sun3_scsi_probe(struct
 	host_flags |= setup_use_tagged_queuing > 0 ? FLAG_TAGGED_QUEUING : 0;
 #endif
 
-	NCR5380_init(instance, host_flags);
+	error = NCR5380_init(instance, host_flags);
+	if (error)
+		goto fail_init;
 
 	error = request_irq(instance->irq, scsi_sun3_intr, 0,
 	                    "NCR5380", instance);
@@ -604,6 +606,7 @@ fail_host:
 		free_irq(instance->irq, instance);
 fail_irq:
 	NCR5380_exit(instance);
+fail_init:
 	scsi_host_put(instance);
 fail_alloc:
 	if (udc_regs)
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2015-11-18 19:33:26.000000000 +1100
+++ linux/drivers/scsi/t128.c	2015-11-18 19:33:27.000000000 +1100
@@ -208,12 +208,13 @@ static int __init t128_detect(struct scs
 found:
 	instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
 	if(instance == NULL)
-		break;
-		
+		goto out_unmap;
+
 	instance->base = base;
 	((struct NCR5380_hostdata *)instance->hostdata)->base = p;
 
-	NCR5380_init(instance, 0);
+	if (NCR5380_init(instance, 0))
+		goto out_unregister;
 
 	NCR5380_maybe_reset_bus(instance);
 
@@ -246,6 +247,12 @@ found:
 	++count;
     }
     return count;
+
+out_unregister:
+	scsi_unregister(instance);
+out_unmap:
+	iounmap(p);
+	return count;
 }
 
 static int t128_release(struct Scsi_Host *shost)
