From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/6] cxlflash: Remove the device cleanly in the system
 shutdown path
Date: Tue, 6 Sep 2016 15:06:12 -0500
Message-ID: <155be261-b2e5-c408-81e9-59634bd7bf95@linux.vnet.ibm.com>
References: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1472848756-64998-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <609a0eff-d4e4-03ea-739f-770fc24860ef@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755342AbcIFUGR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2016 16:06:17 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u86K4Gxe146354
        for <linux-scsi@vger.kernel.org>; Tue, 6 Sep 2016 16:06:16 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25a0y6k2c0-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 06 Sep 2016 16:06:16 -0400
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Tue, 6 Sep 2016 16:06:15 -0400
In-Reply-To: <609a0eff-d4e4-03ea-739f-770fc24860ef@au1.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>



On 9/5/2016 2:12 AM, Andrew Donnellan wrote:
> On 03/09/16 06:39, Uma Krishnan wrote:
>> Commit 704c4b0ddc03 ("cxlflash: Shutdown notify support for CXL Flash
>> cards") was recently introduced to notify the AFU when a system is going
>> down. Due to the position of the cxlflash driver in the device stack,
>> cxlflash devices are _always_ removed during a reboot/shutdown. This can
>> lead to a crash if the cxlflash shutdown hook is invoked _after_ the
>> shutdown hook for the owning virtual PHB. Furthermore, the current
>> implementation of shutdown/remove hooks for cxlflash are not tolerant to
>> being invoked when the device is not enabled. This can also lead to a
>> crash in situations where the remove hook is invoked after the device has
>> been removed via the vPHBs shutdown hook. An example of this scenario
>> would be an EEH reset failure while a reboot/shutdown is in progress.
>>
>> To solve both problems, the shutdown hook for cxlflash is updated to
>> simply remove the device. This path already includes the AFU notification
>> and thus this solution will continue to perform the original intent. At
>> the same time, the remove hook is updated to protect against being
>> called when the device is not enabled.
>>
>> Fixes: 704c4b0ddc03 ("cxlflash: Shutdown notify support for CXL Flash
>> cards")
>> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
>> ---
>>  drivers/scsi/cxlflash/main.c | 18 ++++++------------
>>  1 file changed, 6 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
>> index b063c41..4c2559a 100644
>> --- a/drivers/scsi/cxlflash/main.c
>> +++ b/drivers/scsi/cxlflash/main.c
>> @@ -823,17 +823,6 @@ static void notify_shutdown(struct cxlflash_cfg
>> *cfg, bool wait)
>>  }
>>
>>  /**
>> - * cxlflash_shutdown() - shutdown handler
>> - * @pdev:    PCI device associated with the host.
>> - */
>> -static void cxlflash_shutdown(struct pci_dev *pdev)
>> -{
>> -    struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
>> -
>> -    notify_shutdown(cfg, false);
>
> You can get rid of the second parameter to notify_shutdown() now.
>

Valid comment. This was considered while working the patch. I left it
for now, in case we need this flag in future. If we end up not having
to use it, I will clean it up in a future patch.

>> -}
>> -
>> -/**
>>   * cxlflash_remove() - PCI entry point to tear down host
>>   * @pdev:    PCI device associated with the host.
>>   *
>> @@ -844,6 +833,11 @@ static void cxlflash_remove(struct pci_dev *pdev)
>>      struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
>>      ulong lock_flags;
>>
>> +    if (!pci_is_enabled(pdev)) {
>> +        pr_debug("%s: Device is disabled\n", __func__);
>> +        return;
>> +    }
>> +
>>      /* If a Task Management Function is active, wait for it to complete
>>       * before continuing with remove.
>>       */
>> @@ -2685,7 +2679,7 @@ static struct pci_driver cxlflash_driver = {
>>      .id_table = cxlflash_pci_table,
>>      .probe = cxlflash_probe,
>>      .remove = cxlflash_remove,
>> -    .shutdown = cxlflash_shutdown,
>> +    .shutdown = cxlflash_remove,
>
> What's the justification for using cxlflash_remove() as the shutdown
> hook, rather than just not having a shutdown hook at all?
>

Even though cxlflash gets cleaned up via cxl_remove() shutdown
hook, today it is a dependency on the code external to our driver.
To protect us from future API changes that could possibly impact
cxlflash, we want to maintain a clean and reliable way to get
called in the shutdown path.

