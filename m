Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B0822F388
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 04:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780546347; cv=none; b=b2hhk34JC9awLlzR1CG/y9AaGWI1JWoRlZPatP6wuqW2e+thE0leJL+B0sP3UdVOWt6J6ztv7Wws8HnUVUT3VrNb51emUoDXy1C+vSqewIDW3udy6mFodbMLvHVPe6fhK7jKLLWhlbevk2j8+wH92qjUs9dR4Qfjj1ZQQh8Lq6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780546347; c=relaxed/simple;
	bh=BIg2mcHtdm2hEko1buK0XSs4TUAboO7cDciSC1p8SWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HFB+XiD8rboEUpqNM2ZDFSW2cOGfagFifucd5atF4zN8VpTsoT1qk+5/sNMLdXeN5gwHluUdUF/guetdD42aHbzABYAJNbuNFWckNeOhP3v131TZX7ScucXjYSR2yJ1+L+PzfCrfRyc23Gci7F814ypmXnGfZyJzPdlBsufiNfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YyNNL48h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YyNNL48h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312941F00893;
	Thu,  4 Jun 2026 04:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780546346;
	bh=pXHSkmn8Ctm4rOXYaV7jbBx2oIMNnqAUBcttJDSGVt8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YyNNL48hfsdW7O2x/KgaIiA0KcAauECb8nLN3zrtu/CgP6l/LjQARpQEXCoyo+egu
	 wuaRID+lKPL8EwpgpzrImvldP0jK0Sv4Ov1xDhQKf56nr5FG6pMeszNdzNUMM3Qek+
	 PnN5lpV3IOYZv74uW2uoOnZuo7550kyjHRO+X0y0A27fr201FrD7aS3MevpF5IfBOC
	 K50IqLg23AgapdFeWxYSm4x6HvtWlm+X2EuISzsM7SJRSc7pXhUgmTrwSy+tJuDGkX
	 l3aoRvAfZyaXUb3lpXi5C/Z+BKBfFZrTaoPMrdUmkZLU1bfTqR8HmRejxRyYYv/1tb
	 P5y9Q2kx47EQA==
Message-ID: <b2c0ab9c-d6c0-4f13-9df4-b8589ba98d11@kernel.org>
Date: Thu, 4 Jun 2026 12:12:15 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] scsi: leapraid: Add new SCSI driver
To: Dongdong Hao <doubled@leap-io-kernel.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: yjzhang@leap-io-kernel.com, kezijie@leap-io-kernel.com,
 linux-scsi@vger.kernel.org
References: <cover.1780383814.git.doubled@leap-io-kernel.com>
 <6c20b88401906713f948ff72bf06988930fa0fde.1780383814.git.doubled@leap-io-kernel.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <6c20b88401906713f948ff72bf06988930fa0fde.1780383814.git.doubled@leap-io-kernel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/06/02 15:10, Dongdong Hao wrote:
> The LeapRAID driver provides support for LeapRAID PCIe RAID controllers,
> enabling communication between the host operating system, firmware, and
> hardware for efficient storage management.
> 
> The driver is organized into several logical modules, each with a clear
> responsibility:
> 
> leapraid_os.c: Integrates with the Linux SCSI subsystem, handling host
> template callbacks, PCIe device probing, and initialization.
> 
> leapraid_func.c: Contains low-level routines for firmware/hardware
> interaction, interrupt handling, and reset logic.
> 
> leapraid_app.c: Provides the ioctl interface for user-space tools.
> 
> leapraid_transport.c: Manages interactions with the SCSI transport
> layer for SAS PHYs and ports.
> 
> leapraid_func.h: Contains internal definitions shared among driver
> modules.
> 
> leapraid.h: Contains low-level hardware definitions for
> driver/firmware interaction.
> 
> The leapraid_probe() function orchestrates the setup: it allocates the
> adapter structure and SCSI host, configures hardware interfaces, and
> registers it with the SCSI mid-layer. Following registration,
> scsi_scan_host() is invoked to initiate device discovery, with firmware
> reporting devices via interrupt-driven events.
> 
> This initial commit provides the necessary infrastructure for
> subsequent development of full I/O path handling, error recovery,
> and advanced management features.
> 
> Signed-off-by: Dongdong Hao <doubled@leap-io-kernel.com>

[...]

> +static long bad_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	return -ENOTTY;
> +}

