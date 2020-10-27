Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2D9C56201
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 09:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F77621D24
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 09:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896577AbgJ0J63 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 05:58:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:37518 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896559AbgJ0J5k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Oct 2020 05:57:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E9747B1BF;
        Tue, 27 Oct 2020 09:57:38 +0000 (UTC)
Date:   Tue, 27 Oct 2020 10:57:37 +0100
From:   David Disseldorp <ddiss@suse.de>
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/5] scsi: target: COMPARE AND WRITE miscompare sense
Message-ID: <20201027105737.5a52b17e@suse.de>
In-Reply-To: <ec78c756-6abd-32a8-a7d3-1c7788fa57d3@oracle.com>
References: <20201026190646.8727-1-ddiss@suse.de>
        <ec78c756-6abd-32a8-a7d3-1c7788fa57d3@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 27 Oct 2020 00:49:23 -0500, Mike Christie wrote:

> On 10/26/20 2:06 PM, David Disseldorp wrote:
> > This patchset adds missing functionality to return the offset of
> > non-matching read/compare data in the sense INFORMATION field on
> > COMPARE AND WRITE miscompare.
...
> > Changes since v1:
> > - drop unnecessary WARN_ON()
> > - fix two checkpatch warnings
> > - drop single-use nlbas variable
> > - avoid compare_len recalculation
> > 
> > Cheers, David
> > 
> >   drivers/target/target_core_sbc.c       | 137 +++++++++++++++----------
> >   drivers/target/target_core_transport.c |  33 +++---
> >   include/target/target_core_base.h      |   2 +-
> >   lib/scatterlist.c                      |   2 +-
> >   4 files changed, 102 insertions(+), 72 deletions(-)  
> 
> 
> Reviewed-by: Mike Christie <michael.christie@oracle.com>

Thanks Mike.
@Martin: please pull patches 2/5 through to 5/5 only; the independent
scatterlist patch 1/5 has been submitted via linux-block.

Cheers, David
