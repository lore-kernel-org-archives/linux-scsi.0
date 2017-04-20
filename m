From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH-v1 11/22] Fix driver unload/reload operation.
Date: Thu, 20 Apr 2017 09:08:31 +0000
Message-ID: <30ec21eb-9da1-bff1-9bf1-0f9165a8e988@ce.jp.nec.com>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420044641.10657-12-jsmart2021@gmail.com>
 <20170420073712.GL6217@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tyo161.gate.nec.co.jp ([114.179.232.161]:34893 "EHLO
        tyo161.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940234AbdDTJL1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 05:11:27 -0400
In-Reply-To: <20170420073712.GL6217@linux-x5ow.site>
Content-Language: ja-JP
Content-ID: <08D4A5533C5A7145B62BE4C95F8F152D@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "jsmart2021@gmail.com" <jsmart2021@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 04/20/17 16:37, Johannes Thumshirn wrote:
> On Wed, Apr 19, 2017 at 09:46:30PM -0700, jsmart2021@gmail.com wrote:
>> From: James Smart <jsmart2021@gmail.com>
>>
>> There are couple of different load/unload issues fixed with this patch.
>> One of the issues was reported by Junichi Nomura, a patch was submitted
>> by Johannes Thumsrhirn which did fix one of the problems but the fix in
>> this patch separates the pring free from the queue free and does not set
>> the parameter passed in to NULL.
>>
>> issues:
>> (1) driver could not be unloaded and reloaded without some Oops or
>>  Panic occurring.
>> (2) The driver was panicking because of a corruption in the Memory
>> Manager when the iocb list was getting allocated.
>>
>> Root cause for the memory corruption was a double free of the Work Queue
>> ring pointer memory - Freed once in the lpfc_sli4_queue_free when the CQ
>> was destroyed and again in lpfc_sli4_queue_free when the WQ was destroyed.
>>
>> The pring free and the queue free were separated, the pring free was moved
>> to the wq destroy routine because it a better fit logically to delete the
>> ring with the wq.
>>
>> The checkpatch flagged several alignmenet issues that were also corrected
>> with this patch.
>>
>> The mboxq was never initialed correctly before it was used by the driver
>> this patch corrects that issue.
>>
>> Reported-by: Junichi Nomura <j-nomura@ce.jp.nec.com>
>> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
>> Signed-off-by: James Smart <james.smart@broadcom.com>
>> ---
> 
> Looks good,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> 
> But I'd really like to see a Tested-by from Junichi here.

Thank you for Cc-ing to me.

I tested the patch on top of v4.11-rc7 and confirmed the reported
problem doesn't occur. So,
  Tested-by: Junichi Nomura <j-nomura@ce.jp.nec.com>

-- 
Jun'ichi Nomura, NEC Corporation / NEC Solution Innovators, Ltd.
