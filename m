From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] dpt_i2o: 64 bit support (take 4)
Date: Fri, 25 Apr 2008 12:29:12 -0500
Message-ID: <1209144552.3087.43.camel@localhost.localdomain>
References: <20080424213355.GA21682@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44400 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764086AbYDYR3Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 13:29:16 -0400
In-Reply-To: <20080424213355.GA21682@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-04-24 at 23:33 +0200, Miquel van Smoorenburg wrote:
> I've taken out the ifdef __linux__ code that was added, and
> I removed the unused reboot_notifier code.
> 
> As before, 1/2 is the 64 bit code, 2/2 is the sysfs code.
> 
> # -----
> 
> This patch is an update for drivers/scsi/dpt_i2o.c.
> It applies to both 2.6.24.4 and 2.6.25
> 
> It contains the following changes:
> 
> * 64 bit code based on unofficial Adaptec 64 bit driver
> * removes scsi_module.c dependency, adds module_init / module_exit
>   this is needed because we need to pass the proper device to
>   scsi_add_host(), and the scsi_module.c passes NULL. With NULL,
>   code like arch/x64/kernel/pci-gart_64.c::need_iommu() crashes
>   because the dev pointer it is passed is NULL.
> * adds sysfs entry for /sys/class/dpt_i2o/dptiX so that udev
>   can create /dev/dptiX dynamically
> 
> Obviously there are more cleanups that can be done to this code,
> but we need to start somewhere. Patch has been tested heavily on
> both 32 and 64 bit x86 platforms.
> 
> Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>
> 
> diff -ruN orig/linux-2.6.25/drivers/scsi/Kconfig linux-2.6.25/drivers/scsi/Kconfig
> --- orig/linux-2.6.25/drivers/scsi/Kconfig	2008-04-17 04:49:44.000000000 +0200
> +++ linux-2.6.25/drivers/scsi/Kconfig	2008-04-18 23:09:44.000000000 +0200
> @@ -504,10 +504,9 @@
>  source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
>  source "drivers/scsi/aic94xx/Kconfig"
>  
> -# All the I2O code and drivers do not seem to be 64bit safe.
>  config SCSI_DPT_I2O
>  	tristate "Adaptec I2O RAID support "
> -	depends on !64BIT && SCSI && PCI && VIRT_TO_BUS
> +	depends on SCSI && PCI && VIRT_TO_BUS
>  	help
>  	  This driver supports all of Adaptec's I2O based RAID controllers as 
>  	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained
> diff -ruN orig/linux-2.6.25/drivers/scsi/dpt/dptsig.h linux-2.6.25/drivers/scsi/dpt/dptsig.h
> --- orig/linux-2.6.25/drivers/scsi/dpt/dptsig.h	2008-04-17 04:49:44.000000000 +0200
> +++ linux-2.6.25/drivers/scsi/dpt/dptsig.h	2008-04-24 22:32:35.000000000 +0200
> @@ -30,14 +30,9 @@
>  /* DPT SIGNATURE SPEC AND HEADER FILE                           */
>  /* Signature Version 1 (sorry no 'A')                           */
>  
> -/* to make sure we are talking the same size under all OS's     */
>  typedef unsigned char sigBYTE;
>  typedef unsigned short sigWORD;
> -#if (defined(_MULTI_DATAMODEL) && defined(sun) && !defined(_ILP32))
> -typedef uint32_t sigLONG;
> -#else
> -typedef unsigned long sigLONG;
> -#endif
> +typedef unsigned int sigLONG;
>  
>  /*
>   * use sigWORDLittleEndian for:
> diff -ruN orig/linux-2.6.25/drivers/scsi/dpt/osd_util.h linux-2.6.25/drivers/scsi/dpt/osd_util.h
> --- orig/linux-2.6.25/drivers/scsi/dpt/osd_util.h	2008-04-17 04:49:44.000000000 +0200
> +++ linux-2.6.25/drivers/scsi/dpt/osd_util.h	2008-04-24 22:34:31.000000000 +0200
> @@ -185,7 +185,7 @@
>     typedef unsigned char   uCHAR;
>     typedef unsigned short  uSHORT;
>     typedef unsigned int    uINT;
> -   typedef unsigned long   uLONG;
> +   typedef unsigned int    uLONG;

This is going to cause a large swathe of kernel programmers to blow a
fuse.  It's incredibly non obvious that uLONG should universally be a 32
bit type.

Most of the uses seem to be in the completely unused osd function
definitions and the unused access_U typedef.

I think it can actually safely be left at unsigned long (possibly
removing the access_U typedef that makes the uLONG in the union look
wrong).

>     typedef union {
>  	 uCHAR        u8[4];
> diff -ruN orig/linux-2.6.25/drivers/scsi/dpt_i2o.c linux-2.6.25/drivers/scsi/dpt_i2o.c
> --- orig/linux-2.6.25/drivers/scsi/dpt_i2o.c	2008-04-17 04:49:44.000000000 +0200
> +++ linux-2.6.25/drivers/scsi/dpt_i2o.c	2008-04-24 22:30:29.000000000 +0200
> @@ -108,27 +108,26 @@
>  
>  static DEFINE_MUTEX(adpt_configuration_lock);
>  
> -static struct i2o_sys_tbl *sys_tbl = NULL;
> -static int sys_tbl_ind = 0;
> -static int sys_tbl_len = 0;
> +static struct i2o_sys_tbl *sys_tbl;
> +static dma_addr_t sys_tbl_pa;
> +static int sys_tbl_ind;
> +static int sys_tbl_len;
>  
>  static adpt_hba* hba_chain = NULL;
>  static int hba_count = 0;
>  
> +#ifdef CONFIG_COMPAT
> +static long compat_adpt_ioctl(struct file *, unsigned int, unsigned long);
> +#endif
> +
>  static const struct file_operations adpt_fops = {
>  	.ioctl		= adpt_ioctl,
>  	.open		= adpt_open,
> -	.release	= adpt_close
> -};
> -
> -#ifdef REBOOT_NOTIFIER
> -static struct notifier_block adpt_reboot_notifier =
> -{
> -	 adpt_reboot_event,
> -	 NULL,
> -	 0
> -};
> +	.release	= adpt_close,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl	= compat_adpt_ioctl,
>  #endif
> +};
>  
>  /* Structures and definitions for synchronous message posting.
>   * See adpt_i2o_post_wait() for description
> @@ -151,6 +150,21 @@
>   *============================================================================
>   */
>  
> +static inline int dpt_dma64(adpt_hba *pHba)
> +{
> +	return (sizeof(dma_addr_t) > 4 && (pHba)->dma64);
> +}
> +
> +static inline u32 dma_high(dma_addr_t addr)
> +{
> +	return (u32) ((u64)addr >> 32);
> +}

