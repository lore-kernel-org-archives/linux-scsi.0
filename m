Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AC5C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9423B6135A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhDZPYM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:24:12 -0400
Received: from verein.lst.de ([213.95.11.211]:41766 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234004AbhDZPYM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 11:24:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 75A7568C4E; Mon, 26 Apr 2021 17:23:29 +0200 (CEST)
Date:   Mon, 26 Apr 2021 17:23:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 14/39] NCR5380: Fold SCSI message ABORT onto DID_ABORT
Message-ID: <20210426152329.GF25615@lst.de>
References: <20210423113944.42672-1-hare@suse.de> <20210423113944.42672-15-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423113944.42672-15-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 23, 2021 at 01:39:19PM +0200, Hannes Reinecke wrote:
> The message byte can take only two values, COMMAND_COMPLETE and ABORT.
> So we can easily map ABORT to DID_ABORT and do not set the message byte.

The real question is rather: did anyone care about the message byte,
and why can't this assignment be dropped entirely?
