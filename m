From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] megaraid_sas: Make PI enabled VD 8 byte DMA aligned
Date: Tue, 14 Feb 2017 19:23:41 +0300
Message-ID: <20170214162341.GA3729@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26402 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754361AbdBNQYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2017 11:24:08 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sumit.saxena@avagotech.com
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org

Hello sumit.saxena@avagotech.com,

The patch 0b48d12d0365: "megaraid_sas: Make PI enabled VD 8 byte DMA
aligned" from Oct 15, 2015, leads to the following static checker
warning:

	drivers/scsi/megaraid/megaraid_sas_base.c:1784 megasas_set_dynamic_target_properties()
	warn: if statement not indented

drivers/scsi/megaraid/megaraid_sas_base.c
  1757  void megasas_set_dynamic_target_properties(struct scsi_device *sdev)
  1758  {
  1759          u16 pd_index = 0, ld;
  1760          u32 device_id;
  1761          struct megasas_instance *instance;
  1762          struct fusion_context *fusion;
  1763          struct MR_PRIV_DEVICE *mr_device_priv_data;
  1764          struct MR_PD_CFG_SEQ_NUM_SYNC *pd_sync;
  1765          struct MR_LD_RAID *raid;
  1766          struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
  1767  
  1768          instance = megasas_lookup_instance(sdev->host->host_no);
  1769          fusion = instance->ctrl_context;
  1770          mr_device_priv_data = sdev->hostdata;
  1771  
  1772          if (!fusion || !mr_device_priv_data)
  1773                  return;
  1774  
  1775          if (MEGASAS_IS_LOGICAL(sdev)) {
  1776                  device_id = ((sdev->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL)
  1777                                          + sdev->id;
  1778                  local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
  1779                  ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
  1780                  if (ld >= instance->fw_supported_vd_count)
  1781                          return;
  1782                  raid = MR_LdRaidGet(ld, local_map_ptr);
  1783  
  1784                  if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER)
  1785                  blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  1786  
  1787                  mr_device_priv_data->is_tm_capable =
  1788                          raid->capability.tmCapable;
  1789          } else if (instance->use_seqnum_jbod_fp) {
  1790                  pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
  1791                          sdev->id;
  1792                  pd_sync = (void *)fusion->pd_seq_sync
  1793                                  [(instance->pd_seq_map_id - 1) & 1];
  1794                  mr_device_priv_data->is_tm_capable =
  1795                          pd_sync->seq[pd_index].capability.tmCapable;
  1796          }
  1797  }


regards,
dan carpenter
