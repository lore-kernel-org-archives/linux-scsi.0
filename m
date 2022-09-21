Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A72EC6FA82
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Sep 2022 20:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiIUUwB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Sep 2022 16:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiIUUwA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Sep 2022 16:52:00 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988589F743
        for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2022 13:51:59 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id a29so7190617pfk.5
        for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2022 13:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=D80WZfucxT3T2jixHx4bvU4f4glNNHDVHDNbaBiNbuQ=;
        b=WJ7vftjYdQLkD940fWG48kQOGPwWIwtjmcDQBLyGs95BRKwv0eoPa5OFr2AYkC7V80
         f9B+0Sc+QNYibiS0EvcxPrGaKU8d1DlLXvuipvj3lUidU4MeLT2/VJ/g68UHwbB1RVcw
         8+U02lIJ/hhK3v+qc4033/gXZISHphYuDQHfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=D80WZfucxT3T2jixHx4bvU4f4glNNHDVHDNbaBiNbuQ=;
        b=nH8EZCQGD7+M/90NVfrFs/nXGYiwOCWJ4/JRG3pvbYEvjQJxMekM+x1Apo2NGg8uP8
         4a9ss0Hlo53e6iXzYJ4nikM2TTPPapuww4OJttT+MBNYUka/0VW3aIuWv35NaSTd61JX
         f3LNjYn+Qwvpb92Zr1S9sjXzBUxqEWDQL5VoCXyjLPecbxKVF5M3YP2QsMUKnPCmTCOX
         0wV8QL8A3leWj3bQPoWYFoNea0tY7tMFRumRYs0iUf+Sk1C7eegQrIUBywWGvLHpHIII
         fC3VCyBjU6p5bBQgAcHkQx3HK/prI5GN4+IkUkU0xyI7n5jzME6QenYgZSrhulUS2/g7
         PPlQ==
X-Gm-Message-State: ACrzQf2x3aTaZwS6MtsjwPQILFALYz4zE8iND+al4x4tyji50k1A5oAZ
        auAXy8NbfrhNlRtxGcgj1C+FoA==
X-Google-Smtp-Source: AMsMyM5x/YqAvJnNkuP3s9sudYjK2UWyxBpl4qhk/dsQz/kD2YM+cCHOYeHwTWoTCsY65S3tY/T91g==
X-Received: by 2002:a65:4c85:0:b0:43b:f860:98f9 with SMTP id m5-20020a654c85000000b0043bf86098f9mr48699pgt.368.1663793519127;
        Wed, 21 Sep 2022 13:51:59 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i32-20020a632220000000b00422c003cf78sm2267673pgi.82.2022.09.21.13.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 13:51:58 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Sachin Sant <sachinp@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: scsi_transport_fc: Adjust struct fc_nl_event flex array usage
Date:   Wed, 21 Sep 2022 13:51:55 -0700
Message-Id: <20220921205155.1451649-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3180; h=from:subject; bh=HTYO6DRAcJ0YYvNgnwbkgU3hR5o+67BVqpamWRTBFhs=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjK3lqCxkl8/+3fSy7f7uw22pne0hq/v2+EXdc5unX 3g0ywfSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYyt5agAKCRCJcvTf3G3AJgxsEA CRYo81nzmI4fc8o5wOEqs7W5LE56q0N+KDpzyoinEebkPkLBy9cfnnZ9IZ4uqGx6ql3/k5AfUbjIN1 VOlNweshUp4eFbH9dvygIwI4A1iMBIMYflwNw1nzFzEfMF5ivWNA1625KTcxaaXy2MFPqyAfKcKhKQ Ah6CSfZ80NPSV9Ku41sbuV1dbvmI9cLn+vHkzTeCt4JI+c3KQ7FCdVYgZT5ezS2bNfCLsJrp9tc2Qc mHMqxsGQYYfsBLd+l418aqM9EsgNxZB0/WvsWnxvZEMlsvcYK3qrTJ1cEYuqsfakUMsneAPGfBgPm7 TtvT1T+BVEzuPUynHHMKOAUdKhLV5tDynM/0ILQb5whePXTw3G9MXZE65Nd5yNOjmsAiBWTLhRxl67 luoxLNmyBF0N3ayCoDFgUocr1NNsjSpGKX39IPzTT85h0f6A/pgLML5l5SBpiihEZEOBOcCC69dyPT lO3CTNvu3yelHnrIb+CX+weji6t0ty5gJklkQPZUiVr4SGiluhDoZFNDIlAOM2p/QOoLqR9bQStJA9 WZzCGqSrXJammpEt2Xt3C5zDkun6J4n+x3JWZPJcJxPwL1kGJmZxQkwIv3YS1/k1Y7mqsyJi86tnW/ AtlIF07G7jUvINEO67RaAT2Sx99E3FCKCIG+3chWg3EdXVSuDNY1BnIwW9qQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order to help the compiler reason about the destination buffer in
struct fc_nl_event, add a flexible array member for this purpose.
However, since the header is UAPI, it must not change size or layout, so
a union is used.

