Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 517E4C43214
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 02:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3682361101
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 02:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbhHSCa6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 22:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbhHSCa5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 22:30:57 -0400
Received: from mail-pg1-x564.google.com (mail-pg1-x564.google.com [IPv6:2607:f8b0:4864:20::564])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D163C0613D9
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 19:30:21 -0700 (PDT)
Received: by mail-pg1-x564.google.com with SMTP id k14so4418087pga.13
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 19:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:dkim-signature:from:to:cc:subject:date
         :message-id:in-reply-to:references:content-transfer-encoding;
        bh=NSy0VIbEIz5W7JO0jujV3Q6SFnGtXn+KVAFFJZwMXB4=;
        b=KeGEY9WgX/xFRdSfUN2U0kleIb3BelRwdWmcg99OCH2ykWEwxhp1K5aseubMHT9SQ7
         GcLAbiN8czTJriX+EQOW8yeqUdaglTiQ/Cwz8v9ApQ2dIbtCBPB3bW7IWPYaKWfa0U8U
         hJ+ml2FB3GhOvU7WH0rPU7jSmaBP40avYyeY+Sgu9MEui60m8+kvgqC/IsD8Fk1L6fv0
         Gbxbpfdd7slpVM3Ymw5lss9ImTtQ90/sMDeDGk2UigEXEHm2XgQqwo8HHHrGvJkAyvyp
         hU4BuR0G7M0VpcDNWknDCdE697WVirtn+YBmJF/W6qx4X2BItpWhM31et/II7DCL7ksA
         As+A==
X-Gm-Message-State: AOAM531t5NH70gwCkDXvC2w9z+QLLMJ0/Cgm00CQ7ckOnvo/gRutbB5D
        qgD/APOW+aJV/ZkVBJpW8HyWZnVKaE96jOCd6q87sN3PGQAZ
X-Google-Smtp-Source: ABdhPJxXc87b5Lb56aujd5toN5v0pdiQ7cFKUaUK3HFa+AhKIy4PUN5WyR9OHHjVvomiLYLyDdnxAYM2OkvO
X-Received: by 2002:a63:5f88:: with SMTP id t130mr11884742pgb.6.1629340221059;
        Wed, 18 Aug 2021 19:30:21 -0700 (PDT)
Received: from smtp.aristanetworks.com (smtp.aristanetworks.com. [54.193.82.35])
        by smtp-relay.gmail.com with ESMTPS id b13sm444963pjl.9.2021.08.18.19.30.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Aug 2021 19:30:21 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.69.61])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 6ED893019831;
        Wed, 18 Aug 2021 19:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1629340220;
        bh=NSy0VIbEIz5W7JO0jujV3Q6SFnGtXn+KVAFFJZwMXB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGbGjeIq3UuDrnHlp9MOAfM4vGlpBVnZGGZSeCq9dyoLT2oXBZee+y3jqFKknuKXB
         QQ+pPhQPpwTgxwc4nrydh9S52F8AUw2SmEY80uuAGXAt9sNLBs7kkDvkrsZZbza2Dv
         ndmyiaSgiH3NGpKnfZze8H2HZF6lAsjvzIf9yKCUuQ71//e4LzABO46J/d5d9R9rbJ
         eYN9aqBAdH7ubAvyeDvFOYz6DcmJq1MzdjeUh7iOyq54Mu54zGqiwNTyQjBg4KLuEz
         lLN7YQMKVkMp9mP6p+eqVnMZV3LI01/3qc7S4qEUSWAZqzLZ9K+hukJbSsYVuoKWyu
         QHlJi+Da/lVtg==
Received: from kevmitch by chmeee with local (Exim 4.94.2)
        (envelope-from <kevmitch@chmeee>)
        id 1mGXow-002MCf-LX; Wed, 18 Aug 2021 19:30:18 -0700
From:   Kevin Mitchell <kevmitch@arista.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kevin Mitchell <kevmitch@arista.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] lkdtm: replace SCSI_DISPATCH_CMD with SCSI_QUEUE_RQ
Date:   Wed, 18 Aug 2021 19:29:39 -0700
Message-Id: <20210819022940.561875-2-kevmitch@arista.com>
In-Reply-To: <20210819022940.561875-1-kevmitch@arista.com>
References: <20210819022940.561875-1-kevmitch@arista.com>
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When scsi_dispatch_cmd was moved to scsi_lib.c and made static, some
compilers (i.e., at least gcc 8.4.0) decided to compile this
inline. This is a problem for lkdtm.ko, which inserted a kprobe
on this function for the SCSI_DISPATCH_CMD crashpoint.

Move this crashpoint one function up the call chain to
scsi_queue_rq. Though this is also a static function, it should never be
inlined because it is assigned as a structure entry. Therefore,
kprobe_register should always be able to find it.

Fixes: 82042a2cdb55 ("scsi: move scsi_dispatch_cmd to scsi_lib.c")
Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
---
 Documentation/fault-injection/provoke-crashes.rst | 2 +-
 drivers/misc/lkdtm/core.c                         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/fault-injection/provoke-crashes.rst b/Documentation/fault-injection/provoke-crashes.rst
index a20ba5d93932..18de17354206 100644
--- a/Documentation/fault-injection/provoke-crashes.rst
+++ b/Documentation/fault-injection/provoke-crashes.rst
@@ -29,7 +29,7 @@ recur_count
 cpoint_name
 	Where in the kernel to trigger the action. It can be
 	one of INT_HARDWARE_ENTRY, INT_HW_IRQ_EN, INT_TASKLET_ENTRY,
-	FS_DEVRW, MEM_SWAPOUT, TIMERADD, SCSI_DISPATCH_CMD,
+	FS_DEVRW, MEM_SWAPOUT, TIMERADD, SCSI_QUEUE_RQ,
 	IDE_CORE_CP, or DIRECT
 
 cpoint_type
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index 9dda87c6b54a..016cb0b150fc 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -82,7 +82,7 @@ static struct crashpoint crashpoints[] = {
 	CRASHPOINT("FS_DEVRW",		 "ll_rw_block"),
 	CRASHPOINT("MEM_SWAPOUT",	 "shrink_inactive_list"),
 	CRASHPOINT("TIMERADD",		 "hrtimer_start"),
-	CRASHPOINT("SCSI_DISPATCH_CMD",	 "scsi_dispatch_cmd"),
+	CRASHPOINT("SCSI_QUEUE_RQ",	 "scsi_queue_rq"),
 	CRASHPOINT("IDE_CORE_CP",	 "generic_ide_ioctl"),
 #endif
 };
-- 
2.32.0

