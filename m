Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F267C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 19:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbiGRTWs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 15:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbiGRTWr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 15:22:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D429E2F03A
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 12:22:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61133616DA
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 19:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFF0C341C0;
        Mon, 18 Jul 2022 19:22:44 +0000 (UTC)
Date:   Mon, 18 Jul 2022 15:22:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arun Easi <aeasi@marvell.com>
Cc:     Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: Re: [PATCH 2/6] qla2xxx: Add a generic tracing framework
Message-ID: <20220718152243.21ad13e7@gandalf.local.home>
In-Reply-To: <f49cd5a0-93b8-48a2-5a3a-a4554ef660ac@marvell.com>
References: <20220715060227.23923-1-njavali@marvell.com>
        <20220715060227.23923-3-njavali@marvell.com>
        <20220718085438.mdv3rnbwc4bxfxrd@carbon.lan>
        <f49cd5a0-93b8-48a2-5a3a-a4554ef660ac@marvell.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Jul 2022 12:02:26 -0700
Arun Easi <aeasi@marvell.com> wrote:

> Many times when a problem was reported on the driver, we had to request 
> for a repro with extended error logging (via driver module parameter) 
> turned on. With this internal tracing in place, log messages that appear 
> only with extended error logging are captured by default in the internal 
> trace buffer.
> 
> AFAIK, kernel tracing requires a user initiated action to be turned on, 
> like enabling individual tracepoints. Though a script (either startup or 
> udev) can do this job, enabling tracepoints by default for a single 
> driver, I think, may not be a preferred choice -- particularly when the 
> trace buffer is shared across the kernel. That also brings the extra 
> overhead of finding how this could be done across various distros.
> 
> For cases where the memory/driver size matters, there is an option to 
> compile out this feature, plus choosing a lower default trace buffer size.

You can enable an ftrace instance from inside the kernel, and make it a
compile time option.

	#include <linux/trace_events.h>
	#include <linux/trace.h>

	struct trace_array *tr;

	tr = trace_array_get_by_name("qla2xxx");
	trace_array_set_clr_event(tr, "qla", NULL, true);

And now you have trace events running:

 # cat /sys/kernel/tracing/instances/qla/trace

-- Steve
