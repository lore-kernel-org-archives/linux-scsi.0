Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08BDC2BB85
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 18:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 800ED2074D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 18:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504299AbgDNSpP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 14:45:15 -0400
Received: from smtp.infotech.no ([82.134.31.41]:45529 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504293AbgDNSpN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Apr 2020 14:45:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id E9ED72041CF;
        Tue, 14 Apr 2020 20:45:10 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id g5dzQnLMwoIU; Tue, 14 Apr 2020 20:45:05 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 08CA2204154;
        Tue, 14 Apr 2020 20:45:03 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi:sg: add sg_remove_request in sg_write
To:     Wu Bo <wubo40@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        liuzhiqiang26@huawei.com, linfeilong@huawei.com
References: <610618d9-e983-fd56-ed0f-639428343af7@huawei.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <4ece8e46-f9e4-e582-157a-7ab0268c04aa@interlog.com>
Date:   Tue, 14 Apr 2020 14:44:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <610618d9-e983-fd56-ed0f-639428343af7@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-13 10:13 p.m., Wu Bo wrote:
> From: Wu Bo <wubo40@huawei.com>
> 
> If the __copy_from_user function return failed,
> it should call sg_remove_request in sg_write.

This is a fix.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>   drivers/scsi/sg.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 4e6af59..ff3f532 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -685,8 +685,10 @@ static int get_sg_io_pack_id(int *pack_id, void __user 
> *buf, size_t count)
>          hp->flags = input_size; /* structure abuse ... */
>          hp->pack_id = old_hdr.pack_id;
>          hp->usr_ptr = NULL;
> -       if (copy_from_user(cmnd, buf, cmd_size))
> +       if (copy_from_user(cmnd, buf, cmd_size)) {
> +               sg_remove_request(sfp, srp);
>                  return -EFAULT;
> +       }
>          /*
>           * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
>           * but is is possible that the app intended SG_DXFER_TO_DEV, because there
> -- 
> 1.8.3.1
> 

