Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EB1ECAAD4
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Aug 2022 08:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiH3IHO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Aug 2022 04:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiH3IHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Aug 2022 04:07:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CE475CCB
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2022 01:07:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A3C981F9DC;
        Tue, 30 Aug 2022 08:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661846830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jzxmBLyGseKk0aWin8TQgZnrosx7YeA/I6/86QXXZH0=;
        b=dzOqTzgdEmtPkHztdu1wizrlJ0dvIgdUNBIRiIzDBv2oiqM04ql+LJHCEtefxqGRh4UTFs
        pO1aAo5DcQex37I3wdQlA7QgNwlrU//eBvRH3y/tXthKg6H6ffyHzjYPJJfYRCdGqRvOzY
        EfhHMamuU+oh2Szc+zjMeGp+FJfBoUs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661846830;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jzxmBLyGseKk0aWin8TQgZnrosx7YeA/I6/86QXXZH0=;
        b=iDNtOwH230BdSDqH/5uQBbHnL3Xmq+Uq+0QaDITrPWSqYc107o/CFDpRf1JfvGCiiXK2AX
        MlBulcCOOKHBirAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 94E0213B0C;
        Tue, 30 Aug 2022 08:07:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vrdMJC7FDWPbcQAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 30 Aug 2022 08:07:10 +0000
Date:   Tue, 30 Aug 2022 10:07:10 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, bhazarika@marvell.com,
        agurumurthy@marvell.com
Subject: Re: [PATCH v2 5/7] qla2xxx: Enhance driver tracing with separate
 tunable and more
Message-ID: <20220830080710.sceujw73cqd43rek@carbon.lan>
References: <20220826102559.17474-1-njavali@marvell.com>
 <20220826102559.17474-6-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826102559.17474-6-njavali@marvell.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 26, 2022 at 03:25:57AM -0700, Nilesh Javali wrote:
> From: Arun Easi <aeasi@marvell.com>
> 
> Older tracing of driver messages was to:
>     - log only debug messages to kernel main trace buffer AND
>     - log only if extended logging bits corresponding to this
>       message is off
> 
> This has been modified and extended as follows:
>     - Tracing is now controlled via ql2xextended_error_logging_ktrace
>       module parameter. Bit usages same as ql2xextended_error_logging.
>     - Tracing uses "qla2xxx" trace instance, unless instance creation
>       have issues.
>     - Tracing is enabled (compile time tunable).
>     - All driver messages, include debug and log messages are now traced
>       in kernel trace buffer.
> 
> Trace messages can be viewed by looking at the qla2xxx instance at:
>     /sys/kernel/tracing/instances/qla2xxx/trace

Nice! Thanks for getting this working.

> Trace tunable that takes the same bit mask as ql2xextended_error_logging
> is:
>     ql2xextended_error_logging_ktrace (default=1)
> 
> Suggested-by: Daniel Wagner <dwagner@suse.de>
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>

Reviewed-by: Daniel Wagner <dwagner@suse.de>

