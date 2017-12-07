From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v3 0/2] Ensure that the SCSI error handler gets woken up
Date: Thu, 7 Dec 2017 12:02:07 +0000
Message-ID: <d408dd47-1706-c448-2b74-cbc91a5f90da@huawei.com>
References: <20171204180624.18722-1-bart.vanassche@wdc.com>
 <yq1o9nbxpx4.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:40089 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753066AbdLGMCe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Dec 2017 07:02:34 -0500
In-Reply-To: <yq1o9nbxpx4.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@wdc.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Linuxarm <linuxarm@huawei.com>

On 07/12/2017 01:55, Martin K. Petersen wrote:
>
> Bart,
>
>> As reported by Pavel Tikhomirov it can happen that the SCSI error
>> handler does not get woken up. This is very annoying because it
>> results in a queue stall. The two patches in this series address this
>> issue without acquiring the SCSI host lock in the hot path. Please
>> consider these patches for kernel v4.16.
>
> Applied to 4.16/scsi-queue. Thank you!
>

Is anyone finding a build error for this patch? I built allmodconfig on 
Martin's 4.16/scsi-queue and I get this:
ERROR: "init_rcu_head" [drivers/scsi/scsi_mod.ko] undefined!
ERROR: "destroy_rcu_head" [drivers/scsi/scsi_mod.ko] undefined!

Reverting fixes it.

 From a quick check, it seems the rcu funcitons are not exported, and 
SCSI=m means hosts.c cannot reference it.

Cheers,
John
