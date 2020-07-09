Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CFCC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4945207D0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H1Gd2Qce"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgGIRra (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728489AbgGIRqI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:08 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7115C08C5DC
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:07 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id r12so3254174wrj.13
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t/zzBO2Jyh9x8BHnEJvhlwlew5qspE/Jnd9v9TqHGYM=;
        b=H1Gd2QcePmOch/qjxRoMvW6JpS/d1uxfjssBsju4ijWuNBYeYhSLPGusubNnj64R5d
         lBPC0Qh+tijB0657/8ocUTQZ6VlX4DDoXTQNRPhiWMmbtic0pnF8hwgMWiOEy3krR6EG
         MM9qZbNhjzJosugv5Xct60LzcQ6H/ERwD1FmetEC+68lox6HzXQQqchkvRA86EEmgID1
         u+CtA6elQsQtcnQ0i//PmrJwD9zmThbvWktCDt4ictyJiPhxsvrXz2JYtkVT0KLaaPAB
         70Up4s7t49cja8tJgfdrv/f/xjbyjE6WcN1PZ9nN2M1ioLlvyDRNj9Mo4nYJDzXMOdEN
         Up0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t/zzBO2Jyh9x8BHnEJvhlwlew5qspE/Jnd9v9TqHGYM=;
        b=pnMldiDtipr6WS95MdkuPfPQqVvaRbLhGvzX9W3OtGakjAsXse0aqDrSGCZGVA2GCO
         YPXZvIDIrwIz2sX5WklF/cB2L9Ilc1QD5beJfYMiH4nStaWl0uAYvp0BYNGjplEa4ch2
         h4d8Z5aFU6ZSW/zr70/dNoFSUHeIb4fd9U0nRifJd4uHfksr74Us8y/hfQaOABKDnQbV
         HZ5YIPhbqFLEUEvBA2hN74zrWSRziS4hNCmgnpMsJ1jl3/w/doAWzi6mpFGbeL8FgjHr
         ydRgeD57lEdGSXwH5wBa5/N2h1q8R86szPbHjbm1qyVVm+/h/RKlUdZloRgJ7WU2og4r
         NMKw==
X-Gm-Message-State: AOAM530UidGR5gDXYt9R04oFapeJa+Rlob7CQgU4859Hjl8Dih8J1DwU
        OyZygOYjrZU5QYpmjjoMu+zTuA==
X-Google-Smtp-Source: ABdhPJw/z+CbiouBYdlTZxBgt9fyrvU1bnWHwSoZXHlYLQw4mSjV7jsGybDb0S7HlMNgxmDi9+MCLQ==
X-Received: by 2002:a5d:5341:: with SMTP id t1mr68373388wrv.207.1594316766614;
        Thu, 09 Jul 2020 10:46:06 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:05 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH 07/24] scsi: aacraid: commsup: Fix a bunch of function header issues
Date:   Thu,  9 Jul 2020 18:45:39 +0100
Message-Id: <20200709174556.7651-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some parameters not documented.  Others misspelled.

Also, functions must follow directly after the header that documents them.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/commsup.c:223: warning: Function parameter or member 'scmd' not described in 'aac_fib_alloc_tag'
 drivers/scsi/aacraid/commsup.c:421: warning: Function parameter or member 'qid' not described in 'aac_queue_get'
 drivers/scsi/aacraid/commsup.c:421: warning: Function parameter or member 'hw_fib' not described in 'aac_queue_get'
 drivers/scsi/aacraid/commsup.c:421: warning: Excess function parameter 'priority' description in 'aac_queue_get'
 drivers/scsi/aacraid/commsup.c:421: warning: Excess function parameter 'fib' description in 'aac_queue_get'
 drivers/scsi/aacraid/commsup.c:943: warning: Function parameter or member 'fibptr' not described in 'aac_fib_complete'
 drivers/scsi/aacraid/commsup.c:943: warning: Excess function parameter 'fib' description in 'aac_fib_complete'
 drivers/scsi/aacraid/commsup.c:1061: warning: Excess function parameter 'dev' description in 'AIF_SNIFF_TIMEOUT'
 drivers/scsi/aacraid/commsup.c:1061: warning: Excess function parameter 'fibptr' description in 'AIF_SNIFF_TIMEOUT'
 drivers/scsi/aacraid/commsup.c:2428: warning: Function parameter or member 'data' not described in 'aac_command_thread'
 drivers/scsi/aacraid/commsup.c:2428: warning: Excess function parameter 'dev' description in 'aac_command_thread'

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/commsup.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 8ee4e1abe568d..adbdc3b7c7a70 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -214,6 +214,7 @@ int aac_fib_setup(struct aac_dev * dev)
 /**
  *	aac_fib_alloc_tag-allocate a fib using tags
  *	@dev: Adapter to allocate the fib for
+ *	@scmd: SCSI command
  *
  *	Allocate a fib from the adapter fib pool using tags
  *	from the blk layer.
@@ -405,8 +406,8 @@ static int aac_get_entry (struct aac_dev * dev, u32 qid, struct aac_entry **entr
  *	aac_queue_get		-	get the next free QE
  *	@dev: Adapter
  *	@index: Returned index
- *	@priority: Priority of fib
- *	@fib: Fib to associate with the queue entry
+ *	@qid: Queue number
+ *	@hw_fib: Fib to associate with the queue entry
  *	@wait: Wait if queue full
  *	@fibptr: Driver fib object to go with fib
  *	@nonotify: Don't notify the adapter
@@ -934,7 +935,7 @@ int aac_fib_adapter_complete(struct fib *fibptr, unsigned short size)
 
 /**
  *	aac_fib_complete	-	fib completion handler
- *	@fib: FIB to complete
+ *	@fibptr: FIB to complete
  *
  *	Will do all necessary work to complete a FIB.
  */
@@ -1049,6 +1050,7 @@ static void aac_handle_aif_bu(struct aac_dev *dev, struct aac_aifcmd *aifcmd)
 	}
 }
 
+#define AIF_SNIFF_TIMEOUT	(500*HZ)
 /**
  *	aac_handle_aif		-	Handle a message from the firmware
  *	@dev: Which adapter this fib is from
@@ -1057,8 +1059,6 @@ static void aac_handle_aif_bu(struct aac_dev *dev, struct aac_aifcmd *aifcmd)
  *	This routine handles a driver notify fib from the adapter and
  *	dispatches it to the appropriate routine for handling.
  */
-
-#define AIF_SNIFF_TIMEOUT	(500*HZ)
 static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 {
 	struct hw_fib * hw_fib = fibptr->hw_fib_va;
@@ -2416,7 +2416,7 @@ static int aac_send_hosttime(struct aac_dev *dev, struct timespec64 *now)
 
 /**
  *	aac_command_thread	-	command processing thread
- *	@dev: Adapter to monitor
+ *	@data: Adapter to monitor
  *
  *	Waits on the commandready event in it's queue. When the event gets set
  *	it will pull FIBs off it's queue. It will continue to pull FIBs off
-- 
2.25.1

