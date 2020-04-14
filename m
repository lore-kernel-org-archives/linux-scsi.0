Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10893C2BB86
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 02:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA17C20732
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 02:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403998AbgDNCNn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 22:13:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2367 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403967AbgDNCNl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Apr 2020 22:13:41 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A6650673AB8245D8F5B5;
        Tue, 14 Apr 2020 10:13:37 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.252) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 14 Apr 2020
 10:13:29 +0800
To:     Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liuzhiqiang26@huawei.com>, <linfeilong@huawei.com>
From:   Wu Bo <wubo40@huawei.com>
Subject: [PATCH] scsi:sg: add sg_remove_request in sg_write
Message-ID: <610618d9-e983-fd56-ed0f-639428343af7@huawei.com>
Date:   Tue, 14 Apr 2020 10:13:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.252]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

If the __copy_from_user function return failed,
it should call sg_remove_request in sg_write.

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
  drivers/scsi/sg.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4e6af59..ff3f532 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -685,8 +685,10 @@ static int get_sg_io_pack_id(int *pack_id, void 
__user *buf, size_t count)
         hp->flags = input_size; /* structure abuse ... */
         hp->pack_id = old_hdr.pack_id;
         hp->usr_ptr = NULL;
-       if (copy_from_user(cmnd, buf, cmd_size))
+       if (copy_from_user(cmnd, buf, cmd_size)) {
+               sg_remove_request(sfp, srp);
                 return -EFAULT;
+       }
         /*
          * SG_DXFER_TO_FROM_DEV is functionally equivalent to 
SG_DXFER_FROM_DEV,
          * but is is possible that the app intended SG_DXFER_TO_DEV, 
because there
--
1.8.3.1

