From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: Re: [Re: Linux 2.6.28-rc1] scsi 4:0:0:0: timing out command, waited 22s
Date: Fri, 24 Oct 2008 20:43:37 +0200
Message-ID: <8db1092f0810241143l1e5c3ea8g2587a2db452c3b9e@mail.gmail.com>
References: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
	 <1224871587.3307.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:19686 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYJXSnj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2008 14:43:39 -0400
Received: by qw-out-2122.google.com with SMTP id 3so499459qwe.37
        for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2008 11:43:38 -0700 (PDT)
In-Reply-To: <1224871587.3307.19.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>

Thanks for quick response. I added patch, and DVD works OK.

Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index d5b9b72..4b95c43 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -708,7 +708,11 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
>  {
>        struct ata_queued_cmd *qc;
>
> -       qc = ata_qc_new_init(dev, cmd->request->tag);
> +       if (cmd->request->tag != -1)
> +               qc = ata_qc_new_init(dev, cmd->request->tag);
> +       else
> +               qc = ata_qc_new_init(dev, 0);
> +
>        if (qc) {
>                qc->scsicmd = cmd;
>                qc->scsidone = done;
>
>
>


Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
