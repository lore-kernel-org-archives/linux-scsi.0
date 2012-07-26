From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH v3 6/7] scsi: sr: balance sr disk events block depth
Date: Thu, 26 Jul 2012 14:54:01 +0400
Message-ID: <501121C9.7080806@mvista.com>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com> <1343297129-28174-7-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55751 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab2GZKy4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2012 06:54:56 -0400
Received: by lbbgm6 with SMTP id gm6so1369941lbb.19
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jul 2012 03:54:54 -0700 (PDT)
In-Reply-To: <1343297129-28174-7-git-send-email-aaron.lu@amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

Hello.

On 26-07-2012 14:05, Aaron Lu wrote:

> When the ODD is resumed, disk_unblock_events should be called when:
> 1 The ODD is runtime resumed;
> 2 System is resuming from S3 and the ODD is runtime suspended before S3;
> But not when the system is resuming from S3 and the ODD is runtime
> active before S3.

> So seperate the resume calls, one for system resume and one for runtime
> resume to do different things accordingly.

> Signed-off-by: Aaron Lu <aaron.lu@amd.com>
> ---
>   drivers/scsi/sr.c | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)

> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index fd1c2f6..b8c2f9d 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
[...]
> @@ -211,6 +217,21 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
>
>   static int sr_resume(struct device *dev)
>   {
> +	struct scsi_cd *cd = dev_get_drvdata(dev);
> +
> +	/*
> +	 * If ODD is runtime suspended before system pm, unblock disk
> +	 * events now since on system resume, we will fully resume it

    Comma not needed.

> +	 * and set its rumtime status to active.

    s/rumtime/runtime/. Nice typo. %-)

WBR, Sergei

