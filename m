Return-Path: <SRS0=Icgp=EG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B8CC388F7
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 10:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2829522202
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 10:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgJaKiz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Oct 2020 06:38:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:50232 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbgJaKiz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 31 Oct 2020 06:38:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BB9B4AE09;
        Sat, 31 Oct 2020 10:38:53 +0000 (UTC)
Date:   Sat, 31 Oct 2020 11:38:52 +0100
From:   David Disseldorp <ddiss@suse.de>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Dirk Hohndel (VMware)" <dirk@hohndel.org>
Subject: Re: [PATCH v3 4/4] scsi: target: return COMPARE AND WRITE
 miscompare offsets
Message-ID: <20201031113852.39110f4c@suse.de>
In-Reply-To: <e475cbf3-6dc8-901f-b5e3-30228e9a03a4@interlog.com>
References: <20201030213931.10720-1-ddiss@suse.de>
        <20201030213931.10720-5-ddiss@suse.de>
        <e475cbf3-6dc8-901f-b5e3-30228e9a03a4@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 30 Oct 2020 20:06:31 -0400, Douglas Gilbert wrote:

> I believe the logic is correct (and scsi_debug doesn't set the INFO field
> in its CAW, but should), but I wonder about performance.
> 
> If the probability of equality is high (e.g. like it is usually with
> VERIFY(BytChk=1) ) and memcmp() is faster than that for-loop (which
> could be optimized), then a better strategy might be to always do memcmp()
> first and only if it fails go into the byte by byte for-loop to find the
> offset of the first miscompare.

While adding the INFO return to tgt I noticed that it had the same
memcmp-with-miscompare-for-loop logic that you describe. I'm only aware
of ESXi as a COMPARE AND WRITE consumer and I think probability of
equality is quite high (@Dirk: perhaps you can confirm?).

> IMO this should only be considered, if there is going to be a "v4" of
> this patchset.

I think this optimization wouldn't make the code much more complex, so
I'll do a re-spin with this change. Thanks for the feedback.

Cheers, David
