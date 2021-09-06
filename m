Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EEDC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 08:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8C7761039
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 08:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240455AbhIFIKS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 04:10:18 -0400
Received: from verein.lst.de ([213.95.11.211]:60533 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240406AbhIFIKS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Sep 2021 04:10:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E18B767373; Mon,  6 Sep 2021 10:09:08 +0200 (CEST)
Date:   Mon, 6 Sep 2021 10:09:08 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk,
        martin.petersen@oracle.com, jejb@linux.ibm.com, kbusch@kernel.org,
        sagi@grimberg.me, adrian.hunter@intel.com, beanhuo@micron.com,
        ulf.hansson@linaro.org, avri.altman@wdc.com, swboyd@chromium.org,
        agk@redhat.com, snitzer@redhat.com, josef@toxicpanda.com,
        hch@infradead.org, bvanassche@acm.org, ming.lei@redhat.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-mmc@vger.kernel.org, dm-devel@redhat.com,
        nbd@other.debian.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 3/8] nvme: add error handling support for add_disk()
Message-ID: <20210906080908.GA25575@lst.de>
References: <20210830212538.148729-1-mcgrof@kernel.org> <20210830212538.148729-4-mcgrof@kernel.org> <677ca876-b003-d3b5-9e2e-d50ebef82cce@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <677ca876-b003-d3b5-9e2e-d50ebef82cce@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 06, 2021 at 08:16:35AM +0200, Hannes Reinecke wrote:
> I would rather turn this around, and call 'nvme_put_ctrl()' after removing 
> the namespace from the list. But it's probably more a style issue, come to 
> think of it.

The order in the patch is the inverse of the order before the failure,
which generally is the right thing to do.
