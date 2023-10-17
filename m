Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4018CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 07:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbjJQHZi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 03:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbjJQHZe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 03:25:34 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24789B6
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 00:25:33 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 94A6268BFE; Tue, 17 Oct 2023 09:25:29 +0200 (CEST)
Date:   Tue, 17 Oct 2023 09:25:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5/9] scsi: set host byte after EH completed
Message-ID: <20231017072529.GA11484@lst.de>
References: <20231016121542.111501-1-hare@suse.de> <20231016121542.111501-6-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016121542.111501-6-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 16, 2023 at 02:15:38PM +0200, Hannes Reinecke wrote:
> When SCSI EH completes we should be setting the host byte to
> DID_ABORT, DID_RESET, or DID_TRANSPORT_DISRUPTED to inform
> the caller that some EH processing has happened.

I have a hard time following this commit log.  Yes, we probably
should.  But so far we haven't, so why is this suddenly a problem?

> -void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
> +void __scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q,
> +			int host_byte)
>  {
> +	if (host_byte)
> +		set_host_byte(scmd, host_byte);
>  	list_move_tail(&scmd->eh_entry, done_q);

What is the point of passing in the host_byte vs just setting it in
the caller?

In fat I'm not even quite sure what the point of the existing helper
is, as moving the command to the passed in queue doesn't provide
much of a useful abstraction.

