From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] Asynchronous target discovery, version 10
Date: Mon, 24 Jul 2006 09:46:06 -0400
Message-ID: <44C4CF1E.8090700@emulex.com>
References: <20060721155710.GB9214@parisc-linux.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:14981 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932187AbWGXNvz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 09:51:55 -0400
In-Reply-To: <20060721155710.GB9214@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Jack Steiner <steiner@sgi.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Anton Blanchard <anton@samba.org>, Justin Chen <justin.chen@hp.com>

Matthew,

As mentioned there's a couple of things I don't like about this....

- I disagree with the handing off of a function pointer, with no real
   bounds on it's "lifetime". There are windows with the current code
   that if the driver were to then fail attachment and tear down
   the shost, it would lead to bogus function calls, as well as
   threads, etc that are essentially orphaned.

- The jiffies thing for lpfc isn't needed, we'll deal with it in
   the driver.

- I'm a little nervous with the scsi_scan_target() vectoring into
   scsi_complete_async_scans(). The fc transport does this on a work
   queue, which means you are stalling it, mixing the fchost work
   queue with other driver code, etc (flushes always are a headache).
   Today, it's ok, but...
   >>Note: found another bug in the fc transport sysfs scan
   >> function. We're supposed to be holding the shost_lock when
   >> scan target is called - which would be bad news for your patch
   >> as is. Good news is, we have a bug and aren't holding the lock.
   >> I'll have to fix this bug.

- I'd prefer the callback function to be part of the shost template,
   and kicked in as of scsi_add_host(), and terminated as of
   scsi_remove_host(). This would also make the thread integrated
   with the host. Also, this "scan_ready" check feels like it should
   be more of a generic thing that is always executed in the scan
   code if the function is present.  I'll try to send out a counter
   patch.

- For lpfc, I need to do a different patch. The delay, based on
   where it was, occurred in other paths, such as when applications
   took the card online/offline. So, I'll need to deal with them.
   I don't know if the other vendors have the same issue.
   Also, I'll have to test it before ACK'ing it.

- Lastly, be aware that this code only helps parallelize the discovery
   delay loops in each host (the goal :). It does nothing to aid
   consistent device naming. There are still no guarantees about which
   rport gets which target id, which is scanned first/later, etc.
   Udev is still a requirement.

-- james


