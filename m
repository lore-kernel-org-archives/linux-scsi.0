Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4C6C5DF61
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 06:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87560218AE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 06:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfKGGoS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 01:44:18 -0500
Received: from smtp.infotech.no ([82.134.31.41]:34353 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfKGGoR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Nov 2019 01:44:17 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2ABA6204196;
        Thu,  7 Nov 2019 07:44:13 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yFCgbBxVydWo; Thu,  7 Nov 2019 07:44:11 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id A676C204190;
        Thu,  7 Nov 2019 07:44:10 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] tracing: Fix handling of TRANSFER LENGTH == 0 for READ(6)
 and WRITE(6)
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>
References: <20191105215553.185018-1-bvanassche@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <23e0bd60-649f-9323-ad5d-bfd4b54e7b64@interlog.com>
Date:   Thu, 7 Nov 2019 01:44:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105215553.185018-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-05 4:55 p.m., Bart Van Assche wrote:
> According to SBC-2 a TRANSFER LENGTH field of zero means that 256 logical
> blocks must be transferred. Make the SCSI tracing code follow SBC-2.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Fixes: bf8162354233 ("[SCSI] add scsi trace core functions and put trace points")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_trace.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
> index 784ed9a32a0d..ac35c301c792 100644
> --- a/drivers/scsi/scsi_trace.c
> +++ b/drivers/scsi/scsi_trace.c
> @@ -18,15 +18,18 @@ static const char *
>   scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
>   {
>   	const char *ret = trace_seq_buffer_ptr(p);
> -	sector_t lba = 0, txlen = 0;
> +	u32 lba = 0, txlen;
>   
>   	lba |= ((cdb[1] & 0x1F) << 16);
>   	lba |=  (cdb[2] << 8);
>   	lba |=   cdb[3];
> -	txlen = cdb[4];
> +	/*
> +	 * From SBC-2: a TRANSFER LENGTH field set to zero specifies that 256
> +	 * logical blocks shall be read (READ(6)) or written (WRITE(6)).
> +	 */
> +	txlen = cdb[4] ? cdb[4] : 256;
>   
> -	trace_seq_printf(p, "lba=%llu txlen=%llu",
> -			 (unsigned long long)lba, (unsigned long long)txlen);
> +	trace_seq_printf(p, "lba=%u txlen=%u", lba, txlen);
>   	trace_seq_putc(p, 0);
>   
>   	return ret;
> 

