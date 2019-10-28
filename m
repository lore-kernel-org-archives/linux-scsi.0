Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D21FCA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 19:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28D882196F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 19:42:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IiHYQCFR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbfJ1Tmp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 15:42:45 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36310 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731436AbfJ1Tmo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 15:42:44 -0400
Received: by mail-pf1-f195.google.com with SMTP id v19so7611738pfm.3;
        Mon, 28 Oct 2019 12:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=0uPwjvPDDcbZrAi/t7A1WG2QuL8CBu6DIq/6jf6WPZc=;
        b=IiHYQCFRSdg9h2t1Z9J5bqFPXe6+jjYnEGURx7ceCFWsou1IYyr7C5v35ukK7aA3rJ
         zyqI/kZi6iOMqC+XhwGr2wVVDBxRVTlsCQAnQfs9WktYJlKDLOpltyDlcy6hs0mGqZpz
         ZfOqBXqUsm/m9FaeGlBi07m0SIq4fC6QTQNrHNJRFlDUGGo1DwGA6RfetCzhAMRbSIJo
         o3yndYSx11SsXSIgnnvDTkOyxhiTjsS2SPrD31g34wjDzSpQZQw0lfblorFTwtc3hvIq
         Gkn/sKZiRAESDallHwQRWQy2IczxghbIKpmtMbncFang8KexeRjKp3Gnd1qNfEaXnzqq
         ECvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=0uPwjvPDDcbZrAi/t7A1WG2QuL8CBu6DIq/6jf6WPZc=;
        b=e8HWWBrOAyWFfVgajrfJtb8IKY7yxkDqCcHwhNzIgm4gvi8qlI9i8gNx4rDUGEybcR
         hW1S4Rx/eGBJAACcmBmhlz79Q3vs9mXJlw9EGBwvEjWqc4Xagftn7cChcNDsxXzGxCKW
         luI1fNuXRaTk43tl8AsOEGp3Wb5kmoaLHumXBjo5FKCQobwt/5CWZU1EovN3derOnm7R
         90Or+sOIMTlwa2hKc8lGZ14293FdAU48wP34g4XAobnbS6SCg53OystcaU1ixnivXR9+
         KhCHNug0FtJGVhvBOrkr77H1Q8YqGnx5tz6J+JUzFhj1lziR9mjdgijkuugKPHZVVcYq
         1GOg==
X-Gm-Message-State: APjAAAUrmuNQJhIggzmu/i6C1jjLjYR7T9eLy/kO25LDspcwC/yroV+H
        MeXmqnfbaMpFdMDRsWkOoMU=
X-Google-Smtp-Source: APXvYqzu6TffppNa9xrzWLh4SZ8UPboXLQhcIKs7cEOkosbBItxYLNI9ZgWEQy/bKVnFkVfO7sAmhg==
X-Received: by 2002:a62:82c1:: with SMTP id w184mr9140474pfd.134.1572291762706;
        Mon, 28 Oct 2019 12:42:42 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id j14sm11899910pfi.168.2019.10.28.12.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 12:42:42 -0700 (PDT)
Date:   Tue, 29 Oct 2019 01:12:34 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com, varun@chelsio.com,
        emilne@redhat.com, saurav.girepunje@gmail.com,
        gregkh@linuxfoundation.org, hare@suse.de,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] scsi: csiostor: Return value not required for
 csio_dfs_destroy.
Message-ID: <20191028194234.GA27848@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only csio_hw_free() calling csio_dfs_destroy() and it is not
checking return value. So remove the return from csio_dfs_destroy().

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/scsi/csiostor/csio_init.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index a6dd704d7f2d..28b77fa8b015 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -154,13 +154,11 @@ csio_dfs_create(struct csio_hw *hw)
 /*
  * csio_dfs_destroy - Destroys per-hw debugfs.
  */
-static int
+static void
 csio_dfs_destroy(struct csio_hw *hw)
 {
 	if (hw->debugfs_root)
 		debugfs_remove_recursive(hw->debugfs_root);
-
-	return 0;
 }
 
 /*
-- 
2.20.1

