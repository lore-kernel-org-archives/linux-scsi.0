From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] lpfc: fix model description
Date: Thu, 23 Apr 2015 09:36:46 +0200
Message-ID: <5538A10E.10904@sandisk.com>
References: <20150422231618.00005ec8@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0065.outbound.protection.outlook.com ([65.55.169.65]:37312
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932560AbbDWHvy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 03:51:54 -0400
In-Reply-To: <20150422231618.00005ec8@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>, linux-scsi@vger.kernel.org
Cc: James Smart <James.Smart@Emulex.Com>

On 04/22/15 23:16, Sebastian Herbszt wrote:
> Remove trailing space from model description.
>
> Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
>
> diff -up 4.0/drivers/scsi/lpfc.orig/lpfc_init.c 4.0/drivers/scsi/lpfc/lpfc_init.c
> --- 4.0/drivers/scsi/lpfc.orig/lpfc_init.c	2015-04-15 06:18:24.673045138 +0200
> +++ 4.0/drivers/scsi/lpfc/lpfc_init.c	2015-04-22 21:03:39.203230409 +0200
> @@ -2253,7 +2253,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba
>   				phba->Port);
>   		else if (max_speed == 0)
>   			snprintf(descp, 255,
> -				"Emulex %s %s %s ",
> +				"Emulex %s %s %s",
>   				m.name, m.bus, m.function);
>   		else
>   			snprintf(descp, 255,

Hello Sebastian,

Since you are touching that code, please include the following 
additional changes in your patch or in a separate patch:
* Change the type of the third argument of lpfc_get_hba_model_desc()
   from uint8_t * into char * since that pointer is used to store a
   '\0'-terminated ASCII string.
* Add a size argument to lpfc_get_hba_model_desc() such that the callers
   of this function can specify what the size is of the array descp
   points at (sizeof(phba->ModelDesc) ?).
* Switch from snprintf() to scnprintf() because the latter function
   guarantees '\0'-termination if the output has to be truncated.

Thanks,

Bart.

