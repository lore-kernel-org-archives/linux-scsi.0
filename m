From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Tue, 11 Nov 2014 17:17:17 -0700
Message-ID: <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com>
References: <54629CAE.2000207@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:46872 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaKLARi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2014 19:17:38 -0500
Received: by mail-qa0-f53.google.com with SMTP id n8so7707631qaq.40
        for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2014 16:17:38 -0800 (PST)
In-Reply-To: <54629CAE.2000207@laposte.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Barto <mister.freeman@laposte.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Guenter Roeck <linux@roeck-us.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

[+cc Guenter, linux-scsi]

On Tue, Nov 11, 2014 at 4:33 PM, Barto <mister.freeman@laposte.net> wrote:
> Hello everyone,
>
> I notice a bug since kernel 3.17 ( and also with 3.18 branch ), a random
> hang at boot on some PC configurations, I did a "git bisect" and I found
> that the culprit is  :
>
> [045065d8a300a37218c548e9aa7becd581c6a0e8] [SCSI] fix qemu boot hang problem
>
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=045065d8a300a37218c548e9aa7becd581c6a0e8
>
> the author of this commit has choosen to inverse the logic of the if
> statement in the file  drivers/scsi/scsi_lib.c in order to solve an
> issue with qemu :
>
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1774,7 +1774,7 @@ static void scsi_request_fn(struct request_queue *q)
> blk_requeue_request(q, req);
> atomic_dec(&sdev->device_busy);
> out_delay:
> - if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
> + if (!atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
> blk_delay_queue(q, SCSI_QUEUE_DELAY);
> }
>
> this change triggers a bug on my PC ( I don't have SCSI devices, but
> only 3 SATA harddisks and 2 IDE harddisks, SATA disks are on an ICH7
> sata controler on the motherboard gigabyte GA-P31-DS3L, and IDE disk on
> a JMicron JMB363/368 Sata/IDE PCIe card ), every 5~10 boots the boot
> stops suddenly because of this commit,
>
> If I revert this commit then the bug is gone, more details can be found
> here, where I created a patch who reverts commit 045065d8 :
>
> https://bugzilla.kernel.org/show_bug.cgi?id=87581
>
> my question: why Guenter Roeck ( the author of the bad commit ) has
> choosen to inverse the logic in the if statement ?
> before his commit the if statement was like this :
>
> if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
> blk_delay_queue(q, SCSI_QUEUE_DELAY);
>
> if his decision to inverse the logic of
> "atomic_read(&sdev->device_busy)" is acceptable then the real bug is
> probably located elsewhere in the scsi source code, and we must solve
> this mistery because there is obviously a bug regression in SCSI code
> because with older kernels ( 3.16.7 and lower ) I don't have the random
> hang boot bug with my configuration,
>
> another user in archlinux forums has also this bug and he has a more
> modern PC ( intel i7 core cpu, SSD device ), my fear is when linux
> distros will move to kernel 3.17 then more users will have this weird
> random bug who can occur only on boot and only with a specific PC
> configuration, if the boot step is passed despite the random bug then
> the bug will not occur, it occurs only during the boot process, which
> probably means that the faulty source code is only called during the
> boot process,
>
> thanks for anyone who wants to dig this problem with me
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
