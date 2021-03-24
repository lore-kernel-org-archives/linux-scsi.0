Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F5EC433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 00:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DDB161A17
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 00:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbhCYABP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 20:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231902AbhCYAAl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 20:00:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F67761A17;
        Thu, 25 Mar 2021 00:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616630440;
        bh=K81/gaPd1/oRumyOHJaV3oVbPfdIOv90xp84bd8VfCs=;
        h=Date:From:To:Cc:Subject:From;
        b=n6YYvtYEWq87wpBk1tbUH6m9gzcyVBZporsDb+RRMV8eTSfg1gmUJraTAwGjFw+ni
         xMH22Afbe9Zk3a8bDTYWPi1wIC84oxQnHp1k8tOsAUWUSP3TFLhO0PYwjSjuk8kbRa
         KB4W88rXfhc40BL2ybVhuecNmAnpftt2PvIwpI6qa1nV6rLuHKlwpDvLYc+U9964Z4
         AXemqgpOGcWRTkjsxVmEgnguwBNuMKfcYOaNRpfTbT1zvY5lFCA88E8ZDCw2MbwuId
         Gj963jGHaDp9CmE9ueeZ61BuMWR9cVbqL7guhi1qDPsuc5iADhei9B5gKIgRUYjRqy
         mTSqZtM0AQxfQ==
Date:   Wed, 24 Mar 2021 18:00:36 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] SCSI: fusion: mpi_ioc.h: Replace one-element array
 with flexible-array member
Message-ID: <20210324230036.GA67851@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Also, this helps with the ongoing efforts to enable -Warray-bounds by
fixing the following warning:

drivers/message/fusion/mptbase.c: In function ‘mptbase_reply’:
drivers/message/fusion/mptbase.c:7747:62: warning: array subscript 1 is above array bounds of ‘U32[1]’ {aka ‘unsigned int[1]’} [-Warray-bounds]
 7747 |     ioc->events[idx].data[ii] = le32_to_cpu(pEventReply->Data[ii]);
./include/uapi/linux/byteorder/little_endian.h:34:51: note: in definition of macro ‘__le32_to_cpu’
   34 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
      |                                                   ^
drivers/message/fusion/mptbase.c:7747:33: note: in expansion of macro ‘le32_to_cpu’
 7747 |     ioc->events[idx].data[ii] = le32_to_cpu(pEventReply->Data[ii]);
      | 

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/message/fusion/lsi/mpi_ioc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/lsi/mpi_ioc.h b/drivers/message/fusion/lsi/mpi_ioc.h
index c249f2994fc1..1534460fd5b1 100644
--- a/drivers/message/fusion/lsi/mpi_ioc.h
+++ b/drivers/message/fusion/lsi/mpi_ioc.h
@@ -448,7 +448,7 @@ typedef struct _MSG_EVENT_NOTIFY_REPLY
      U32                    IOCLogInfo;                 /* 10h */
      U32                    Event;                      /* 14h */
      U32                    EventContext;               /* 18h */
-     U32                    Data[1];                    /* 1Ch */
+     U32                    Data[];			/* 1Ch */
 } MSG_EVENT_NOTIFY_REPLY, MPI_POINTER PTR_MSG_EVENT_NOTIFY_REPLY,
   EventNotificationReply_t, MPI_POINTER pEventNotificationReply_t;
 
-- 
2.27.0

