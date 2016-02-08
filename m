From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: megaraid_sas: Task management support
Date: Mon, 8 Feb 2016 21:21:30 +0300
Message-ID: <20160208182130.GB18802@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49908 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbcBHSVq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2016 13:21:46 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sumit.saxena@avagotech.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

Hello Sumit Saxena,

The patch 31796fa184ee: "megaraid_sas: Task management support" from
Jan 28, 2016, leads to the following static checker warning:

	drivers/scsi/megaraid/megaraid_sas_base.c:1788 megasas_update_sdev_properties()
	warn: if statement not indented

drivers/scsi/megaraid/megaraid_sas_base.c
  1781          } else {
  1782                  device_id = ((sdev->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL)
  1783                                          + sdev->id;
  1784                  local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
  1785                  ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
  1786                  raid = MR_LdRaidGet(ld, local_map_ptr);
  1787  
  1788                  if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER)
  1789                  blk_queue_update_dma_alignment(sdev->request_queue, 0x7);

It looks like the code is correct but the patch just deleted a tab
accidentally.

  1790                  mr_device_priv_data->is_tm_capable =
  1791                          raid->capability.tmCapable;
  1792          }

regards,
dan carpenter
