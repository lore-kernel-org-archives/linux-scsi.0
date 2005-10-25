From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] libata: Remove dependence on host_set->dev for SAS
Date: Tue, 25 Oct 2005 14:30:48 -0500
Message-ID: <435E87E8.9010506@us.ibm.com>
References: <4341A91A.3020000@us.ibm.com> <434251E0.9060000@pobox.com>	 <58cb370e0510040322q1cb7a13bjfc6c7875140d20a9@mail.gmail.com> <58cb370e0510041356h780e7a5aifda0c232f677471e@mail.gmail.com> <43443E99.4090008@pobox.com> <435D5D83.1060201@us.ibm.com> <435D5DE5.7010306@us.ibm.com> <435E7105.4010105@pobox.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:64149 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S932316AbVJYTax
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Oct 2005 15:30:53 -0400
In-Reply-To: <435E7105.4010105@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Brian King wrote:
> 
>>Remove some of the dependence on the host_set struct
>>in preparation for supporting SAS HBAs. Adds a struct device
>>pointer to the ata_port struct.
>>
>>This patch depends on the qc_transport patch:
>>
>>http://marc.theaimsgroup.com/?l=linux-ide&m=112845939215286&w=2
>>
>>Signed-off-by: Brian King <brking@us.ibm.com>
>>---
>>
>> linux-2.6-bjking1/drivers/scsi/libata-core.c |   13 +++++++------
>> linux-2.6-bjking1/include/linux/libata.h     |    1 +
>> 2 files changed, 8 insertions(+), 6 deletions(-)
>>
>>diff -puN include/linux/libata.h~libata_host_set_dev include/linux/libata.h
>>--- linux-2.6/include/linux/libata.h~libata_host_set_dev	2005-10-24 15:04:22.000000000 -0500
>>+++ linux-2.6-bjking1/include/linux/libata.h	2005-10-24 15:04:22.000000000 -0500
>>@@ -315,6 +315,7 @@ struct ata_port {
>> 
>> 	struct ata_host_stats	stats;
>> 	struct ata_host_set	*host_set;
>>+	struct device 		*dev;
>> 
>> 	struct work_struct	packet_task;
>> 
> 
> 
> Patch seems basically OK.  But taking this patch to its conclusion means 
> deleting 'dev' from struct ata_host_set too...  I wonder what breakage 
> will result from that?

It breaks ata_pci_host_stop:

void ata_pci_host_stop (struct ata_host_set *host_set)
{
	struct pci_dev *pdev = to_pci_dev(host_set->dev);

	pci_iounmap(pdev, host_set->mmio_base);
}

I could poke into the first port here to get the 'dev', but I didn't
particularly like that.

I also thought about changing the prototype for host_set to pass in
the 'dev' pointer, but wasn't sure that would work for the non PCI case.

Or, we just live with the duplication...

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
