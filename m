From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: megaraid_sas: Task management support
Date: Fri, 12 Feb 2016 14:52:57 +0530
Message-ID: <d77f601478195bbb0d13406152552d7a@mail.gmail.com>
References: <20160208182130.GB18802@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34169 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbcBLJW7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2016 04:22:59 -0500
Received: by mail-lf0-f54.google.com with SMTP id j78so47903428lfb.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Feb 2016 01:22:58 -0800 (PST)
In-Reply-To: <20160208182130.GB18802@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, sumit.saxena@avagotech.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, February 08, 2016 11:52 PM
> To: sumit.saxena@avagotech.com
> Cc: megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org
> Subject: re: megaraid_sas: Task management support
>
> Hello Sumit Saxena,
>
> The patch 31796fa184ee: "megaraid_sas: Task management support" from Jan
> 28, 2016, leads to the following static checker warning:
>
> 	drivers/scsi/megaraid/megaraid_sas_base.c:1788
> megasas_update_sdev_properties()
> 	warn: if statement not indented
>
> drivers/scsi/megaraid/megaraid_sas_base.c
>   1781          } else {
>   1782                  device_id = ((sdev->channel % 2) *
> MEGASAS_MAX_DEV_PER_CHANNEL)
>   1783                                          + sdev->id;
>   1784                  local_map_ptr =
fusion->ld_drv_map[(instance->map_id & 1)];
>   1785                  ld = MR_TargetIdToLdGet(device_id,
local_map_ptr);
>   1786                  raid = MR_LdRaidGet(ld, local_map_ptr);
>   1787
>   1788                  if (raid->capability.ldPiMode ==
> MR_PROT_INFO_TYPE_CONTROLLER)
>   1789
blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
>
> It looks like the code is correct but the patch just deleted a tab
accidentally.
Yes code is correct, tab got deleted accidentally.
>
>   1790                  mr_device_priv_data->is_tm_capable =
>   1791                          raid->capability.tmCapable;
>   1792          }
>
> regards,
> dan carpenter
