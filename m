From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Tue, 11 Nov 2014 18:53:04 -0800
Message-ID: <5462CB90.1080303@roeck-us.net>
References: <54629CAE.2000207@laposte.net> <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:47155 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbaKLCxP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2014 21:53:15 -0500
Received: from mailnull by bh-25.webhostbox.net with sa-checked (Exim 4.82)
	(envelope-from <linux@roeck-us.net>)
	id 1XoO3W-000yPq-BH
	for linux-scsi@vger.kernel.org; Wed, 12 Nov 2014 02:53:14 +0000
In-Reply-To: <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>, Barto <mister.freeman@laposte.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joe Perches <joe@perches.com>

On 11/11/2014 04:17 PM, Bjorn Helgaas wrote:
> [+cc Guenter, linux-scsi]
>
> On Tue, Nov 11, 2014 at 4:33 PM, Barto <mister.freeman@laposte.net> wrote:
>> Hello everyone,
>>
>> I notice a bug since kernel 3.17 ( and also with 3.18 branch ), a random
>> hang at boot on some PC configurations, I did a "git bisect" and I found
>> that the culprit is  :
>>
>> [045065d8a300a37218c548e9aa7becd581c6a0e8] [SCSI] fix qemu boot hang problem
>>
>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=045065d8a300a37218c548e9aa7becd581c6a0e8
>>
>> the author of this commit has choosen to inverse the logic of the if
>> statement in the file  drivers/scsi/scsi_lib.c in order to solve an
>> issue with qemu :
>>
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1774,7 +1774,7 @@ static void scsi_request_fn(struct request_queue *q)
>> blk_requeue_request(q, req);
>> atomic_dec(&sdev->device_busy);
>> out_delay:
>> - if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
>> + if (!atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
>> blk_delay_queue(q, SCSI_QUEUE_DELAY);
>> }
>>

The above commit was a follow-up to commit 71e75c97f97a, which did the following:

-       if (sdev->device_busy == 0 && !scsi_device_blocked(sdev))
+       if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))

meaning it reversed the polarity of the check in the original code.
Since that commit created problems as observed in qemu, I thought it
would be obvious that restoring the original polarity would make sense.
This is explained in my patch, so I am somewhat at loss why ...

>> this change triggers a bug on my PC ( I don't have SCSI devices, but
>> only 3 SATA harddisks and 2 IDE harddisks, SATA disks are on an ICH7
>> sata controler on the motherboard gigabyte GA-P31-DS3L, and IDE disk on
>> a JMicron JMB363/368 Sata/IDE PCIe card ), every 5~10 boots the boot
>> stops suddenly because of this commit,
>>
>> If I revert this commit then the bug is gone, more details can be found
>> here, where I created a patch who reverts commit 045065d8 :
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=87581
>>
>> my question: why Guenter Roeck ( the author of the bad commit ) has
>> choosen to inverse the logic in the if statement ?

this question is asked.

Having said that, I don't really care one way or another. I am fine
with reverting my commit; if that is done, I'll simply remove the
related scsi tests from my qemu test runs.

Guenter

>> before his commit the if statement was like this :
>>
>> if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
>> blk_delay_queue(q, SCSI_QUEUE_DELAY);
>>
>> if his decision to inverse the logic of
>> "atomic_read(&sdev->device_busy)" is acceptable then the real bug is
>> probably located elsewhere in the scsi source code, and we must solve
>> this mistery because there is obviously a bug regression in SCSI code
>> because with older kernels ( 3.16.7 and lower ) I don't have the random
>> hang boot bug with my configuration,
>>
>> another user in archlinux forums has also this bug and he has a more
>> modern PC ( intel i7 core cpu, SSD device ), my fear is when linux
>> distros will move to kernel 3.17 then more users will have this weird
>> random bug who can occur only on boot and only with a specific PC
>> configuration, if the boot step is passed despite the random bug then
>> the bug will not occur, it occurs only during the boot process, which
>> probably means that the faulty source code is only called during the
>> boot process,
>>
>> thanks for anyone who wants to dig this problem with me
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>

