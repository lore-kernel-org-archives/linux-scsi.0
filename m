Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579FFC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15AB761059
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhDZPWk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:22:40 -0400
Received: from verein.lst.de ([213.95.11.211]:41749 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233971AbhDZPWk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 11:22:40 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 40F4768C4E; Mon, 26 Apr 2021 17:21:57 +0200 (CEST)
Date:   Mon, 26 Apr 2021 17:21:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 10/39] scsi_error: use DID_TIME_OUT instead of
 DRIVER_TIMEOUT
Message-ID: <20210426152156.GC25615@lst.de>
References: <20210423113944.42672-1-hare@suse.de> <20210423113944.42672-11-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423113944.42672-11-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 23, 2021 at 01:39:15PM +0200, Hannes Reinecke wrote:
> Set DID_TIME_OUT instead of DRIVER_TIMEOUT when a command
> is finally marked as failed after error recovery.

This seems like something that we need to propagating to userspace
through the various sg interfaces as applications could rely on the
bit.

