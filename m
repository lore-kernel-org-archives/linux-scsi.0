Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46626C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 20:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2122361CBB
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 20:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhGGUTR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 16:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhGGUTR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 16:19:17 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69B6C061574
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 13:16:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id b8-20020a17090a4888b02901725eedd346so2367414pjh.4
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 13:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=wglB+IbvMmtFDHmzOA/hNEV2wgHilB9Tfw6um82nPuU=;
        b=bYv5jkv1VpKOl+u/0e2UBJW92oh452GIx1Zpa+eZwUk0dqeT6BBwC0cbzBmPocRICE
         LRsakLj6f24bVCZVgqhRCBWGEKjgztwyVEknk/o/oaNWTZd+cBAyVyvQwgWm9RqZQazm
         J4p/rnneY4A5wRi0VZjkU5rp8FfaR6VpE9GwM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=wglB+IbvMmtFDHmzOA/hNEV2wgHilB9Tfw6um82nPuU=;
        b=W9BWqFr20JQEGwUOujGlDsJ+UIAIoR+3/2Ki4g9I7DUdc/m/PMR+VvD0ZTmdsR5vZV
         ixTsdggpr5sJ+YFeuTi4KVM1Ffgmhk/CcrsuMWVqykouPOjJQFBNdVyziDD/2qyOwuOs
         UcWK9swJDq3DDTrqMBQFwE1j0oDvi259iR+C1Ci/HFH2zZIABYlGjCTx46+hmuaZaF27
         fVJX7KHpwB0bsQVIXuGyiE5r0un6eW3Qm6517oRA8xI/ZwA8pXHXmkS4LAYDkfhi37Pm
         lq0EUgn7Hjmhf36AJhSnL8es40rc+gkSQHlTX98V7ImklgxBmjgD12TTvU0J0TacZdDB
         iOmw==
X-Gm-Message-State: AOAM531Y9zTGS6d5ojHxp5GMmF0qXwB+6mhcwql76VWhm0Td1eHKxjqy
        b1njXvA0sB7tMy/dJ26OkujEOYyuA91wV+0P
X-Google-Smtp-Source: ABdhPJwzAmSmyrzZZ+5XyRNXGrnEVn8TJQsl2DYSERN4NMipF4Ch7g2ZjriYroJoPufviWufnMchKg==
X-Received: by 2002:a17:90a:4893:: with SMTP id b19mr27264703pjh.45.1625688995919;
        Wed, 07 Jul 2021 13:16:35 -0700 (PDT)
Received: from smtpclient.apple ([192.30.189.3])
        by smtp.gmail.com with ESMTPSA id z3sm29420pgl.77.2021.07.07.13.16.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jul 2021 13:16:35 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3681.0.2.1.2\))
Subject: Re: [PATCH 1/1]: scsi scsi_dh_alua: don't fail I/O until transition
 time expires
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <B5561C06-0029-45C5-9291-A66DAF48C303@purestorage.com>
Date:   Wed, 7 Jul 2021 13:16:34 -0700
Cc:     linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <82F24BD9-6888-4E60-B821-CA026194A0BD@purestorage.com>
References: <622E6257-85C7-4F9B-9CCD-2EF1791CB21F@purestorage.com>
 <23d45b9e-2c56-d637-dd2f-ea5a1ef267ac@suse.de>
 <27C07B47-22C8-4447-BB09-1386C64C21A0@purestorage.com>
 <add9c9c2-ed37-e973-6d8f-1d98c94905e4@suse.de>
 <AF99F82D-7451-412C-AD21-8CF5593E6F59@purestorage.com>
 <B5561C06-0029-45C5-9291-A66DAF48C303@purestorage.com>
To:     Hannes Reinecke <hare@suse.de>
X-Mailer: Apple Mail (2.3681.0.2.1.2)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just checking back in. It seems that there are at least two ways to fix =
this problem. It seems like it can be done in either the ALUA device =
handler or in drivers/md/dm-mpath.c. At this point, however, the failing =
of the path when ALUA state transitioning is hit breaks what used to =
work and what we believe should work. Where should we go from here?

Thanks,
Brian

Brian Bunker
SW Eng
brian@purestorage.com



> On Jun 17, 2021, at 12:19 PM, Brian Bunker <brian@purestorage.com> =
wrote:
>=20
> drivers/md/dm-mpath.c

