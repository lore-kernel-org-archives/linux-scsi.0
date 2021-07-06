Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA1D0C07E99
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 03:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1EB161986
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 03:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhGFDON (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 23:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbhGFDOM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 23:14:12 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04767C061574
        for <linux-scsi@vger.kernel.org>; Mon,  5 Jul 2021 20:11:35 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 21so18253878pfp.3
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jul 2021 20:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=KN5Dq3VA+/OK1czIe0yr+RPnDgcQ25YkL9hr4K2AuxQ=;
        b=FbVlosVGAhF2T6PbGoyZZARHDAwjMwIpt3FNw1ekVJ+XmMI1+ZamoDfeWjFUHawEfC
         46/cNs0JkmNw3vvdf57w/nlsupI7oLAh42FvEz9zqK2+cVfkvxclUy1pWPjTG+jz0Al9
         f8AJ0O3icq2SH1G4OYhIXPAd4gciEIQ3eU0sbeWqxmtd/njqb79EAXia0kyGseQkWBUn
         msgzF7zHuiTRT/CiGjJYK1dk7VJFV4YK/xI0hha5LAt2LcBIgc2vkfYepbTN+wsyunSo
         jDzBCM99o+GP2VQk1aL/flnMk2DNhSWQ/K32Gst94HfNPYBFqwCXZN+NwuyH8IxGR6nM
         hY7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=KN5Dq3VA+/OK1czIe0yr+RPnDgcQ25YkL9hr4K2AuxQ=;
        b=ZfOQDwuLFUvnSPpYW1snV/SFSJq4oNl8PfTe4q2PHjcNlAJ4fDH3U9MuNhoADEZ2aY
         7+ag7+8kPBxZ6Ij5xYWJmsI5EFXyDti7TNzr4b+0HVJdhWrIowzmBmrfIXVR1BlFwy5u
         hbhxPuXpacJNnWQ61/pl/vX/3g9OIPHpTVWjS5noTuGQSYwZGmYsSNat8Y4HdDLC6hc3
         qPujXOfhOTd2441mY6ooM9HSaYuh/hXNGmZCJe8lG+kqMMWh28taYLqmhUHKQxtMlaok
         sRzDZFiJCNpAUHyNIFYQ8RoQF/RoBsjfd6kFYgkUKq3AWf2au0g6QbYgEF8Io48jtexI
         zNjQ==
X-Gm-Message-State: AOAM533gFN0fpB/D6JvjGi0goSNNYsvX5uV0nObgSyDdeC91r8bfPQii
        tyOApIdXOtrFKnD+9J159MVmPmHCEro=
X-Google-Smtp-Source: ABdhPJxOx466+SDypIkdhWOH43VDZXHJ52iYosJzhttWfk3yW3ZZvGuxLxAeo/K0egb4q5DVSgr3Pg==
X-Received: by 2002:a62:7a08:0:b029:323:c5f:6503 with SMTP id v8-20020a627a080000b02903230c5f6503mr1504362pfc.59.1625541094527;
        Mon, 05 Jul 2021 20:11:34 -0700 (PDT)
Received: from jianchwadeMacBook-Pro.local ([154.86.159.246])
        by smtp.gmail.com with ESMTPSA id b33sm3699584pgb.92.2021.07.05.20.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 20:11:34 -0700 (PDT)
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org
From:   Wang Jianchao <jianchao.wan9@gmail.com>
Subject: Discard performance regression after "scsi: sd: Remove LBPRZ
 dependency for discards"
Message-ID: <279cb008-4c92-0535-efdd-6e877bea7349@gmail.com>
Date:   Tue, 6 Jul 2021 11:11:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin

We have a sata ssd with following parameters,

  max_ws_blocks = 0
  max_unmap_blocks = 262143
  lbprz = 1
  lbpu = 1
  unmap_limit_for_ws = 0

But the discard performance is very different on 3.10 and 4.18 series,
On 3.10 series, the bw of discard is ~60G/s, but on 4.18, it is only ~2.7G/s
The reason is the discard_max_bytes,
3.10 series : 4294966784
4.18 series : 134217216

This difference happen after commit 
commit bcd069bb250acf6088b60d189ab3ec3ae8dd11a5 (scsi: sd: Remove LBPRZ dependency for discards)

@@ -2842,7 +2829,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
                                sd_config_discard(sdkp, SD_LBP_WS16);
 
                } else {        /* LBP VPD page tells us what to use */
-                       if (sdkp->lbpu && sdkp->max_unmap_blocks && !sdkp->lbprz)
+                       if (sdkp->lbpu && sdkp->max_unmap_blocks)
                                sd_config_discard(sdkp, SD_LBP_UNMAP);
                        else if (sdkp->lbpws)
                                sd_config_discard(sdkp, SD_LBP_WS16);

Before this commit, it enters SD_LBP_WS16 case, but after the patch, it enters SD_LBP_UNMAP.

Which should be the correct case ?

Thanks and Best regards
Jianchao
