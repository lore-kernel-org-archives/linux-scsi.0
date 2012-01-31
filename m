From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 4/5] scsi: Add a report opcode helper
Date: Tue, 31 Jan 2012 14:53:50 -0500
Message-ID: <4F2846CE.2050907@garzik.org>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com> <1327969892-5090-5-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38413 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab2AaTx4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2012 14:53:56 -0500
Received: by bkcjm19 with SMTP id jm19so309711bkc.19
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2012 11:53:55 -0800 (PST)
In-Reply-To: <1327969892-5090-5-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, jaxboe@fusionio.com

On 01/30/2012 07:31 PM, Martin K. Petersen wrote:
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1052,6 +1052,7 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
>   {
>   	sdev->use_10_for_rw = 1;
>   	sdev->use_10_for_ms = 1;
> +	sdev->no_report_opcodes = 1;
>
>   	/* Schedule policy is determined by ->qc_defer() callback and
>   	 * it needs to see every deferred qc.  Set dev_blocked to 1 to


While this is bare minimum acceptable, remember this covers ATA and 
ATAPI devices both.

A preferred patch would simulate the RSOC op for ATA devices, and only 
apply the above condition to ATAPI devices.

	Jeff


