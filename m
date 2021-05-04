Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C68FEC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 09:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89BC1610FC
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 09:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhEDJvt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 05:51:49 -0400
Received: from verein.lst.de ([213.95.11.211]:38774 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230058AbhEDJvs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 05:51:48 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0DDEF68AFE; Tue,  4 May 2021 11:50:53 +0200 (CEST)
Date:   Tue, 4 May 2021 11:50:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 02/18] fnic: use scsi_host_busy_iter() to traverse
 commands
Message-ID: <20210504095052.GB25986@lst.de>
References: <20210503150333.130310-1-hare@suse.de> <20210503150333.130310-3-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503150333.130310-3-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 03, 2021 at 05:03:17PM +0200, Hannes Reinecke wrote:
> Use scsi_host_busy_iter() to traverse commands instead of
> hand-crafted routines walking the command list.

While the replacement looks like the right thing to do at the micro level,
can we take one step back?

Shouldn't completing commands be left entirely to the SCSI EH code
instead of messing with it in the driver?