The allocation size calculations are also corrected (it was potentially
allocating an extra 8 bytes), and the padding is zeroed to avoid leaking
kernel heap memory contents.

Detected at run-time by the recently added memcpy() bounds checking:

  memcpy: detected field-spanning write (size 8) of single field "&event->event_data" at drivers/scsi/scsi_transport_fc.c:581 (size 4)

Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Link: https://lore.kernel.org/linux-next/42404B5E-198B-4FD3-94D6-5E16CF579EF3@linux.ibm.com/
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/scsi_transport_fc.c    | 8 +++++---
 include/uapi/scsi/scsi_netlink_fc.h | 7 +++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index a2524106206d..0d798f11dc34 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -543,7 +543,7 @@ fc_host_post_fc_event(struct Scsi_Host *shost, u32 event_number,
 	struct nlmsghdr	*nlh;
 	struct fc_nl_event *event;
 	const char *name;
-	u32 len;
+	size_t len, padding;
 	int err;
 
 	if (!data_buf || data_len < 4)
@@ -554,7 +554,7 @@ fc_host_post_fc_event(struct Scsi_Host *shost, u32 event_number,
 		goto send_fail;
 	}
 
-	len = FC_NL_MSGALIGN(sizeof(*event) + data_len);
+	len = FC_NL_MSGALIGN(sizeof(*event) - sizeof(event->event_data) + data_len);
 
 	skb = nlmsg_new(len, GFP_KERNEL);
 	if (!skb) {
@@ -578,7 +578,9 @@ fc_host_post_fc_event(struct Scsi_Host *shost, u32 event_number,
 	event->event_num = event_number;
 	event->event_code = event_code;
 	if (data_len)
-		memcpy(&event->event_data, data_buf, data_len);
+		memcpy(event->event_data_flex, data_buf, data_len);
+	padding = len - offsetof(typeof(*event), event_data_flex) - data_len;
+	memset(event->event_data_flex + data_len, 0, padding);
 
 	nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_FC_EVENTS,
 			GFP_KERNEL);
diff --git a/include/uapi/scsi/scsi_netlink_fc.h b/include/uapi/scsi/scsi_netlink_fc.h
index 7535253f1a96..b46e9cbeb001 100644
--- a/include/uapi/scsi/scsi_netlink_fc.h
+++ b/include/uapi/scsi/scsi_netlink_fc.h
@@ -35,7 +35,7 @@
  * FC Transport Broadcast Event Message :
  *   FC_NL_ASYNC_EVENT
  *
- * Note: if Vendor Unique message, &event_data will be  start of
+ * Note: if Vendor Unique message, event_data_flex will be start of
  * 	 vendor unique payload, and the length of the payload is
  *       per event_datalen
  *
@@ -50,7 +50,10 @@ struct fc_nl_event {
 	__u16 event_datalen;
 	__u32 event_num;
 	__u32 event_code;
-	__u32 event_data;
+	union {
+		__u32 event_data;
+		__DECLARE_FLEX_ARRAY(__u8, event_data_flex);
+	};
 } __attribute__((aligned(sizeof(__u64))));
 
 
-- 
2.34.1

