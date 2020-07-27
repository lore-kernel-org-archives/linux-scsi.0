Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA64DC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 21:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFBC820729
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 21:04:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c0dl7GcE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgG0VEe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 17:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0VEe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 17:04:34 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA6CC061794;
        Mon, 27 Jul 2020 14:04:33 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 11so16723008qkn.2;
        Mon, 27 Jul 2020 14:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fmK6L/0QiUgIiYwBxTGcL+joJ1wkGcxNcczqzti8GgY=;
        b=c0dl7GcE3qXrMwLhOyjCKdHyJDcA7m5LeZ3ATOvuptnRH+viC3uFNrauwRs93IgcOo
         P4UOGQvq9tIWAxrDwItERdsK410OCjjyclMBJFN+cgOk0VnLVwcQW2Hh5oEE5mqvr/sy
         Wp2YwKveou+lupv1qxLro38uV9x6lR7/iDOKfz5rfHmJ9xNmzjrCVvCtMeOZW6J+gq9/
         Mdz0yl3w6rZhpQRZyDKvcG+pfgBvm3EoYzycuT5KMx63zKkwwfyCQeBuPVVZcxpVrDXm
         W0lNdPqNBv+aT8T1t/pPhrftQIrYQ9BA9OHHIOw+bdlCQre/JI9Ds/Lit7p0ipW0aN3z
         kvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fmK6L/0QiUgIiYwBxTGcL+joJ1wkGcxNcczqzti8GgY=;
        b=hEMiLRaSTC8md+GNMR6Z1+gJBxcyQPYQovqjvEj9DrkuVJMQzhII2S4BEhT93maIW5
         mk63hzUvmc+N1Fz2/MKCBrlz7OhaVWwfroIVoIooVxbhLNgby5XlIcpjIzKi03gUPpT/
         1UjjNNocxFpYE+ANm8fdxjlwEkVyNf1Nxkdihhpas3hmOYBhTekFYHbC7eRe/uJXgnCc
         6DcUuJUdvqiHCUo3C92EQgM1qd/JkeolDyNbfTlWB2/Gi/qifcIf+wBwsmlUmnXvgHoc
         u4hy/nQi0CcHPY1t9efW3z0kMLl3UPJ+ByW5wKRNTYnjwNZ06/s0f1vWeJ6z+E+81NZI
         /LAA==
X-Gm-Message-State: AOAM531OvMSGN5egsnSc9CI93Hj6xtE0hJwvyyAxjI4Bt5osFzDm5Lh2
        Xv1iYPQjhDJbbJkHUFU0iYbUsWApGQ==
X-Google-Smtp-Source: ABdhPJwB0/ozeneo/2CVyhyaxpaK56OJSASvgnRELqqALjaQFssdkweq7IKzB/8rlXefcfcoKqrb/w==
X-Received: by 2002:ae9:ef8d:: with SMTP id d135mr24189692qkg.109.1595883873133;
        Mon, 27 Jul 2020 14:04:33 -0700 (PDT)
Received: from localhost.localdomain ([209.94.141.207])
        by smtp.gmail.com with ESMTPSA id k2sm20964994qkf.127.2020.07.27.14.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 14:04:32 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH] scsi/megaraid: Prevent kernel-infoleak in kioc_to_mimd()
Date:   Mon, 27 Jul 2020 17:02:35 -0400
Message-Id: <20200727210235.327835-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hinfo_to_cinfo() does no operation on `cinfo` when `hinfo` is NULL,
causing kioc_to_mimd() to copy uninitialized stack memory to userspace.
Fix it by initializing `cinfo` with memset().

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
 drivers/scsi/megaraid/megaraid_mm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 8df53446641a..9df0e6b253a8 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -816,6 +816,8 @@ kioc_to_mimd(uioc_t *kioc, mimd_t __user *mimd)
 
 		case MEGAIOC_QADAPINFO:
 
+			memset(&cinfo, 0, sizeof(cinfo));
+
 			hinfo = (mraid_hba_info_t *)(unsigned long)
 					kioc->buf_vaddr;
 
-- 
2.25.1

