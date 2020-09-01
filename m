Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4ACDC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 00:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8091A2083E
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 00:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgIAAvl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 20:51:41 -0400
Received: from smtp.infotech.no ([82.134.31.41]:46997 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgIAAvl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Aug 2020 20:51:41 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 9B263204150;
        Tue,  1 Sep 2020 02:51:39 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KSi27MoeShlS; Tue,  1 Sep 2020 02:51:38 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 6420C204248;
        Tue,  1 Sep 2020 02:51:37 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 2/2] scsi: scsi_debug: sdebug_build_parts() respect
 virtual_gb
To:     John Pittman <jpittman@redhat.com>, martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, djeffery@redhat.com, linux-scsi@vger.kernel.org
References: <20200827213327.25537-1-jpittman@redhat.com>
 <20200827213327.25537-3-jpittman@redhat.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <9a00d053-c696-16a6-6db5-d0d131865fcc@interlog.com>
Date:   Mon, 31 Aug 2020 20:51:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827213327.25537-3-jpittman@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-27 5:33 p.m., John Pittman wrote:
> If virtual_gb is passed while using num_parts, when creating the
> partitions, virtual_gb is not respected.  Set num_sectors using
> get_sdebug_capacity() to pull virtual_gb if set.
> 
> Signed-off-by: John Pittman <jpittman@redhat.com>
> ---
>   drivers/scsi/scsi_debug.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 3d9db1e8b781..e6b57cead316 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5270,7 +5270,7 @@ static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
>   		sdebug_num_parts = SDEBUG_MAX_PARTS;
>   		pr_warn("reducing partitions to %d\n", SDEBUG_MAX_PARTS);
>   	}
> -	num_sectors = (int)sdebug_store_sectors;
> +	num_sectors = (int)get_sdebug_capacity();
>   	max_part_secs = sectors_per_part = (num_sectors - sdebug_sectors_per)
>   			   / sdebug_num_parts;
>   	heads_by_sects = sdebug_heads * sdebug_sectors_per;
> 

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
