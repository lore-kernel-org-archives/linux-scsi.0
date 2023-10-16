Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF60CCDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 06:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjJPGUj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 02:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjJPGUj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 02:20:39 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CFA95;
        Sun, 15 Oct 2023 23:20:37 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 31FF96732A; Mon, 16 Oct 2023 08:20:33 +0200 (CEST)
Date:   Mon, 16 Oct 2023 08:20:32 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v2 04/15] fs: Restore write hint support
Message-ID: <20231016062032.GB26670@lst.de>
References: <20231005194129.1882245-1-bvanassche@acm.org> <20231005194129.1882245-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231005194129.1882245-5-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 05, 2023 at 12:40:50PM -0700, Bart Van Assche wrote:
> This patch reverts a small subset of commit c75e707fe1aa ("block: remove
> the per-bio/request write hint"). The following functionality has been
> restored:

Please explain this in terms of what you add.  The fact that it restores
something isn't more than a little footnote added at the end.

> --- /dev/null
> +++ b/include/linux/fs-lifetime.h

The name seems a bit odd for something that primarily deals with bios.
bio-lifetime.h would seem like a better fit.

> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#include <linux/bio.h>
> +#include <linux/fs.h>
> +#include <linux/ioprio.h>
> +
> +static inline enum rw_hint bio_get_data_lifetime(struct bio *bio)
> +{
> +	/* +1 to map 0 onto WRITE_LIFE_NONE. */
> +	return IOPRIO_PRIO_LIFETIME(bio->bi_ioprio) + 1;

This seems a little to magic.  Why not a lookup table?

> +}
> +
> +static inline void bio_set_data_lifetime(struct bio *bio, enum rw_hint lifetime)

Please avoid the overly long line.

> +	/* -1 to map WRITE_LIFE_NONE onto 0. */
> +	if (lifetime != 0)
> +		lifetime--;
> +	WARN_ON_ONCE(lifetime & ~IOPRIO_LIFETIME_MASK);

I'd return here instead of propagating the bogus value.

