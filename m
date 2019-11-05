Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B10CCA9EC7
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 06:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 473EC2084D
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 06:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbfKEGDd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 01:03:33 -0500
Received: from smtp.infotech.no ([82.134.31.41]:53572 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730453AbfKEGDd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Nov 2019 01:03:33 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 8B93020414D;
        Tue,  5 Nov 2019 07:03:32 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kyejSwwHxviu; Tue,  5 Nov 2019 07:03:31 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 315D220423D;
        Tue,  5 Nov 2019 07:03:30 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 37/52] scsi_debug: use scsi_build_sense()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-38-hare@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <43f15ef8-7910-e498-c0b3-6aa5072388e4@interlog.com>
Date:   Tue, 5 Nov 2019 01:03:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-38-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-04 4:01 a.m., Hannes Reinecke wrote:
> Use scsi_build_sense() to format the sense code.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index d323523f5f9d..72f10e631ff4 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -779,7 +779,7 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *scp,
>   	}
>   	asc = c_d ? INVALID_FIELD_IN_CDB : INVALID_FIELD_IN_PARAM_LIST;
>   	memset(sbuff, 0, SCSI_SENSE_BUFFERSIZE);
> -	scsi_build_sense_buffer(sdebug_dsense, sbuff, ILLEGAL_REQUEST, asc, 0);
> +	scsi_build_sense(scp, sdebug_dsense, ILLEGAL_REQUEST, asc, 0);
>   	memset(sks, 0, sizeof(sks));
>   	sks[0] = 0x80;
>   	if (c_d)
> @@ -805,17 +805,14 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *scp,
>   
>   static void mk_sense_buffer(struct scsi_cmnd *scp, int key, int asc, int asq)
>   {
> -	unsigned char *sbuff;
> -
> -	sbuff = scp->sense_buffer;
> -	if (!sbuff) {
> +	if (!scp->sense_buffer) {
>   		sdev_printk(KERN_ERR, scp->device,
>   			    "%s: sense_buffer is NULL\n", __func__);
>   		return;
>   	}
> -	memset(sbuff, 0, SCSI_SENSE_BUFFERSIZE);
> +	memset(scp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>   
> -	scsi_build_sense_buffer(sdebug_dsense, sbuff, key, asc, asq);
> +	scsi_build_sense(scp, sdebug_dsense, key, asc, asq);
>   
>   	if (sdebug_verbose)
>   		sdev_printk(KERN_INFO, scp->device,
> 

