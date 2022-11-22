Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26F9C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 06:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiKVGil (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 01:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKVGik (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 01:38:40 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53AC13E2A
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 22:38:39 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 83DFE68D05; Tue, 22 Nov 2022 07:38:36 +0100 (CET)
Date:   Tue, 22 Nov 2022 07:38:36 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH 06/15] scsi: core: Convert to scsi_execute_cmd
Message-ID: <20221122063836.GB14514@lst.de>
References: <20221122033934.33797-1-michael.christie@oracle.com> <20221122033934.33797-7-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122033934.33797-7-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 21, 2022 at 09:39:25PM -0600, Mike Christie wrote:
> +	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buffer,
> +				  request_len, 30 * HZ, 3,
> +				  ((struct scsi_exec_args) { .sshdr = &sshdr }));

Maybe it's me, but I hate the syntax to declare structs inside argument
list.  But even when we go with it, splitting it into multiple lines
would be a lot more readable:
				  ((struct scsi_exec_args) {
				  	.sshdr = &sshdr,
				  }));

