From: Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [Pv-drivers] [PATCH] VMW_PVSCSI: Try setting host->max_id as suggested by the device.
Date: Wed, 07 Mar 2012 09:57:40 -0800
Message-ID: <1411420.EBvOk1Fz7O@dtor-d630.eng.vmware.com>
References: <1331118587.3170.39.camel@arvind-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:59295 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757048Ab2CGR5m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Mar 2012 12:57:42 -0500
In-Reply-To: <1331118587.3170.39.camel@arvind-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pv-drivers@vmware.com
Cc: Arvind Kumar <arvindkumar@vmware.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com

On Wednesday, March 07, 2012 04:39:47 PM Arvind Kumar wrote:
> Try setting host->max_id as suggested by the device.
> 
> Fetch the config page from the device to learn max target id to set
> host->max_id.
> 
> Also, fix some indentation issues and update the 'Maintained by' field.
> 
> From: Arvind Kumar <arvindkumar@vmware.com>
> 
> Signed-off-by: Arvind Kumar <arvindkumar@vmware.com>
> Cc: Alok N Kataria <akataria@vmware.com>
> ---
>  drivers/scsi/vmw_pvscsi.c |   65 +++++++++++++++++++++++++++-
>  drivers/scsi/vmw_pvscsi.h |  107
> +++++++++++++++++++++++++++++++++++---------- 2 files changed, 148
> insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index 7264116..92c941f 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -17,7 +17,7 @@
>   * along with this program; if not, write to the Free Software
>   * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
> USA. *
> - * Maintained by: Alok N Kataria <akataria@vmware.com>
> + * Maintained by: Arvind Kumar <arvindkumar@vmware.com>
>   *
>   */
> 
> @@ -1178,6 +1178,63 @@ static int __devinit pvscsi_allocate_sg(struct
> pvscsi_adapter *adapter) return 0;
>  }
> 
> +/*
> + * Query the device, fetch the config info and return the
> + * maximum number of targets on the adapter. In case of
> + * failure due to any reason return default i.e. 16.
> + */
> +static u32 pvscsi_get_max_targets(struct pvscsi_adapter *adapter)
> +{
> +	struct PVSCSICmdDescConfigCmd cmd;
> +	struct PVSCSIConfigPageHeader *header;
> +	dma_addr_t configPagePA;
> +	void *config_page;
> +	u32 numPhys;
> +
> +	numPhys = 16;

Just do

	u32 numPhys = 16;

> +	config_page = pci_alloc_consistent(adapter->dev, PAGE_SIZE,
> +					   &configPagePA);
> +	if (!config_page) {
> +		printk(KERN_INFO "vmw_pvscsi: failed to allocate memory for"
> +		       " config page\n");

This should be dev_warn() (or maybe dev_dbg() if we expect this to fail) and
the string should not be split (it is OK to run over 80 columns limit for
messges).

> +		goto exit;
> +	}
> +	BUG_ON(configPagePA & ~PAGE_MASK);
> +
> +	/* Fetch config info from the device. */
> +	cmd.configPageAddress = (((u64)(PVSCSI_CONFIG_CONTROLLER_ADDRESS))
> +				 << 32);

Too many parens...

> +	cmd.configPageNum = PVSCSI_CONFIG_PAGE_CONTROLLER;
> +	cmd.cmpAddr = configPagePA;
> +	cmd._pad = 0;
> +
> +	/*
> +	 * Mark the completion page header with error values. If the device
> +	 * completes the command successfully, it sets the status values to
> +	 * indicate success.
> +	 */
> +	header = config_page;
> +	memset(header, 0, sizeof *header);
> +	header->hostStatus = BTSTAT_INVPARAM;
> +	header->scsiStatus = SDSTAT_CHECK;
> +
> +	pvscsi_write_cmd_desc(adapter, PVSCSI_CMD_CONFIG, &cmd, sizeof cmd);
> +
> +	if (header->hostStatus == BTSTAT_SUCCESS &&
> +	    header->scsiStatus == SDSTAT_GOOD) {
> +		struct PVSCSIConfigPageController *config;
> +
> +		config = config_page;
> +		numPhys = config->numPhys;
> +	} else
> +		printk(KERN_INFO "vmw_pvscsi: PVSCSI_CMD_CONFIG failed."
> +		       " hostStatus = 0x%x, scsiStatus = 0x%x\n",
> +		       header->hostStatus, header->scsiStatus);

dev_warn() or dev_dbg() here as well.

> +	pci_free_consistent(adapter->dev, PAGE_SIZE, config_page, configPagePA);
> +exit:
> +	return numPhys;
> +}
> +
>  static int __devinit pvscsi_probe(struct pci_dev *pdev,
>  				  const struct pci_device_id *id)
>  {
> @@ -1272,6 +1329,12 @@ static int __devinit pvscsi_probe(struct pci_dev
> *pdev, }
> 
>  	/*
> +	 * Ask the device for max number of targets.
> +	 */
> +	host->max_id = pvscsi_get_max_targets(adapter);
> +	printk(KERN_INFO "vmw_pvscsi: host->max_id: %u\n", host->max_id);
> +

dev_dbg()? Or dev_info().

Thanks.

-- 
Dmitry
