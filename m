Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA82C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 16:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiBPQm5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 11:42:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbiBPQm5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 11:42:57 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B10617E96C
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 08:42:44 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id h7-20020a17090a648700b001b927560c2bso2889166pjj.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 08:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OZpOkof/CGyaDmM5P8LiByNQQAqddDTc7qxmAovk87k=;
        b=YTQefZm1n6AUYLvZ23JF8+jSV5Zn+Vt9p+sH97gsvDWefckQyvJG5HAyu94yNCXH9W
         9BX5m7xzBlz032tJvWkaIj7gSezvNh6AQvip5tX6FcFvzVWEV78l5apQ2+gYJuRIabYA
         5JzZGrxJXkKuLDcIF4Kg1fUtx5lHmah40yvhHpO8PfNuZ0ds5nXHdoRyYLxEdPqBbxkf
         PvZYLIJrTslHCY1X4XZENnDydNzb8P2R0zvj3JmEhdCdwqtXHtFyJVkw4/0H8bga1RqG
         tMrWR3nPtOmDQxcKGYu4tPWeQK8LgzdIKUhp24P90FeXcwUveLja+QGecSO1c+qQVgb5
         HKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OZpOkof/CGyaDmM5P8LiByNQQAqddDTc7qxmAovk87k=;
        b=L1VJXTukiCs+v11TmScSoQ6kDLTXSWXOtSH9dTfFQVaH/Qn86OX2J8GnB2RnQ/QzAs
         zUc3m5lb117+1J7Yf75/7/5nUndhSbo4kYr6LzQ3zH6wKx0jAqIm8MF3JoSnlt37fn4U
         ZnJkJVbp8cM8GLVzL8CK6mdFyQ50lTc9ItToiQvZ4/vzZhdR5MXbjzfhMxGNVGTu1/XM
         R4k88NRsM/Rh/+PZAxK81HMgukhed8FdLueS0jndkxUYLbUAxta2P4Enr7t5vFEjqUJU
         oCEO8nzW97BrjO6R2hCGrPxkdJsaIYN6E8iLZO1U5KFyX3JfInOiUi9Iy6ja9lO7KOts
         Pw/g==
X-Gm-Message-State: AOAM5338n5vQaspvRvqNE1WZ5k9t2ht6ndA7cwqWukhcHPeFMqkx+4lV
        OzVMexylFOH+xiE8AnPbfWM=
X-Google-Smtp-Source: ABdhPJxTi0KdUPKwTvw3K2Afh7CgKaGWn7ARC13HEsv6QMuX+rDhPgGblnTa31cZZMvuHNHtqOvGLA==
X-Received: by 2002:a17:90b:4a92:b0:1b8:a3c5:1afe with SMTP id lp18-20020a17090b4a9200b001b8a3c51afemr2744580pjb.69.1645029763989;
        Wed, 16 Feb 2022 08:42:43 -0800 (PST)
Received: from ELIJAHBAI-MB0.tencent.com ([203.205.141.118])
        by smtp.gmail.com with ESMTPSA id p16sm5745964pgj.79.2022.02.16.08.42.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Feb 2022 08:42:43 -0800 (PST)
From:   Haimin Zhang <tcs.kernel@gmail.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Haimin Zhang <tcs.kernel@gmail.com>,
        TCS Robot <tcs_robot@tencent.com>
Subject: [PATCH] scsi: add __GFP_ZERO flag for blk_rq_map_kern in function sg_scsi_ioctl
Date:   Thu, 17 Feb 2022 00:42:23 +0800
Message-Id: <20220216164223.55546-1-tcs.kernel@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add __GFP_ZERO flag for blk_rq_map_kern in function sg_scsi_ioctl to
avoid a kernel information leak issue. This issue can cause the content of
local variable buffer which was passed to function blk_rq_map_kern was
rewritten. At last, it can be leaked to the user buffer.

Reported-by: TCS Robot <tcs_robot@tencent.com>
Signed-off-by: Haimin Zhang <tcs.kernel@gmail.com>
---
This can cause a kernel-info-leak problem.
0. This problem occurred in function scsi_ioctl. If the parameter cmd is SCSI_IOCTL_SEND_COMMAND, the function scsi_ioctl will call sg_scsi_ioctl to further process.
1. In function sg_scsi_ioctl, it creates a scsi request and calls blk_rq_map_kern to map kernel data to a request.
3. blq_rq_map_kern calls bio_copy_kern to request a bio.
4. bio_copy_kern calls alloc_page to request the buffer of a bio. In the case of reading, it wouldn't fill anything into the buffer.

