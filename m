Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806F6C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 09:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63ABD206B6
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 09:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfKSJCB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 04:02:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:34816 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbfKSJCA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 04:02:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 44514B1B7;
        Tue, 19 Nov 2019 09:01:59 +0000 (UTC)
Message-ID: <4b19bf3fdb242f166b203c456243553c09a22c92.camel@suse.de>
Subject: Re: [PATCH 52/52] scsi: Drop the now obsolete driver_byte
 definitions
From:   Martin Wilck <mwilck@suse.de>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
Date:   Tue, 19 Nov 2019 10:02:37 +0100
In-Reply-To: <20191104090151.129140-53-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
         <20191104090151.129140-53-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2019-11-04 at 10:01 +0100, Hannes Reinecke wrote:
> The driver_byte field in the result is now unused, so we can drop
> the definitions.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  Documentation/scsi/scsi_mid_low_api.txt |  3 +--
>  block/bsg-lib.c                         |  2 +-
>  block/bsg.c                             |  2 +-
>  block/scsi_ioctl.c                      |  2 +-
>  drivers/scsi/constants.c                | 14 --------------
>  drivers/scsi/scsi_logging.c             | 10 ++--------
>  drivers/scsi/sd.c                       |  9 ++++-----
>  drivers/scsi/sd_zbc.c                   |  4 ++--
>  drivers/scsi/sg.c                       |  5 ++---
>  drivers/scsi/sr.c                       |  2 +-
>  drivers/scsi/sr_ioctl.c                 |  2 +-
>  drivers/scsi/st.c                       |  4 ++--
>  include/scsi/scsi.h                     |  3 ---
>  include/scsi/scsi_cmnd.h                |  4 ----
>  include/trace/events/scsi.h             |  7 +------
>  15 files changed, 19 insertions(+), 54 deletions(-)
> 

While I generally like this change, the driver byte is part of the
sg_io user space API, and used in sg3_utils and multipath-tools (in
particular, DRIVER_SENSE), and likely in other user space tools as
well. Can we simply ditch it without adding some compatibility code to
sg and bsg?

Thanks,
Martin


