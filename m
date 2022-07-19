Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918E3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 21:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiGSVlD convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiGSVlB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 17:41:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A012019E
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 14:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1ED261A81
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 21:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4DDC341C6;
        Tue, 19 Jul 2022 21:40:58 +0000 (UTC)
Date:   Tue, 19 Jul 2022 17:40:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arun Easi <aeasi@marvell.com>
Cc:     Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: Re: [EXT] Re: [PATCH 2/6] qla2xxx: Add a generic tracing framework
Message-ID: <20220719174056.56d39d87@gandalf.local.home>
In-Reply-To: <259d53a5-958e-6508-4e45-74dba2821242@marvell.com>
References: <20220715060227.23923-1-njavali@marvell.com>
        <20220715060227.23923-3-njavali@marvell.com>
        <20220718085438.mdv3rnbwc4bxfxrd@carbon.lan>
        <f49cd5a0-93b8-48a2-5a3a-a4554ef660ac@marvell.com>
        <20220718152243.21ad13e7@gandalf.local.home>
        <259d53a5-958e-6508-4e45-74dba2821242@marvell.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 Jul 2022 14:06:11 -0700
Arun Easi <aeasi@marvell.com> wrote:

> It appears by calling the above two interfaces, I get a separate instance 
> of "qla" only traces, but with only the "qla"-only instance being enabled, 
> leaving the main (/sys/kernel/tracing/events/qla/enable) one disabled. No 
> issues there, but when I enable both of them, I get garbage values on one.
> 
> /sys/kernel/tracing/instances/qla2xxx/trace:
>              cat-56106   [012] ..... 2419873.470098: ql_dbg_log: qla2xxx [0000:05:00.0]-1054:14:  Entered (null).
>              cat-56106   [012] ..... 2419873.470101: ql_dbg_log: qla2xxx [0000:05:00.0]-1000:14:  Entered ×+<96>²Ü<98>^H.
>              cat-56106   [012] ..... 2419873.470102: ql_dbg_log: qla2xxx [0000:05:00.0]-1006:14:  Prepare to issue mbox cmd=0xde589000.
> 
> /sys/kernel/tracing/trace:
>              cat-56106   [012] ..... 2419873.470097: ql_dbg_log: qla2xxx [0000:05:00.0]-1054:14:  Entered qla2x00_get_firmware_state.
>              cat-56106   [012] ..... 2419873.470100: ql_dbg_log: qla2xxx [0000:05:00.0]-1000:14:  Entered qla2x00_mailbox_command.
>              cat-56106   [012] ..... 2419873.470102: ql_dbg_log: qla2xxx [0000:05:00.0]-1006:14:  Prepare to issue mbox cmd=0x69.
> 
> It appears that only one should be enabled at a time. Per my read of 
> Documentation/trace/ftrace.rst, the main directory and instances have 
> separate trace buffers, so I am a bit confused with the above output.

That's because it uses va_list, and va_list can only be used once.

I just added helpers for va_list use cases:

   https://lore.kernel.org/all/20220705224453.120955146@goodmis.org/

But it will likely suffer the same issue, but I can easily fix that with
this on top:

Not even compiled tested:

-- Steve

diff --git a/include/trace/stages/stage6_event_callback.h b/include/trace/stages/stage6_event_callback.h
index 0f51f6b3ab70..3c554a585320 100644
--- a/include/trace/stages/stage6_event_callback.h
+++ b/include/trace/stages/stage6_event_callback.h
@@ -40,7 +40,12 @@
 
 #undef __assign_vstr
 #define __assign_vstr(dst, fmt, va)					\
-	vsnprintf(__get_str(dst), TRACE_EVENT_STR_MAX, fmt, *(va))
+	do {								\
+		va_list __cp_va;					\
+		va_copy(__cp_va, *(va));				\
+		vsnprintf(__get_str(dst), TRACE_EVENT_STR_MAX, fmt, __cp_va); \
+		va_end(__cp_va);					\
+	} while (0)
 
 #undef __bitmask
 #define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
