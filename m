Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE31C432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 17:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEE26206F4
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 17:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKNRBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 12:01:18 -0500
Received: from verein.lst.de ([213.95.11.211]:40603 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbfKNRBS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Nov 2019 12:01:18 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 173BF68B05; Thu, 14 Nov 2019 18:01:16 +0100 (CET)
Date:   Thu, 14 Nov 2019 18:01:15 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi_dh_rdac: avoid crash during rescan
Message-ID: <20191114170115.GA4359@lst.de>
References: <20191111104522.99531-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111104522.99531-1-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 11, 2019 at 11:45:22AM +0100, Hannes Reinecke wrote:
> During rescanning the device might already have been removed, so
> we should drop the BUG_ON and just ignore the non-existing device.

The device is also added to the list before sdev is set, which is rather
silly, so that might be worth fixing as well.
