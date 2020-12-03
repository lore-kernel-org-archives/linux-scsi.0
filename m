Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6F0C4361A
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 22:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C723207AE
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 22:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgLCWDu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 17:03:50 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40696 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbgLCWDu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 17:03:50 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 3239222866;
        Thu,  3 Dec 2020 17:03:07 -0500 (EST)
Date:   Fri, 4 Dec 2020 09:02:39 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Hannes Reinecke <hare@suse.de>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 27/34] esp_scsi: use host byte as last argument to
 esp_cmd_is_done()
In-Reply-To: <20201202115249.37690-28-hare@suse.de>
Message-ID: <alpine.LNX.2.23.453.2012040851230.6@nippy.intranet>
References: <20201202115249.37690-1-hare@suse.de> <20201202115249.37690-28-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2 Dec 2020, Hannes Reinecke wrote:

> Just pass in the host byte to esp_cmd_is_done(), and set the
> status or message bytes before calling this function.
> 

There are 3 such callsites but in 2 you've not done so.

Are you relying on the mid-layer to initialize the unset bytes to zero?

Wouldn't it be more readable to explicitly set the status and message 
bytes, as per the existing code?
