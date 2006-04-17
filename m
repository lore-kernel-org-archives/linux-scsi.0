From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 2/2] libata: Use scsi_device max_cmd_len (resend)
Date: Mon, 17 Apr 2006 18:52:45 -0400
Message-ID: <44441C3D.80906@pobox.com>
References: <200604172240.k3HMes2V010154@d01av01.pok.ibm.com> <44441B41.40206@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:18826 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751356AbWDQWwt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Apr 2006 18:52:49 -0400
In-Reply-To: <44441B41.40206@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Brian King wrote:
> @@ -4573,7 +4567,7 @@ static void ata_host_init(struct ata_por
>  	host->max_lun = 1;
>  	host->max_channel = 1;
>  	host->unique_id = ata_unique_id++;
> -	host->max_cmd_len = 12;
> +	host->max_cmd_len = ATAPI_CDB_LEN;
>  


Have you audited the code paths to ensure that a CDB of length 15 is 
_NEVER_ sent, before ata_scsi_dev_config() is called?

The current code intentionally uses the minimum -- 12 -- and then raises 
it if both device and host are capable of more.

	Jeff


