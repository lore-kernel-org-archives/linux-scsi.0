Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C33CC55186
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 03:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38DDF20774
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 03:59:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="j5/WDfoR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgDXD7L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 23:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726152AbgDXD7K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 23:59:10 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A555DC09B045
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 20:59:10 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j7so3980385pgj.13
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 20:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=aKsqWMMF7XAjoR4qcP662Fe48hXXc7Lfc4rPTQqKh9o=;
        b=j5/WDfoRPCLBn1WQ1c0L6jqcy6WQKwUgIPItCEj01VYZseeyqXJPqHsKczRUkrrm5/
         5xqKigrsIQ/xiEudgVB3vcLyvmFMiloSYZsOb9gLtOJEbPQcsgjWpKrdiGX/Vrs6gUzv
         3BLBcg6NnxizxZuvBFGCtS+jKkq1bJW2t7EbQxtTQ/9v241gNCGko1mKHjkYkgWrmmUt
         4QeuYo0nHVzjyq67PWKGTzD4ubtvwDzxChO/LgXTLbpONFe1sUv/h4tKBTiyFVbQrP2Z
         pp20yse0r33YK7eQSQMp1bhZ1Bm48xQM++/MYbNuURnm5s1IrfuMtYQ8QnWyRfRAGqav
         PDsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aKsqWMMF7XAjoR4qcP662Fe48hXXc7Lfc4rPTQqKh9o=;
        b=BchHnti8yMrG3xDpUcDDP0W/K7JB+FXJyzZzjaR4uA/m+z3DVi5Z445CuznAFB8pco
         8qZ2nRsV+F3u7msviPB+ucczym8VgXDTdIVASVOXqq7OiQHNm8/CCm7lVNFP7w5kX9bN
         bOBz4Ztq5j7rp/XtnoaE8/8fcvAylpfZ/buWFIu/UtdWGXnBy99VcUpvQ652UabBtMlz
         xOiRqdZkbY84Ox76QqxWv3WZ4ubqNLpsz2GmokQK2bClv8KWD90UxHnfyYGjncbfBHPm
         F8CX8ufZAb66q9CELH54XOOJYS2cY3RvEQEz349iPJpmUzycgcCK4IaJv4CVt5IJ8kkB
         1EKA==
X-Gm-Message-State: AGi0Pua55WtcNPb8Tow0I4Sqc3uo4D8jiRwJm+z0JkUeZi1asg0Hd75y
        UdiK2YMG9jYqD097cGFl0DjwxQ==
X-Google-Smtp-Source: APiQypKWZLh/0XqqNuuWKjfHAZlWJhkXUX+e2woAMrVxhdNM1AcpFWit0BuA/jGbd3dZQrxSG++WkQ==
X-Received: by 2002:a63:f48:: with SMTP id 8mr7400137pgp.184.1587700750199;
        Thu, 23 Apr 2020 20:59:10 -0700 (PDT)
Received: from debian.bytedance.net ([61.120.150.75])
        by smtp.gmail.com with ESMTPSA id h14sm3624577pjc.46.2020.04.23.20.59.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 20:59:09 -0700 (PDT)
From:   Hou Pu <houpu@bytedance.com>
To:     martin.petersen@oracle.com, mchristi@redhat.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Hou Pu <houpu@bytedance.com>
Subject: [PATCH v2 0/2] iscsi-target: fix login error when receiving is too fast
Date:   Thu, 23 Apr 2020 23:58:41 -0400
Message-Id: <20200424035843.5914-1-houpu@bytedance.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
We encountered "iSCSI Login negotiation failed" several times.
After enable debug log in iscsi_target_nego.c of iSCSI target.
Error shows:
  "Got LOGIN_FLAGS_READ_ACTIVE=1, conn: xxxxxxxxxx >>>>"

Patch 1 is trying to fix this problem. Please see comment in patch 1
for details.

Changes from v2:
* Improve comments in patch #1.
* Change bit possition of login_flags in patch #1.

Hou Pu (2):
  iscsi-target: fix login error when receiving is too fast
  iscsi-target: Fix inconsistent debug message in
    __iscsi_target_sk_check_close

 drivers/target/iscsi/iscsi_target_nego.c | 31 ++++++++++++++++++++++++++-----
 include/target/iscsi/iscsi_target_core.h |  9 +++++----
 2 files changed, 31 insertions(+), 9 deletions(-)

-- 
2.11.0

