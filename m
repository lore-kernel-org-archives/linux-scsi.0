Return-Path: <SRS0=n0Yx=CO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AA1C2BBD0
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 18:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8998C2078E
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 18:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgIEShf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 14:37:35 -0400
Received: from smtp.infotech.no ([82.134.31.41]:59034 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728393AbgIEShf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 5 Sep 2020 14:37:35 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 1C2ED204191;
        Sat,  5 Sep 2020 20:37:33 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id liXuSSHj5cEV; Sat,  5 Sep 2020 20:37:31 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id C84B320418E;
        Sat,  5 Sep 2020 20:37:29 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 2/4] scsi: sg: implement BLKSSZGET
To:     Tom Yan <tom.ty89@gmail.com>, linux-scsi@vger.kernel.org
Cc:     stern@rowland.harvard.edu, James.Bottomley@SteelEye.com,
        akinobu.mita@gmail.com, hch@lst.de, jens.axboe@oracle.com
References: <CAGnHSE=fY2wkzNeZTSHC37Sp-uD4D8YMEb7LesDkPcQWAfiK=w@mail.gmail.com>
 <20200904200554.168979-1-tom.ty89@gmail.com>
 <20200904200554.168979-2-tom.ty89@gmail.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <4d24624d-0793-1038-be5c-38212c5a1311@interlog.com>
Date:   Sat, 5 Sep 2020 14:37:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200904200554.168979-2-tom.ty89@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-04 4:05 p.m., Tom Yan wrote:
> Provide an ioctl to get the logical sector size so that the maximum
> bytes per request can be derived.
> 
> Follow-up of the BLKSECTGET fix.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/sg.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index e57831910228..0e3f084141a3 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1118,6 +1118,8 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>   		max_sectors = min_t(unsigned int, USHRT_MAX,
>   				    queue_max_sectors(sdp->device->request_queue));
>   		return put_user(max_sectors, ip);
> +	case BLKSSZGET:
> +		return put_user(queue_logical_block_size(sdp->device->request_queue), ip);
>   	case BLKTRACESETUP:
>   		return blk_trace_setup(sdp->device->request_queue,
>   				       sdp->disk->disk_name,
> 

