From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: Queue depth adjustments to scsi-ml
Date: Fri, 18 Sep 2009 18:12:37 -0700
Message-ID: <1253322757.2231.83.camel@vi2.jf.intel.com>
References: <B221F493-51BD-41D6-9F95-99EA7EFF8D5F@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:61466 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752894AbZISBMe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2009 21:12:34 -0400
In-Reply-To: <B221F493-51BD-41D6-9F95-99EA7EFF8D5F@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: vasu.dev@intel.com, Mike Christie <michaelc@cs.wisc.edu>, Andrew Vasquez <andrew.vasquez@qlogic.com>, LinuxSCSI <linux-scsi@vger.kernel.org>

On Fri, 2009-09-18 at 17:11 -0700, Giridhar Malavali wrote:
> Hi Vasu Dev,
> 
> I am trying to apply your patches to test the recent scsi queue depth  
> changes on qla2xxx driver. I see two set of patches submitted on   
> 2009-08-26 and 2009-09-03 at http://marc.info/?l=linux-scsi&w=2&r=1&s=vasu+dev&q=b
> 
> I tried to apply the recent patches ( submitted on 2009-09-03 - 10  
> patches) and it fails.
> 

I rebased my sent patches on current scsi-misc top commit and all
applies cleanly on top of this commit:- 

	commit 338f43ee21f0a3a8fec25526aec21e60b7d30129
	Author: Anil Veerabhadrappa <anilgv@broadcom.com>
	Date:   Fri Sep 11 10:38:26 2009 -0700
	[SCSI] bnx2i: Fix context mapping issue for architectures with
PAGE_SIZE != 4096

Hopefully James will apply these patches soon and that will solve this
issue for you.

> Do I need to pick both sets of patches. In first set of patches I am  
> seeing some of the patches missing ( 1/9, 2/9, 3/9).

I sent only one set of patch and all of them are present at this link
http://marc.info/?a=119828370000006&r=1&w=2 . However later I updated
three patches on this series with their version v2

  1. 2009-09-13  [1] [PATCH 02/10 v2] scsi error: have scsi-ml call
change linux-scs 
  2. 2009-09-10  [1] [PATCH 03/10 v2] drivers: convert drivers setting the linux-scs 
  3. 2009-09-07  [1] [PATCH v2] drivers: convert libfc calling scsi_track_ linux-scs 
	
	Above last one is [PATCH 04/10 v2], I should have used 04/10 prefix in
that one. However I used refid in all v2 patches, so all should be
single thread in your inbox and you need to pick v2 of these patches.

	Ignore all my RFC patches you listed below

> Can u please let me know which patches need to be picked up for  
> testing the changes.
> 

The qla2xx ramp down code is in this patch
http://marc.info/?l=linux-scsi&m=125201657106722&w=2 and Mike sent you
ramp up code patch as attachment. You could append qla2xx ramp up and
down as separate another patch based on pending queue depth patches.

	Vasu

> Thanks,
> Giridhar Malavali
> 
>   24. 2009-09-03  [PATCH 08/10]  
> fcoe,                                   linux-scs Vasu Dev
>   25. 2009-09-03  [PATCH 10/10] zfcp: Adapt change_queue_depth for  
> queu linux-scs Vasu Dev
>   26. 2009-09-03  [PATCH 09/10] libfc: adds queue_depth ramp up to  
> libf linux-scs Vasu Dev
>   27. 2009-09-03  [PATCH 07/10] scsi: add common queue_depth ramp up  
> co linux-scs Vasu Dev
>   28. 2009-09-03  [PATCH 05/10] scsi: updates sdev to add queue_depth  
> r linux-scs Vasu Dev
>   29. 2009-09-03  [PATCH 06/10] scsi: adds sdev->queue_ramp_up_period  
> t linux-scs Vasu Dev
>   30. 2009-09-03  [PATCH 04/10] drivers: convert fc drivers  
> calling     linux-scs Vasu Dev
>   31. 2009-09-03  [PATCH 03/10] drivers: convert drivers setting the  
> ch linux-scs Vasu Dev
>   32. 2009-09-03  [PATCH 02/10] scsi error: have scsi-ml call  
> change_qu linux-scs Vasu Dev
>   33. 2009-09-03  [PATCH 01/10] scsi-ml: modify change_queue_depth to  
> t linux-scs Vasu Dev
>   34. 2009-09-03  [PATCH 00/10] handles queue_depth adjustments in  
> scsi linux-scs Vasu Dev
> 
> _____
> 
>   49. 2009-08-26  [RFC PATCH 6/9] scsi: adds sdev- 
>  >queue_ramp_up_period linux-scs Vasu Dev
>   50. 2009-08-26  [RFC PATCH 9/9] libfc: adds queue_depth ramp up to  
> li linux-scs Vasu Dev
>   51. 2009-08-26  [RFC PATCH 8/9]  
> fcoe,                                 linux-scs Vasu Dev
>   52. 2009-08-26  [RFC PATCH 7/9] scsi: add common queue_depth ramp  
> up  linux-scs Vasu Dev
>   53. 2009-08-26  [RFC PATCH 5/9] scsi: updates sdev to add  
> queue_depth linux-scs Vasu Dev
>   54. 2009-08-26  [RFC PATCH 4/9] drivers: convert fc drivers  
> calling   linux-scs Vasu Dev
>   55. 2009-08-26  [RFC PATCH 0/9] RFC: handle queue_depth adjustments  
> b linux-scs Vasu Dev
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

