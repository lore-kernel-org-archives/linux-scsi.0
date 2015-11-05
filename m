From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 20/27] hpsa: generalize external arrays
Date: Thu, 5 Nov 2015 10:23:33 -0600
Message-ID: <9FDA9021-7F35-44B6-B3CA-04604EA89D31@linux.vnet.ibm.com>
References: <20151104214910.15472.23179.stgit@brunhilda> <20151104215157.15472.13416.stgit@brunhilda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:50191 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161670AbbKEQXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 11:23:48 -0500
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 5 Nov 2015 11:23:47 -0500
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 75A416E8045
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2015 11:11:54 -0500 (EST)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA5GNhtC57081986
	for <linux-scsi@vger.kernel.org>; Thu, 5 Nov 2015 16:23:43 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA5GMJbW021153
	for <linux-scsi@vger.kernel.org>; Thu, 5 Nov 2015 11:22:23 -0500
In-Reply-To: <20151104215157.15472.13416.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

> On Nov 4, 2015, at 3:51 PM, Don Brace <don.brace@pmcs.com> wrote:
> 
> From: Scott Teel <scott.teel@pmcs.com>
> 
> External array LUNs must use target and lun numbers assigned by the
> external array. So the driver must treat these differently from
> local LUNs when assigning lun/target.
> 
> LUN's 'model' field has been used to detect Lun types that need
> special treatment, but the desire is to eliminate the need to reference
> specific array models, and support any external array.
> 
> Pass-through RAID (PTRAID) luns are not luns of the local controller,
> so they are not reported in LUN count of command 'ID controller'.
> However, they ARE reported in "Report logical Luns" command.
> Local luns are listed first, then PTRAID LUNs.
> 
> The number of luns from "Report LUNs" in excess of those reported by
> 'ID controller' are therefore the PTRAID LUNS.
> 
> We can now remove function is_ext_target, and the 'white list'
> array of supported model names.
> 
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
> drivers/scsi/hpsa.c     |  139 ++++++++++++++++++++++++++++++++++++++---------
> drivers/scsi/hpsa.h     |    1 
> drivers/scsi/hpsa_cmd.h |   11 ++++
> 3 files changed, 125 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 0af4c67..1a67d63 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -275,7 +275,6 @@ static int hpsa_scsi_ioaccel_queue_command(struct ctlr_info *h,
> static void hpsa_command_resubmit_worker(struct work_struct *work);
> static u32 lockup_detected(struct ctlr_info *h);
> static int detect_controller_lockup(struct ctlr_info *h);
> -static int is_ext_target(struct ctlr_info *h, struct hpsa_scsi_dev_t *device);
> 
> static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
> {
> @@ -776,7 +775,7 @@ static ssize_t path_info_show(struct device *dev,
> 				hdev->bus, hdev->target, hdev->lun,
> 				scsi_device_type(hdev->devtype));
> 
> -		if (is_ext_target(h, hdev) ||
> +		if (hdev->external ||
> 			hdev->devtype == TYPE_RAID ||
> 			is_logical_device(hdev)) {
> 			output_len += snprintf(path[i] + output_len,
> @@ -3034,6 +3033,35 @@ out:
> 	return rc;
> }
> 
> +static int hpsa_bmic_id_controller(struct ctlr_info *h,
> +	struct bmic_identify_controller *buf, size_t bufsize)
> +{
> +	int rc = IO_OK;
> +	struct CommandList *c;
> +	struct ErrorInfo *ei;
> +
> +	c = cmd_alloc(h);
> +
> +	rc = fill_cmd(c, BMIC_IDENTIFY_CONTROLLER, h, buf, bufsize,
> +		0, RAID_CTLR_LUNID, TYPE_CMD);
> +	if (rc)
> +		goto out;
> +
> +	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
> +		PCI_DMA_FROMDEVICE, NO_TIMEOUT);
> +	if (rc)
> +		goto out;
> +	ei = c->err_info;
> +	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
> +		hpsa_scsi_interpret_error(h, c);
> +		rc = -1;
> +	}
> +out:
> +	cmd_free(h, c);
> +	return rc;
> +}
> +
> +
> static int hpsa_bmic_id_physical_device(struct ctlr_info *h,
> 		unsigned char scsi3addr[], u16 bmic_device_index,
> 		struct bmic_identify_physical_device *buf, size_t bufsize)
> @@ -3510,27 +3538,6 @@ static void hpsa_update_device_supports_aborts(struct ctlr_info *h,
> 	}
> }
> 
> -static unsigned char *ext_target_model[] = {
> -	"MSA2012",
> -	"MSA2024",
> -	"MSA2312",
> -	"MSA2324",
> -	"P2000 G3 SAS",
> -	"MSA 2040 SAS",
> -	NULL,
> -};
> -
> -static int is_ext_target(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
> -{
> -	int i;
> -
> -	for (i = 0; ext_target_model[i]; i++)
> -		if (strncmp(device->model, ext_target_model[i],
> -			strlen(ext_target_model[i])) == 0)
> -			return 1;
> -	return 0;
> -}
> -
> /*
>  * Helper function to assign bus, target, lun mapping of devices.
>  * Logical drive target and lun are assigned at this time, but
> @@ -3554,7 +3561,7 @@ static void figure_bus_target_lun(struct ctlr_info *h,
> 		return;
> 	}
> 	/* It's a logical device */
> -	if (is_ext_target(h, device)) {
> +	if (device->external) {
> 		hpsa_set_bus_target_lun(device,
> 			HPSA_EXTERNAL_RAID_VOLUME_BUS, (lunid >> 16) & 0x3fff,
> 			lunid & 0x00ff);
> @@ -3588,7 +3595,7 @@ static int add_ext_target_dev(struct ctlr_info *h,
> 	if (!is_logical_dev_addr_mode(lunaddrbytes))
> 		return 0; /* It's the logical targets that may lack lun 0. */
> 
> -	if (!is_ext_target(h, tmpdevice))
> +	if (!tmpdevice->external)
> 		return 0; /* Only external target devices have this problem. */
> 
> 	if (tmpdevice->lun == 0) /* if lun is 0, then we have a lun 0. */
> @@ -3647,6 +3654,27 @@ static int hpsa_get_pdisk_of_ioaccel2(struct ctlr_info *h,
> 	return 0;
> }
> 
> +static int  figure_external_status(struct ctlr_info *h, int raid_ctlr_position,
> +	int i, int nphysicals, int nlocal_logicals)
> +{
> +	/* In report logicals, local logicals are listed first,
> +	* then any externals.
> +	*/
> +	int logicals_start = nphysicals + (raid_ctlr_position == 0);
> +
> +	if (i == raid_ctlr_position)
> +		return 0;
> +
> +	if (i < logicals_start)
> +		return 0;
> +
> +	/* i is in logicals range, but still within local logicals */
> +	if ((i - nphysicals - (raid_ctlr_position == 0)) < nlocal_logicals)
> +		return 0;
> +
> +	return 1; /* it's an external lun */
> +}
> +
> /*
>  * Do CISS_REPORT_PHYS and CISS_REPORT_LOG.  Data is returned in physdev,
>  * logdev.  The number of luns in physdev and logdev are returned in
> @@ -3770,6 +3798,32 @@ static void hpsa_get_path_info(struct hpsa_scsi_dev_t *this_device,
> 		sizeof(this_device->bay));
> }
> 
> +/* get number of local logical disks. */
> +static int hpsa_set_local_logical_count(struct ctlr_info *h,
> +	struct bmic_identify_controller *id_ctlr,
> +	u32 *nlocals)
> +{
> +	int rc;
> +
> +	if (!id_ctlr) {
> +		dev_warn(&h->pdev->dev, "%s: id_ctlr buffer is NULL.\n",
> +			__func__);
> +		return -ENOMEM;
> +	}
> +	memset(id_ctlr, 0, sizeof(*id_ctlr));
> +	rc = hpsa_bmic_id_controller(h, id_ctlr, sizeof(*id_ctlr));
> +	if (!rc)
> +		if (id_ctlr->configured_logical_drive_count < 256)
> +			*nlocals = id_ctlr->configured_logical_drive_count;
> +		else
> +			*nlocals = le16_to_cpu(
> +					id_ctlr->extended_logical_unit_count);
> +	else
> +		*nlocals = -1;
> +	return rc;
> +}
> +
> +
> static void hpsa_update_scsi_devices(struct ctlr_info *h)
> {
> 	/* the idea here is we could get notified
> @@ -3785,8 +3839,10 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
> 	struct ReportExtendedLUNdata *physdev_list = NULL;
> 	struct ReportLUNdata *logdev_list = NULL;
> 	struct bmic_identify_physical_device *id_phys = NULL;
> +	struct bmic_identify_controller *id_ctlr = NULL;
> 	u32 nphysicals = 0;
> 	u32 nlogicals = 0;
> +	u32 nlocal_logicals = 0;
> 	u32 ndev_allocated = 0;
> 	struct hpsa_scsi_dev_t **currentsd, *this_device, *tmpdevice;
> 	int ncurrent = 0;
> @@ -3800,9 +3856,10 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
> 	logdev_list = kzalloc(sizeof(*logdev_list), GFP_KERNEL);
> 	tmpdevice = kzalloc(sizeof(*tmpdevice), GFP_KERNEL);
> 	id_phys = kzalloc(sizeof(*id_phys), GFP_KERNEL);
> +	id_ctlr = kzalloc(sizeof(*id_ctlr), GFP_KERNEL);
> 
> 	if (!currentsd || !physdev_list || !logdev_list ||
> -		!tmpdevice || !id_phys) {
> +		!tmpdevice || !id_phys || !id_ctlr) {
> 		dev_err(&h->pdev->dev, "out of memory\n");
> 		goto out;
> 	}
> @@ -3816,6 +3873,13 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
> 		goto out;
> 	}
> 
> +	/* Set number of local logicals (non PTRAID) */
> +	if (hpsa_set_local_logical_count(h, id_ctlr, &nlocal_logicals)) {
> +		dev_warn(&h->pdev->dev,
> +			"%s: Can't determine number of local logical devices.\n",
> +			__func__);
> +	}
> +
> 	/* We might see up to the maximum number of logical and physical disks
> 	 * plus external target devices, and a device for the local RAID
> 	 * controller.
> @@ -3879,6 +3943,11 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
> 			continue;
> 		}
> 
> +		/* Determine if this is a lun from an external target array */
> +		tmpdevice->external =
> +			figure_external_status(h, raid_ctlr_position, i,
> +						nphysicals, nlocal_logicals);
> +
> 		figure_bus_target_lun(h, lunaddrbytes, tmpdevice);
> 		hpsa_update_device_supports_aborts(h, tmpdevice, lunaddrbytes);
> 		this_device = currentsd[ncurrent];
> @@ -3962,6 +4031,7 @@ out:
> 	kfree(currentsd);
> 	kfree(physdev_list);
> 	kfree(logdev_list);
> +	kfree(id_ctlr);
> 	kfree(id_phys);
> }
> 
> @@ -6414,6 +6484,23 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
> 			c->Request.CDB[7] = (size >> 16) & 0xFF;
> 			c->Request.CDB[8] = (size >> 8) & 0XFF;
> 			break;
> +		case BMIC_IDENTIFY_CONTROLLER:
> +			c->Request.CDBLen = 10;
> +			c->Request.type_attr_dir =
> +				TYPE_ATTR_DIR(cmd_type, ATTR_SIMPLE, XFER_READ);
> +			c->Request.Timeout = 0;
> +			c->Request.CDB[0] = BMIC_READ;
> +			c->Request.CDB[1] = 0;
> +			c->Request.CDB[2] = 0;
> +			c->Request.CDB[3] = 0;
> +			c->Request.CDB[4] = 0;
> +			c->Request.CDB[5] = 0;
> +			c->Request.CDB[6] = BMIC_IDENTIFY_CONTROLLER;
> +			c->Request.CDB[7] = (size >> 16) & 0xFF;
> +			c->Request.CDB[8] = (size >> 8) & 0XFF;
> +			c->Request.CDB[9] = 0;
> +			break;
> +

For consistency with the other fill_cmd() cases these unnecessary zeroing statements
should be removed, either now or at some point in the future.

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

> 		default:
> 			dev_warn(&h->pdev->dev, "unknown command 0x%c\n", cmd);
> 			BUG();
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index a4cab12..ffcd4cb 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -77,6 +77,7 @@ struct hpsa_scsi_dev_t {
> 	struct hpsa_scsi_dev_t *phys_disk[RAID_MAP_MAX_ENTRIES];
> 	int nphysical_disks;
> 	int supports_aborts;
> +	int external;   /* 1-from external array 0-not <0-unknown */
> };
> 
> struct reply_queue_buffer {
> diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
> index c2c0737..c83eaf1 100644
> --- a/drivers/scsi/hpsa_cmd.h
> +++ b/drivers/scsi/hpsa_cmd.h
> @@ -286,6 +286,7 @@ struct SenseSubsystem_info {
> #define BMIC_FLASH_FIRMWARE 0xF7
> #define BMIC_SENSE_CONTROLLER_PARAMETERS 0x64
> #define BMIC_IDENTIFY_PHYSICAL_DEVICE 0x15
> +#define BMIC_IDENTIFY_CONTROLLER 0x11
> 
> /* Command List Structure */
> union SCSI3Addr {
> @@ -682,6 +683,16 @@ struct hpsa_pci_info {
> 	u32		board_id;
> };
> 
> +struct bmic_identify_controller {
> +	u8	configured_logical_drive_count;	/* offset 0 */
> +	u8	pad1[153];
> +	__le16	extended_logical_unit_count;	/* offset 154 */
> +	u8	pad2[136];
> +	u8	controller_mode;	/* offset 292 */
> +	u8	pad3[32];
> +};
> +
> +
> struct bmic_identify_physical_device {
> 	u8    scsi_bus;          /* SCSI Bus number on controller */
> 	u8    scsi_id;           /* SCSI ID on this bus */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

