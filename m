From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [8/18]  qla2xxx: Remove dead code
Date: Mon, 21 Jun 2004 22:54:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622055417.GA8439@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:25257 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266597AbUFVFuc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:50:32 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1844 04/06/04 08:20:44 andrew.vasquez@apc.qlogic.com +2 -0
  Remove several unused failover variables and functions from
  the embedded driver.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_gbl.h |    2 
 drivers/scsi/qla2xxx/qla_os.c  |  114 -----------------------------------------
 2 files changed, 1 insertion(+), 115 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	2004-06-21 15:38:12 -07:00
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	2004-06-21 15:38:12 -07:00
@@ -75,8 +75,6 @@
 #if defined(MODULE)
 extern char *ql2xopts;
 #endif
-extern struct list_head qla_hostlist;
-extern rwlock_t qla_hostlist_lock;
 
 extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:38:12 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:38:12 -07:00
@@ -135,13 +135,6 @@
 static void copy_mem_info(struct info_str *, char *, int);
 static int copy_info(struct info_str *, char *, ...);
 
-
-/*
- * List of host adapters
- */
-LIST_HEAD(qla_hostlist);
-rwlock_t qla_hostlist_lock = RW_LOCK_UNLOCKED;
-
 static void qla2x00_free_device(scsi_qla_host_t *);
 
 static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
@@ -190,8 +183,6 @@
 
 static void qla2x00_display_fc_names(scsi_qla_host_t *);
 
-void qla2x00_blink_led(scsi_qla_host_t *);
-
 /* TODO Convert to inlines
  *
  * Timer routines
@@ -2118,15 +2109,9 @@
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-
 	/* Enable chip interrupts. */
 	qla2x00_enable_intrs(ha);
 
-	/* Insert new entry into the list of adapters */
-	write_lock(&qla_hostlist_lock);
-	list_add_tail(&ha->list, &qla_hostlist);
-	write_unlock(&qla_hostlist_lock);
-
 	/* v2.19.5b6 */
 	/*
 	 * Wait around max loop_reset_delay secs for the devices to come
@@ -2188,10 +2173,6 @@
 
 	ha = pci_get_drvdata(pdev);
 
-	write_lock(&qla_hostlist_lock);
-	list_del(&ha->list);
-	write_unlock(&qla_hostlist_lock);
-
 	sysfs_remove_bin_file(&ha->host->shost_gendev.kobj,
 	    &sysfs_fw_dump_attr);
 	sysfs_remove_bin_file(&ha->host->shost_gendev.kobj, &sysfs_nvram_attr);
@@ -2335,7 +2316,6 @@
 	uint32_t        tmp_sn;
 	uint32_t	*flags;
 	uint8_t		*loop_state;
-	int	found;
 	scsi_qla_host_t *ha;
 	char fw_info[30];
  
@@ -2343,27 +2323,7 @@
 	    "Entering proc_info buff_in=%p, offset=0x%lx, length=0x%x\n",
 	    buffer, offset, length);)
 
-	ha = NULL;
-
-	/* Find the host that was specified */
-	found = 0;
-	read_lock(&qla_hostlist_lock);
-	list_for_each_entry(ha, &qla_hostlist, list) {
-		if (ha->host == shost) {
-			found++;
-			break;
-		}
-	}
-	read_unlock(&qla_hostlist_lock);
-
-	/* if host wasn't found then exit */
-	if (!found) {
-		DEBUG2_3(printk(KERN_WARNING
-		    "%s: Can't find adapter for host %p\n", 
-		    __func__, shost);)
-
-		return (retval);
-	}
+	ha = (scsi_qla_host_t *) shost->hostdata;
 
 	if (inout == TRUE) {
 		/* Has data been written to the file? */
@@ -3645,73 +3605,6 @@
 }
 
 /**************************************************************************
- * qla2x00_blink_led
- *
- * Description:
- *   This function sets the colour of the LED while preserving the
- *   unsued GPIO pins every sec.
- *
- * Input:
- *       ha - Host adapter structure
- *      
- * Return:
- * 	None
- *
- * Context: qla2x00_timer() Interrupt
- ***************************************************************************/
-void
-qla2x00_blink_led(scsi_qla_host_t *ha)
-{
-	uint16_t	gpio_enable, gpio_data, led_color;
-	unsigned long	cpu_flags = 0;
-	device_reg_t	*reg = ha->iobase;
-
-	/* Save the Original GPIOE */ 
-	spin_lock_irqsave(&ha->hardware_lock, cpu_flags);
-	gpio_enable = RD_REG_WORD(&reg->gpioe);
-	gpio_data = RD_REG_WORD(&reg->gpiod);
-	spin_unlock_irqrestore(&ha->hardware_lock, cpu_flags);
-
-	DEBUG2(printk("%s Original data of gpio_enable_reg=0x%x"
-	    " gpio_data_reg=0x%x\n",
-	    __func__,gpio_enable,gpio_data));
-
-	if (ha->beacon_green_on){
-		led_color = GPIO_LED_GREEN_ON_AMBER_OFF;
-		ha->beacon_green_on = 0;
-	} else {
-		led_color = GPIO_LED_GREEN_OFF_AMBER_OFF;
-		ha->beacon_green_on = 1;
-	}
-
-	/* Set the modified gpio_enable values */
-	gpio_enable |= GPIO_LED_GREEN_ON_AMBER_OFF;
-
-	DEBUG2(printk("%s Before writing enable : gpio_enable_reg=0x%x"
-	    " gpio_data_reg=0x%x led_color=0x%x\n",
-	    __func__, gpio_enable, gpio_data, led_color));
-
-	spin_lock_irqsave(&ha->hardware_lock, cpu_flags);
-	WRT_REG_WORD(&reg->gpioe,gpio_enable);
-	spin_unlock_irqrestore(&ha->hardware_lock, cpu_flags);
-
-	/* Clear out the previously set LED colour */
-	gpio_data &= ~GPIO_LED_GREEN_ON_AMBER_OFF;
-
-	/* Set the new input LED colour to GPIOD */
-	gpio_data |= led_color;
-
-	DEBUG2(printk("%s Before writing data: gpio_enable_reg=0x%x"
-	    " gpio_data_reg=0x%x led_color=0x%x\n",
-	    __func__,gpio_enable,gpio_data,led_color));
-
-	/* Set the modified gpio_data values */
-	spin_lock_irqsave(&ha->hardware_lock, cpu_flags);
-	WRT_REG_WORD(&reg->gpiod,gpio_data);
-	spin_unlock_irqrestore(&ha->hardware_lock, cpu_flags);
-}
-
-/**************************************************************************
 *   qla2x00_timer
 *
 * Description:
@@ -3744,11 +3637,6 @@
 		set_bit(SCSI_RESTART_NEEDED, &ha->dpc_flags);
 		start_dpc++;
 	}
-
-	/* Check if beacon LED needs to be blinked */
-	if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && ha->beacon_blink_led)
-		qla2x00_blink_led(ha);
-
 
 	/*
 	 * Ports - Port down timer.
