Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D3BC77B71
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 05:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjDRFG5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 01:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjDRFG4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 01:06:56 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5CC5B85
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 22:06:41 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2F6DB67373; Tue, 18 Apr 2023 07:06:37 +0200 (CEST)
Date:   Tue, 18 Apr 2023 07:06:37 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 1/4] scsi: sd: Let sd_shutdown() fail future I/O
Message-ID: <20230418050637.GA29686@lst.de>
References: <20230417230656.523826-1-bvanassche@acm.org> <20230417230656.523826-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417230656.523826-2-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 17, 2023 at 04:06:53PM -0700, Bart Van Assche wrote:
> +fail_future_io:
> +	q = sdkp->disk->queue;
> +	blk_queue_flag_set(QUEUE_FLAG_DYING, q);

SD does not own the queue and has abslutely not business marking it
dying.
