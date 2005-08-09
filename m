From: Jon Scottorn <jscottorn@possibilityforge.com>
Subject: Re: Adaptec i2o controller
Date: Tue, 09 Aug 2005 12:13:37 -0600
Message-ID: <42F8F251.5000902@possibilityforge.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0168461E@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.possibilityforge.com ([209.33.206.30]:21197 "EHLO
	possibilityforge.com") by vger.kernel.org with ESMTP
	id S964910AbVHISN5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 14:13:57 -0400
Received: from dev.possibilityforge.com ([209.33.206.3])
	by  with esmtp (Exim 4.50)
	id 1E2Ybh-0001ik-1P
	for linux-scsi@vger.kernel.org; Tue, 09 Aug 2005 12:13:53 -0600
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F0168461E@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Ok, I have got it to compile and I have installed it.  I reboot and I
still get the same error I initially had, the kernel panic error. 

Any other suggestion that I could try?

Thanks,

Jon

Salyzyn, Mark wrote:

>There is an additional 'build fix' patch that Andrew Morton submitted on
>the kernel list (I have changed out his dpr_i2o with dpt_i2o below
>though).
>
>---------------------------------------------------
>Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
>Cc: James Bottomley <James.Bottomley@steeleye.com>
>Signed-off-by: Andrew Morton <akpm@osdl.org>
>---
>
> drivers/scsi/dpt_i2o.c |    2 +-
> 1 files changed, 1 insertion(+), 1 deletion(-)
>
>diff -puN drivers/scsi/dpt_i2o.c~dpt_i2o-build-fix
>drivers/scsi/dpt_i2o.c
>--- devel/drivers/scsi/dpt_i2o.c~dpt_i2o-build-fix	2005-08-09
>00:18:51.000000000 -0700
>+++ devel-akpm/drivers/scsi/dpt_i2o.c	2005-08-09 00:19:02.000000000
>-0700
>@@ -907,7 +907,7 @@ static int adpt_install_hba(struct scsi_
> 		raptorFlag = TRUE;
> 	}
> 
>-	if (pci_request_regions(pDev)) {
>+	if (pci_request_regions(pDev, "dpt_i2o")) {
> 		PERROR("dpti: adpt_config_hba: pci request region
>failed\n");
> 		return -EINVAL;
> 	}
>_
>------------------------------------------------------------------------
>-
>Sincerely -- Mark Salyzyn
>
>-----Original Message-----
>From: linux-scsi-owner@vger.kernel.org
>[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jon Scottorn
>Sent: Tuesday, August 09, 2005 12:47 PM
>To: unlisted-recipients
>Cc: SCSI Mailing List
>Subject: Re: Adaptec i2o controller
>
>Thanks for the replies,
>
>      After applying the patch, Now I get a compile error
>
>drivers/scsi/dpt_i2o.c: In function `adpt_install_hba':
>drivers/scsi/dpt_i2o.c:908: error: too few arguments to function
>`pci_request_regions'
>drivers/scsi/dpt_i2o.c: In function `adpt_isr':
>drivers/scsi/dpt_i2o.c:2037: warning: passing arg 1 of `readl' makes
>pointer from integer without a cast
>drivers/scsi/dpt_i2o.c:2038: warning: passing arg 1 of `readl' makes
>pointer from integer without a cast
>drivers/scsi/dpt_i2o.c:2049: warning: passing arg 1 of `readl' makes
>pointer from integer without a cast
>drivers/scsi/dpt_i2o.c:2050: warning: passing arg 2 of `writel' makes
>pointer from integer without a cast
>drivers/scsi/dpt_i2o.c:2053: warning: passing arg 1 of `readl' makes
>pointer from integer without a cast
>drivers/scsi/dpt_i2o.c:2055: warning: passing arg 1 of `readl' makes
>pointer from integer without a cast
>drivers/scsi/dpt_i2o.c:2062: warning: passing arg 1 of `readl' makes
>pointer from integer without a cast
>drivers/scsi/dpt_i2o.c:2069: warning: passing arg 1 of `readl' makes
>pointer from integer without a cast
>drivers/scsi/dpt_i2o.c:2076: warning: passing arg 1 of `readl' makes
>pointer from integer without a cast
>drivers/scsi/dpt_i2o.c: In function `adpt_i2o_to_scsi':
>drivers/scsi/dpt_i2o.c:2246: warning: passing arg 1 of `readl' makes
>pointer from integer without a cast
>drivers/scsi/dpt_i2o.c:2250: warning: passing arg 1 of `readl' makes
>pointer from integer without a cast
>drivers/scsi/dpt_i2o.c:2255: warning: passing arg 1 of `readl' makes
>pointer from integer without a cast
>drivers/scsi/dpt_i2o.c:2266: warning: passing arg 1 of `readl' makes
>pointer from integer without a cast
>drivers/scsi/dpt_i2o.c: At top level:
>drivers/scsi/dpt_i2o.c:171: warning: `dptids' defined but not used
>make[3]: *** [drivers/scsi/dpt_i2o.o] Error 1
>make[2]: *** [drivers/scsi] Error 2
>make[1]: *** [drivers] Error 2
>
>and I do have only one option selected in the .config file.
>
>Any other thoughts?
>
>Thanks,
>
>Jon
>
>Salyzyn, Mark wrote:
>
>  
>
>>This dpt_i2o patch *plus* the patch Markus submitted yesterday for the
>>i2o driver to the kernel list need to be performed to create the mutual
>>exclusion between the two drivers.
>>
>>Jon, just select one (CONFIG_SCSI_DPT_I2O) or the other (CONFIG_I2O) in
>>your .config
>>
>>Sincerely -- Mark Salyzyn
>>
>>-----Original Message-----
>>From: linux-scsi-owner@vger.kernel.org
>>[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
>>Sent: Tuesday, August 09, 2005 12:11 PM
>>To: Jon Scottorn
>>Cc: SCSI Mailing List
>>Subject: Re: Adaptec i2o controller
>>
>>On Tue, 2005-08-09 at 09:59 -0600, Jon Scottorn wrote:
>> 
>>
>>    
>>
>>> I have been running a 2.6.8 kernel with the adaptec i2o scsi
>>>controller and I went to upgrade to the 2.6.12.4 kernel and when I
>>>reboot into that kernel I get a kernel panic. I am wondering either
>>>   
>>>
>>>      
>>>
>>what
>> 
>>
>>    
>>
>>>I have done wrong or what has changed with the i2o driver between the
>>>two kernels. 
>>>Here is the error I get, I am summarizing because I have to type the
>>>error in.
>>>
>>>EIP is at adpt_isr+0x175/0x1f2
>>>then has a stack and call trace:
>>>(#0001,*0):c01035b2 oops
>>>kernel panic - not syncing: Fatal exception in interrupt
>>>   
>>>
>>>      
>>>
>>Could you try out the patch in this email:
>>
>>http://marc.theaimsgroup.com/?l=linux-scsi&m=112351014310129
>>
>>Thanks,
>>
>>James
>>
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>>    
>>
>in
>  
>
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> 
>>
>>    
>>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>
