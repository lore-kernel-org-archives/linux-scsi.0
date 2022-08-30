Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90DCECAAA1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Aug 2022 07:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiH3Hz7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Aug 2022 03:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiH3Hz6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Aug 2022 03:55:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866EE9C20F
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2022 00:55:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F09031F388;
        Tue, 30 Aug 2022 07:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661846154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dUfLqjJ/b2ym45DMl8EciNH8RIVz3pewi30XIOBTG+4=;
        b=BXWjyWRpEDia113BKn2qdJ+Jm57jJw+ukl4cS3cjCDNp1+4xBaKmkscZ9OJD8qLBHhOdJK
        WS10BpwVuyvbSbpt6GGH7knP/1FXCWjfz+3lifcHABfl7+wu/ebS1zgH+6CMYxpMorj8BZ
        eCwntU5QsHBFglmMXlmTt71/Y25rquY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661846154;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dUfLqjJ/b2ym45DMl8EciNH8RIVz3pewi30XIOBTG+4=;
        b=WAmdZ1vu6EKrxqZpQv97Xg9/sCWYQXRdIm4uHqlkzq5cD6HUw4dQPzEXNlVDU7CRIIoGLk
        pSLlmHeYHkdV6QAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D600713B0C;
        Tue, 30 Aug 2022 07:55:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qPsWNIrCDWNPbQAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 30 Aug 2022 07:55:54 +0000
Date:   Tue, 30 Aug 2022 09:55:54 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
Cc:     Arun Easi <aeasi@marvell.com>, Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 5/7] qla2xxx: Enhance driver tracing with separate
 tunable and more
Message-ID: <20220830075554.2pv7fnszi6nyac3m@carbon.lan>
References: <20220826102559.17474-1-njavali@marvell.com>
 <20220826102559.17474-6-njavali@marvell.com>
 <773B9D53-D043-42D9-B830-694A3E21A222@oracle.com>
 <ad348f6e-fec6-1ce5-eed5-621f84a5e580@marvell.com>
 <AFBD250B-7F4D-4C63-B05E-E534F9BC5805@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AFBD250B-7F4D-4C63-B05E-E534F9BC5805@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 29, 2022 at 07:25:34PM +0000, Himanshu Madhani wrote:
> root@tatoonie~6.0.0-rc1+:/# ls -l /sys/kernel/tracing/
> total 0
> root@tatoonie~6.0.0-rc1+:/# ls -l /sys/kernel/debug/tracing/instances/qla2xxx/trace
> -rw-r----- 1 root root 0 Aug 29 08:54 /sys/kernel/debug/tracing/instances/qla2xxx/trace

IIRC, Steven's goal was to get all distros to move the mount point
from /sys/kernel/debug/tracing to /sys/kernel/tracing. Not sure where we
stand here.
