Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122D1ECAAD1
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 13:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbiIANmQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 09:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbiIANlf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 09:41:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D704D254
        for <linux-scsi@vger.kernel.org>; Thu,  1 Sep 2022 06:40:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAF8761460
        for <linux-scsi@vger.kernel.org>; Thu,  1 Sep 2022 13:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407A6C433C1;
        Thu,  1 Sep 2022 13:40:31 +0000 (UTC)
Date:   Thu, 1 Sep 2022 09:41:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH v2 5/7] qla2xxx: Enhance driver tracing with separate
 tunable and more
Message-ID: <20220901094102.76b0bb1e@gandalf.local.home>
In-Reply-To: <20220830075554.2pv7fnszi6nyac3m@carbon.lan>
References: <20220826102559.17474-1-njavali@marvell.com>
        <20220826102559.17474-6-njavali@marvell.com>
        <773B9D53-D043-42D9-B830-694A3E21A222@oracle.com>
        <ad348f6e-fec6-1ce5-eed5-621f84a5e580@marvell.com>
        <AFBD250B-7F4D-4C63-B05E-E534F9BC5805@oracle.com>
        <20220830075554.2pv7fnszi6nyac3m@carbon.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 30 Aug 2022 09:55:54 +0200
Daniel Wagner <dwagner@suse.de> wrote:

> On Mon, Aug 29, 2022 at 07:25:34PM +0000, Himanshu Madhani wrote:
> > root@tatoonie~6.0.0-rc1+:/# ls -l /sys/kernel/tracing/
> > total 0
> > root@tatoonie~6.0.0-rc1+:/# ls -l /sys/kernel/debug/tracing/instances/qla2xxx/trace
> > -rw-r----- 1 root root 0 Aug 29 08:54 /sys/kernel/debug/tracing/instances/qla2xxx/trace  
> 
> IIRC, Steven's goal was to get all distros to move the mount point
> from /sys/kernel/debug/tracing to /sys/kernel/tracing. Not sure where we
> stand here.

I believe Fedora and Debian both have added it there.

Note, when mounting the debugfs file system to /sys/kernel/debug, tracefs
is automatically mounted at /sys/kernel/debug/tracing for backward
compatibility.

But the correct place to mount tracefs, is at /sys/kernel/tracing. Perhaps
I will remove the autmatic mounting of tracefs on debugfs when that becomes
the norm.

-- Steve
