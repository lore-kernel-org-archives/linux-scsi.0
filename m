From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] avoiding obsolete scsi APIs in dc395
Date: Sun, 20 Jun 2004 18:04:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040620160442.GA17201@lst.de>
References: <20040606123908.GA30885@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:2750 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265655AbUFTQE5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2004 12:04:57 -0400
Content-Disposition: inline
In-Reply-To: <20040606123908.GA30885@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: oliver@neukum.name, aliakc@web.de, lenehan@twibble.org
Cc: linux-scsi@vger.kernel.org

On Sun, Jun 06, 2004 at 02:39:08PM +0200, Christoph Hellwig wrote:
> replace obsolete typedefs and scsi_to_pci_dma_dir, use proper includes
> and re-order includes correctly.

ping?

> 
> 
> 
> --- 1.33/drivers/scsi/dc395x.c	2004-05-12 17:46:20 +02:00
> +++ edited/drivers/scsi/dc395x.c	2004-06-06 14:27:30 +02:00
> @@ -51,16 +51,20 @@
>  #include <linux/delay.h>
>  #include <linux/ctype.h>
>  #include <linux/blkdev.h>
> -#include <asm/io.h>
> -#include "scsi.h"
> -#include <scsi/scsi_host.h>
> -#include "dc395x.h"
> -#include <scsi/scsicam.h>	/* needed for scsicam_bios_param */
>  #include <linux/interrupt.h>
>  #include <linux/init.h>
>  #include <linux/spinlock.h>
>  #include <linux/pci.h>
>  #include <linux/list.h>
> +#include <asm/io.h>
> +
> +#include <scsi/scsi.h>
> +#include <scsi/scsicam.h>	/* needed for scsicam_bios_param */
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_host.h>
> +
> +#include "dc395x.h"
>  
>  #define DC395X_NAME	"dc395x"
>  #define DC395X_BANNER	"Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040"
> @@ -222,7 +226,7 @@
>  struct ScsiReqBlk {
>  	struct list_head list;		/* next/prev ptrs for srb lists */
>  	struct DeviceCtlBlk *dcb;
> -	Scsi_Cmnd *cmd;
> +	struct scsi_cmnd *cmd;
>  
>  	struct SGentry *segment_x;	/* Linear array of hw sg entries (up to 64 entries) */
>  	u32 sg_bus_addr;	        /* Bus address of sg list (ie, of segment_x) */
> @@ -372,10 +376,10 @@
>  static void reselect(struct AdapterCtlBlk *acb);
>  static u8 start_scsi(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
>  		struct ScsiReqBlk *srb);
> -static void build_srb(Scsi_Cmnd *cmd, struct DeviceCtlBlk *dcb,
> +static void build_srb(struct scsi_cmnd *cmd, struct DeviceCtlBlk *dcb,
>  		struct ScsiReqBlk *srb);
>  static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_code,
> -		Scsi_Cmnd *cmd, u8 force);
> +		struct scsi_cmnd *cmd, u8 force);
>  static void scsi_reset_detect(struct AdapterCtlBlk *acb);
>  static void pci_unmap_srb(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb);
>  static void pci_unmap_srb_sense(struct AdapterCtlBlk *acb,
> @@ -738,7 +742,7 @@
>  
>  
>  /* Find cmd in SRB list */
> -inline static struct ScsiReqBlk *find_cmd(Scsi_Cmnd *cmd, 
> +inline static struct ScsiReqBlk *find_cmd(struct scsi_cmnd *cmd, 
>  		struct list_head *head)
>  {
>  	struct ScsiReqBlk *i;
> @@ -973,10 +977,10 @@
>  
>  
>  /* Prepare SRB for being sent to Device DCB w/ command *cmd */
> -static void build_srb(Scsi_Cmnd *cmd, struct DeviceCtlBlk *dcb,
> +static void build_srb(struct scsi_cmnd *cmd, struct DeviceCtlBlk *dcb,
>  		struct ScsiReqBlk *srb)
>  {
> -	int dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
> +	enum dma_data_direction dir = cmd->sc_data_direction;
>  	dprintkdbg(DBG_0, "build_srb: (pid#%li) <%02i-%i>\n",
>  		cmd->pid, dcb->target_id, dcb->target_lun);
>  
> @@ -1089,7 +1093,7 @@
>   *        and is expected to be held on return.
>   *
>   **/
> -static int dc395x_queue_command(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
> +static int dc395x_queue_command(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>  {
>  	struct DeviceCtlBlk *dcb;
>  	struct ScsiReqBlk *srb;
> @@ -1304,7 +1308,7 @@
>   * @cmd - some command for this host (for fetching hooks)
>   * Returns: SUCCESS (0x2002) on success, else FAILED (0x2003).
>   */
> -static int dc395x_eh_bus_reset(Scsi_Cmnd *cmd)
> +static int dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
>  {
>  	struct AdapterCtlBlk *acb =
>  		(struct AdapterCtlBlk *)cmd->device->host->hostdata;
> @@ -1356,7 +1360,7 @@
>   * @cmd - command to be aborted
>   * Returns: SUCCESS (0x2002) on success, else FAILED (0x2003).
>   */
> -static int dc395x_eh_abort(Scsi_Cmnd *cmd)
> +static int dc395x_eh_abort(struct scsi_cmnd *cmd)
>  {
>  	/*
>  	 * Look into our command queues: If it has not been sent already,
> @@ -1939,7 +1943,7 @@
>  {
>  	u8 idx;
>  	struct scatterlist *sg;
> -	Scsi_Cmnd *cmd = srb->cmd;
> +	struct scsi_cmnd *cmd = srb->cmd;
>  	int segment = cmd->use_sg;
>  	u32 xferred = srb->total_xfer_length - left; /* bytes transfered */
>  	struct SGentry *psge = srb->segment_x + srb->sg_index;
> @@ -3249,8 +3253,8 @@
>  /* unmap mapped pci regions from SRB */
>  static void pci_unmap_srb(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
>  {
> -	Scsi_Cmnd *cmd = srb->cmd;
> -	int dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
> +	struct scsi_cmnd *cmd = srb->cmd;
> +	enum dma_data_direction dir = cmd->sc_data_direction;
>  	if (cmd->use_sg && dir != PCI_DMA_NONE) {
>  		/* unmap DC395x SG list */
>  		dprintkdbg(DBG_SG, "pci_unmap_srb: list=%08x(%05x)\n",
> @@ -3301,11 +3305,10 @@
>  		struct ScsiReqBlk *srb)
>  {
>  	u8 tempcnt, status;
> -	Scsi_Cmnd *cmd = srb->cmd;
> +	struct scsi_cmnd *cmd = srb->cmd;
>  	struct ScsiInqData *ptr;
> -	int dir;
> +	enum dma_data_direction dir = cmd->sc_data_direction;
>  
> -	dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
>  	if (cmd->use_sg) {
>  		struct scatterlist* sg = (struct scatterlist *)cmd->request_buffer;
>  		ptr = (struct ScsiInqData *)(page_address(sg->page) + sg->offset);
> @@ -3510,7 +3513,7 @@
>  
>  /* abort all cmds in our queues */
>  static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
> -		Scsi_Cmnd *cmd, u8 force)
> +		struct scsi_cmnd *cmd, u8 force)
>  {
>  	struct DeviceCtlBlk *dcb;
>  	dprintkl(KERN_INFO, "doing_srb_done: pids ");
> @@ -3518,14 +3521,14 @@
>  	list_for_each_entry(dcb, &acb->dcb_list, list) {
>  		struct ScsiReqBlk *srb;
>  		struct ScsiReqBlk *tmp;
> -		Scsi_Cmnd *p;
> +		struct scsi_cmnd *p;
>  
>  		list_for_each_entry_safe(srb, tmp, &dcb->srb_going_list, list) {
> +			enum dma_data_direction dir;
>  			int result;
> -			int dir;
>  
>  			p = srb->cmd;
> -			dir = scsi_to_pci_dma_dir(p->sc_data_direction);
> +			dir = p->sc_data_direction;
>  			result = MK_RES(0, did_flag, 0, 0);
>  			printk("G:%li(%02i-%i) ", p->pid,
>  			       p->device->id, p->device->lun);
> @@ -3665,7 +3668,7 @@
>  static void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
>  		struct ScsiReqBlk *srb)
>  {
> -	Scsi_Cmnd *cmd = srb->cmd;
> +	struct scsi_cmnd *cmd = srb->cmd;
>  	dprintkdbg(DBG_1, "request_sense: (pid#%li) <%02i-%i>\n",
>  		cmd->pid, cmd->device->id, cmd->device->lun);
>  
> @@ -4738,7 +4741,7 @@
>  }
>  
>  
> -static Scsi_Host_Template dc395x_driver_template = {
> +static struct scsi_host_template dc395x_driver_template = {
>  	.module                 = THIS_MODULE,
>  	.proc_name              = DC395X_NAME,
>  	.proc_info              = dc395x_proc_info,
---end quoted text---
