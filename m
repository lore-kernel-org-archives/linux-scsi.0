From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: Re: [PATCH 1/1] pmcraid driver to support set timestamp command and
 other fixes
Date: Thu, 28 Oct 2010 16:20:39 -0700 (PDT)
Message-ID: <alpine.LNX.1.10.1010281619220.25170@rslab235.pmc-sierra.bc.ca>
References: <alpine.LNX.1.10.1010131341370.20256@rslab235.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:45632 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754444Ab0J2BOz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2010 21:14:55 -0400
In-Reply-To: <alpine.LNX.1.10.1010131341370.20256@rslab235.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: anil_ravindranath@pmc-sierra.com

Hi James,

Can you please let me know status of the below patch which I submitted two 
weeks back.

With regards,
  Anil

On Wed, 13 Oct 2010, Anil Ravindranath wrote:

> 
> The following are the fixes in this patch:
> 1. Added support of set timestamp command in the driver
> 2. Pass all status code to mgmt application. Earlier we were passing only 
> failed ones.
> 3. Call class_destroy after unregister_chrdev and pci_unregister_driver
> 
> Signed-off-by: Anil Ravindranath<anil_ravindranath@pmc-sierra.com>
> 
>  pmcraid.c |  129 ++++++++++++++++++++++++++++++++++++++++++++++++++++----------
>  pmcraid.h |   22 +++++++++-
>  2 files changed, 129 insertions(+), 22 deletions(-)
> 
> --- scsi-misc-2.6.orig/drivers/scsi/pmcraid.h	2010-10-13 14:37:18.000000000 -0700
> +++ scsi-misc-2.6/drivers/scsi/pmcraid.h	2010-10-13 14:46:23.000000000 -0700
> @@ -42,7 +42,7 @@
>   */
>  #define PMCRAID_DRIVER_NAME		"PMC MaxRAID"
>  #define PMCRAID_DEVFILE			"pmcsas"
> -#define PMCRAID_DRIVER_VERSION		"2.0.2"
> +#define PMCRAID_DRIVER_VERSION		"2.0.3"
>  #define PMCRAID_DRIVER_DATE		__DATE__
>  
>  #define PMCRAID_FW_VERSION_1		0x002
> @@ -184,6 +184,7 @@
>  #define PMCRAID_IOASC_IR_INVALID_RESOURCE_HANDLE        0x05250000
>  #define PMCRAID_IOASC_AC_TERMINATED_BY_HOST		0x0B5A0000
>  #define PMCRAID_IOASC_UA_BUS_WAS_RESET			0x06290000
> +#define PMCRAID_IOASC_TIME_STAMP_OUT_OF_SYNC		0x06908B00
>  #define PMCRAID_IOASC_UA_BUS_WAS_RESET_BY_OTHER		0x06298000
>  
>  /* Driver defined IOASCs */
> @@ -561,6 +562,17 @@
>  	__u8	reserved3[16];
>  };
>  
> +#define PMCRAID_TIMESTAMP_LEN		12
> +#define PMCRAID_REQ_TM_STR_LEN		6
> +#define PMCRAID_SCSI_SET_TIMESTAMP	0xA4
> +#define PMCRAID_SCSI_SERVICE_ACTION	0x0F
> +
> +struct pmcraid_timestamp_data {
> +	__u8 reserved1[4];
> +	__u8 timestamp[PMCRAID_REQ_TM_STR_LEN];		/* current time value */
> +	__u8 reserved2[2];
> +};
> +
>  /* pmcraid_cmd - LLD representation of SCSI command */
>  struct pmcraid_cmd {
>  
> @@ -705,6 +717,9 @@
>  	struct pmcraid_inquiry_data *inq_data;
>  	dma_addr_t  inq_data_baddr;
>  
> +	struct pmcraid_timestamp_data *timestamp_data;
> +	dma_addr_t  timestamp_data_baddr;
> +
>  	/* size of configuration table entry, varies based on the firmware */
>  	u32	config_table_entry_size;
>  
> @@ -791,6 +806,7 @@
>  #define SHUTDOWN_NONE               0x0
>  #define SHUTDOWN_NORMAL             0x1
>  #define SHUTDOWN_ABBREV             0x2
> +	u32 timestamp_error:1; /* indicate set timestamp for out of sync */
>  
>  };
>  
> @@ -1056,10 +1072,10 @@
>  #define PMCRAID_PASSTHROUGH_IOCTL    'F'
>  
>  #define DRV_IOCTL(n, size) \
> -    _IOC(_IOC_READ|_IOC_WRITE, PMCRAID_DRIVER_IOCTL, (n), (size))
> +	_IOC(_IOC_READ|_IOC_WRITE, PMCRAID_DRIVER_IOCTL, (n), (size))
>  
>  #define FMW_IOCTL(n, size) \
> -    _IOC(_IOC_READ|_IOC_WRITE, PMCRAID_PASSTHROUGH_IOCTL,  (n), (size))
> +	_IOC(_IOC_READ|_IOC_WRITE, PMCRAID_PASSTHROUGH_IOCTL,  (n), (size))
>  
>  /*
>   * _ARGSIZE: macro that gives size of the argument type passed to an IOCTL cmd.
> --- scsi-misc-2.6.orig/drivers/scsi/pmcraid.c	2010-10-13 14:36:56.000000000 -0700
> +++ scsi-misc-2.6/drivers/scsi/pmcraid.c	2010-10-13 15:00:46.000000000 -0700
> @@ -1594,10 +1594,12 @@
>  	cfg_entry = &ccn_hcam->cfg_entry;
>  	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
>  
> -	pmcraid_info
> -		("CCN(%x): %x type: %x lost: %x flags: %x res: %x:%x:%x:%x\n",
> +	pmcraid_info("CCN(%x): %x timestamp: %llx type: %x lost: %x flags: %x \
> +		 res: %x:%x:%x:%x\n",
>  		 pinstance->ccn.hcam->ilid,
>  		 pinstance->ccn.hcam->op_code,
> +		((pinstance->ccn.hcam->timestamp1) |
> +		((pinstance->ccn.hcam->timestamp2 & 0xffffffffLL) << 32)),
>  		 pinstance->ccn.hcam->notification_type,
>  		 pinstance->ccn.hcam->notification_lost,
>  		 pinstance->ccn.hcam->flags,
> @@ -1850,6 +1852,7 @@
>   *   none
>   */
>  static void pmcraid_initiate_reset(struct pmcraid_instance *);
> +static void pmcraid_set_timestamp(struct pmcraid_cmd *cmd);
>  
>  static void pmcraid_process_ldn(struct pmcraid_cmd *cmd)
>  {
> @@ -1881,6 +1884,10 @@
>  					       lock_flags);
>  			return;
>  		}
> +		if (fd_ioasc == PMCRAID_IOASC_TIME_STAMP_OUT_OF_SYNC) {
> +			pinstance->timestamp_error = 1;
> +			pmcraid_set_timestamp(cmd);
> +		}
>  	} else {
>  		dev_info(&pinstance->pdev->dev,
>  			"Host RCB(LDN) failed with IOASC: 0x%08X\n", ioasc);
> @@ -3363,7 +3370,7 @@
>  	sg_size = buflen;
>  
>  	for (i = 0; i < num_elem; i++) {
> -		page = alloc_pages(GFP_KERNEL|GFP_DMA, order);
> +		page = alloc_pages(GFP_KERNEL|GFP_DMA|__GFP_ZERO, order);
>  		if (!page) {
>  			for (j = i - 1; j >= 0; j--)
>  				__free_pages(sg_page(&scatterlist[j]), order);
> @@ -3739,6 +3746,7 @@
>  	unsigned long request_buffer;
>  	unsigned long request_offset;
>  	unsigned long lock_flags;
> +	void *ioasa;
>  	u32 ioasc;
>  	int request_size;
>  	int buffer_size;
> @@ -3780,6 +3788,11 @@
>  	rc = __copy_from_user(buffer,
>  			     (struct pmcraid_passthrough_ioctl_buffer *) arg,
>  			     sizeof(struct pmcraid_passthrough_ioctl_buffer));
> +
> +	ioasa =
> +	(void *)(arg +
> +		offsetof(struct pmcraid_passthrough_ioctl_buffer, ioasa));
> +
>  	if (rc) {
>  		pmcraid_err("ioctl: can't copy passthrough buffer\n");
>  		rc = -EFAULT;
> @@ -3947,22 +3960,14 @@
>  	}
>  
>  out_handle_response:
> -	/* If the command failed for any reason, copy entire IOASA buffer and
> -	 * return IOCTL success. If copying IOASA to user-buffer fails, return
> +	/* copy entire IOASA buffer and return IOCTL success.
> +	 * If copying IOASA to user-buffer fails, return
>  	 * EFAULT
>  	 */
> -	if (PMCRAID_IOASC_SENSE_KEY(le32_to_cpu(cmd->ioa_cb->ioasa.ioasc))) {
> -		void *ioasa =
> -		    (void *)(arg +
> -		    offsetof(struct pmcraid_passthrough_ioctl_buffer, ioasa));
> -
> -		pmcraid_info("command failed with %x\n",
> -			     le32_to_cpu(cmd->ioa_cb->ioasa.ioasc));
> -		if (copy_to_user(ioasa, &cmd->ioa_cb->ioasa,
> -				 sizeof(struct pmcraid_ioasa))) {
> -			pmcraid_err("failed to copy ioasa buffer to user\n");
> -			rc = -EFAULT;
> -		}
> +	if (copy_to_user(ioasa, &cmd->ioa_cb->ioasa,
> +		sizeof(struct pmcraid_ioasa))) {
> +		pmcraid_err("failed to copy ioasa buffer to user\n");
> +		rc = -EFAULT;
>  	}
>  
>  	/* If the data transfer was from device, copy the data onto user
> @@ -5146,6 +5151,16 @@
>  		pinstance->inq_data = NULL;
>  		pinstance->inq_data_baddr = 0;
>  	}
> +
> +	if (pinstance->timestamp_data != NULL) {
> +		pci_free_consistent(pinstance->pdev,
> +				    sizeof(struct pmcraid_timestamp_data),
> +				    pinstance->timestamp_data,
> +				    pinstance->timestamp_data_baddr);
> +
> +		pinstance->timestamp_data = NULL;
> +		pinstance->timestamp_data_baddr = 0;
> +	}
>  }
>  
>  /**
> @@ -5204,6 +5219,20 @@
>  		return -ENOMEM;
>  	}
>  
> +	/* allocate DMAable memory for set timestamp data buffer */
> +	pinstance->timestamp_data = pci_alloc_consistent(
> +					pinstance->pdev,
> +					sizeof(struct pmcraid_timestamp_data),
> +					&pinstance->timestamp_data_baddr);
> +
> +	if (pinstance->timestamp_data == NULL) {
> +		pmcraid_err("couldn't allocate DMA memory for \
> +				set time_stamp \n");
> +		pmcraid_release_buffers(pinstance);
> +		return -ENOMEM;
> +	}
> +
> +
>  	/* Initialize all the command blocks and add them to free pool. No
>  	 * need to lock (free_pool_lock) as this is done in initialization
>  	 * itself
> @@ -5609,6 +5638,68 @@
>  }
>  
>  /**
> + * pmcraid_set_timestamp - set the timestamp to IOAFP
> + *
> + * @cmd: pointer to pmcraid_cmd structure
> + *
> + * Return Value
> + *  0 for success or non-zero for failure cases
> + */
> +static void pmcraid_set_timestamp(struct pmcraid_cmd *cmd)
> +{
> +	struct pmcraid_instance *pinstance = cmd->drv_inst;
> +	struct pmcraid_ioarcb *ioarcb = &cmd->ioa_cb->ioarcb;
> +	__be32 time_stamp_len = cpu_to_be32(PMCRAID_TIMESTAMP_LEN);
> +	struct pmcraid_ioadl_desc *ioadl = ioarcb->add_data.u.ioadl;
> +
> +	struct timeval tv;
> +	__le64 timestamp;
> +
> +	do_gettimeofday(&tv);
> +	timestamp = tv.tv_sec * 1000;
> +
> +	pinstance->timestamp_data->timestamp[0] = (__u8)(timestamp);
> +	pinstance->timestamp_data->timestamp[1] = (__u8)((timestamp) >> 8);
> +	pinstance->timestamp_data->timestamp[2] = (__u8)((timestamp) >> 16);
> +	pinstance->timestamp_data->timestamp[3] = (__u8)((timestamp) >> 24);
> +	pinstance->timestamp_data->timestamp[4] = (__u8)((timestamp) >> 32);
> +	pinstance->timestamp_data->timestamp[5] = (__u8)((timestamp)  >> 40);
> +
> +	pmcraid_reinit_cmdblk(cmd);
> +	ioarcb->request_type = REQ_TYPE_SCSI;
> +	ioarcb->resource_handle = cpu_to_le32(PMCRAID_IOA_RES_HANDLE);
> +	ioarcb->cdb[0] = PMCRAID_SCSI_SET_TIMESTAMP;
> +	ioarcb->cdb[1] = PMCRAID_SCSI_SERVICE_ACTION;
> +	memcpy(&(ioarcb->cdb[6]), &time_stamp_len, sizeof(time_stamp_len));
> +
> +	ioarcb->ioadl_bus_addr = cpu_to_le64((cmd->ioa_cb_bus_addr) +
> +					offsetof(struct pmcraid_ioarcb,
> +						add_data.u.ioadl[0]));
> +	ioarcb->ioadl_length = cpu_to_le32(sizeof(struct pmcraid_ioadl_desc));
> +	ioarcb->ioarcb_bus_addr &= ~(0x1FULL);
> +
> +	ioarcb->request_flags0 |= NO_LINK_DESCS;
> +	ioarcb->request_flags0 |= TRANSFER_DIR_WRITE;
> +	ioarcb->data_transfer_length =
> +		cpu_to_le32(sizeof(struct pmcraid_timestamp_data));
> +	ioadl = &(ioarcb->add_data.u.ioadl[0]);
> +	ioadl->flags = IOADL_FLAGS_LAST_DESC;
> +	ioadl->address = cpu_to_le64(pinstance->timestamp_data_baddr);
> +	ioadl->data_len = cpu_to_le32(sizeof(struct pmcraid_timestamp_data));
> +
> +	if (!pinstance->timestamp_error) {
> +		pinstance->timestamp_error = 0;
> +		pmcraid_send_cmd(cmd, pmcraid_set_supported_devs,
> +			 PMCRAID_INTERNAL_TIMEOUT, pmcraid_timeout_handler);
> +	} else {
> +		pmcraid_send_cmd(cmd, pmcraid_return_cmd,
> +			 PMCRAID_INTERNAL_TIMEOUT, pmcraid_timeout_handler);
> +		return;
> +	}
> +}
> +
> +
> +/**
>   * pmcraid_init_res_table - Initialize the resource table
>   * @cmd:  pointer to pmcraid command struct
>   *
> @@ -5719,7 +5810,7 @@
>  
>  	/* release the resource list lock */
>  	spin_unlock_irqrestore(&pinstance->resource_lock, lock_flags);
> -	pmcraid_set_supported_devs(cmd);
> +	pmcraid_set_timestamp(cmd);
>  }
>  
>  /**
> @@ -6053,10 +6144,10 @@
>  static void __exit pmcraid_exit(void)
>  {
>  	pmcraid_netlink_release();
> -	class_destroy(pmcraid_class);
>  	unregister_chrdev_region(MKDEV(pmcraid_major, 0),
>  				 PMCRAID_MAX_ADAPTERS);
>  	pci_unregister_driver(&pmcraid_driver);
> +	class_destroy(pmcraid_class);
>  }
>  
>  module_init(pmcraid_init);
> 
