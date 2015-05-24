From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 3/9] [SCSI] aacraid: Enable MSI interrupt for series-6
 controller
Date: Sun, 24 May 2015 21:31:19 +0200
Message-ID: <55622707.405@redhat.com>
References: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com> <1431562378-8514-4-git-send-email-rajinikanth.pandurangan@pmcs.com> <555F31B0.3090103@redhat.com> <E34C6B6293F0214497D0C55B92526C05B697A023@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbbEXTb0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 May 2015 15:31:26 -0400
In-Reply-To: <E34C6B6293F0214497D0C55B92526C05B697A023@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>

On 05/23/2015 01:46 AM, Rajinikanth Pandurangan wrote:
> Hello Tomas,
> 
> As the function aac_src_init() itself specific to Series-6 controller, change applicable only to series-6.
The change removes a kernel option, which assumedly
is used to control which kind of interrupt handling
the driver may use. With aac_msi = 1 the driver
might have used MSI -> the text "Enable MSI interrupt mode"
is misleading.
Let's say the text isn't precise - but i can accept it,
so you don't have to repost.

Tomas


> Thanks,
> -Raj P.
> 
> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com] 
> Sent: Friday, May 22, 2015 6:40 AM
> To: Rajinikanth Pandurangan; jbottomley@parallels.com; linux-scsi@vger.kernel.org
> Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Achim Leubner; Murthy Bhat
> Subject: Re: [PATCH 3/9] [SCSI] aacraid: Enable MSI interrupt for series-6 controller
> 
> On 05/14/2015 02:12 AM, rajinikanth.pandurangan@pmcs.com wrote:
>> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
>>
>> Description:
>> 	Enable MSI interrupt mode for series-6 controller.
> aac_msi is a driver option, how is it related to series-6 controller?
> Tomas
>>
>> Signed-off-by: Rajinikanth Pandurangan 
>> <rajinikanth.pandurangan@pmcs.com>
>> ---
>>  drivers/scsi/aacraid/src.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c 
>> index b0204d0..ae494c5 100644
>> --- a/drivers/scsi/aacraid/src.c
>> +++ b/drivers/scsi/aacraid/src.c
>> @@ -742,7 +742,7 @@ int aac_src_init(struct aac_dev *dev)
>>  	if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE1)
>>  		goto error_iounmap;
>>  
>> -	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
>> +	dev->msi = !pci_enable_msi(dev->pdev);
>>  
>>  	dev->aac_msix[0].vector_no = 0;
>>  	dev->aac_msix[0].dev = dev;
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