```
__alloc_pages+0xbbf/0x1090 build/../mm/page_alloc.c:5409
alloc_pages+0x8a5/0xb80
bio_copy_kern build/../block/blk-map.c:449 [inline]
blk_rq_map_kern+0x813/0x1400 build/../block/blk-map.c:640
sg_scsi_ioctl build/../drivers/scsi/scsi_ioctl.c:618 [inline]
scsi_ioctl+0x40c0/0x4600 build/../drivers/scsi/scsi_ioctl.c:932
sg_ioctl_common build/../drivers/scsi/sg.c:1112 [inline]
sg_ioctl+0x3351/0x4c10 build/../drivers/scsi/sg.c:1165
vfs_ioctl build/../fs/ioctl.c:51 [inline]
__do_sys_ioctl build/../fs/ioctl.c:874 [inline]
__se_sys_ioctl+0x2df/0x4a0 build/../fs/ioctl.c:860
__x64_sys_ioctl+0xd8/0x110 build/../fs/ioctl.c:860
do_syscall_x64 build/../arch/x86/entry/common.c:51 [inline]
do_syscall_64+0x54/0xd0 build/../arch/x86/entry/common.c:82
entry_SYSCALL_64_after_hwframe+0x44/0xae
```

5. Then this request will be sent to the disk driver. When bio is finished, bio_copy_kern_endio_read will copy the readed content back to parameter data from the bio.
But if the block driver didn't process this request, the buffer of bio is still unitialized.

```
memcpy_from_page build/../include/linux/highmem.h:346 [inline]
memcpy_from_bvec build/../include/linux/bvec.h:207 [inline]
bio_copy_kern_endio_read+0x4a3/0x620 build/../block/blk-map.c:403
bio_endio+0xa7f/0xac0 build/../block/bio.c:1491
req_bio_endio build/../block/blk-mq.c:674 [inline]
blk_update_request+0x1129/0x22d0 build/../block/blk-mq.c:742
scsi_end_request+0x119/0xe40 build/../drivers/scsi/scsi_lib.c:543
scsi_io_completion+0x329/0x810 build/../drivers/scsi/scsi_lib.c:939
scsi_finish_command+0x6e3/0x700 build/../drivers/scsi/scsi.c:199
scsi_complete+0x239/0x640 build/../drivers/scsi/scsi_lib.c:1441
blk_complete_reqs build/../block/blk-mq.c:892 [inline]
blk_done_softirq+0x189/0x260 build/../block/blk-mq.c:897
__do_softirq+0x1ee/0x7c5 build/../kernel/softirq.c:558
```

6. Finally, the internal buffer's content is copied to the user buffer which is specified by the parameter sic->data of sg_scsi_ioctl.
_copy_to_user+0x1c9/0x270 build/../lib/usercopy.c:33
copy_to_user build/../include/linux/uaccess.h:209 [inline]
sg_scsi_ioctl build/../drivers/scsi/scsi_ioctl.c:634 [inline]
scsi_ioctl+0x44d9/0x4600 build/../drivers/scsi/scsi_ioctl.c:932
sg_ioctl_common build/../drivers/scsi/sg.c:1112 [inline]
sg_ioctl+0x3351/0x4c10 build/../drivers/scsi/sg.c:1165
vfs_ioctl build/../fs/ioctl.c:51 [inline]
__do_sys_ioctl build/../fs/ioctl.c:874 [inline]
__se_sys_ioctl+0x2df/0x4a0 build/../fs/ioctl.c:860
__x64_sys_ioctl+0xd8/0x110 build/../fs/ioctl.c:860
do_syscall_x64 build/../arch/x86/entry/common.c:51 [inline]
do_syscall_64+0x54/0xd0 build/../arch/x86/entry/common.c:82
entry_SYSCALL_64_after_hwframe+0x44/0xae

 drivers/scsi/scsi_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index e13fd380deb6..e92836f4bbd6 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -607,7 +607,7 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
 	}
 
 	if (bytes) {
-		err = blk_rq_map_kern(q, rq, buffer, bytes, GFP_NOIO);
+		err = blk_rq_map_kern(q, rq, buffer, bytes, GFP_NOIO | __GFP_ZERO);
 		if (err)
 			goto error;
 	}
-- 
2.30.1 (Apple Git-130)

