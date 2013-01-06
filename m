From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH v11 9/9] libata: do not suspend port if normal ODD is
 attached
Date: Sun, 06 Jan 2013 18:34:36 +0400
Message-ID: <50E98B7C.7030908@mvista.com>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com> <1357440509-28108-10-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:64473 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab3AFOen (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jan 2013 09:34:43 -0500
Received: by mail-la0-f42.google.com with SMTP id fe20so13222901lab.1
        for <linux-scsi@vger.kernel.org>; Sun, 06 Jan 2013 06:34:42 -0800 (PST)
In-Reply-To: <1357440509-28108-10-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

Hello.

On 06-01-2013 6:48, Aaron Lu wrote:

> For ODDs, the upper layer will poll for media change every a few
> seconds, which will make it enter and leave suspend state very
> oftern. And as each suspend will also cause a hard/soft reset,

    s/oftern/often/

> the gain of runtime suspend is very little while the ODD may
> mis-function after constantly being reset. So the idle callback
> here will not proceed to suspend if a non-ZPODD capable ODD is
> attached to the port.

> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>   drivers/ata/libata-core.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)

> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 65a362e..f664a90 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5408,8 +5408,27 @@ static int ata_port_resume(struct device *dev)
>   	return rc;
>   }
>
> +/*
> + * For ODDs, the upper layer will poll for media change every a few seconds,
> + * which will make it enter and leave suspend state every a few seconds. And

    Article is not needed before "few". (Same comment to the changelog.)

> + * as each suspend will cause a hard/soft reset, the gain of runtime suspend
> + * is very little and the ODD may mis-function after constantly being reset.

    s/mis-function/malfunction/ perhaps? (Same in the changelog.)

MBR, Sergei

