Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0220AC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 10:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E02F922B49
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 10:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbgH0KMG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 06:12:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:54450 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgH0KMG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Aug 2020 06:12:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D8C55AC2F;
        Thu, 27 Aug 2020 10:12:36 +0000 (UTC)
Message-ID: <04f76144372753cceab48f59f7f2aaea017f021f.camel@suse.com>
Subject: Re: [PATCH 1/4] qla2xxx: Reset done and free callback pointer on
 release
From:   Martin Wilck <mwilck@suse.com>
To:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>
Date:   Thu, 27 Aug 2020 12:12:04 +0200
In-Reply-To: <20200827095829.63871-2-dwagner@suse.de>
References: <20200827095829.63871-1-dwagner@suse.de>
         <20200827095829.63871-2-dwagner@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.36.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-08-27 at 11:58 +0200, Daniel Wagner wrote:
> Reset ->done and ->free when releasing the srb. There is a hidden
> use-after-free bug in the driver which corrupts the srb memory pool
> which originates from the cleanup callbacks. By explicitly resetting
> the callbacks to NULL, we workaround the memory corruption.
> 
> An extensive search didn't bring any lights on the real problem. The
> initial idea was to set both pointers to NULL and try to catch
> invalid
> accesses. But instead the memory corruption was gone and the driver
> didn't crash.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_inline.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h
> b/drivers/scsi/qla2xxx/qla_inline.h
> index 861dc522723c..6d41d758fc17 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -211,6 +211,8 @@ static inline void
>  qla2xxx_rel_qpair_sp(struct qla_qpair *qpair, srb_t *sp)
>  {
>  	sp->qpair = NULL;
> +	sp->done = NULL;
> +	sp->free = NULL;
>  	mempool_free(sp, qpair->srb_mempool);
>  	QLA_QPAIR_MARK_NOT_BUSY(qpair);
>  }

Both sp->done() and sp->free() are called all over the place without
making sure the pointers are non-null. If these functions can be called
for freed sp's, wouldn't that mean we'd crash?

How about setting them to a dummy function that prints a big fat
warning?

Martin


