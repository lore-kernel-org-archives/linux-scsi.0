Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 294BBC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 08:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbiGSIZW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 04:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbiGSIZU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 04:25:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8EC63A7
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 01:25:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CAD6B1F96A;
        Tue, 19 Jul 2022 08:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658219114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZfuoHiT5gI+iw/S8x1Y2zaDL+70FJ7UZFvNUKZxxny0=;
        b=k3annwPybrFslMQjEAqEHKoJUsJ6DKPO/htUuUT/UJClksg5kTww6cIXd2JqeFTHt//38Y
        Sftbde49D7ocySAtUaRe583q6BqoPh85n74wqfDq2kZT9zVUBlaqTwLKmunwXABfjOll9G
        Kh/PcyMGyiEZAtuKqneBNovQ36wbyDs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658219114;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZfuoHiT5gI+iw/S8x1Y2zaDL+70FJ7UZFvNUKZxxny0=;
        b=e6xvCFOHv/awHgQrZ3kGHoOIMR8G4QnrtPYGPQE7bhGDQAZRgUggMgk/GAOqFOr9eicYDJ
        bbmgSmctWlqy/9Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BCF1C13488;
        Tue, 19 Jul 2022 08:25:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VlYULmpq1mLXSQAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 19 Jul 2022 08:25:14 +0000
Date:   Tue, 19 Jul 2022 10:25:14 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Arun Easi <aeasi@marvell.com>, Nilesh Javali <njavali@marvell.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, bhazarika@marvell.com,
        agurumurthy@marvell.com
Subject: Re: [PATCH 2/6] qla2xxx: Add a generic tracing framework
Message-ID: <20220719082514.egsqevbaxl7a4prx@carbon.lan>
References: <20220715060227.23923-1-njavali@marvell.com>
 <20220715060227.23923-3-njavali@marvell.com>
 <20220718085438.mdv3rnbwc4bxfxrd@carbon.lan>
 <f49cd5a0-93b8-48a2-5a3a-a4554ef660ac@marvell.com>
 <20220718152243.21ad13e7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718152243.21ad13e7@gandalf.local.home>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arun,

On Mon, Jul 18, 2022 at 03:22:43PM -0400, Steven Rostedt wrote:
> On Mon, 18 Jul 2022 12:02:26 -0700
> Arun Easi <aeasi@marvell.com> wrote:
> 
> > Many times when a problem was reported on the driver, we had to request 
> > for a repro with extended error logging (via driver module parameter) 
> > turned on. With this internal tracing in place, log messages that appear 
> > only with extended error logging are captured by default in the internal 
> > trace buffer.
> > 
> > AFAIK, kernel tracing requires a user initiated action to be turned on, 
> > like enabling individual tracepoints. Though a script (either startup or 
> > udev) can do this job, enabling tracepoints by default for a single 
> > driver, I think, may not be a preferred choice -- particularly when the 
> > trace buffer is shared across the kernel. That also brings the extra 
> > overhead of finding how this could be done across various distros.
> > 
> > For cases where the memory/driver size matters, there is an option to 
> > compile out this feature, plus choosing a lower default trace buffer size.

I am really asking the question why do we need to add special debugging
code to every single driver? Can't we try to make more use of generic
code and extend it if necessary?

Both FC drivers qla2xxx and lpfc are doing their own thing for
debugging/logging and I really fail to see why we can't not move towards
a more generic way. Dumping logs to the kernel log was the simplest way
but as this series shows, this is not something you can do in production
systems.

> You can enable an ftrace instance from inside the kernel, and make it a
> compile time option.
>
> 	#include <linux/trace_events.h>
> 	#include <linux/trace.h>
> 
> 	struct trace_array *tr;
> 
> 	tr = trace_array_get_by_name("qla2xxx");
> 	trace_array_set_clr_event(tr, "qla", NULL, true);
> 
> And now you have trace events running:
> 
>  # cat /sys/kernel/tracing/instances/qla/trace

Thanks Steve for the tip!

Daniel
