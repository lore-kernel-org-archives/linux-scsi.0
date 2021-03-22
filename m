Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6E1C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 00:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 329C261941
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 00:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCVAaK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Mar 2021 20:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCVA3m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2021 20:29:42 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E154EC061574;
        Sun, 21 Mar 2021 17:29:41 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id y5so7429678qkl.9;
        Sun, 21 Mar 2021 17:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qo7mpPnQNrjsn8Fdj917329tS50ebmB+EiR3DqrVDcE=;
        b=kHdDfmmXACgRTt/bhZFviqMTu6kpk49oPUMzwqwZjnX5ttKoHHJF3sA61C3mm9D9JR
         ruyG4vuLb1Nr5DqePXyo0DfCv+Sip7my3QCNTV7CHPpEAP5l39d2YWoZgnHJgSDCfiCB
         JTm4rWTRVzjHZvsYpoY/1IhjQ+4DwIQivgT9OcyAPgK3OD+u4ooCRIntiRoJO8bFvZ3C
         NSsjzd4hlfGTP8w0OQoEwzDU/HpQDNr9EZgUDMThbY555Yf/Mrr2SZGtGAM2uobC9RRz
         FC9eQSmV34OVvNi/Kx4qDEhnj+Y8a7rmyAUoHdIhnClJnhO2HrKOzZMLKvSyWQequ9QV
         LKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qo7mpPnQNrjsn8Fdj917329tS50ebmB+EiR3DqrVDcE=;
        b=L89Av4PrTctXGuBfy1EgBbmehP46AM0zwNr4e52ByRYByOTRd7zi16ZwmyWJB6jXvz
         8JimD6TkqJqALRUZsa/Tst+UYrsmGDHZ/agl64GFrb/vaswUtRaluXt0DL9y4Wl9C6JM
         hPcF+pYqidAkDnOAkIUx9v2/XbYL87ZPzf/IrsLiL0XInSWb9NqCLOMLzSkFdawp8Qxk
         d+bJhE8j57KRjOzzrG1ft8oW/3tUFhfDV+wYoNTHDg/r0HcNm7hfwgRgP5yW1MFDbSNw
         4lJNEXCVFwB6hVEPylzsOsLnGX+jIIvI8lJeCZpJHUxKbPDjsio7XNY002k87Sc8JRtk
         uddg==
X-Gm-Message-State: AOAM5301uojiS8nAMepTBXmm2sUqRjCfxjDAOtaUsfJ1BqOkTydACLV6
        Tjk2ZIlhX3N2S0Phg8n59Qc=
X-Google-Smtp-Source: ABdhPJyw1xBxJIWrNPZTw9NKvf4FAU+5x13kwkdKcHYR8N7YnUtuO27LfAVht9HzFjyH6x5vwFozCA==
X-Received: by 2002:a05:620a:1133:: with SMTP id p19mr8960232qkk.340.1616372981099;
        Sun, 21 Mar 2021 17:29:41 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:f925:bb4b:54d2:533])
        by smtp.googlemail.com with ESMTPSA id j3sm9721373qki.84.2021.03.21.17.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 17:29:40 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH 0/2] scsi: myrb: fix null-ptr-dereference issues
Date:   Sun, 21 Mar 2021 20:29:33 -0400
Message-Id: <20210322002936.1352871-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series fixes two null-ptr-dereference issues in the myrb driver.
Both are caused by uninitialized variables.

Tong Zhang (2):
  scsi: myrb: fix null-ptr-dereference in myrb_cleanup
  scsi: myrb: fix null-ptr-dereference in myrb_probe

 drivers/scsi/myrb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.25.1