Matthew Wilcox wrote:
> Here's version 10 of the async scanning patch, against 2.6.18-rc1.
> Notable changes since version 9:
> 
>  - Integrated James' patch to fix modular SCSI.
>  - New interface scsi_target_discovery() for the benefit of transports
>    which find targets without scanning.
>  - qla2xxx and lpfc drivers converted to use above interface.
>  - Prototypes moved from scsi_device.h to scsi_host.h
> 
> Outstanding questions:
>  - Should we be async or sync by default?  James told me he wants it to
>    be sync by default.  It could even be a CONFIG option.
>  - I'm not sure the type "none" is implemented correctly, particularly for
>    drivers which call scsi_scan_target()
>  - I still want to know if we want a shost_for_each_device_safe iterator,
>    see the comment in the code.
>  - Can anyone think of a better name than scsi_target_discovery?
> 
> I'd like to thank Andrew Vasquez and Eric Moore for sitting down with me
> yesterday afternoon and explaining how their drivers work.  I've not done
> the bits for Fusion yet.  The interface is tweaked slightly from what
> we discussed yesterday.  To make lpfc work, I needed to add the elapsed
> time to the callback function.  I also realised that we'd designed an
> interface that was agnostic to FC and would work well for SAS too.
> 
> I haven't tested the Qlogic or Emulex drivers.  They compile, but I
> may have messed up the conversion from while loop conditions to the
> finished functions.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> 
> Index: drivers/scsi/Makefile
> ===================================================================
> RCS file: /var/cvs/linux-2.6/drivers/scsi/Makefile,v
> retrieving revision 1.26.12.1
> retrieving revision 1.28
> diff -u -p -r1.26.12.1 -r1.28
> --- drivers/scsi/Makefile	6 Jul 2006 11:44:05 -0000	1.26.12.1
> +++ drivers/scsi/Makefile	19 Jul 2006 20:00:05 -0000	1.28
> @@ -158,6 +158,9 @@ scsi_mod-y			+= scsi.o hosts.o scsi_ioct
>  scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
>  scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
>  
> +tmp-$(CONFIG_SCSI)      := scsi_wait_scan.o
> +obj-m                   += $(tmp-m)
> +
>  sd_mod-objs	:= sd.o
>  sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
>  ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
> Index: drivers/scsi/scsi_priv.h
> ===================================================================
> RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_priv.h,v
> retrieving revision 1.20.26.1
> retrieving revision 1.22
> diff -u -p -r1.20.26.1 -r1.22
> --- drivers/scsi/scsi_priv.h	6 Jul 2006 11:44:07 -0000	1.20.26.1
> +++ drivers/scsi/scsi_priv.h	19 Jul 2006 20:00:05 -0000	1.22
> @@ -38,6 +38,9 @@ static inline void scsi_log_completion(s
>  	{ };
>  #endif
>  
> +/* scsi_scan.c */
> +int scsi_complete_async_scans(void);
> +
>  /* scsi_devinfo.c */
>  extern int scsi_get_device_flags(struct scsi_device *sdev,
>  				 const unsigned char *vendor,
> Index: drivers/scsi/scsi_scan.c
> ===================================================================
> RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_scan.c,v
> retrieving revision 1.41.6.1
> diff -u -p -r1.41.6.1 scsi_scan.c
> --- drivers/scsi/scsi_scan.c	6 Jul 2006 11:44:07 -0000	1.41.6.1
> +++ drivers/scsi/scsi_scan.c	21 Jul 2006 15:20:44 -0000
> @@ -29,7 +29,9 @@
>  #include <linux/moduleparam.h>
>  #include <linux/init.h>
>  #include <linux/blkdev.h>
> -#include <asm/semaphore.h>
> +#include <linux/delay.h>
> +#include <linux/kthread.h>
> +#include <linux/spinlock.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -87,6 +89,11 @@ module_param_named(max_luns, max_scsi_lu
>  MODULE_PARM_DESC(max_luns,
>  		 "last scsi LUN (should be between 1 and 2^32-1)");
>  
> +static char scsi_scan_type[] = "async";
> +
> +module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type), S_IRUGO);
> +MODULE_PARM_DESC(scan, "sync, async or none");
> +
>  /*
>   * max_scsi_report_luns: the maximum number of LUNS that will be
>   * returned from the REPORT LUNS command. 8 times this value must
> @@ -108,6 +115,56 @@ MODULE_PARM_DESC(inq_timeout, 
>  		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
>  		 " Default is 5. Some non-compliant devices need more.");
>  
> +static spinlock_t async_scan_lock = SPIN_LOCK_UNLOCKED;
> +static LIST_HEAD(scanning_hosts);
> +
> +struct async_scan_data {
> +	struct list_head list;
> +	struct Scsi_Host *shost;
> +	struct completion prev_finished;
> +};
> +
> +int scsi_complete_async_scans(void)
> +{
> +	struct async_scan_data *data;
> +
> +	do {
> +		if (list_empty(&scanning_hosts))
> +			return 0;
> +		data = kmalloc(sizeof(*data), GFP_KERNEL);
> +		if (!data)
> +			msleep(1);
> +	} while (!data);
> +
> +	data->shost = NULL;
> +	init_completion(&data->prev_finished);
> +
> +	spin_lock(&async_scan_lock);
> +	if (list_empty(&scanning_hosts))
> +		goto done;
> +	list_add_tail(&data->list, &scanning_hosts);
> +	spin_unlock(&async_scan_lock);
> +
> +	printk(KERN_INFO "scsi: waiting for bus probes to complete ...\n");
> +	wait_for_completion(&data->prev_finished);
> +
> +	spin_lock(&async_scan_lock);
> +	list_del(&data->list);
> + done:
> +	spin_unlock(&async_scan_lock);
> +
> +	kfree(data);
> +	return 0;
> +}
> +
> +/* Only exported for the benefit of scsi_wait_scan */
> +EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
> +
> +#ifndef MODULE
> +late_initcall(scsi_complete_async_scans);
> +#endif
> +
> +
>  /**
>   * scsi_unlock_floptical - unlock device via a special MODE SENSE command
>   * @sdev:	scsi device to send command to
> @@ -628,7 +632,8 @@ static int scsi_probe_lun(struct scsi_de
>   *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a scsi_device
>   *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
>   **/
> -static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
> +static int scsi_add_lun(struct scsi_device *sdev, char *inq_result,
> +			int *bflags, int async)
>  {
>  	/*
>  	 * XXX do not save the inquiry, since it can change underneath us,
> @@ -801,7 +809,7 @@ static int scsi_add_lun(struct scsi_devi
>  	 * register it and tell the rest of the kernel
>  	 * about it.
>  	 */
> -	if (scsi_sysfs_add_sdev(sdev) != 0)
> +	if (!async && scsi_sysfs_add_sdev(sdev) != 0)
>  		return SCSI_SCAN_NO_RESPONSE;
>  
>  	return SCSI_SCAN_LUN_PRESENT;
> @@ -955,7 +963,7 @@ static int scsi_probe_and_add_lun(struct
>  		goto out_free_result;
>  	}
>  
> -	res = scsi_add_lun(sdev, result, &bflags);
> +	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
>  	if (res == SCSI_SCAN_LUN_PRESENT) {
>  		if (bflags & BLIST_KEY) {
>  			sdev->lockable = 0;
> @@ -1457,6 +1465,12 @@ void scsi_scan_target(struct device *par
>  {
>  	struct Scsi_Host *shost = dev_to_shost(parent);
>  
> +	if (strncmp(scsi_scan_type, "none", 4) == 0)
> +		return;
> +
> +	if (!shost->async_scan)
> +		scsi_complete_async_scans();
> +
>  	mutex_lock(&shost->scan_mutex);
>  	if (scsi_host_scan_allowed(shost))
>  		__scsi_scan_target(parent, channel, id, lun, rescan);
> @@ -1502,6 +1516,9 @@ int scsi_scan_host_selected(struct Scsi_
>  		"%s: <%u:%u:%u>\n",
>  		__FUNCTION__, channel, id, lun));
>  
> +	if (!shost->async_scan)
> +		scsi_complete_async_scans();
> +
>  	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
>  	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
>  	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
> @@ -1522,17 +1539,179 @@ int scsi_scan_host_selected(struct Scsi_
>  	return 0;
>  }
>  
> +/* The error handling here is pretty yucky.  Do we want an
> + * shost_for_each_device_safe() iterator?
> + */
> +static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
> +{
> +	struct scsi_device *sdev;
> +	shost_for_each_device(sdev, shost) {
> +		int err;
> + next:
> +		err = scsi_sysfs_add_sdev(sdev);
> +		if (err) {
> +			struct scsi_device *tmp = sdev;
> +			sdev = __scsi_iterate_devices(shost, sdev);
> +			scsi_destroy_sdev(tmp);
> +			goto next;
> +		}
> +	}
> +}
> +
> +/**
> + * scsi_prep_async_scan - prepare for an async scan
> + * @shost: the host which will be scanned
> + * Returns: a cookie to be passed to scsi_finish_async_scan()
> + *
> + * If your driver does not use scsi_scan_host(), you can call this function
> + * to tell the midlayer you're about to commence an asynchronous scan.
> + * This reserves your device's position in the scanning list and ensures
> + * that other asynchronous scans started after yours won't affect the
> + * disc ordering.
> + */
> +struct async_scan_data * scsi_prep_async_scan(struct Scsi_Host *shost)
> +{
> +	struct async_scan_data *data;
> +
> +	if (strncmp(scsi_scan_type, "sync", 4) == 0)
> +		return NULL;
> +
> +	if (shost->async_scan) {
> +		printk("%s called twice for host %d", __FUNCTION__,
> +				shost->host_no);
> +		dump_stack();
> +		return NULL;
> +	}
> +
> +	data = kmalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		goto err;
> +	data->shost = scsi_host_get(shost);
> +	if (!data->shost)
> +		goto err;
> +	init_completion(&data->prev_finished);
> +
> +	spin_lock(&async_scan_lock);
> +	shost->async_scan = 1;
> +	if (list_empty(&scanning_hosts))
> +		complete(&data->prev_finished);
> +	list_add_tail(&data->list, &scanning_hosts);
> +	spin_unlock(&async_scan_lock);
> +
> +	return data;
> +
> + err:
> +	kfree(data);
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(scsi_prep_async_scan);
> +
> +/**
> + * scsi_finish_async_scan - asynchronous scan has finished
> + * @data: cookie returned from earlier call to scsi_prep_async_scan()
> + *
> + * Once your driver has found all the devices currently present, call
> + * this function.  It will announce all the devices it has found to
> + * the rest of the system.
> + */
> +void scsi_finish_async_scan(struct async_scan_data *data)
> +{
> +	struct Scsi_Host *shost;
> +
> +	if (!data)
> +		return;
> +
> +	shost = data->shost;
> +	if (!shost->async_scan) {
> +		printk("%s called twice for host %d", __FUNCTION__,
> +				shost->host_no);
> +		dump_stack();
> +		return;
> +	}
> +
> +	wait_for_completion(&data->prev_finished);
> +
> +	scsi_sysfs_add_devices(shost);
> +
> +	spin_lock(&async_scan_lock);
> +	shost->async_scan = 0;
> +	list_del(&data->list);
> +	if (!list_empty(&scanning_hosts)) {
> +		struct async_scan_data *next = list_entry(scanning_hosts.next,
> +				struct async_scan_data, list);
> +		complete(&next->prev_finished);
> +	}
> +	spin_unlock(&async_scan_lock);
> +
> +	scsi_host_put(shost);
> +	kfree(data);
> +}
> +EXPORT_SYMBOL_GPL(scsi_finish_async_scan);
> +
> +static int do_scan_async(void *_data)
> +{
> +	struct async_scan_data *data = _data;
> +	scsi_scan_host_selected(data->shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
> +				SCAN_WILD_CARD, 0);
> +
> +	scsi_finish_async_scan(data);
> +	return 0;
> +}
> +
>  /**
>   * scsi_scan_host - scan the given adapter
>   * @shost:	adapter to scan
>   **/
>  void scsi_scan_host(struct Scsi_Host *shost)
>  {
> -	scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
> -				SCAN_WILD_CARD, 0);
> +	struct async_scan_data *data;
> +
> +	if (strncmp(scsi_scan_type, "none", 4) == 0)
> +		return;
> +
> +	data = scsi_prep_async_scan(shost);
> +	if (!data) {
> +		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
> +					SCAN_WILD_CARD, 0);
> +		return;
> +	}
> +	kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
>  }
>  EXPORT_SYMBOL(scsi_scan_host);
>  
> +struct target_discovery_data {
> +	struct Scsi_Host *shost;
> +	struct async_scan_data *data;
> +	int (*finished)(struct Scsi_Host *, unsigned long);
> +	unsigned long timeout;
> +};
> +
> +static int do_target_discovery(void *_data)
> +{
> +	struct target_discovery_data *data = _data;
> +	unsigned long start = jiffies;
> +	while (time_before(jiffies, start + data->timeout)) {
> +		if (data->finished(data->shost, jiffies - start))
> +			break;
> +		msleep(10);
> +	}
> +	scsi_finish_async_scan(data->data);
> +	kfree(data);
> +	return 0;
> +}
> +
> +void scsi_target_discovery(struct Scsi_Host *shost, unsigned long timeout,
> +			   int (*finished)(struct Scsi_Host *, unsigned long))
> +{
> +	struct target_discovery_data *data = kmalloc(sizeof(*data), GFP_KERNEL);
> +	data->shost = shost;
> +	data->data = scsi_prep_async_scan(shost);
> +	data->finished = finished;
> +	data->timeout = timeout;
> +	kthread_run(do_target_discovery, data, "scsi_scan_%d", shost->host_no);
> +}
> +EXPORT_SYMBOL_GPL(scsi_target_discovery);
> +
>  void scsi_forget_host(struct Scsi_Host *shost)
>  {
>  	struct scsi_device *sdev;
> Index: drivers/scsi/scsi_wait_scan.c
> ===================================================================
> RCS file: drivers/scsi/scsi_wait_scan.c
> diff -N drivers/scsi/scsi_wait_scan.c
> --- /dev/null	1 Jan 1970 00:00:00 -0000
> +++ drivers/scsi/scsi_wait_scan.c	19 Jul 2006 20:00:05 -0000	1.1
> @@ -0,0 +1,31 @@
> +/*
> + * scsi_wait_scan.c
> + *
> + * Copyright (C) 2006 James Bottomley <James.Bottomley@SteelEye.com>
> + *
> + * This is a simple module to wait until all the async scans are
> + * complete.  The idea is to use it in initrd/initramfs scripts.  You
> + * modprobe it after all the modprobes of the root SCSI drivers and it
> + * will wait until they have all finished scanning their busses before
> + * allowing the boot to proceed
> + */
> +
> +#include <linux/module.h>
> +#include "scsi_priv.h"
> +
> +static int __init wait_scan_init(void)
> +{
> +	scsi_complete_async_scans();
> +	return 0;
> +}
> +
> +static void __exit wait_scan_exit(void)
> +{
> +}
> + 
> +MODULE_DESCRIPTION("SCSI wait for scans");
> +MODULE_AUTHOR("James Bottomley");
> +MODULE_LICENSE("GPL");
> + 
> +module_init(wait_scan_init);
> +module_exit(wait_scan_exit);
> Index: drivers/scsi/lpfc/lpfc_init.c
> ===================================================================
> RCS file: /var/cvs/linux-2.6/drivers/scsi/lpfc/lpfc_init.c,v
> retrieving revision 1.9.8.1
> diff -u -p -r1.9.8.1 lpfc_init.c
> --- drivers/scsi/lpfc/lpfc_init.c	6 Jul 2006 11:44:11 -0000	1.9.8.1
> +++ drivers/scsi/lpfc/lpfc_init.c	21 Jul 2006 15:20:45 -0000
> @@ -405,26 +405,6 @@ lpfc_config_port_post(struct lpfc_hba * 
>  	}
>  	/* MBOX buffer will be freed in mbox compl */
>  
> -	i = 0;
> -	while ((phba->hba_state != LPFC_HBA_READY) ||
> -	       (phba->num_disc_nodes) || (phba->fc_prli_sent) ||
> -	       ((phba->fc_map_cnt == 0) && (i<2)) ||
> -	       (psli->sli_flag & LPFC_SLI_MBOX_ACTIVE)) {
> -		/* Check every second for 30 retries. */
> -		i++;
> -		if (i > 30) {
> -			break;
> -		}
> -		if ((i >= 15) && (phba->hba_state <= LPFC_LINK_DOWN)) {
> -			/* The link is down.  Set linkdown timeout */
> -			break;
> -		}
> -
> -		/* Delay for 1 second to give discovery time to complete. */
> -		msleep(1000);
> -
> -	}
> -
>  	/* Since num_disc_nodes keys off of PLOGI, delay a bit to let
>  	 * any potential PRLIs to flush thru the SLI sub-system.
>  	 */
> @@ -1413,6 +1393,23 @@ lpfc_scsi_free(struct lpfc_hba * phba)
>  	return 0;
>  }
>  
> +static int lpfc_finished_discovery(struct Scsi_Host *shost,
> +						unsigned long elapsed_jiffies)
> +{
> +	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
> +
> +	if (phba->hba_state != LPFC_HBA_READY)
> +		return 0;
> +	if (phba->num_disc_nodes || phba->fc_prli_sent)
> +		return 0;
> +	if ((phba->fc_map_cnt == 0) && (elapsed_jiffies < 2 * HZ))
> +		return 0;
> +	if (phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE)
> +		return 0;
> +	if ((phba->hba_state > LPFC_LINK_DOWN) || (elapsed_jiffies < 15 * HZ))
> +		return 0;
> +	return 1;
> +}
>  
>  static int __devinit
>  lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
> Index: drivers/scsi/qla2xxx/qla_os.c
> ===================================================================
> RCS file: /var/cvs/linux-2.6/drivers/scsi/qla2xxx/qla_os.c,v
> retrieving revision 1.28.8.1
> diff -u -p -r1.28.8.1 qla_os.c
> --- drivers/scsi/qla2xxx/qla_os.c	6 Jul 2006 11:44:14 -0000	1.28.8.1
> +++ drivers/scsi/qla2xxx/qla_os.c	21 Jul 2006 15:20:45 -0000
> @@ -1334,6 +1334,17 @@ qla24xx_disable_intrs(scsi_qla_host_t *h
>  	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  }
>  
> +static int qla2x00_scan_finished(struct Scsi_Host *shost, unsigned long x)
> +{
> +	scsi_qla_host_t *ha = (scsi_qla_host_t *)shost->hostdata;
> +
> +	qla2x00_check_fabric_devices(ha);
> +
> +	if (ha->device_flags & (DFLG_NO_CABLE | DFLG_FABRIC_DEVICES))
> +		return 1;
> +	return !(ha->device_flags & SWITCH_FOUND);
> +}
> +
>  /*
>   * PCI driver interface
>   */
> @@ -1344,8 +1355,7 @@ qla2x00_probe_one(struct pci_dev *pdev, 
>  	device_reg_t __iomem *reg;
>  	struct Scsi_Host *host;
>  	scsi_qla_host_t *ha;
> -	unsigned long	flags = 0;
> -	unsigned long	wait_switch = 0;
> +	unsigned long flags;
>  	char pci_info[20];
>  	char fw_str[30];
>  	fc_port_t *fcport;
> @@ -1595,22 +1605,6 @@ qla2x00_probe_one(struct pci_dev *pdev, 
>  
>  	ha->isp_ops.enable_intrs(ha);
>  
> -	/* v2.19.5b6 */
> -	/*
> -	 * Wait around max loop_reset_delay secs for the devices to come
> -	 * on-line. We don't want Linux scanning before we are ready.
> -	 *
> -	 */
> -	for (wait_switch = jiffies + (ha->loop_reset_delay * HZ);
> -	    time_before(jiffies,wait_switch) &&
> -	     !(ha->device_flags & (DFLG_NO_CABLE | DFLG_FABRIC_DEVICES))
> -	     && (ha->device_flags & SWITCH_FOUND) ;) {
> -
> -		qla2x00_check_fabric_devices(ha);
> -
> -		msleep(10);
> -	}
> -
>  	pci_set_drvdata(pdev, ha);
>  	ha->flags.init_done = 1;
>  	num_hosts++;
> @@ -1619,6 +1613,8 @@ qla2x00_probe_one(struct pci_dev *pdev, 
>  	if (ret)
>  		goto probe_failed;
>  
> +	scsi_target_discovery(host, ha->loop_reset_delay * HZ,
> +				qla2x00_scan_finished);
>  	qla2x00_alloc_sysfs_attr(ha);
>  
>  	qla2x00_init_host_attr(ha);
> Index: include/scsi/scsi_host.h
> ===================================================================
> RCS file: /var/cvs/linux-2.6/include/scsi/scsi_host.h,v
> retrieving revision 1.27.8.1
> diff -u -p -r1.27.8.1 scsi_host.h
> --- include/scsi/scsi_host.h	6 Jul 2006 11:45:47 -0000	1.27.8.1
> +++ include/scsi/scsi_host.h	21 Jul 2006 15:20:46 -0000
> @@ -545,6 +545,9 @@ struct Scsi_Host {
>  	/* task mgmt function in progress */
>  	unsigned tmf_in_progress:1;
>  
> +	/* Are we currently performing an async scan? */
> +	unsigned async_scan:1;
> +
>  	/*
>  	 * Optional work queue to be utilized by the transport
>  	 */
> @@ -639,6 +642,12 @@ extern void scsi_host_put(struct Scsi_Ho
>  extern struct Scsi_Host *scsi_host_lookup(unsigned short);
>  extern const char *scsi_host_state_name(enum scsi_host_state);
>  
> +struct async_scan_data;
> +struct async_scan_data * scsi_prep_async_scan(struct Scsi_Host *shost);
> +void scsi_finish_async_scan(struct async_scan_data *data);
> +void scsi_target_discovery(struct Scsi_Host *shost, unsigned long timeout,
> +			   int (*finished)(struct Scsi_Host *, unsigned long));
> +
>  extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
>  
>  static inline void scsi_assign_lock(struct Scsi_Host *shost, spinlock_t *lock)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
