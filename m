From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] hpsa: add missing pci_set_master in kdump path
Date: Thu, 25 Sep 2014 14:41:07 +0200
Message-ID: <54240D63.7080900@redhat.com>
References: <5412EA9F.4060703@redhat.com> <20140925122039.GA11116@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbaIYMlc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 08:41:32 -0400
In-Reply-To: <20140925122039.GA11116@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On 09/25/2014 02:20 PM, Christoph Hellwig wrote:
> Tomas, can you also give me a signed-off-by for this one?

Oh, I forgot to add it before.

Patch is 
Signed-off-by: Tomas Henzl <thenzl@redhat.com>

>
> On Fri, Sep 12, 2014 at 02:44:15PM +0200, Tomas Henzl wrote:
>> Add a call to pci_set_master(...)  missing in the previous
>> patch "hpsa: refine the pci enable/disable handling".
>> Found thanks to Rob Elliot.
>> ---
>>  drivers/scsi/hpsa.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index 7828834..cef5d49 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -6544,7 +6544,7 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
>>  		dev_warn(&pdev->dev, "failed to enable device.\n");
>>  		return -ENODEV;
>>  	}
>> -
>> +	pci_set_master(pdev);
>>  	/* Reset the controller with a PCI power-cycle or via doorbell */
>>  	rc = hpsa_kdump_hard_reset_controller(pdev);
>>  
>> -- 
>> 1.8.3.1
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

