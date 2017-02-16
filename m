From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 10/16] aacraid: Terminate kthread on controller fw assert
Date: Thu, 16 Feb 2017 10:31:00 +0100
Message-ID: <2b400849-db1a-4109-37f2-cd00fc1ccc85@suse.de>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-11-RaghavaAditya.Renukunta@microsemi.com>
 <9d502c4a-a3ad-352e-c3d0-2d08042c5f1b@suse.de>
 <4D8E82A446BF54499747901DBDEB737A7B8C1F6F@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38271 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751583AbdBPJbC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 04:31:02 -0500
In-Reply-To: <4D8E82A446BF54499747901DBDEB737A7B8C1F6F@avsrvexchmbx2.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>

On 02/15/2017 11:22 PM, Raghava Aditya Renukunta wrote:
>>
>> This look a bit scary. Can't the kthread be converted to a workqueue so
>> we could call cancel_work_sync()?
> 
> Could you please elaborate on the reasons why this fix is scary?
> I understand that killing a thread is not standard (for any reason), 
> and if there are other nuanced issues I would like to understand them.

I'm actually concerned that this could have all kinds of side effects.
But this is just a gut feeling. I see some drm drivers are doing the
same, so it might be possible, but IMHO this is not a good design.

And IIRC kthreads do have more downsides (i.e. CPU hotplugging and
issues with kernel live patching).

I think most kthreads (haven't looked too close to the aacraid kthread I
must admit, but I'll be doing so) can be converted to either workqueues
or timers (or a combination of both).

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
