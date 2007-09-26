From: Jeff Garzik <jeff@garzik.org>
Subject: Re: queued patches for SCSI for 2.6.24
Date: Tue, 25 Sep 2007 22:37:33 -0400
Message-ID: <46F9C5ED.6050505@garzik.org>
References: <1190768402.8707.20.camel@localhost.localdomain>	<20070925065233Q.tomof@acm.org>	<1190770955.8707.23.camel@localhost.localdomain> <20070925073735U.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38943 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbXIZChk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2007 22:37:40 -0400
In-Reply-To: <20070925073735U.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, James.Bottomley@SteelEye.com
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index adc9559..694015d 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -342,6 +342,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
>  	shost->use_clustering = sht->use_clustering;
>  	shost->ordered_tag = sht->ordered_tag;
> +
> +	if (!sht->supported_mode)
> +		sht->supported_mode = MODE_INITIATOR;
> +
>  	shost->active_mode = sht->supported_mode;


I almost hesitate to speak up, after making the original suggestion, but:

Are there any const-ness worries for scsi_host_template, or plans for 
the future?  I do not see any other examples of the host template 
members getting modified.

Perhaps this value should instead be mirrored in scsi_host, like many 
others?

	Jeff


