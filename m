From: "dbasehore ." <dbasehore@chromium.org>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
Date: Thu, 31 Jan 2013 14:00:09 -0800
Message-ID: <CAGAzgso4cJHM+CNV0nCu6zUmq=xUstbsguynUp+hyx581LcHJg@mail.gmail.com>
References: <1356064540-17414-1-git-send-email-dbasehore@chromium.org>
	<50D5C473.2030902@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:34874 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3AaWAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2013 17:00:09 -0500
Received: by mail-oa0-f41.google.com with SMTP id i10so3605347oag.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Jan 2013 14:00:09 -0800 (PST)
In-Reply-To: <50D5C473.2030902@mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: JBottomley@parallels.com, jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

(Resending as plain text so the message is tracked on vger)

Hi, thanks for reading through my patch.

With regards to SCSI_SENSE_BUFFERSIZE, I'm following the precedent of
scsi_execute_req found in drivers/scsi/scsi_lib.c

It seems that it is used by the scsi_normalize_sense function which I
call in sd_resume_async. I just input SCSI_SENSE_BUFFERSIZE directly
there though. I didn't know if anything would change its behavior on a
lower level if I made sense_len = SCSI_SENSE_BUFFERSIZE, so I just
went with what was already done.

I'll make sure the semantic fixes go into the final patch.

Also, I forgot to mention one possible problem earlier. I understand
that some hard drives have a command buffer that can be executed by
the hard drive in an order it determines. Does anyone know of a
potential problem if the following happens?

-resume finishes (hard drive not started yet)
-read/write sent to disk, inserted before start command

Could this happen? If so, could it cause any problems?

I've tested the possibility of a program trying to read/write from the
disk before it has started, and the read/write blocks until the disk
has actually been spun up. I don't know if there are specific hard
drives where this could be a problem though.
