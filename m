From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata & scsi error handling
Date: Tue, 17 Aug 2004 22:08:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4122BA04.3070705@pobox.com>
References: <4122771A.4070203@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:19628 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268576AbUHRCIU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 22:08:20 -0400
In-Reply-To: <4122771A.4070203@wasp.net.au>
List-Id: linux-scsi@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Brad Campbell wrote:
> I think I have this timeout error issue pegged now.
> 
> I know this is both wrong, ugly and likely to cause internal kernel 
> damage, but for the purpose of pegging what I think may be the culprit 
> it works around the error nicely here
> 
> brad@srv:/usr/src$ diff -u temp/linux-2.6.8.1/drivers/scsi/libata-scsi.c 
> linux-2.6.8.1/drivers/scsi/libata-scsi.c
> --- temp/linux-2.6.8.1/drivers/scsi/libata-scsi.c       2004-08-14 
> 14:55:19.000000000 +0400
> +++ linux-2.6.8.1/drivers/scsi/libata-scsi.c    2004-08-18 
> 01:04:11.000000000 +0400
> @@ -213,6 +213,7 @@
> 
>         ap = (struct ata_port *) &host->hostdata[0];
>         ap->ops->eng_timeout(ap);
> +       host->host_failed--;
> 
>         DPRINTK("EXIT\n");
>         return 0;
> 
> The issue is that the libata installed eh_strategy_handler does not 
> complete the error as
> scsi_unjam_host -> scsi_eh_abort_cmds -> scsi_eh_finish_cmd does.


Well, well, well.  If I had a libata Honorary Hacker merit badge, I 
would give it to you.

It is highly likely that your patch is doing the right thing.  Doug 
Ledford, 2.4.x SCSI maintainer, pointed out to me recently that my 2.4.x 
error handling code MUST update a couple variables, otherwise error 
handling would hang as you see.  The reason is that scsi_unjam_host(), 
on both 2.4.x and 2.6.x, is the only ->eh_strategy_handler until libata 
came along.

So, it is likely that there are a few details the scsi_unjam_host() 
performs, that needs to do too.

Thanks much for your excellent detective work, I'll see where to best 
put this change...


	Jeff

