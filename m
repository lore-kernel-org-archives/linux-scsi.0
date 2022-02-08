Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A36C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 06:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346977AbiBHGMg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 01:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346817AbiBHGMf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 01:12:35 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7226EC0401F5
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 22:12:34 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id z35so69352pfw.2
        for <linux-scsi@vger.kernel.org>; Mon, 07 Feb 2022 22:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yWSVf8pbp0RLvS5feKysE3VKtu9J4rvhM+KTpk9qrQU=;
        b=RWsRxyFyvyBYavICh4sWDRq4hFtsEElxduscRcl85/r8UOE0dw2Nlb0AOk5bEGU3lg
         DkZflRcmok1YGuVYCzYE45ulO5ZJ698Fb7Gjl8BGpz6voNJ8n+PG8SLaUKoo24urmeC9
         2rz+93DgZMa0q+9w1e6CvVgGAFHFYrTTnYkSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yWSVf8pbp0RLvS5feKysE3VKtu9J4rvhM+KTpk9qrQU=;
        b=iBanOLw8FdVZXRAWcQz4jjpAnVg4rfvLI3ZIolSIaNFanguWg3Gl5Jxiz4Dd9l0wYZ
         oRKpsFY8/+ykYDkeicgrbYq80rA4+TCjm69+R1XBgQSfIv+SuANA8YvaDAwua9dyhdbO
         aG2J8Gm8zJFFoHNQQcWFoP4MtYheyQp2nad9Wj93haES7TyafhrHRXMy3RrBfmF4x3kP
         dosRyhoAcIlBnVY8BvvyLBqtUWp+FM+Nl7d/eW+L7VHH00tvOMcQ/S1qLKqwB5ZFgObj
         pTd9/Gxmf0O0z+wbEUHnd8Gk3K6iTb+QfEiQdC5GZJVcrx0wjgpOkXG1jFO8wPalpYOJ
         YPjg==
X-Gm-Message-State: AOAM531rQ7j9GJ2uGbwsHOl5BlyH7TeS8xp70FkNU/ej16Sm0W+eK2Ct
        Oj3M3oqch/2758fAG6xxuW7zIg==
X-Google-Smtp-Source: ABdhPJxMZHBfADJf5rumQgSBE2gS1uUgJUBmaG65f5WBVQCEbETLwB32tdutR63nj4k6vRzs4MCykQ==
X-Received: by 2002:a63:5226:: with SMTP id g38mr2349009pgb.620.1644300753875;
        Mon, 07 Feb 2022 22:12:33 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a17sm1302594pju.15.2022.02.07.22.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 22:12:33 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Michael Cyr <mikecyr@linux.ibm.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: ibmvscsis: Silence -Warray-bounds warning
Date:   Mon,  7 Feb 2022 22:12:31 -0800
Message-Id: <20220208061231.3429486-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3327; h=from:subject; bh=/IFLfs1Idemy5ZGqf/yG83q6j/a9J08ZqJuMOeTGsMc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBiAgnPuZwn6owIovK4j5/iRsH/3BYZhyUfQIj6fwJ5 88HlxfyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYgIJzwAKCRCJcvTf3G3AJpBFD/ 9fpNqNpzwfTSYBWn11FjpJwFuNAFKT4TKK39GQ0i7wMXrhdsnlmfxGsSVAihkLaBhDuM4U+I6C3IWq SKIf4/3YhmuOY3zpOP5mR89k8A+a75Dxc1ySlhMEDgZp0PqyN/CnAuasvO0RoV5r2PqzOibb5R16Sd 6+ZfpUpagXYYLM9iEfpi9fH6539iQ03hnfedEYcnkW/r4Q6jeyIpjhs6oK4UKrgZj1RxJWDqTTDu63 lu7UBWo4m0OHQocaQxhH63xAhRLM+Zyc6uu3VS08yLprlo8PTEQcZZCa7YZhKhwtrDyfkgyH3K1oKr QPUYVEsKyoGi+UazuVQAp5QNRA9fHRXmyKGAFVNlzRKQkyWrVGAsP8Kd80Z/zMMZTcM5cWYZzBzamw m6AyzSoYBaAmkjyOxOdVurN5YrFJ1Bmrzhl6WEjSduTt41LWAn66BCutY9bJvjKD0lcHZ/mbBxWZam rcTEFdaWxa/pc3Af+dWk50AKGQsr9B5rQcb7+Uz4f7mcor+30QQiBSxfr1/4+dz4VAeA70PRvxP8YR vcdSQSwIQ+xbEeULJ69Zm7S4SNhOtduIy9fUjXneFuBHXyQzN23Nn9rz8vwqKFYm7Kpgnem/l8fOUs 5xUAvVR6eKrYc0rHSMenoo+wfC0fMhbvZ4eIgmi4F9bpcYv4u+YPY6OzYIhA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of doing a cast to storage that is too small, add a union for
the high 64 bits. Silences the warnings under -Warray-bounds:

drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c: In function 'ibmvscsis_send_messages':
drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:1934:44: error: array subscript 'struct viosrp_crq[0]' is partly outside array bounds of 'u64[1]' {aka 'long long unsigned int[1]'} [-Werror=array-bounds]
 1934 |                                         crq->valid = VALID_CMD_RESP_EL;
      |                                            ^~
drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:1875:13: note: while referencing 'msg_hi'
 1875 |         u64 msg_hi = 0;
      |             ^~~~~~

There is no change to the resulting binary instructions.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: https://lore.kernel.org/lkml/20220125142430.75c3160e@canb.auug.org.au
Cc: Michael Cyr <mikecyr@linux.ibm.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c |  9 +++------
 include/scsi/viosrp.h                    | 17 +++++++++++------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 61f06f6885a5..80238e6a3c98 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1872,11 +1872,8 @@ static void srp_snd_msg_failed(struct scsi_info *vscsi, long rc)
  */
 static void ibmvscsis_send_messages(struct scsi_info *vscsi)
 {
-	u64 msg_hi = 0;
-	/* note do not attempt to access the IU_data_ptr with this pointer
-	 * it is not valid
-	 */
-	struct viosrp_crq *crq = (struct viosrp_crq *)&msg_hi;
+	struct viosrp_crq empty_crq = { };
+	struct viosrp_crq *crq = &empty_crq;
 	struct ibmvscsis_cmd *cmd, *nxt;
 	long rc = ADAPT_SUCCESS;
 	bool retry = false;
@@ -1940,7 +1937,7 @@ static void ibmvscsis_send_messages(struct scsi_info *vscsi)
 					crq->IU_length = cpu_to_be16(cmd->rsp.len);
 
 					rc = h_send_crq(vscsi->dma_dev->unit_address,
-							be64_to_cpu(msg_hi),
+							be64_to_cpu(crq->high),
 							be64_to_cpu(cmd->rsp.tag));
 
 					dev_dbg(&vscsi->dev, "send_messages: cmd %p, tag 0x%llx, rc %ld\n",
diff --git a/include/scsi/viosrp.h b/include/scsi/viosrp.h
index c978133c83e3..6c5559d2b285 100644
--- a/include/scsi/viosrp.h
+++ b/include/scsi/viosrp.h
@@ -70,12 +70,17 @@ enum viosrp_crq_status {
 };
 
 struct viosrp_crq {
-	u8 valid;		/* used by RPA */
-	u8 format;		/* SCSI vs out-of-band */
-	u8 reserved;
-	u8 status;		/* non-scsi failure? (e.g. DMA failure) */
-	__be16 timeout;		/* in seconds */
-	__be16 IU_length;		/* in bytes */
+	union {
+		__be64 high;			/* High 64 bits */
+		struct {
+			u8 valid;		/* used by RPA */
+			u8 format;		/* SCSI vs out-of-band */
+			u8 reserved;
+			u8 status;		/* non-scsi failure? (e.g. DMA failure) */
+			__be16 timeout;		/* in seconds */
+			__be16 IU_length;	/* in bytes */
+		};
+	};
 	__be64 IU_data_ptr;	/* the TCE for transferring data */
 };
 
-- 
2.30.2

