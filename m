Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1764FC3DA79
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Dec 2022 15:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbiLWP5o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Dec 2022 10:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiLWP5f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Dec 2022 10:57:35 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7BF4AF27
        for <linux-scsi@vger.kernel.org>; Fri, 23 Dec 2022 07:57:31 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id DADCB68AA6; Fri, 23 Dec 2022 16:57:27 +0100 (CET)
Date:   Fri, 23 Dec 2022 16:57:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, john.g.garry@oracle.com,
        bvanassche@acm.org, mwilck@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v3 12/15] scsi: virtio_scsi: Convert to scsi_execute_cmd
Message-ID: <20221223155727.GA30763@lst.de>
References: <20221214235001.57267-1-michael.christie@oracle.com> <20221214235001.57267-13-michael.christie@oracle.com> <20221215081540.GG3308@lst.de> <0771d185-107a-e3fa-aa61-9dbd1da36a61@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0771d185-107a-e3fa-aa61-9dbd1da36a61@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Dec 18, 2022 at 03:40:48PM -0600, Mike Christie wrote:
> It looks like a hack around scsi_scan_host not removing devices.
> Going forward, it looks like we can remove the inquiry code by having
> scsi_scan_host be able to remove devices that are no longer returned.

Yes, that's the place to do it.  I can see arguments for and against
that, but doing it from and LLDD (and including sd.h in the LLDD
implementation!) just doesn't make sense.

> I was thinking to handle the DID_BAD_TARGET use case above and this type
> of issue:
> 
> https://lore.kernel.org/linux-scsi/CA+PODjqrRzyJnOKoabMOV4EPByNnL1LgTi+QAKENP3NwUq5YCw@mail.gmail.com/
> 
> maybe we want to have a driver level BLIST like:

Maybe instead of a blist we just need better way to communicate
this rather than abusing DID_BAD_TARGET?

> One other question, can I do this work after the patchset in this email, the
> scsi_cmnd retry patches and the actual PR ones? I keep going off track on these
> side adventures.

Yes, please.  I think we need to finish this series first.
