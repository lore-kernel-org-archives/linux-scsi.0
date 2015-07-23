From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V5 10/11] [SCSI] aacraid: Replace pci_enable_msix() with
 pci_enable_msix_range()
Date: Thu, 23 Jul 2015 16:33:35 +0200
Message-ID: <55B0FB3F.30705@redhat.com>
References: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1437583757-5449-11-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <55B0E3F6.5040808@redhat.com>
 <E34C6B6293F0214497D0C55B92526C05EAFF8421@BBYEXM02.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbbGWOdi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jul 2015 10:33:38 -0400
In-Reply-To: <E34C6B6293F0214497D0C55B92526C05EAFF8421@BBYEXM02.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>

On 23.7.2015 15:42, Rajinikanth Pandurangan wrote:
> Hello Tomas,
> 
> Our real intention was to replace pci_enable_msix() with pci_enable_msix_range().
> In V4, I had min as 8 and max as msi_count (which could be max of 32).  So range was 2 - 32.  But then as you suggested to make separate patch if I wanted to set the min range different, I have created patch 11 in V5.
> In patch 10 of V5, set range as (1 - 32). - I thought this would reflect our original intention.
> After discussed internally, we wanted to have at least minimum of 2 MSIx, so it reflects in patch 11 of V5.
In V4 you had a minimum value of 8 and because AAC_MAX_MSIX also
is eight your were limiting it to exact 8, that seemed to me as a clear
mistake so I pointed you to that. Your answer was that this
functional change is intended (8 as minimum value instead of 2),
so I asked you for a new patch for the minimum value change.

In your V5 you again use the original range and thus
the split to two patches makes no sense.
As I already wrote, I accepted it as it is (two patches
instead of one is not a big problem)
If you for some reason will post a new series, please
merge 10 and 11.

> 
> Please let me know if you still think I missed something.

For  for future series
- if you wish the upper limit to be 32
change the definition of AAC_MAX_MSIX in aacraid.h
- change the description of the  aac_msi option
from the current description it seems that msi-x is unsupported
- and and important point is - you may add the 'reviewed-by' tag
only if the person actually reviewed your patch and not just commented
or asked you to make some change

Cheers,

tomas


> 
> Thanks,
> 
> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com] 
> Sent: Thursday, July 23, 2015 5:54 AM
> To: Rajinikanth Pandurangan; jbottomley@parallels.com; linux-scsi@vger.kernel.org
> Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Mahesh Rajashekhara; Achim Leubner; Murthy Bhat
> Subject: Re: [PATCH V5 10/11] [SCSI] aacraid: Replace pci_enable_msix() with pci_enable_msix_range()
> 
> On 22.7.2015 18:49, rajinikanth.pandurangan@pmcs.com wrote:
>> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
>>
>> Description:
>>         As pci_enable_msix() deprecated, replaced with 
>> pci_enable_msix_range()
>>
>> V4 Reviewed/commented by:
>> 	Tomas Henzl <thenzl@redhat.com>
>>
>> Changes from V4:
>> 	Changed to 1 as minimum msix range in pci_enable_msix_range() to 
>> match with original code.
> I don't this is correct, your original code hasn't allowed a single msi-x line too, it allowed it in an exact same range <2,8> like it is now with 10+11/11 patch applied.
> It looks like you have decided to not change the minimal supported value in the end, that means that not two but a single patch is preferred. If you for any reason repost your series, please merge
> 10+11 into a single patch.
> I can accept it in the current form too so -
> 
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> 
> Tomas
> 
>>
>> Signed-off-by: Rajinikanth Pandurangan 
>> <rajinikanth.pandurangan@pmcs.com>
>> ---
>>  drivers/scsi/aacraid/comminit.c | 20 ++++++--------------
>>  1 file changed, 6 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/scsi/aacraid/comminit.c 
>> b/drivers/scsi/aacraid/comminit.c index b4b6088..a02cfb3 100644
>> --- a/drivers/scsi/aacraid/comminit.c
>> +++ b/drivers/scsi/aacraid/comminit.c
>> @@ -338,7 +338,7 @@ static int aac_comm_init(struct aac_dev * dev)
>>  
>>  void aac_define_int_mode(struct aac_dev *dev)  {
>> -	int i, msi_count;
>> +	int i, msi_count, min_msix;
>>  
>>  	msi_count = i = 0;
>>  	/* max. vectors from GET_COMM_PREFERRED_SETTINGS */ @@ -366,22 
>> +366,14 @@ void aac_define_int_mode(struct aac_dev *dev)
>>  
>>  	if (msi_count > 1 &&
>>  	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
>> -		i = pci_enable_msix(dev->pdev,
>> +		min_msix = 1;
>> +		i = pci_enable_msix_range(dev->pdev,
>>  				    dev->msixentry,
>> +				    min_msix,
>>  				    msi_count);
>> -		 /* Check how many MSIX vectors are allocated */
>> -		if (i >= 0) {
>> +		if (i > 0) {
>>  			dev->msi_enabled = 1;
>> -			if (i) {
>> -				msi_count = i;
>> -				if (pci_enable_msix(dev->pdev,
>> -				    dev->msixentry,
>> -				    msi_count)) {
>> -					dev->msi_enabled = 0;
>> -					printk(KERN_ERR "%s%d: MSIX not supported!! Will try MSI 0x%x.\n",
>> -							dev->name, dev->id, i);
>> -				}
>> -			}
>> +			msi_count = i;
>>  		} else {
>>  			dev->msi_enabled = 0;
>>  			printk(KERN_ERR "%s%d: MSIX not supported!! Will try MSI 0x%x.\n",
>>
> 

