Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB36C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6729661008
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhHQMWv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 08:22:51 -0400
Received: from verein.lst.de ([213.95.11.211]:58304 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235897AbhHQMWu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 08:22:50 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 77EE167357; Tue, 17 Aug 2021 14:22:16 +0200 (CEST)
Date:   Tue, 17 Aug 2021 14:22:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 06/51] qla1280: separate out host reset function from
 qla1280_error_action()
Message-ID: <20210817122216.GE30436@lst.de>
References: <20210817091456.73342-1-hare@suse.de> <20210817091456.73342-7-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817091456.73342-7-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 17, 2021 at 11:14:11AM +0200, Hannes Reinecke wrote:
> There's not much in common between host reset and all other error
> handlers, so use a separate function here.

This loses the search in the internal queueing list.  Which is probably
fine, but needs to be explained.
