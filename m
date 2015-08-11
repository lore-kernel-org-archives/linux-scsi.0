From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] scsi: Fixup fixed sense generation
Date: Tue, 11 Aug 2015 09:49:26 +0300
Message-ID: <55C99AF6.5080601@dev.mellanox.co.il>
References: <1438347903-106697-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34889 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbbHKGta (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 02:49:30 -0400
Received: by wicne3 with SMTP id ne3so48038546wic.0
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2015 23:49:29 -0700 (PDT)
In-Reply-To: <1438347903-106697-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>


> -		put_unaligned_be64(info, &buf[3]);
> +		/*
> +		 * Fixed format sense reserves only 32 bits for the
> +		 * 'information' field
> +		 */
> +		put_unaligned_be32((u32)info, &buf[3]);
>   	}
>   }
>   EXPORT_SYMBOL(scsi_set_sense_information);
>

Hannes,

This bit is handled in "scsi: Fix sense information setting in fixed 
sized format"
see http://permalink.gmane.org/gmane.linux.scsi/103115

Can you make it incremental to this patch?

James, I don't see it on the scsi tree, can you pick it up?

Sagi.
