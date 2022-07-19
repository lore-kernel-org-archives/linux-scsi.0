Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8884C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 13:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiGSNxs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 09:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237346AbiGSNxh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 09:53:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05E6115B2F
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 06:05:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECB13B81B38
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 13:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB048C341CA;
        Tue, 19 Jul 2022 13:05:42 +0000 (UTC)
Date:   Tue, 19 Jul 2022 09:05:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     Arun Easi <aeasi@marvell.com>, Nilesh Javali <njavali@marvell.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, bhazarika@marvell.com,
        agurumurthy@marvell.com
Subject: Re: [PATCH 2/6] qla2xxx: Add a generic tracing framework
Message-ID: <20220719090541.1296f2f1@gandalf.local.home>
In-Reply-To: <20220719082514.egsqevbaxl7a4prx@carbon.lan>
References: <20220715060227.23923-1-njavali@marvell.com>
        <20220715060227.23923-3-njavali@marvell.com>
        <20220718085438.mdv3rnbwc4bxfxrd@carbon.lan>
        <f49cd5a0-93b8-48a2-5a3a-a4554ef660ac@marvell.com>
        <20220718152243.21ad13e7@gandalf.local.home>
        <20220719082514.egsqevbaxl7a4prx@carbon.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 Jul 2022 10:25:14 +0200
Daniel Wagner <dwagner@suse.de> wrote:

> > You can enable an ftrace instance from inside the kernel, and make it a
> > compile time option.
> >
> > 	#include <linux/trace_events.h>
> > 	#include <linux/trace.h>
> > 
> > 	struct trace_array *tr;
> > 
> > 	tr = trace_array_get_by_name("qla2xxx");
> > 	trace_array_set_clr_event(tr, "qla", NULL, true);
> > 
> > And now you have trace events running:
> > 
> >  # cat /sys/kernel/tracing/instances/qla/trace  

The above should be:

     # cat /sys/kernel/tracing/instances/qla2xxx/trace

as the instance name is the string sent to trace_array_get_by_name().

-- Steve

