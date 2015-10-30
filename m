From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1 24/25] hpsa: add in sas transport class
Date: Fri, 30 Oct 2015 15:07:18 -0500
Message-ID: <04D5BEB2-DCD8-49C7-8BA7-24FD162E5729@linux.vnet.ibm.com>
References: <20151028215206.5323.84194.stgit@brunhilda> <20151028220656.5323.34704.stgit@brunhilda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:58790 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759546AbbJ3UHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 16:07:25 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 30 Oct 2015 14:07:24 -0600
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 10A436E8040
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 15:55:33 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9UK7LcR65273994
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 20:07:21 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9UK7KPg028693
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 16:07:21 -0400
In-Reply-To: <20151028220656.5323.34704.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org


> On Oct 28, 2015, at 5:06 PM, Don Brace <don.brace@pmcs.com> wrote:
> 
> From: Kevin Barnett <kevin.barnett@pmcs.com>
> 
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
> drivers/scsi/hpsa.c     |  535 +++++++++++++++++++++++++++++++++++++++++++++--
> drivers/scsi/hpsa.h     |   27 ++
> drivers/scsi/hpsa_cmd.h |   14 +
> 3 files changed, 555 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 56526312..ca38a00 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -41,6 +41,7 @@
> #include <scsi/scsi_host.h>
> #include <scsi/scsi_tcq.h>
> #include <scsi/scsi_eh.h>
> +#include <scsi/scsi_transport_sas.h>
> #include <scsi/scsi_dbg.h>
> #include <linux/cciss_ioctl.h>
> #include <linux/string.h>
> @@ -205,6 +206,16 @@ static struct board_type products[] = {
> 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
> };
> 
> +static struct scsi_transport_template *hpsa_sas_transport_template;
> +static int hpsa_add_sas_host(struct ctlr_info *h);
> +static void hpsa_delete_sas_host(struct ctlr_info *h);
> +static int hpsa_add_sas_device(struct hpsa_sas_node *hpsa_sas_node,
> +			struct hpsa_scsi_dev_t *device);
> +static void hpsa_remove_sas_device(struct hpsa_scsi_dev_t *device);
> +static struct hpsa_scsi_dev_t
> +	*hpsa_find_device_by_sas_rphy(struct ctlr_info *h,
> +		struct sas_rphy *rphy);
> +
> #define SCSI_CMD_BUSY ((struct scsi_cmnd *)&hpsa_cmd_busy)
> static const struct scsi_cmnd hpsa_cmd_busy;
> #define SCSI_CMD_IDLE ((struct scsi_cmnd *)&hpsa_cmd_idle)
> @@ -277,6 +288,8 @@ static void hpsa_command_resubmit_worker(struct work_struct *work);
> static u32 lockup_detected(struct ctlr_info *h);
> static int detect_controller_lockup(struct ctlr_info *h);
> static void hpsa_disable_rld_caching(struct ctlr_info *h);
> +static inline int hpsa_scsi_do_report_phys_luns(struct ctlr_info *h,
> +	struct ReportExtendedLUNdata *buf, int bufsize);
> static int hpsa_luns_changed(struct ctlr_info *h);
> 
> static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
> @@ -1696,8 +1709,12 @@ static int hpsa_add_device(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
> {
> 	int rc = 0;
> 
> -	rc = scsi_add_device(h->scsi_host, device->bus,
> +	if (is_logical_device(device)) /* RAID */
> +		rc = scsi_add_device(h->scsi_host, device->bus,
> 					device->target, device->lun);
> +	else /* HBA */
> +		rc = hpsa_add_sas_device(h->sas_host, device);
> +
> 	return rc;
> }
> 
> @@ -1706,21 +1723,23 @@ static void hpsa_remove_device(struct ctlr_info *h,
> {
> 	struct scsi_device *sdev = NULL;
> 
> -	sdev = scsi_device_lookup(h->scsi_host, device->bus,
> +	if (is_logical_device(device)) { /* RAID */
> +		sdev = scsi_device_lookup(h->scsi_host, device->bus,
> 						device->target, device->lun);
> -
> -	if (sdev) {
> -		scsi_remove_device(sdev);
> -		scsi_device_put(sdev);
> -	} else {
> -		/*
> -		 * We don't expect to get here.  Future commands
> -		 * to this device will get a selection timeout as
> -		 * if the device were gone.
> -		 */
> -		hpsa_show_dev_msg(KERN_WARNING, h, device,
> +		if (sdev) {
> +			scsi_remove_device(sdev);
> +			scsi_device_put(sdev);
> +		} else {
> +			/*
> +			 * We don't expect to get here.  Future commands
> +			 * to this device will get a selection timeout as
> +			 * if the device were gone.
> +			 */
> +			hpsa_show_dev_msg(KERN_WARNING, h, device,
> 					"didn't find device for removal.");
> -	}
> +		}
> +	} else /* HBA */
> +		hpsa_remove_sas_device(device);
> }
> 
> static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
> @@ -1915,11 +1934,24 @@ static int hpsa_slave_alloc(struct scsi_device *sdev)
> 
> 	h = sdev_to_hba(sdev);
> 	spin_lock_irqsave(&h->devlock, flags);
> -	sd = lookup_hpsa_scsi_dev(h, sdev_channel(sdev),
> -		sdev_id(sdev), sdev->lun);
> -	if (likely(sd)) {
> +	if (sdev_channel(sdev) == HPSA_PHYSICAL_DEVICE_BUS) {
> +		struct scsi_target *starget;
> +		struct sas_rphy *rphy;
> +
> +		starget = scsi_target(sdev);
> +		rphy = target_to_rphy(starget);
> +		sd = hpsa_find_device_by_sas_rphy(h, rphy);
> +		if (sd) {
> +			sd->target = sdev_id(sdev);
> +			sd->lun = sdev->lun;
> +		}
> +	} else
> +		sd = lookup_hpsa_scsi_dev(h, sdev_channel(sdev),
> +					sdev_id(sdev), sdev->lun);
> +
> +	if (sd && sd->expose_device) {
> 		atomic_set(&sd->ioaccel_cmds_out, 0);
> -		sdev->hostdata = sd->expose_device ? sd : NULL;
> +		sdev->hostdata = sd;
> 	} else
> 		sdev->hostdata = NULL;
> 	spin_unlock_irqrestore(&h->devlock, flags);
> @@ -3069,6 +3101,38 @@ out:
> 	return rc;
> }
> 
> +static int hpsa_bmic_sense_subsystem_information(struct ctlr_info *h,
> +		unsigned char scsi3addr[], u16 bmic_device_index,
> +		struct bmic_sense_subsystem_info *buf, size_t bufsize)
> +{
> +	int rc = IO_OK;
> +	struct CommandList *c;
> +	struct ErrorInfo *ei;
> +
> +	c = cmd_alloc(h);
> +
> +	rc = fill_cmd(c, BMIC_SENSE_SUBSYSTEM_INFORMATION, h, buf, bufsize,
> +		0, RAID_CTLR_LUNID, TYPE_CMD);
> +	if (rc)
> +		goto out;
> +
> +	c->Request.CDB[2] = bmic_device_index & 0xff;
> +	c->Request.CDB[9] = (bmic_device_index >> 8) & 0xff;
> +
> +	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
> +				PCI_DMA_FROMDEVICE, NO_TIMEOUT);
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
> static int hpsa_bmic_id_controller(struct ctlr_info *h,
> 	struct bmic_identify_controller *buf, size_t bufsize)
> {
> @@ -3097,7 +3161,6 @@ out:
> 	return rc;
> }
> 
> -
> static int hpsa_bmic_id_physical_device(struct ctlr_info *h,
> 		unsigned char scsi3addr[], u16 bmic_device_index,
> 		struct bmic_identify_physical_device *buf, size_t bufsize)
> @@ -3124,9 +3187,64 @@ static int hpsa_bmic_id_physical_device(struct ctlr_info *h,
> 	}
> out:
> 	cmd_free(h, c);
> +
> 	return rc;
> }
> 
> +static u64 hpsa_get_sas_address_from_report_physical(struct ctlr_info *h,
> +						unsigned char *scsi3addr)
> +{
> +	struct ReportExtendedLUNdata *physdev;
> +	u32 nphysicals;
> +	u64 sa = 0;
> +	int i;
> +
> +	physdev = kzalloc(sizeof(*physdev), GFP_KERNEL);
> +	if (!physdev)
> +		return 0;
> +
> +	if (hpsa_scsi_do_report_phys_luns(h, physdev, sizeof(*physdev))) {
> +		dev_err(&h->pdev->dev, "report physical LUNs failed.\n");
> +		kfree(physdev);
> +		return 0;
> +	}
> +	nphysicals = get_unaligned_be32(physdev->LUNListLength) / 24;
> +
> +	for (i = 0; i < nphysicals; i++)
> +		if (!memcmp(&physdev->LUN[i].lunid[0], scsi3addr, 8))
> +			sa = get_unaligned_be64(&physdev->LUN[i].wwid[0]);

Don't you want to break out here if you found a match?

> +
> +	kfree(physdev);
> +
> +	return sa;
> +}
> +
> +static void hpsa_get_sas_address(struct ctlr_info *h, unsigned char *scsi3addr,
> +					struct hpsa_scsi_dev_t *dev)
> +{
> +	int rc;
> +	u64 sa = 0;
> +
> +	if (is_hba_lunid(scsi3addr)) {
> +		struct bmic_sense_subsystem_info *ssi;
> +
> +		ssi = kzalloc(sizeof(*ssi), GFP_KERNEL);

What happens if this allocation fails? If the I/O can succeed without the
DMA buffer then you will run into trouble when deriving sa.

> +
> +		rc = hpsa_bmic_sense_subsystem_information(h,
> +					scsi3addr, 0, ssi, sizeof(*ssi));
> +		if (rc == 0) {
> +			sa = get_unaligned_be64(ssi->primary_world_wide_id);
> +			h->sas_address = sa;
> +		}
> +
> +		kfree(ssi);
> +	} else
> +		sa = hpsa_get_sas_address_from_report_physical(h, scsi3addr);
> +
> +	dev->sas_address = sa;
> +}
> +
> +/* Get a device id from inquiry page 0x83 */
> static int hpsa_vpd_page_supported(struct ctlr_info *h,
> 	unsigned char scsi3addr[], u8 page)
> {
> @@ -3961,6 +4079,13 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
> 		else
> 			this_device->expose_device = 1;
> 
> +
> +		/*
> +		 * Get the SAS address for physical devices that are exposed.
> +		 */
> +		if (this_device->physical_device && this_device->expose_device)
> +			hpsa_get_sas_address(h, lunaddrbytes, this_device);
> +
> 		switch (this_device->devtype) {
> 		case TYPE_ROM:
> 			/* We don't *really* support actual CD-ROM devices,
> @@ -4006,6 +4131,10 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
> 		if (ncurrent >= HPSA_MAX_DEVICES)
> 			break;
> 	}
> +
> +	if (h->sas_host == NULL)
> +		hpsa_add_sas_host(h);
> +
> 	adjust_hpsa_scsi_table(h, hostno, currentsd, ncurrent);
> out:
> 	kfree(tmpdevice);
> @@ -5137,6 +5266,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
> 	sh->can_queue = h->nr_cmds - HPSA_NRESERVED_CMDS;
> 	sh->cmd_per_lun = sh->can_queue;
> 	sh->sg_tablesize = h->maxsgentries;
> +	sh->transportt = hpsa_sas_transport_template;
> 	sh->hostdata[0] = (unsigned long) h;
> 	sh->irq = h->intr[h->intr_mode];
> 	sh->unique_id = sh->irq;
> @@ -6485,6 +6615,16 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
> 			c->Request.CDB[7] = (size >> 16) & 0xFF;
> 			c->Request.CDB[8] = (size >> 8) & 0XFF;
> 			break;
> +		case BMIC_SENSE_SUBSYSTEM_INFORMATION:
> +			c->Request.CDBLen = 10;
> +			c->Request.type_attr_dir =
> +				TYPE_ATTR_DIR(cmd_type, ATTR_SIMPLE, XFER_READ);
> +			c->Request.Timeout = 0;
> +			c->Request.CDB[0] = BMIC_READ;
> +			c->Request.CDB[6] = BMIC_SENSE_SUBSYSTEM_INFORMATION;
> +			c->Request.CDB[7] = (size >> 16) & 0xFF;
> +			c->Request.CDB[8] = (size >> 8) & 0XFF;
> +			break;
> 		case BMIC_IDENTIFY_CONTROLLER:
> 			c->Request.CDBLen = 10;
> 			c->Request.type_attr_dir =
> @@ -6501,7 +6641,6 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
> 			c->Request.CDB[8] = (size >> 8) & 0XFF;
> 			c->Request.CDB[9] = 0;
> 			break;
> -
> 		default:
> 			dev_warn(&h->pdev->dev, "unknown command 0x%c\n", cmd);
> 			BUG();
> @@ -8618,6 +8757,9 @@ static void hpsa_remove_one(struct pci_dev *pdev)
> 	free_percpu(h->lockup_detected);		/* init_one 2 */
> 	h->lockup_detected = NULL;			/* init_one 2 */
> 	/* (void) pci_disable_pcie_error_reporting(pdev); */	/* init_one 1 */
> +
> +	hpsa_delete_sas_host(h);
> +
> 	kfree(h);					/* init_one 1 */
> }
> 
> @@ -9080,18 +9222,369 @@ static void hpsa_drain_accel_commands(struct ctlr_info *h)
> 	} while (1);
> }
> 
> +static struct hpsa_sas_phy *hpsa_alloc_sas_phy(
> +				struct hpsa_sas_port *hpsa_sas_port)
> +{
> +	struct hpsa_sas_phy *hpsa_sas_phy;
> +	struct sas_phy *phy;
> +
> +	hpsa_sas_phy = kzalloc(sizeof(*hpsa_sas_phy), GFP_KERNEL);
> +	if (!hpsa_sas_phy)
> +		return NULL;
> +
> +	phy = sas_phy_alloc(hpsa_sas_port->parent_node->parent_dev,
> +		hpsa_sas_port->next_phy_index);
> +	if (!phy) {
> +		kfree(hpsa_sas_phy);
> +		return NULL;
> +	}
> +
> +	hpsa_sas_port->next_phy_index++;
> +	hpsa_sas_phy->phy = phy;
> +	hpsa_sas_phy->parent_port = hpsa_sas_port;
> +
> +	return hpsa_sas_phy;
> +}
> +
> +static void hpsa_free_sas_phy(struct hpsa_sas_phy *hpsa_sas_phy)
> +{
> +	struct sas_phy *phy = hpsa_sas_phy->phy;
> +
> +	sas_port_delete_phy(hpsa_sas_phy->parent_port->port, phy);
> +	sas_phy_free(phy);
> +	if (hpsa_sas_phy->added_to_port)
> +		list_del(&hpsa_sas_phy->phy_list_entry);
> +	kfree(hpsa_sas_phy);
> +}
> +
> +static int hpsa_sas_port_add_phy(struct hpsa_sas_phy *hpsa_sas_phy)
> +{
> +	int rc;
> +	struct hpsa_sas_port *hpsa_sas_port;
> +	struct sas_phy *phy;
> +	struct sas_identify *identify;
> +
> +	hpsa_sas_port = hpsa_sas_phy->parent_port;
> +	phy = hpsa_sas_phy->phy;
> +
> +	identify = &phy->identify;
> +	memset(identify, 0, sizeof(*identify));
> +	identify->sas_address = hpsa_sas_port->sas_address;
> +	identify->device_type = SAS_END_DEVICE;
> +	identify->initiator_port_protocols = SAS_PROTOCOL_STP;
> +	identify->target_port_protocols = SAS_PROTOCOL_STP;
> +	phy->minimum_linkrate_hw = SAS_LINK_RATE_UNKNOWN;
> +	phy->maximum_linkrate_hw = SAS_LINK_RATE_UNKNOWN;
> +	phy->minimum_linkrate = SAS_LINK_RATE_UNKNOWN;
> +	phy->maximum_linkrate = SAS_LINK_RATE_UNKNOWN;
> +	phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
> +
> +	rc = sas_phy_add(hpsa_sas_phy->phy);
> +	if (rc)
> +		return rc;
> +
> +	sas_port_add_phy(hpsa_sas_port->port, hpsa_sas_phy->phy);
> +	list_add_tail(&hpsa_sas_phy->phy_list_entry,
> +			&hpsa_sas_port->phy_list_head);
> +	hpsa_sas_phy->added_to_port = true;
> +
> +	return 0;
> +}
> +
> +static int
> +	hpsa_sas_port_add_rphy(struct hpsa_sas_port *hpsa_sas_port,
> +				struct sas_rphy *rphy)
> +{
> +	struct sas_identify *identify;
> +
> +	identify = &rphy->identify;
> +	identify->sas_address = hpsa_sas_port->sas_address;
> +	identify->initiator_port_protocols = SAS_PROTOCOL_STP;
> +	identify->target_port_protocols = SAS_PROTOCOL_STP;
> +
> +	return sas_rphy_add(rphy);
> +}
> +
> +static struct hpsa_sas_port
> +	*hpsa_alloc_sas_port(struct hpsa_sas_node *hpsa_sas_node,
> +				u64 sas_address)
> +{
> +	int rc;
> +	struct hpsa_sas_port *hpsa_sas_port;
> +	struct sas_port *port;
> +
> +	hpsa_sas_port = kzalloc(sizeof(*hpsa_sas_port), GFP_KERNEL);
> +	if (!hpsa_sas_port)
> +		return NULL;
> +
> +	INIT_LIST_HEAD(&hpsa_sas_port->phy_list_head);
> +	hpsa_sas_port->parent_node = hpsa_sas_node;
> +
> +	port = sas_port_alloc_num(hpsa_sas_node->parent_dev);
> +	if (!port)
> +		goto free_hpsa_port;
> +
> +	rc = sas_port_add(port);
> +	if (rc)
> +		goto free_sas_port;
> +
> +	hpsa_sas_port->port = port;
> +	hpsa_sas_port->sas_address = sas_address;
> +	list_add_tail(&hpsa_sas_port->port_list_entry,
> +			&hpsa_sas_node->port_list_head);
> +
> +	return hpsa_sas_port;
> +
> +free_sas_port:
> +	sas_port_free(port);
> +free_hpsa_port:
> +	kfree(hpsa_sas_port);
> +
> +	return NULL;
> +}
> +
> +static void hpsa_free_sas_port(struct hpsa_sas_port *hpsa_sas_port)
> +{
> +	struct hpsa_sas_phy *hpsa_sas_phy;
> +	struct hpsa_sas_phy *next;
> +
> +	list_for_each_entry_safe(hpsa_sas_phy, next,
> +			&hpsa_sas_port->phy_list_head, phy_list_entry)
> +		hpsa_free_sas_phy(hpsa_sas_phy);
> +
> +	sas_port_delete(hpsa_sas_port->port);
> +	list_del(&hpsa_sas_port->port_list_entry);
> +	kfree(hpsa_sas_port);
> +}
> +
> +static struct hpsa_sas_node *hpsa_alloc_sas_node(struct device *parent_dev)
> +{
> +	struct hpsa_sas_node *hpsa_sas_node;
> +
> +	hpsa_sas_node = kzalloc(sizeof(*hpsa_sas_node), GFP_KERNEL);
> +	if (hpsa_sas_node) {
> +		hpsa_sas_node->parent_dev = parent_dev;
> +		INIT_LIST_HEAD(&hpsa_sas_node->port_list_head);
> +	}
> +
> +	return hpsa_sas_node;
> +}
> +
> +static void hpsa_free_sas_node(struct hpsa_sas_node *hpsa_sas_node)
> +{
> +	struct hpsa_sas_port *hpsa_sas_port;
> +	struct hpsa_sas_port *next;
> +
> +	if (!hpsa_sas_node)
> +		return;
> +
> +	list_for_each_entry_safe(hpsa_sas_port, next,
> +			&hpsa_sas_node->port_list_head, port_list_entry)
> +		hpsa_free_sas_port(hpsa_sas_port);
> +
> +	kfree(hpsa_sas_node);
> +}
> +
> +static struct hpsa_scsi_dev_t
> +	*hpsa_find_device_by_sas_rphy(struct ctlr_info *h,
> +					struct sas_rphy *rphy)
> +{
> +	int i;
> +	struct hpsa_scsi_dev_t *device;
> +
> +	for (i = 0; i < h->ndevices; i++) {
> +		device = h->dev[i];
> +		if (!device->sas_port)
> +			continue;
> +		if (device->sas_port->rphy == rphy)
> +			return device;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int hpsa_add_sas_host(struct ctlr_info *h)
> +{
> +	int rc;
> +	struct device *parent_dev;
> +	struct hpsa_sas_node *hpsa_sas_node;
> +	struct hpsa_sas_port *hpsa_sas_port;
> +	struct hpsa_sas_phy *hpsa_sas_phy;
> +
> +	parent_dev = &h->scsi_host->shost_gendev;
> +
> +	hpsa_sas_node = hpsa_alloc_sas_node(parent_dev);
> +	if (!hpsa_sas_node)
> +		return -ENOMEM;
> +
> +	hpsa_sas_port = hpsa_alloc_sas_port(hpsa_sas_node, h->sas_address);
> +	if (!hpsa_sas_port) {
> +		rc = -ENODEV;
> +		goto free_sas_node;
> +	}
> +
> +	hpsa_sas_phy = hpsa_alloc_sas_phy(hpsa_sas_port);
> +	if (!hpsa_sas_phy) {
> +		rc = -ENODEV;
> +		goto free_sas_port;
> +	}
> +
> +	rc = hpsa_sas_port_add_phy(hpsa_sas_phy);
> +	if (rc)
> +		goto free_sas_phy;
> +
> +	h->sas_host = hpsa_sas_node;
> +
> +	return 0;
> +
> +free_sas_phy:
> +	hpsa_free_sas_phy(hpsa_sas_phy);
> +free_sas_port:
> +	hpsa_free_sas_port(hpsa_sas_port);
> +free_sas_node:
> +	hpsa_free_sas_node(hpsa_sas_node);
> +
> +	return rc;
> +}
> +
> +static void hpsa_delete_sas_host(struct ctlr_info *h)
> +{
> +	hpsa_free_sas_node(h->sas_host);
> +}
> +
> +static int hpsa_add_sas_device(struct hpsa_sas_node *hpsa_sas_node,
> +				struct hpsa_scsi_dev_t *device)
> +{
> +	int rc;
> +	struct hpsa_sas_port *hpsa_sas_port;
> +	struct sas_rphy *rphy;
> +
> +	hpsa_sas_port = hpsa_alloc_sas_port(hpsa_sas_node, device->sas_address);
> +	if (!hpsa_sas_port)
> +		return -ENOMEM;
> +
> +	rphy = sas_end_device_alloc(hpsa_sas_port->port);
> +	if (!rphy) {
> +		rc = -ENODEV;
> +		goto free_sas_port;
> +	}
> +
> +	hpsa_sas_port->rphy = rphy;
> +	device->sas_port = hpsa_sas_port;
> +
> +	rc = hpsa_sas_port_add_rphy(hpsa_sas_port, rphy);
> +	if (rc)
> +		goto free_sas_port;
> +
> +	return 0;
> +
> +free_sas_port:
> +	hpsa_free_sas_port(hpsa_sas_port);
> +	device->sas_port = NULL;
> +
> +	return rc;
> +}
> +
> +static void hpsa_remove_sas_device(struct hpsa_scsi_dev_t *device)
> +{
> +	if (device->sas_port) {
> +		hpsa_free_sas_port(device->sas_port);
> +		device->sas_port = NULL;
> +	}
> +}
> +
> +static int
> +hpsa_sas_get_linkerrors(struct sas_phy *phy)
> +{
> +	return 0;
> +}
> +
> +static int
> +hpsa_sas_get_enclosure_identifier(struct sas_rphy *rphy, u64 *identifier)
> +{
> +	return 0;
> +}
> +
> +static int
> +hpsa_sas_get_bay_identifier(struct sas_rphy *rphy)
> +{
> +	return -ENXIO;
> +}
> +
> +static int
> +hpsa_sas_phy_reset(struct sas_phy *phy, int hard_reset)
> +{
> +	return 0;
> +}
> +
> +static int
> +hpsa_sas_phy_enable(struct sas_phy *phy, int enable)
> +{
> +	return 0;
> +}
> +
> +static int
> +hpsa_sas_phy_setup(struct sas_phy *phy)
> +{
> +	return 0;
> +}
> +
> +static void
> +hpsa_sas_phy_release(struct sas_phy *phy)
> +{
> +}
> +
> +static int
> +hpsa_sas_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates)
> +{
> +	return -EINVAL;
> +}
> +
> +/* SMP = Serial Management Protocol */
> +static int
> +hpsa_sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
> +struct request *req)
> +{
> +	return -EINVAL;
> +}
> +
> +static struct sas_function_template hpsa_sas_transport_functions = {
> +	.get_linkerrors = hpsa_sas_get_linkerrors,
> +	.get_enclosure_identifier = hpsa_sas_get_enclosure_identifier,
> +	.get_bay_identifier = hpsa_sas_get_bay_identifier,
> +	.phy_reset = hpsa_sas_phy_reset,
> +	.phy_enable = hpsa_sas_phy_enable,
> +	.phy_setup = hpsa_sas_phy_setup,
> +	.phy_release = hpsa_sas_phy_release,
> +	.set_phy_speed = hpsa_sas_phy_speed,
> +	.smp_handler = hpsa_sas_smp_handler,
> +};
> +
> /*
>  *  This is it.  Register the PCI driver information for the cards we control
>  *  the OS will call our registered routines when it finds one of our cards.
>  */
> static int __init hpsa_init(void)
> {
> -	return pci_register_driver(&hpsa_pci_driver);
> +	int rc;
> +
> +	hpsa_sas_transport_template =
> +		sas_attach_transport(&hpsa_sas_transport_functions);
> +	if (!hpsa_sas_transport_template)
> +		return -ENODEV;
> +
> +	rc = pci_register_driver(&hpsa_pci_driver);
> +
> +	if (rc)
> +		sas_release_transport(hpsa_sas_transport_template);
> +
> +	return rc;
> }
> 
> static void __exit hpsa_cleanup(void)
> {
> 	pci_unregister_driver(&hpsa_pci_driver);
> +	sas_release_transport(hpsa_sas_transport_template);
> }
> 
> static void __attribute__((unused)) verify_offsets(void)
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index 6c82d3c..7847405 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -33,6 +33,29 @@ struct access_method {
> 	unsigned long (*command_completed)(struct ctlr_info *h, u8 q);
> };
> 
> +/* for SAS hosts and SAS expanders */
> +struct hpsa_sas_node {
> +	struct device *parent_dev;
> +	struct list_head port_list_head;
> +};
> +
> +struct hpsa_sas_port {
> +	struct list_head port_list_entry;
> +	u64 sas_address;
> +	struct sas_port *port;
> +	int next_phy_index;
> +	struct list_head phy_list_head;
> +	struct hpsa_sas_node *parent_node;
> +	struct sas_rphy *rphy;
> +};
> +
> +struct hpsa_sas_phy {
> +	struct list_head phy_list_entry;
> +	struct sas_phy *phy;
> +	struct hpsa_sas_port *parent_port;
> +	bool added_to_port;
> +};
> +
> struct hpsa_scsi_dev_t {
> 	unsigned int devtype;
> 	int bus, target, lun;		/* as presented to the OS */
> @@ -41,6 +64,7 @@ struct hpsa_scsi_dev_t {
> 	u8 expose_device;
> #define RAID_CTLR_LUNID "\0\0\0\0\0\0\0\0"
> 	unsigned char device_id[16];    /* from inquiry pg. 0x83 */
> +	u64 sas_address;
> 	unsigned char vendor[8];        /* bytes 8-15 of inquiry data */
> 	unsigned char model[16];        /* bytes 16-31 of inquiry data */
> 	unsigned char raid_level;	/* from inquiry page 0xC1 */
> @@ -77,6 +101,7 @@ struct hpsa_scsi_dev_t {
> 	struct hpsa_scsi_dev_t *phys_disk[RAID_MAP_MAX_ENTRIES];
> 	int nphysical_disks;
> 	int supports_aborts;
> +	struct hpsa_sas_port *sas_port;
> 	int external;   /* 1-from external array 0-not <0-unknown */
> };
> 
> @@ -134,6 +159,7 @@ struct ctlr_info {
> 	char    *product_name;
> 	struct pci_dev *pdev;
> 	u32	board_id;
> +	u64	sas_address;
> 	void __iomem *vaddr;
> 	unsigned long paddr;
> 	int 	nr_cmds; /* Number of commands allowed on this controller */
> @@ -272,6 +298,7 @@ struct ctlr_info {
> 	wait_queue_head_t event_sync_wait_queue;
> 	struct mutex reset_mutex;
> 	u8 reset_in_progress;
> +	struct hpsa_sas_node *sas_host;
> };
> 
> struct offline_device_entry {
> diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
> index 4910344..d92ef0d 100644
> --- a/drivers/scsi/hpsa_cmd.h
> +++ b/drivers/scsi/hpsa_cmd.h
> @@ -290,6 +290,7 @@ struct SenseSubsystem_info {
> #define BMIC_SET_DIAG_OPTIONS 0xF4
> #define BMIC_SENSE_DIAG_OPTIONS 0xF5
> #define HPSA_DIAG_OPTS_DISABLE_RLD_CACHING 0x40000000
> +#define BMIC_SENSE_SUBSYSTEM_INFORMATION 0x66
> 
> /* Command List Structure */
> union SCSI3Addr {
> @@ -828,5 +829,18 @@ struct bmic_identify_physical_device {
> 	u8     padding[112];
> };
> 
> +struct bmic_sense_subsystem_info {
> +	u8	primary_slot_number;
> +	u8	reserved[3];
> +	u8	chasis_serial_number[32];
> +	u8	primary_world_wide_id[8];
> +	u8	primary_array_serial_number[32]; /* NULL terminated */
> +	u8	primary_cache_serial_number[32]; /* NULL terminated */
> +	u8	reserved_2[8];
> +	u8	secondary_array_serial_number[32];
> +	u8	secondary_cache_serial_number[32];
> +	u8	pad[332];
> +};
> +
> #pragma pack()
> #endif /* HPSA_CMD_H */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

