From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH]scsi: megaraid_sas: fix raid card hotswap failure
Date: Mon, 08 May 2017 21:38:45 -0400
Message-ID: <yq1d1biu7ve.fsf@oracle.com>
References: <1493372584-1204-1-git-send-email-johnzzpcrystal@gmail.com>
        <1493489471-4848-1-git-send-email-johnzzpcrystal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46000 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753012AbdEIBiz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2017 21:38:55 -0400
In-Reply-To: <1493489471-4848-1-git-send-email-johnzzpcrystal@gmail.com> (Zhou
        Zhengping's message of "Sun, 30 Apr 2017 02:11:11 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhou Zhengping <johnzzpcrystal@gmail.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de, James.Bottomley@hansenpartnership.com


Zhou,

> When a scsi_device is unpluged from scsi controller, if the
> scsi_device is still be used by application layer,it won't be released
> until users release it. In this case, scsi_device_remove just set the
> scsi_device's state to be SDEV_DEL. But if you plug the disk just
> before the old scsi_device is released, then there will be two
> scsi_device structures in scsi_host->__devices. when the next
> unpluging event happens,some low-level drivers will check whether the
> scsi_device has been added to host (for example, the megaraid sas
> series controller) by calling scsi_device_lookup(call
> __scsi_device_lookup) in function
> megasas_aen_polling.__scsi_device_lookup will return the first
> scsi_device.  Because its state is SDEV_DEL, the scsi_device_lookup
> will return NULL finally, making the low-level driver assume that the
> scsi_device has been removed,and won't call scsi_device_remove,which
> will lead the failure of hot swap.

Applied to 4.12/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