promotion to u64 is suboptimal in the 32 bit case.  The standard way of
doing this is to use the kernel.h:upper_32_bits() macro which does

(addr >> 16) >> 16

> +static inline u32 dma_low(dma_addr_t addr)
> +{
> +	return (u32)addr;
> +}
> +
>  static u8 adpt_read_blink_led(adpt_hba* host)
>  {
>  	if(host->FwDebugBLEDflag_P != 0) {
> @@ -178,8 +192,6 @@
>  	struct pci_dev *pDev = NULL;
>  	adpt_hba* pHba;
>  
> -	adpt_init();
> -
>  	PINFO("Detecting Adaptec I2O RAID controllers...\n");
>  
>          /* search for all Adatpec I2O RAID cards */
> @@ -248,7 +260,7 @@
>  	}
>  
>  	for (pHba = hba_chain; pHba; pHba = pHba->next) {
> -		if( adpt_scsi_register(pHba,sht) < 0){
> +		if (adpt_scsi_host_alloc(pHba, sht) < 0){
>  			adpt_i2o_delete_hba(pHba);
>  			continue;
>  		}
> @@ -282,7 +294,7 @@
>  
>  static void adpt_inquiry(adpt_hba* pHba)
>  {
> -	u32 msg[14]; 
> +	u32 msg[17]; 
>  	u32 *mptr;
>  	u32 *lenptr;
>  	int direction;
> @@ -290,11 +302,12 @@
>  	u32 len;
>  	u32 reqlen;
>  	u8* buf;
> +	dma_addr_t addr;
>  	u8  scb[16];
>  	s32 rcode;
>  
>  	memset(msg, 0, sizeof(msg));
> -	buf = kmalloc(80,GFP_KERNEL|ADDR32);
> +	buf = pci_alloc_consistent(pHba->pDev, 80, &addr);

You probably want to use dma_alloc_coherent here ... it's identical to
pci_alloc_consistent in almost every way, except that it allows you to
pass in the GFP_KERNEL flag (pci_alloc_consistent has to assume
GFP_ATOMIC and thus you can get unexpected failures if SLUB is having a
bad day) and you have to call it on &pHba->pDev->dev and use the
corresponding dma_free_coherent().

>  	if(!buf){
>  		printk(KERN_ERR"%s: Could not allocate buffer\n",pHba->name);
>  		return;
> @@ -305,7 +318,10 @@
>  	direction = 0x00000000;	
>  	scsidir  =0x40000000;	// DATA IN  (iop<--dev)
>  
> -	reqlen = 14;		// SINGLE SGE
> +	if (dpt_dma64(pHba))
> +		reqlen = 17;		// SINGLE SGE, 64 bit
> +	else
> +		reqlen = 14;		// SINGLE SGE, 32 bit
>  	/* Stick the headers on */
>  	msg[0] = reqlen<<16 | SGL_OFFSET_12;
>  	msg[1] = (0xff<<24|HOST_TID<<12|ADAPTER_TID);
> @@ -338,8 +354,16 @@
>  
>  	/* Now fill in the SGList and command */
>  	*lenptr = len;
> -	*mptr++ = 0xD0000000|direction|len;
> -	*mptr++ = virt_to_bus(buf);
> +	if (dpt_dma64(pHba)) {
> +		*mptr++ = (0x7C<<24)+(2<<16)+0x02; /* Enable 64 bit */
> +		*mptr++ = 1 << PAGE_SHIFT;
> +		*mptr++ = 0xD0000000|direction|len;
> +		*mptr++ = dma_low(addr);
> +		*mptr++ = dma_high(addr);
> +	} else {
> +		*mptr++ = 0xD0000000|direction|len;
> +		*mptr++ = addr;
> +	}
>  
>  	// Send it on it's way
>  	rcode = adpt_i2o_post_wait(pHba, msg, reqlen<<2, 120);
> @@ -347,7 +371,7 @@
>  		sprintf(pHba->detail, "Adaptec I2O RAID");
>  		printk(KERN_INFO "%s: Inquiry Error (%d)\n",pHba->name,rcode);
>  		if (rcode != -ETIME && rcode != -EINTR)
> -			kfree(buf);
> +			pci_free_consistent(pHba->pDev, 80, buf, addr);
>  	} else {
>  		memset(pHba->detail, 0, sizeof(pHba->detail));
>  		memcpy(&(pHba->detail), "Vendor: Adaptec ", 16);
> @@ -356,7 +380,7 @@
>  		memcpy(&(pHba->detail[40]), " FW: ", 4);
>  		memcpy(&(pHba->detail[44]), (u8*) &buf[32], 4);
>  		pHba->detail[48] = '\0';	/* precautionary */
> -		kfree(buf);
> +		pci_free_consistent(pHba->pDev, 80, buf, addr);
>  	}
>  	adpt_i2o_status_get(pHba);
>  	return ;
> @@ -632,6 +656,100 @@
>  	return len;
>  }
>  
> +/*
> + *	Turn a struct scsi_cmnd * into a unique 32 bit 'context'.
> + */
> +static u32 adpt_cmd_to_context(struct scsi_cmnd *cmd)
> +{
> +#if BITS_PER_LONG == 32
> +	return (u32)(unsigned long)cmd;
> +#else
> +	return (u32)cmd->serial_number;
> +#endif

Really, no ... use serial_number the whole time.  Commands get reused,
so the command pointer might not end up unique (for commands the board
thinks it still has and the SCSI layer took away because of timeouts).

> +
> +/*
> + *	Go from a u32 'context' to a struct scsi_cmnd * .
> + *	This could probably be made more efficient.
> + */
> +static struct scsi_cmnd *
> +	adpt_cmd_from_context(adpt_hba * pHba, u32 context)
> +{
> +#if BITS_PER_LONG == 32
> +	return (struct scsi_cmnd*)(unsigned long)context;
> +#else
> +	struct scsi_cmnd * cmd;
> +	struct scsi_device * d;
> +
> +	if (context == 0)
> +		return NULL;
> +
> +	spin_unlock(pHba->host->host_lock);
> +	shost_for_each_device(d, pHba->host) {
> +		unsigned long flags;
> +		spin_lock_irqsave(&d->list_lock, flags);
> +		list_for_each_entry(cmd, &d->cmd_list, list) {
> +			if (((u32)cmd->serial_number == context)) {
> +				spin_unlock_irqrestore(&d->list_lock, flags);
> +				scsi_device_put(d);
> +				spin_lock(pHba->host->host_lock);
> +				return cmd;
> +			}
> +		}
> +		spin_unlock_irqrestore(&d->list_lock, flags);
> +	}
> +	spin_lock(pHba->host->host_lock);
> +
> +	return NULL;
> +#endif
> +}
> +
> +/*
> + *	Turn a pointer to ioctl reply data into an u32 'context'
> + */
> +static u32 adpt_ioctl_to_context(adpt_hba * pHba, void *reply)
> +{
> +#if BITS_PER_LONG == 32
> +	return (u32)(unsigned long)reply;
> +#else
> +	ulong flags = 0;
> +	u32 nr, i;
> +
> +	spin_lock_irqsave(pHba->host->host_lock, flags);
> +	nr =  sizeof(pHba->ioctl_reply_context) /
> +		sizeof(pHba->ioctl_reply_context[0]);
> +	for (i = 0; i < nr; i++) {
> +		if (pHba->ioctl_reply_context[i] == NULL) {
> +			pHba->ioctl_reply_context[i] = reply;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(pHba->host->host_lock, flags);
> +	if (i >= nr) {
> +		kfree (reply);
> +		printk(KERN_WARNING"%s: Too many outstanding "
> +				"ioctl commands\n", pHba->name);
> +		return (u32)-1;
> +	}
> +
> +	return i;
> +#endif
> +}
> +
> +/*
> + *	Go from an u32 'context' to a pointer to ioctl reply data.
> + */
> +static void *adpt_ioctl_from_context(adpt_hba *pHba, u32 context)
> +{
> +#if BITS_PER_LONG == 32
> +	return (void *)(unsigned long)context;
> +#else
> +	void *p = pHba->ioctl_reply_context[context];
> +	pHba->ioctl_reply_context[context] = NULL;
> +
> +	return p;
> +#endif
> +}
>  
>  /*===========================================================================
>   * Error Handling routines
> @@ -660,7 +778,7 @@
>  	msg[1] = I2O_CMD_SCSI_ABORT<<24|HOST_TID<<12|dptdevice->tid;
>  	msg[2] = 0;
>  	msg[3]= 0; 
> -	msg[4] = (u32)cmd;
> +	msg[4] = adpt_cmd_to_context(cmd);
>  	if (pHba->host)
>  		spin_lock_irq(pHba->host->host_lock);
>  	rcode = adpt_i2o_post_wait(pHba, msg, sizeof(msg), FOREVER);
> @@ -861,27 +979,6 @@
>  	 printk(KERN_INFO "Adaptec I2O controllers down.\n");
>  }
>  
> -/*
> - * reboot/shutdown notification.
> - *
> - * - Quiesce each IOP in the system
> - *
> - */
> -
> -#ifdef REBOOT_NOTIFIER
> -static int adpt_reboot_event(struct notifier_block *n, ulong code, void *p)
> -{
> -
> -	 if(code != SYS_RESTART && code != SYS_HALT && code != SYS_POWER_OFF)
> -		  return NOTIFY_DONE;
> -
> -	 adpt_i2o_sys_shutdown();
> -
> -	 return NOTIFY_DONE;
> -}
> -#endif
> -
> -
>  static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev)
>  {
>  
> @@ -893,6 +990,7 @@
>  	u32 hba_map1_area_size = 0;
>  	void __iomem *base_addr_virt = NULL;
>  	void __iomem *msg_addr_virt = NULL;
> +	int dma64 = 0;
>  
>  	int raptorFlag = FALSE;
>  
> @@ -906,8 +1004,20 @@
>  	}
>  
>  	pci_set_master(pDev);
> -	if (pci_set_dma_mask(pDev, DMA_32BIT_MASK))
> -		return -EINVAL;
> +	/*
> +	 *	Only try to enable DMA 64 bit mode mode if the dma_addr_t
> +	 *	type can hold 64 bit addresses.
> +	 */
> +	if (sizeof(dma_addr_t) == 8 &&
> +	    pci_set_dma_mask(pDev, DMA_64BIT_MASK) == 0) {
> +		dma64 = 1;

it might be worth using dma_get_required_mask() here.  That allows you
to see not only if the platform supports 64 bits, but also if you need
to turn it on (as in you check what's returned and if it's >
DMA_32BIT_MASK you know you're on a 64 bit DMA platform with > 4GB
memory and thus you need to turn this on).

> +	} else {
> +		if (pci_set_dma_mask(pDev, DMA_32BIT_MASK) != 0)
> +			return -EINVAL;
> +	}
> +
> +	/* Make sure pci_alloc_consistent returns 32 bit addresses */
> +	pci_set_consistent_dma_mask(pDev, DMA_32BIT_MASK);
>  
>  	base_addr0_phys = pci_resource_start(pDev,0);
>  	hba_map0_area_size = pci_resource_len(pDev,0);
> @@ -929,6 +1039,19 @@
>  		raptorFlag = TRUE;
>  	}
>  
> +#if BITS_PER_LONG == 64
> +	/* x86_64 machines need more optimal mappings */
> +	if (raptorFlag == TRUE) {
> +		if (hba_map0_area_size > 128)
> +			hba_map0_area_size = 128;
> +		if (hba_map1_area_size > 524288)
> +			hba_map1_area_size = 524288;
> +	} else {
> +		if (hba_map0_area_size > 524288)
> +			hba_map0_area_size = 524288;
> +	}
> +#endif

If this is really only x86_64 ... and it looks rather odd; shouldn't
this be an 

ifdef __x86_64__ (or whatever the symbol is)?

James


