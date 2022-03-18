Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CC4C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Mar 2022 15:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237444AbiCRPwS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 11:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237664AbiCRPwR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 11:52:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9581E2EAF43
        for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2022 08:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647618657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EA6rKw0mpZS/aykq/0IZss6wMcc+T85vi5DhFZF9ONo=;
        b=UCmclOQUaR6DsHHXUiIMni/q3Uq/fMESrUObFI/jaeVq5G4A+jbj+iWV3SVi9cTRFYfzi0
        Pmn1/8avB0Turokn6fUnrZ65Hf4x0QOKEBwyyDJULeMk36IUY7LhwkEkWMpdk85p/A3Lfi
        d934dYWSubQv32c7yL/VTKnyOf4rp2w=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-KhqJoQwcMUedV3k770tFBw-1; Fri, 18 Mar 2022 11:50:56 -0400
X-MC-Unique: KhqJoQwcMUedV3k770tFBw-1
Received: by mail-qv1-f69.google.com with SMTP id z2-20020a056214060200b00440d1bc7815so6342113qvw.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2022 08:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=EA6rKw0mpZS/aykq/0IZss6wMcc+T85vi5DhFZF9ONo=;
        b=gStGyGUQZckpXBQ8GjifnTpQQIR7v0y/WevqAXCP/hXBqN9KHuuEN1OYyE7mt+F1Ch
         sDBJxj9N0FVvkTCnbbG782DLbWjBtU5GNp0iB44NwU/C6FkwqhxrFodY1m3TzPrhW7yj
         WKaD1Zqm/qgd6VyRgFTlo/C90+JT8Xptl/YC09/749K8ZiYm+eQeNmRCzWwX5fv5zW8J
         EUoH201mpTPM21F/xGqDUYnxnyHD2+0S5FFCvfoQT90ofzkhC7HLQabkYG+Y4hjbRuXf
         71/YBr2matTuVlIFoRYaFrvuXKdk/4HTr7yZvKxHSoEBB4JIUqD8UzubTQms/TkysGp6
         BGZg==
X-Gm-Message-State: AOAM530m48IvSw1prYqxLs6+5ypcddUCuO9IKZJr5AsCGN9HqU2c+VBt
        ci0/1279fs1XulDUvl7sMHYHn7AyaGTfOKmBLwCHR1kHRJBUtbLZFk+O6+bjftwPkQ4L6G5/9Qw
        p1dwthffP4tuX+0+e/JwSkw==
X-Received: by 2002:a05:6214:1742:b0:440:e595:e467 with SMTP id dc2-20020a056214174200b00440e595e467mr6421907qvb.120.1647618655909;
        Fri, 18 Mar 2022 08:50:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgIejkdzkLMwxBDMtlAiE9/alrgh/1pdd6MyvTOu+dCk94bCjIfSzYEnDl0BXAJKTnQN94zA==
X-Received: by 2002:a05:6214:1742:b0:440:e595:e467 with SMTP id dc2-20020a056214174200b00440e595e467mr6421897qvb.120.1647618655597;
        Fri, 18 Mar 2022 08:50:55 -0700 (PDT)
