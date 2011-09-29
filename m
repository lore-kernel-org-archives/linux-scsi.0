From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/5] isci: atapi support
Date: Thu, 29 Sep 2011 09:45:48 -0400
Message-ID: <4E84768C.7030503@garzik.org>
References: <20110929013717.23617.3675.stgit@localhost6.localdomain6> <20110929014741.23617.56819.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63295 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab1I2Npv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2011 09:45:51 -0400
Received: by qyk7 with SMTP id 7so886177qyk.19
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2011 06:45:50 -0700 (PDT)
In-Reply-To: <20110929014741.23617.56819.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@parallels.com, Maciej Trela <maciej.trela@intel.com>, dmilburn@redhat.com, dave.jiang@intel.com, hare@suse.de, linux-scsi@vger.kernel.org

On 09/28/2011 09:47 PM, Dan Williams wrote:
> Based on original implementation from Jiangbi Liu and Maciej Trela.
>
> ATAPI transfers happen in two-to-three stages.  The two stage atapi
> commands are those that include a dma data transfer.  The data transfer
> portion of these operations is handled by the hardware packet-dma
> acceleration.  The three-stage commands do not have a data transfer and
> are handled without hardware assistance in raw frame mode.
>
> stage1: transmit host-to-device fis to notify the device of an incoming
> atapi cdb.  Upon reception of the pio-setup-fis repost the task_context
> to perform the dma transfer of the cdb+data (go to stage3), or repost
> the task_context to transmit the cdb as a raw frame (go to stage 2).
>
> stage2: wait for hardware notification of the cdb transmission and then
> go to stage 3.
>
> stage3: wait for the arrival of the terminating device-to-host fis and
> terminate the command.
>
> To keep the implementation simple we only support ATAPI packet-dma
> protocol (for commands with data) to avoid needing to handle the data
> transfer manually (like we do for SATA-PIO).  This may affect
> compatibility for a small number of devices (see
> ATA_HORKAGE_ATAPI_MOD16_DMA).
>
> If the data-transfer underruns, or encounters an error the
> device-to-host fis is expected to arrive in the unsolicited frame queue
> to pass to libata for disposition.  However, in the DONE_UNEXP_FIS (data
> underrun) case it appears we need to craft a response.  In the
> DONE_REG_ERR case we do receive the UF and propagate it to libsas.
>
> Signed-off-by: Maciej Trela<maciej.trela@intel.com>
> Signed-off-by: Dan Williams<dan.j.williams@intel.com>
> ---
>   drivers/scsi/isci/remote_device.c   |   24 +++
>   drivers/scsi/isci/remote_device.h   |    9 +
>   drivers/scsi/isci/request.c         |  327 ++++++++++++++++++++++++++++++++++-
>   drivers/scsi/isci/request.h         |   28 +++
>   drivers/scsi/libsas/sas_scsi_host.c |    2
>   include/scsi/libsas.h               |    5 +
>   6 files changed, 379 insertions(+), 16 deletions(-)

Acked-by: Jeff Garzik <jgarzik@redhat.com>



