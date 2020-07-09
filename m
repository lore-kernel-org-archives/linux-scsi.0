Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE08C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 19:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7416C20767
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 19:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ADFRbs+F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgGITBu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 15:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgGITBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 15:01:49 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF21C08C5CE
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 12:01:49 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 145so2861962qke.9
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 12:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=zP7xEak2X2UQD3loa21ynbQlpFMfIYBlacPSOMSAldQ=;
        b=ADFRbs+Ff9ofITNaN7lppNr7eGZUVg4comvP9IEl9dZdHSJmCE0HzB40zHRNFRR7Wy
         eJcmrn4IvgScjtQK7jXuzSWkLutwvEOhNvAhl4PVsaTCDHFlSMZYYQQ5F3V92u2kAN3o
         rht0eLJv0u/d+cFDuX7WtnGU7/99U5HJ9AgJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=zP7xEak2X2UQD3loa21ynbQlpFMfIYBlacPSOMSAldQ=;
        b=foD4YCqnUIUh+EHLPiuCBUeFMucduu1oqNWd62aHhe+tS7rKneR6CbZzJf9kR9o9pS
         /K2KgvQY6C2Q4sPRYHYsF0qUW9Vopsf1g1ifodcinq/S3YhOPmWLi0AAstayt9Nbmlce
         1svjk49xDgr0uY3lIWHzmdg4603mo95DELyD5duyEC7Y04gIszlxXV29GUfy+s39aXJk
         vlSyOFL6xRs6kUCmOWf4QUywlRk2nkGL4awolIu95twM3UoUW47DDNk0TpRMbFo6fx77
         7zK/Z8C3rzQl4DECLK9SwOJQsp1OAfRsNZITNuKZutPglScKbY50mlYIhBlTf3E165pT
         Z2RA==
X-Gm-Message-State: AOAM532kgIydOkIOXkAlLVK3Bs4e/tFYU0ju1l+Cka7RcRF9MjIIyLXr
        vnV2w/4deVASdcoauGaRRN2ZMAPXRCtFOw85/TBA2A==
X-Google-Smtp-Source: ABdhPJx/xhKbrtUaRkWzBfv+HZio8FxaqOSaaNQsDVjBu1/zBThO6QrRWJPiPL/UUNwJ4FwLIB/rZQvDNwm502Wgzso=
X-Received: by 2002:a37:9284:: with SMTP id u126mr39090733qkd.127.1594321308679;
 Thu, 09 Jul 2020 12:01:48 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-11-git-send-email-john.garry@huawei.com>
 <d55972999b9370f947c20537e41b49bf@mail.gmail.com> <e61593f8-5ee7-5763-9d02-d0ea13aeb49f@huawei.com>
 <92ba1829c9e822e4239a7cdfd94acbce@mail.gmail.com> <10d36c09-9d5b-92e9-23ac-ea1a2628e7d9@huawei.com>
 <0563e53f843c97de1a5a035fae892bf8@mail.gmail.com> <61299951-97dc-b2be-c66c-024dfbd3a1cb@huawei.com>
In-Reply-To: <61299951-97dc-b2be-c66c-024dfbd3a1cb@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQBVjmvxAE7FMYb7GtMRWGcwtMcECgFIs823Ad7lfqMBmFaE1AGZowweAlKrFcUB/hGY5AG4aoXNq54LkqA=
Date:   Fri, 10 Jul 2020 00:31:44 +0530
Message-ID: <b49c33ebda36b8f116a51bc5c430eb9d@mail.gmail.com>
Subject: RE: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        ming.lei@redhat.com, bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >> If you want to share an updated megaraid sas driver patch based on
> >> that, then that's fine. I can incorporate that change in the patch
> >> where we add host_tagset to the scsi host template.
> > If you share git repo link of next submission, I can send you
> > megaraid_sas driver patch which you can include in series.
>
> So this is my work-en-progress branch:
>
> https://github.com/hisilicon/kernel-dev/commits/private-topic-blk-mq-
> shared-tags-rfc-v8

I tested this repo + megaraid_sas shared hosttag driver. This repo (5.8-rc)
has CPU hotplug patch.
" bf0beec0607d blk-mq: drain I/O when all CPUs in a hctx are offline"

Looking at description of above patch and changes, it looks like
megaraid_sas driver can still work without shared host tag for this feature.

I observe CPU hotplug works irrespective of shared host tag in megaraid_sas
on 5.8-rc.

Without shared host tag, megaraid driver will expose single hctx and all the
CPU will be mapped to hctx0.
Any CPU offline event will have " blk_mq_hctx_notify_offline" callback in
blk-mq module. If we do not have this callback/patch, we will see IO
timeout.
blk_mq_hctx_notify_offline callback will make sure all the outstanding on
hctx0 is cleared and only after it is cleared, CPU will go offline.

megaraid_sas driver has  internal reply_queue mapping which helps to get IO
completion on same cpu.  Driver get msix index from that table based on "
raw_smp_processor_id".
If table is mapped correctly at probe time,  It is not possible to pick
entry of offline CPU.

Am I missing anything ?

If you can help me to understand why we need shared host tag for CPU
hotplug, I can try to frame some test case for possible reproduction.

>
> I just updated to include the change to have Scsi_Host.host_tagset in
> 4291f617a02b commit ("scsi: Add host and host template flag
> 'host_tagset'")
>
> megaraid sas support is not on the branch yet, but I think everything else
> required is. And it is mutable, so I'd clone it now if I were you - or
> just replace
> the required patch onto your v7 branch.

I am working on this.

>
> Thanks,
> John
