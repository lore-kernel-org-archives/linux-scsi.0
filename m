From: Maksim Rayskiy <maksim.rayskiy@gmail.com>
Subject: Re: [linux-pm] [RFC] Deferred disk spinup during system resume
Date: Thu, 6 Jan 2011 19:46:43 -0800
Message-ID: <AANLkTimRvxEkU4Pfmp1V1od5drAfAby0j2wt_8iS2KzT@mail.gmail.com>
References: <1294363046-28820-1-git-send-email-maksim.rayskiy@gmail.com>
	<4D2685A1.6020708@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52979 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab1AGDqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2011 22:46:44 -0500
Received: by iwn9 with SMTP id 9so16904268iwn.19
        for <linux-scsi@vger.kernel.org>; Thu, 06 Jan 2011 19:46:43 -0800 (PST)
In-Reply-To: <4D2685A1.6020708@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, tj@kernel.org

>> Okay, I moved EH scheduling to ata_qc_issue(). But since now =A0STAR=
T
>> taskfile is
>> created in ata_eh_maybe_verify() I do not see why the same code has =
to
>> remain in ata_scsi_start_stop_xlat. Does it make sense?
>
> The taskfile you are to pass to the hardware is created in
> atapi_start_stop_xlat(), so you should not create a new taskfile in
> ata_eh_maybe_verify()
>

I can only see that the taskfile is being created in
ata_scsi_translate(). I want START request to return immediately, so I
need to schedule a deferred execution.
Do you suggest I create a new work_struct for this purpose (something
like link->spinup_task)? If I do that, I do not need to use
ata_port_schedule_eh() at all.

Thanks,
Maksim.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
