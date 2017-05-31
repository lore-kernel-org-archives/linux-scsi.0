From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: Fix crash on PCI hotplug remove path
Date: Wed, 31 May 2017 09:55:47 -0700
Message-ID: <4389ae0e-98bd-441e-9768-231d9d31ca39@broadcom.com>
References: <20170528214554.24336-1-gpiccoli@linux.vnet.ibm.com>
 <ad52a01e-8b2c-6ca8-3d63-c76d9c144ba6@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:35930 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdEaQzy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 12:55:54 -0400
Received: by mail-pg0-f54.google.com with SMTP id x64so10532283pgd.3
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2017 09:55:54 -0700 (PDT)
In-Reply-To: <ad52a01e-8b2c-6ca8-3d63-c76d9c144ba6@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: raphasil@linux.vnet.ibm.com, dick.kennedy@broadcom.com, jsmart2021@gmail.com, porcusbr@gmail.com

Actually, I think we solved this in a better manner in this patch in the 
11.4.0.0 patch set:
   PATCH 10/15] lpfc: Fix crash on powering off BFS VM with passthrough 
device
   http://marc.info/?l=linux-scsi&m=149621070910290&w=2

See if the above patch fixes your error.

-- james



On 5/29/2017 4:11 PM, James Smart wrote:
> looks good
>
> Signed-off-by: James Smart  <james.smart@broadcom.com>
>
> -- james
>
>
>
> On 5/28/2017 2:45 PM, Guilherme G. Piccoli wrote:
>> During a PCI hotplug remove event we could have a NULL pointer
>> dereference on lpfc_sli_abort_iocb(), if pring is NULL. This
>> patch adds a check for this case and is able to circumvent the
>> failure and continue the hotplug remove process with success.
>>
>> This issue was introduced after the driver refactor made on
>> commit 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications").
>>
>> Fixes: 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications")
>> Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
>> Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
>> ---
>> This patch was rebased against Martin's 4.12/scsi-fixes.
>>
>>
>
