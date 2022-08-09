Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9B6C19F2D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 06:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbiHIGwz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 02:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiHIGww (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 02:52:52 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B7F205CF
        for <linux-scsi@vger.kernel.org>; Mon,  8 Aug 2022 23:52:51 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 33EF368AA6; Tue,  9 Aug 2022 08:52:47 +0200 (CEST)
Date:   Tue, 9 Aug 2022 08:52:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Dave Prizer <dave.prizer@hpe.com>
Subject: Re: [PATCH RESEND] scsi: scan: retry INQUIRY after timeout
Message-ID: <20220809065247.GA9663@lst.de>
References: <20220808202018.22224-1-mwilck@suse.com> <251c6042-5778-5d82-64e3-a2de5e1e2d36@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <251c6042-5778-5d82-64e3-a2de5e1e2d36@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 08, 2022 at 05:11:27PM -0500, Mike Christie wrote:
> For REPORT_LUNS it looks like we retry almost all errors 3 times. For the
> probe/setup commands, at least for disks, it looks like we also are more
> forgiving and will retry DID_TIME_OUT/DID_TRANSPORT_DISRUPTED 3 times for
> commands like SAI_READ_CAPACITY_16 (I didn't check every sd operation and
> other upper level drivers).
> 
> However, for the other probe/setup  operations that rely on scsi_attach_vpd
> succeeding like sd_read_block_limits then we will hit issues where the device
> is partially setup. Should scsi_vpd_inquiry be retrying 3 times as well?
> 
> An alternative to changing all the callers would be we could make scsi_noretry_cmd
> detect when it's an internal passthrough command and just retry these types of
> errors. For SG IO type of passthough we still want to fail right away.

Yes, I think one single place to do retries for setup path command
is much better than growing ad-hoc logic.

I just made a similar comment to similar nvme patch from SuSE a few days
ago..
