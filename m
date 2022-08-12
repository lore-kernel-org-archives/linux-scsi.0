Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF19AC00140
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 05:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiHLFdy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 01:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbiHLFdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 01:33:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3F4A0275
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 22:33:52 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 851C468AA6; Fri, 12 Aug 2022 07:33:49 +0200 (CEST)
Date:   Fri, 12 Aug 2022 07:33:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v2 1/1] scsi: Fix passthrough retry counter handling
Message-ID: <20220812053349.GA24671@lst.de>
References: <20220812011206.9157-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812011206.9157-1-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 11, 2022 at 08:12:06PM -0500, Mike Christie wrote:
> Passthrough users will set the scsi_cmnd->allowed value and were
> expecting up to $allowed retries. The problem is that before:
> 
> commit 6aded12b10e0 ("scsi: core: Remove struct scsi_request")
> 
> we used to set the retries on the scsi_request then copy them over to
> scsi_cmnd->allowed in scsi_setup_scsi_cmnd. With that patch we now set
> scsi_cmnd->allowed to 0 in scsi_prepare_cmd and overwrite what the
> passthrough user set.
> 
> This moves the allowed initialization to after the blk_rq_is_passthrough
> check so it's only done for the non-passthrough path where the ULD
> init_command will normally set an allowed value it prefers.
> 
> Fixes: 6aded12b10e0 ("scsi: core: Remove struct scsi_request")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
