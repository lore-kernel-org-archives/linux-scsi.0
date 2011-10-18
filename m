From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 9/10] megaraid_sas: Add driver workaround for PERC5/1068
 kdump kernel panic
Date: Tue, 18 Oct 2011 16:41:08 +0200
Message-ID: <4E9D9004.6070905@redhat.com>
References: <CAHtARFFp12dh5fmsNQG8w_g_RP6ftXR57HmhydNomZy1PtExXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab1JROlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Oct 2011 10:41:12 -0400
In-Reply-To: <CAHtARFFp12dh5fmsNQG8w_g_RP6ftXR57HmhydNomZy1PtExXg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On 10/09/2011 03:15 AM, adam radford wrote:
> James/linux-scsi,
>
> The following patch for megaraid_sas adds a driver workaround for
> PERC5/1068 based controller FW that keeps a command from the main
> kernel that the driver cannot cancel which was causing a kernel panic
> in shutdown of the kdump kernel.
>
> Signed-off-by: Adam Radford <aradford@gmail.com>
This is an improved version of http://www.spinics.net/lists/linux-scsi/msg54294.html
I tested this patch too, I can confirm that it resolves the panic.

Tomas

>
> diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
> scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
> --- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-08
> 15:29:22.411330755 -0700
> +++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-08
> 17:20:01.091455209 -0700
> @@ -215,6 +215,10 @@
>
>  	cmd->scmd = NULL;
>  	cmd->frame_count = 0;
> +	if ((instance->pdev->device != PCI_DEVICE_ID_LSI_FUSION) &&
> +	    (instance->pdev->device != PCI_DEVICE_ID_LSI_INVADER) &&
> +	    (reset_devices))
> +		cmd->frame->hdr.cmd = MFI_CMD_INVALID;
>  	list_add_tail(&cmd->list, &instance->cmd_pool);
>
>  	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
> @@ -2165,7 +2169,16 @@
>  		cmd->scmd->SCp.ptr = NULL;
>
>  	switch (hdr->cmd) {
> -
> +	case MFI_CMD_INVALID:
> +		/* Some older 1068 controller FW may keep a pended
> +		   MR_DCMD_CTRL_EVENT_GET_INFO left over from the main kernel
> +		   when booting the kdump kernel.  Ignore this command to
> +		   prevent a kernel panic on shutdown of the kdump kernel. */
> +		printk(KERN_WARNING "megaraid_sas: MFI_CMD_INVALID command "
> +		       "completed.\n");
> +		printk(KERN_WARNING "megaraid_sas: If you have a controller "
> +		       "other than PERC5, please upgrade your firmware.\n");
> +		break;
>  	case MFI_CMD_PD_SCSI_IO:
>  	case MFI_CMD_LD_SCSI_IO:
>
> @@ -2934,6 +2947,10 @@
>  		memset(cmd->frame, 0, total_sz);
>  		cmd->frame->io.context = cmd->index;
>  		cmd->frame->io.pad_0 = 0;
> +		if ((instance->pdev->device != PCI_DEVICE_ID_LSI_FUSION) &&
> +		    (instance->pdev->device != PCI_DEVICE_ID_LSI_INVADER) &&
> +		    (reset_devices))
> +			cmd->frame->hdr.cmd = MFI_CMD_INVALID;
>  	}
>
>  	return 0;
> diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h
> scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
> --- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h	2011-10-08
> 15:29:22.413330801 -0700
> +++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2011-10-08
> 17:16:58.131395817 -0700
> @@ -139,6 +139,7 @@
>  #define MFI_CMD_ABORT				0x06
>  #define MFI_CMD_SMP				0x07
>  #define MFI_CMD_STP				0x08
> +#define MFI_CMD_INVALID				0xff
>
>  #define MR_DCMD_CTRL_GET_INFO			0x01010000
>  #define MR_DCMD_LD_GET_LIST			0x03010000

