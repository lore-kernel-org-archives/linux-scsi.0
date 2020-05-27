Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D78C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B52C4207CB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgE0CXT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 22:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgE0CXT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 22:23:19 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45199C061A0F
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2020 19:23:19 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 73A582A0285
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        Khazhismel Kumykov <khazhy@google.com>, cleech@redhat.com,
        lduncan@suse.com, kernel@collabora.com
Subject: Re: [PATCH v2] iscsi: Fix deadlock on recovery path during GFP_IO reclaim
Organization: Collabora
References: <20200520022959.1912856-1-krisman@collabora.com>
        <159054550935.12032.12429490681572583579.b4-ty@oracle.com>
Date:   Tue, 26 May 2020 22:23:13 -0400
In-Reply-To: <159054550935.12032.12429490681572583579.b4-ty@oracle.com>
        (Martin K. Petersen's message of "Tue, 26 May 2020 22:12:58 -0400")
Message-ID: <85imgiyv3i.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

> On Tue, 19 May 2020 22:29:59 -0400, Gabriel Krisman Bertazi wrote:
>
>> iscsi suffers from a deadlock in case a management command submitted via
>> the netlink socket sleeps on an allocation while holding the
>> rx_queue_mutex, if that allocation causes a memory reclaim that
>> writebacks to a failed iscsi device.  Then, the recovery procedure can
>> never make progress to recover the failed disk or abort outstanding IO
>> operations to complete the reclaim (since rx_queue_mutex is locked),
>> thus locking the system.
>> 
>> [...]
>
> Applied to 5.8/scsi-queue, thanks!
>
> [1/1] scsi: iscsi: Fix deadlock on recovery path during GFP_IO reclaim
>       https://git.kernel.org/mkp/scsi/c/7e7cd796f277

Thanks, Martin!

-- 
Gabriel Krisman Bertazi
