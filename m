From: Barto <mister.freeman@laposte.net>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Thu, 13 Nov 2014 04:28:01 +0100
Message-ID: <54642541.9080302@laposte.net>
References: <54629CAE.2000207@laposte.net> <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com> <5462CB90.1080303@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5462CB90.1080303@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>, Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

reverting your commit 045065d8a300a37218c is a solution, but it's just =
a
temporary solution,

it's better to search why your commit can create a random hang on boot
on some PC configurations,

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1774,7 +1774,7 @@ static void scsi_request_fn(struct request_queue =
*q)
blk_requeue_request(q, req);
atomic_dec(&sdev->device_busy);
out_delay:
- if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
+ if (!atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
blk_delay_queue(q, SCSI_QUEUE_DELAY);
}

perhaps the atomic_read() function doesn't make the expected job on som=
e
rare circonstances, I have the same doubts about the blk_delay_queue()
function


Le 12/11/2014 03:53, Guenter Roeck a =C3=A9crit :> On 11/11/2014 04:17 =
PM,
Bjorn Helgaas wrote:
>> [+cc Guenter, linux-scsi]
>>
>> On Tue, Nov 11, 2014 at 4:33 PM, Barto <mister.freeman@laposte.net>
>> wrote:
>>> Hello everyone,
>>>
>>> I notice a bug since kernel 3.17 ( and also with 3.18 branch ), a r=
andom
>>> hang at boot on some PC configurations, I did a "git bisect" and I =
found
>>> that the culprit is  :
>>>
>>> [045065d8a300a37218c548e9aa7becd581c6a0e8] [SCSI] fix qemu boot han=
g
>>> problem
>>>
>>>
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D045065d8a300a37218c548e9aa7becd581c6a0e8
>>>
>>>
>>> the author of this commit has choosen to inverse the logic of the i=
f
>>> statement in the file  drivers/scsi/scsi_lib.c in order to solve an
>>> issue with qemu :
>>>
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -1774,7 +1774,7 @@ static void scsi_request_fn(struct
>>> request_queue *q)
>>> blk_requeue_request(q, req);
>>> atomic_dec(&sdev->device_busy);
>>> out_delay:
>>> - if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev)=
)
>>> + if (!atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev=
))
>>> blk_delay_queue(q, SCSI_QUEUE_DELAY);
>>> }
>>>
>
> The above commit was a follow-up to commit 71e75c97f97a, which did th=
e
> following:
>
> -       if (sdev->device_busy =3D=3D 0 && !scsi_device_blocked(sdev))
> +       if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(s=
dev))
>
> meaning it reversed the polarity of the check in the original code.
> Since that commit created problems as observed in qemu, I thought it
> would be obvious that restoring the original polarity would make sens=
e.
> This is explained in my patch, so I am somewhat at loss why ...
>
>>> this change triggers a bug on my PC ( I don't have SCSI devices, bu=
t
>>> only 3 SATA harddisks and 2 IDE harddisks, SATA disks are on an ICH=
7
>>> sata controler on the motherboard gigabyte GA-P31-DS3L, and IDE dis=
k on
>>> a JMicron JMB363/368 Sata/IDE PCIe card ), every 5~10 boots the boo=
t
>>> stops suddenly because of this commit,
>>>
>>> If I revert this commit then the bug is gone, more details can be f=
ound
>>> here, where I created a patch who reverts commit 045065d8 :
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D87581
>>>
>>> my question: why Guenter Roeck ( the author of the bad commit ) has
>>> choosen to inverse the logic in the if statement ?
>
> this question is asked.
>
> Having said that, I don't really care one way or another. I am fine
> with reverting my commit; if that is done, I'll simply remove the
> related scsi tests from my qemu test runs.
>
> Guenter
>
>>> before his commit the if statement was like this :
>>>
>>> if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
>>> blk_delay_queue(q, SCSI_QUEUE_DELAY);
>>>
>>> if his decision to inverse the logic of
>>> "atomic_read(&sdev->device_busy)" is acceptable then the real bug i=
s
>>> probably located elsewhere in the scsi source code, and we must sol=
ve
>>> this mistery because there is obviously a bug regression in SCSI co=
de
>>> because with older kernels ( 3.16.7 and lower ) I don't have the ra=
ndom
>>> hang boot bug with my configuration,
>>>
>>> another user in archlinux forums has also this bug and he has a mor=
e
>>> modern PC ( intel i7 core cpu, SSD device ), my fear is when linux
>>> distros will move to kernel 3.17 then more users will have this wei=
rd
>>> random bug who can occur only on boot and only with a specific PC
>>> configuration, if the boot step is passed despite the random bug th=
en
>>> the bug will not occur, it occurs only during the boot process, whi=
ch
>>> probably means that the faulty source code is only called during th=
e
>>> boot process,
>>>
>>> thanks for anyone who wants to dig this problem with me
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>