> +static const struct file_operations leapraid_ctl_fops = {
> +	.owner = THIS_MODULE,
> +	.unlocked_ioctl = leapraid_ctl_ioctl,
> +	.mmap = leapraid_fw_mmap,
> +	.compat_ioctl = bad_ioctl,

You do not need to define .compat_ioctl if not supported. The ioctl syscall will
return -ENOTTY when .compat_ioctl is undefined. So drop bad_ioctl()

[...]

> +out_cleanup:
> +	adapter->driver_cmds.cfg_op_cmd.status = LEAPRAID_CMD_NOT_USED;
> +	mutex_unlock(&adapter->driver_cmds.cfg_op_cmd.mutex);
> +	if (issue_reset) {
> +		if (adapter->scan_dev_desc.first_scan_dev_fired) {
> +			dev_info(&adapter->pdev->dev,
> +				 "%s:%d cfg-req: Failure, issuing reset\n",
> +				 __func__, __LINE__);

Shouldn't this be a dev_err() ? or dev_warn() ?

> +			leapraid_hard_reset_handler(adapter, FULL_RESET);
> +		} else {
> +			dev_warn(&adapter->pdev->dev,
> +				 "cfg-req: CMD fail in init, skip reset\n");
> +		}
> +		rc = -EFAULT;
> +	}
> +	return rc;

[...]

> +	adapter_state = leapraid_get_adapter_state(adapter);
> +	if (adapter_state != LEAPRAID_DB_OPERATIONAL) {
> +		dev_info(&adapter->pdev->dev, "%s:%d: call hard_reset 0x%x\n",
> +			 __func__, __LINE__, adapter_state);
> +		rc = leapraid_hard_reset_handler(adapter, FULL_RESET);
> +		dev_warn(&adapter->pdev->dev, "%s: Hard reset %s\n",
> +			 __func__, rc == 0 ? "success" : "failed");

A warning in the case of success is a little odd. Maybe stay silent for the
success case and dev_err() for the failure case ?

> +
> +		adapter_state = leapraid_get_adapter_state(adapter);
> +		if (rc && adapter_state != LEAPRAID_DB_OPERATIONAL)
> +			return;
> +	}

[...]

> +static struct leapraid_fw_evt_work *leapraid_alloc_fw_evt_work(void)
> +{
> +	struct leapraid_fw_evt_work *fw_evt =
> +		kzalloc(sizeof(*fw_evt), GFP_ATOMIC);

Please add a blank line here.

> +	if (!fw_evt)
> +		return NULL;

Maybe simplify here:

	if (fw_evt)
		kref_init(&fw_evt->refcnt);

	return fw_evt;

> +
> +	kref_init(&fw_evt->refcnt);
> +	return fw_evt;
> +}

[...]

> +static void leapraid_remove_unresp_raid_volumes(
> +		struct leapraid_adapter *adapter)
> +{
> +	unsigned long flags;
> +	struct leapraid_raid_volume *raid_volume, *raid_volume_next;
> +	LIST_HEAD(head);
> +
> +	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
> +	list_for_each_entry_safe(raid_volume, raid_volume_next,
> +				 &adapter->dev_topo.raid_volume_list, list) {
> +		if (!raid_volume->resp)
> +			list_move_tail(&raid_volume->list, &head);
> +		else
> +			raid_volume->resp = 0;
> +	}
> +	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
> +
> +	list_for_each_entry_safe(raid_volume, raid_volume_next, &head, list) {
> +		leapraid_sas_volume_delete_by_ptr(adapter, raid_volume);
> +	}
> +
> +	dev_info(&adapter->pdev->dev,
> +		 "Unresponsive RAID volumes removed\n");

Maybe dev_warn() here ?

> +static void leapraid_remove_unresp_sas_exp(struct leapraid_adapter *adapter)
> +{
> +	struct leapraid_topo_node *topo_node_exp, *topo_node_exp_next;
> +	unsigned long flags;
> +	LIST_HEAD(head);
> +
> +	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
> +	list_for_each_entry_safe(topo_node_exp, topo_node_exp_next,
> +				 &adapter->dev_topo.exp_list, list) {
> +		if (!topo_node_exp->resp)
> +			list_move_tail(&topo_node_exp->list, &head);
> +		else
> +			topo_node_exp->resp = 0;
> +	}
> +	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
> +
> +	list_for_each_entry_safe(topo_node_exp, topo_node_exp_next,
> +				 &head, list)
> +		leapraid_exp_node_rm(adapter, topo_node_exp);
> +
> +	dev_info(&adapter->pdev->dev,
> +		 "Unresponsive SAS expanders removed\n");

And here too ?

[...]

> +static void leapraid_scan_all_dev_after_reset(struct leapraid_adapter *adapter)
> +{
> +	dev_info(&adapter->pdev->dev, "Begin scanning devices\n");
> +
> +	leapraid_sas_host_add(adapter, adapter->dev_topo.card.phys_num > 0);
> +	leapraid_scan_exp_after_reset(adapter);
> +	if (adapter->adapter_attr.raid_support) {
> +		leapraid_scan_phy_disks_after_reset(adapter);
> +		leapraid_scan_vol_after_reset(adapter);
> +	}
> +	leapraid_scan_sas_dev_after_reset(adapter);
> +
> +	dev_info(&adapter->pdev->dev, "Devices scan complete\n");

Maybe drop this message to not polute too much the kernel log ?

[...]

> +static u8 leapraid_handle_scan_cb(struct leapraid_adapter *adapter,
> +				  struct leapraid_driver_cmd *cmd,
> +				  struct leapraid_rep *rep)
> +{
> +	u16 status;
> +
> +	cmd->status &= ~LEAPRAID_CMD_PENDING;
> +
> +	status = le16_to_cpu(rep->adapter_status) &
> +		 LEAPRAID_ADAPTER_STATUS_MASK;
> +
> +	if (status != LEAPRAID_ADAPTER_STATUS_SUCCESS)
> +		adapter->scan_dev_desc.scan_dev_failed = 1;
> +
> +	if (!cmd->async_scan_dev) {
> +		complete(&cmd->done);
> +		return 1;
> +	}
> +
> +	if (status == LEAPRAID_ADAPTER_STATUS_SUCCESS)
> +		leapraid_scan_dev_complete(adapter);
> +	else
> +		adapter->scan_dev_desc.scan_start_failed = status;
> +
> +	return 1;
> +}

This function only returns 1. It has a single caller site. So make it void and...

> +static bool leapraid_driver_cmds_done(struct leapraid_adapter *adapter,
> +				      u16 taskid, u8 msix_index,
> +				      u32 rep_paddr, u8 cb_idx)
> +{

[...]

> +		if (_sp_cmd->cb_idx == LEAPRAID_SCAN_DEV_CB_IDX)
> +			return leapraid_handle_scan_cb(adapter,
> +						       _sp_cmd,
> +						       leap_mpi_rep);

call thr function here and "retrun true".

> +
> +		if (_sp_cmd->cb_idx == LEAPRAID_CTL_CB_IDX)
> +			leapraid_handle_ctl_cb(adapter, leap_mpi_rep, taskid);
> +	}
> +
> +	_sp_cmd->status &= ~LEAPRAID_CMD_PENDING;
> +	complete(&_sp_cmd->done);
> +
> +	return true;
> +}

[...]

> +static int leapraid_tm_post_processing(struct leapraid_adapter *adapter,
> +				       u16 hdl, uint channel, uint id,
> +				       uint lun, u8 type, u16 taskid_task)
> +{
> +	int rc;
> +
> +	rc = leapraid_tm_cmd_map_status(adapter, channel, id, lun,
> +					type, taskid_task);
> +	if (rc == SUCCESS)
> +		return rc;
> +
> +	leapraid_mask_int(adapter);
> +	leapraid_sync_irqs(adapter, true);
> +	leapraid_unmask_int(adapter);
> +
> +	rc = leapraid_tm_cmd_map_status(adapter, channel, id, lun, type,
> +					taskid_task);
> +	return rc;

	return leapraid_tm_cmd_map_status(adapter, channel, id, lun,
					  type, taskid_task);

is a little better :)

[...]

> +static inline bool leapraid_is_scmd_permitted(struct leapraid_adapter *adapter,
> +					      struct scsi_cmnd *scmd)
> +{
> +	u8 opcode;
> +
> +	if (adapter->access_ctrl.pcie_recovering ||
> +	    atomic_read(&adapter->overheat_desc.thermal_alert))
> +		return false;
> +
> +	if (adapter->access_ctrl.host_removing) {
> +		if (leapraid_pci_removed(adapter))
> +			return false;
> +
> +		opcode = scmd->cmnd[0];
> +		if (opcode == SYNCHRONIZE_CACHE || opcode == START_STOP)
> +			return true;
> +
> +		return false;

Simplify:

		return opcode == SYNCHRONIZE_CACHE ||
			opcode == START_STOP;

> +	}
> +	return true;
> +}

[...]

With these nits corrected, feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

Martin,

I did 3 rounds of reviews with the author off-list. So I think this is all good
enough to get in, which will simplify fixes/improvements going forward.



-- 
Damien Le Moal
Western Digital Research
