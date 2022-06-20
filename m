Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E392CCA47E
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 07:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239300AbiFTHXP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 03:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239292AbiFTHXP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 03:23:15 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899E3E0BE;
        Mon, 20 Jun 2022 00:23:14 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D4DB868AA6; Mon, 20 Jun 2022 09:23:10 +0200 (CEST)
Date:   Mon, 20 Jun 2022 09:23:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     michael.christie@oracle.com, Keith Busch <kbusch@kernel.org>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 09/11] block, nvme: Add error for reservation conflicts.
Message-ID: <20220620072310.GI11418@lst.de>
References: <20220603065536.5641-1-michael.christie@oracle.com> <20220603065536.5641-10-michael.christie@oracle.com> <Yppkz4HIPVxr54hn@kbusch-mbp.dhcp.thefacebook.com> <fdd77f3b-691a-a9bf-b31f-0aa845e68e59@suse.de> <6cc818cf-fac4-d485-ea9d-0b8597f24a33@oracle.com> <b612013c-46e4-d1c3-81f8-b28a026240e6@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b612013c-46e4-d1c3-81f8-b28a026240e6@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jun 05, 2022 at 11:42:11AM +0200, Hannes Reinecke wrote:
> Well ... we tried to find a generic error for reservation failure, as we 
> thought that reservation failure was too SCSI specific.
> And we wanted the error to describe what the resulting handling should be, 
> not what the cause was. Hence we ended up with BLK_STS_NEXUS.
>
> But turns out that our initial assumption wasn't valid, and that 
> reservations are a general concept. So by all means, rename BLK_STS_NEXUS 
> to BLK_STS_RSV_CONFLICT to make it clear what this error is about.

I think think this is a good ida, but we'll need to involve the
s390 dasd folks.  Maybe do this as a separate prep patch?

While thinking about DASD I think it would benefit from returning
the blk_status_t from ->free_cp insted of the hand crafted conversion
as well.