Received: from emilne (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c1-20020a05620a0ce100b0067e0cd1746fsm3816349qkj.51.2022.03.18.08.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 08:50:54 -0700 (PDT)
Message-ID: <de2f3c75e472dd2dc550731a5f23ffaa1de18a66.camel@redhat.com>
Subject: Re: [PATCH] scsi: add __GFP_ZERO flag for blk_rq_map_kern in
 function sg_scsi_ioctl
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Haimin Zhang <tcs.kernel@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date:   Fri, 18 Mar 2022 11:50:53 -0400
In-Reply-To: <20220216164223.55546-1-tcs.kernel@gmail.com>
References: <20220216164223.55546-1-tcs.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-02-17 at 00:42 +0800, Haimin Zhang wrote:
> Add __GFP_ZERO flag for blk_rq_map_kern in function sg_scsi_ioctl to
> avoid a kernel information leak issue. This issue can cause the content of
> local variable buffer which was passed to function blk_rq_map_kern was
> rewritten. At last, it can be leaked to the user buffer.
> 
> Reported-by: TCS Robot <tcs_robot@tencent.com>
> Signed-off-by: Haimin Zhang <tcs.kernel@gmail.com>
> ---
> This can cause a kernel-info-leak problem.
> 0. This problem occurred in function scsi_ioctl. If the parameter cmd is SCSI_IOCTL_SEND_COMMAND, the function scsi_ioctl will call sg_scsi_ioctl to further process.
> 1. In function sg_scsi_ioctl, it creates a scsi request and calls blk_rq_map_kern to map kernel data to a request.
> 3. blq_rq_map_kern calls bio_copy_kern to request a bio.
> 4. bio_copy_kern calls alloc_page to request the buffer of a bio. In the case of reading, it wouldn't fill anything into the buffer.
> 
> ```
> __alloc_pages+0xbbf/0x1090 build/../mm/page_alloc.c:5409
> alloc_pages+0x8a5/0xb80
> bio_copy_kern build/../block/blk-map.c:449 [inline]
> blk_rq_map_kern+0x813/0x1400 build/../block/blk-map.c:640
> sg_scsi_ioctl build/../drivers/scsi/scsi_ioctl.c:618 [inline]
> scsi_ioctl+0x40c0/0x4600 build/../drivers/scsi/scsi_ioctl.c:932
> sg_ioctl_common build/../drivers/scsi/sg.c:1112 [inline]
> sg_ioctl+0x3351/0x4c10 build/../drivers/scsi/sg.c:1165
> vfs_ioctl build/../fs/ioctl.c:51 [inline]
> __do_sys_ioctl build/../fs/ioctl.c:874 [inline]
> __se_sys_ioctl+0x2df/0x4a0 build/../fs/ioctl.c:860
> __x64_sys_ioctl+0xd8/0x110 build/../fs/ioctl.c:860
> do_syscall_x64 build/../arch/x86/entry/common.c:51 [inline]
> do_syscall_64+0x54/0xd0 build/../arch/x86/entry/common.c:82
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> ```
> 
> 5. Then this request will be sent to the disk driver. When bio is finished, bio_copy_kern_endio_read will copy the readed content back to parameter data from the bio.
> But if the block driver didn't process this request, the buffer of bio is still unitialized.
> 
> ```
> memcpy_from_page build/../include/linux/highmem.h:346 [inline]
> memcpy_from_bvec build/../include/linux/bvec.h:207 [inline]
> bio_copy_kern_endio_read+0x4a3/0x620 build/../block/blk-map.c:403
> bio_endio+0xa7f/0xac0 build/../block/bio.c:1491
> req_bio_endio build/../block/blk-mq.c:674 [inline]
> blk_update_request+0x1129/0x22d0 build/../block/blk-mq.c:742
> scsi_end_request+0x119/0xe40 build/../drivers/scsi/scsi_lib.c:543
> scsi_io_completion+0x329/0x810 build/../drivers/scsi/scsi_lib.c:939
> scsi_finish_command+0x6e3/0x700 build/../drivers/scsi/scsi.c:199
> scsi_complete+0x239/0x640 build/../drivers/scsi/scsi_lib.c:1441
> blk_complete_reqs build/../block/blk-mq.c:892 [inline]
> blk_done_softirq+0x189/0x260 build/../block/blk-mq.c:897
> __do_softirq+0x1ee/0x7c5 build/../kernel/softirq.c:558
> ```
> 
> 6. Finally, the internal buffer's content is copied to the user buffer which is specified by the parameter sic->data of sg_scsi_ioctl.
> _copy_to_user+0x1c9/0x270 build/../lib/usercopy.c:33
> copy_to_user build/../include/linux/uaccess.h:209 [inline]
> sg_scsi_ioctl build/../drivers/scsi/scsi_ioctl.c:634 [inline]
> scsi_ioctl+0x44d9/0x4600 build/../drivers/scsi/scsi_ioctl.c:932
> sg_ioctl_common build/../drivers/scsi/sg.c:1112 [inline]
> sg_ioctl+0x3351/0x4c10 build/../drivers/scsi/sg.c:1165
> vfs_ioctl build/../fs/ioctl.c:51 [inline]
> __do_sys_ioctl build/../fs/ioctl.c:874 [inline]
> __se_sys_ioctl+0x2df/0x4a0 build/../fs/ioctl.c:860
> __x64_sys_ioctl+0xd8/0x110 build/../fs/ioctl.c:860
> do_syscall_x64 build/../arch/x86/entry/common.c:51 [inline]
> do_syscall_64+0x54/0xd0 build/../arch/x86/entry/common.c:82
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
>  drivers/scsi/scsi_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
> index e13fd380deb6..e92836f4bbd6 100644
> --- a/drivers/scsi/scsi_ioctl.c
> +++ b/drivers/scsi/scsi_ioctl.c
> @@ -607,7 +607,7 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
>  	}
>  
>  	if (bytes) {
> -		err = blk_rq_map_kern(q, rq, buffer, bytes, GFP_NOIO);
> +		err = blk_rq_map_kern(q, rq, buffer, bytes, GFP_NOIO | __GFP_ZERO);
>  		if (err)
>  			goto error;
>  	}

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


