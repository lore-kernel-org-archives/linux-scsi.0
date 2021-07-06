Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-25.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C858C07E96
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 14:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67D0B619BE
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 14:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhGFOpy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 10:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbhGFOpr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 10:45:47 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3DEC05BD0E
        for <linux-scsi@vger.kernel.org>; Tue,  6 Jul 2021 07:34:25 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id a5-20020a7bc1c50000b02901e3bbe0939bso2441259wmj.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jul 2021 07:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Dnxcz/j4jG7HOHqQqtlrR1/gzrXIHBGiVaeaud+bq1k=;
        b=ZiPC5E1vvjR+gWMyDSxYovoTYlmZkcT0KsnREYe9VplS0xxrBAQpNLBpBLa8rGfk2L
         r5o4PQfdkNYqTbAL70aohbU9JJvyCl8gWTiCricSt9hkBS+MpZVNRGC1croOmTbR9mMN
         nZ77ToVsVEZmMMgi2hByimoSm6KMJccSasCUXcNV2xbY3afowZAu5bbnDkojVu6ApOoa
         ynh7OQoh1g4fVfliqRvd3iJDkD6dRv6fHJaZ/lrUwWCDHcCrEKq7UKBEft//LbaFi6mn
         UmVaXxx7+Lj3ZylhOVuoLMNMIKJU+MKmWSxGtG8TPcr5XD5yD/YCce5i3xUi5elcM+Z2
         hK1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Dnxcz/j4jG7HOHqQqtlrR1/gzrXIHBGiVaeaud+bq1k=;
        b=Wl/k12+z2SB9ICxFH5jjNSVNjiZwhZ0Rzz0byq11I/GVMxwWYqZj0+WwDlUYNyrBdG
         aBiOQVIACU77LEez7b3hIMTp7U8iz0ZHPHA2mIL8w+5c7VNKalq7p664IZFoOR6blyaY
         +ndu5M+qscnYUD3Dt9fJ0x5kZo2Hwjv+kyGqQE4+9/i/hfMpuyJiN/okrr3dhTh/0x4E
         j0YMOLIb0soob+3mfvhuke1eWGi3s2CAr6k8HJn1UIhHU31IC3ndkd2OeslUe7zfWpot
         4AM+22UPpBm0IAX1XwMdfZ0u2IVzx4jM0ec5t9YTJbvNEBdYupu7+SB9b8Bb/yD+jQGy
         idDA==
X-Gm-Message-State: AOAM530ui5QPqatqQTZWdLbwhdxARUVWHaYXGnYWjI60gTYSt8+xCygD
        OpHvWyk8PyCA64X8FWIjy8q6+OilwwrqIA==
X-Google-Smtp-Source: ABdhPJxfaenUatsMwKqcqHPDvtnSYMFEMLRXvzeRlYaQpb+QZ5H8KRAvj//aDlwQjov+ZhP4O6Ga4A==
X-Received: by 2002:a1c:638a:: with SMTP id x132mr1153093wmb.90.1625582063590;
        Tue, 06 Jul 2021 07:34:23 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:15:13:396a:6bf2:9c33:26ce])
        by smtp.gmail.com with ESMTPSA id b8sm3351889wmb.20.2021.07.06.07.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 07:34:22 -0700 (PDT)
Date:   Tue, 6 Jul 2021 16:34:17 +0200
From:   Marco Elver <elver@google.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, hare@suse.de,
        syzkaller-bugs@googlegroups.com
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.13+ merge window
Message-ID: <YORp6acYukSgM2PO@elver.google.com>
References: <e118d4b2fb924156f791564483336e7125276c47.camel@HansenPartnership.com>
 <YORh1+8Mk5RYCzx7@elver.google.com>
 <yq1wnq3ed3i.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1wnq3ed3i.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/2.0.5 (2021-01-21)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 06, 2021 at 10:27AM -0400, Martin K. Petersen wrote:
> Marco,
>
> > On Fri, Jul 02, 2021 at 09:11AM +0100, James Bottomley wrote:
> > [...]
> >>       scsi: core: Kill DRIVER_SENSE
> > [...]
> >
> > As of this being merged, most of our syzbot instances are broken with:
>
> I believe this should fix it:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.14/scsi-queue&id=c43ddbf97f46b93727718408d60a47ce8c08f30c

Indeed it does! For "scsi: virtio_scsi: Do not overwrite SCSI status":

	Tested-by: Marco Elver <elver@google.com>

Thanks,
-- Marco
