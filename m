Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58475C432C3
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36AF8216F4
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfKPQeA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 11:34:00 -0500
Received: from verein.lst.de ([213.95.11.211]:49390 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727551AbfKPQeA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Nov 2019 11:34:00 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6EA7168BE1; Sat, 16 Nov 2019 17:33:57 +0100 (CET)
Date:   Sat, 16 Nov 2019 17:33:57 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/5] aacraid: use scsi_host_busy_iter() for traversing
 outstanding commands
Message-ID: <20191116163357.GD23951@lst.de>
References: <20191115122757.132006-1-hare@suse.de> <20191115122757.132006-5-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115122757.132006-5-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 15, 2019 at 01:27:56PM +0100, Hannes Reinecke wrote:
> Use scsi_host_busy_iter() for traversing outstanding commands and
> drop the cmd_list usage.

This is missing all the feedback from last time, no maintainers are
Cced, it is not split up and properly documented, etc.  It is still
reverse engineering the scsi commands instead of looking at the
block request.

And while looking at this again, I think the iteration in
aac_synchronize should simply be removed without a replacement.  Cache
flushes in the Linux block layer and in SCSI have always only been
for complete commands, not for in-flight commands.  So unless the
hardware has a weird quirk this code should just go away.  Which is
another reason to add the maintainers at the hardware vendor, as they
can help with insights.
