Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92660C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 08:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbiKOIOA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 03:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiKOIN7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 03:13:59 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09209F5B1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 00:13:59 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6464B67373; Tue, 15 Nov 2022 09:13:55 +0100 (CET)
Date:   Tue, 15 Nov 2022 09:13:55 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.g.garry@oracle.com>
Cc:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v6 03/35] scsi: Add struct for args to execution
 functions
Message-ID: <20221115081355.GB17445@lst.de>
References: <20221104231927.9613-1-michael.christie@oracle.com> <20221104231927.9613-4-michael.christie@oracle.com> <1bd9df90-fda6-270e-e437-e1039a0a8b76@oracle.com> <02dd9d58-a5dc-2733-5b34-481f276fe231@oracle.com> <a215068e-a5f6-34ce-2b23-8f964b09db4c@oracle.com> <d3e1d2ea-a68d-da0e-7379-dd583ebcec61@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3e1d2ea-a68d-da0e-7379-dd583ebcec61@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 11, 2022 at 12:07:26PM +0000, John Garry wrote:
> We already pass a blk_opt_t arg in flags, so why have a separate conduit to 
> set REQ_OP_DRV_{IN/OUT}? A couple of other observations:
> a. why do we manually set req->cmd_flags from flags instead of passing 
> flags directly to scsi_alloc_request()
> b. why pass a req_flags_t instead of a blk_mq_req_flags_t - as I see, 
> rq_flags arg is only ever set to RQF_PM or 0, so no need for a conversion.

Mostly historic I guess.  But to me the fact that the blk_opf_t is
passed is a good argument for only passing that and not an extra
DMA direction.

rq_flags is a mess - the flags to the request allocator are different
from those at runtime, and the PM case needs both.  We'll eventually
need to clean this up in the block layer, but this is not the time.
