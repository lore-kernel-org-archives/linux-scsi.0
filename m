Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3030C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 00:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8163F2080C
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 00:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgICA4Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 20:56:25 -0400
Received: from smtp.infotech.no ([82.134.31.41]:52222 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgICA4Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Sep 2020 20:56:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 819E220418E;
        Thu,  3 Sep 2020 02:56:23 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8Od1ITAUUyUq; Thu,  3 Sep 2020 02:56:20 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id ED58620415B;
        Thu,  3 Sep 2020 02:56:19 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v2 1/2] scsi: scsi_debug: adjust num_parts to create
 equally sized partitions
To:     John Pittman <jpittman@redhat.com>, martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, djeffery@redhat.com, loberman@redhat.com,
        linux-scsi@vger.kernel.org
References: <20200902211434.9979-1-jpittman@redhat.com>
 <20200902211434.9979-2-jpittman@redhat.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <d615ba1b-92a5-7412-c789-1bd91597bce5@interlog.com>
Date:   Wed, 2 Sep 2020 20:56:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200902211434.9979-2-jpittman@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-02 5:14 p.m., John Pittman wrote:
> Currently when using the num_parts parameter, partitions are aligned
> and the end sector is one prior to the next start.  This creates
> different sized partitions. Create instead equally sized partitions by
> trimming the end of each partition to the size of the smallest
> partition.  This aligns better with what one would expect from
> automatically created partitions and can be helpful with testing
> things such as raid which often expect legs of the same size.
> Minimal space is lost as the initial partition starting size is
> calculated by dividing num_sectors by sdebug_num_parts.
>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> Signed-off-by: John Pittman <jpittman@redhat.com>
> ---
>   drivers/scsi/scsi_debug.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 1ad7260d4758..ada0361eac83 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5257,7 +5257,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
>   static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
>   {
>   	struct msdos_partition *pp;
> -	int starts[SDEBUG_MAX_PARTS + 2];
> +	int starts[SDEBUG_MAX_PARTS + 2], max_part_secs;
>   	int sectors_per_part, num_sectors, k;
>   	int heads_by_sects, start_sec, end_sec;
>   
> @@ -5273,9 +5273,13 @@ static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
>   			   / sdebug_num_parts;
>   	heads_by_sects = sdebug_heads * sdebug_sectors_per;
>   	starts[0] = sdebug_sectors_per;
> -	for (k = 1; k < sdebug_num_parts; ++k)
> +	max_part_secs = sectors_per_part;
> +	for (k = 1; k < sdebug_num_parts; ++k) {
>   		starts[k] = ((k * sectors_per_part) / heads_by_sects)
>   			    * heads_by_sects;
> +		if (starts[k] - starts[k - 1] < max_part_secs)
> +			max_part_secs = starts[k] - starts[k - 1];
> +	}
>   	starts[sdebug_num_parts] = num_sectors;
>   	starts[sdebug_num_parts + 1] = 0;
>   
> @@ -5284,7 +5288,7 @@ static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
>   	pp = (struct msdos_partition *)(ramp + 0x1be);
>   	for (k = 0; starts[k + 1]; ++k, ++pp) {
>   		start_sec = starts[k];
> -		end_sec = starts[k + 1] - 1;
> +		end_sec = starts[k] + max_part_secs - 1;
>   		pp->boot_ind = 0;
>   
>   		pp->cyl = start_sec / heads_by_sects;
> 

