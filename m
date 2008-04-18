From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [SCSI] libsas: fix endianness bug in sas_ata
Date: Fri, 18 Apr 2008 16:50:44 -0400
Message-ID: <480909A4.7000906@garzik.org>
References: <200804181917.m3IJHbLk032765@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:48803 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbYDRUuq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 16:50:46 -0400
In-Reply-To: <200804181917.m3IJHbLk032765@hera.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

Linux Kernel Mailing List wrote:
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -698,7 +698,7 @@ static int sas_discover_sata_dev(struct domain_device *dev)
>  		/* incomplete response */
>  		SAS_DPRINTK("sending SET FEATURE/PUP_STBY_SPIN_UP to "
>  			    "dev %llx\n", SAS_ADDR(dev->sas_addr));
> -		if (!le16_to_cpu(identify_x[83] & (1<<6)))
> +		if (!(identify_x[83] & cpu_to_le16(1<<6)))
>  			goto cont1;
>  		res = sas_issue_ata_cmd(dev, ATA_SET_FEATURES,
>  					ATA_FEATURE_PUP_STBY_SPIN_UP,

Note that this code (not the patch, the code itself) duplicates libata 
code performing the same task...

We really need to get libsas going on the new EH.  We don't need this 
sort of needless code duplication.

	Jeff


