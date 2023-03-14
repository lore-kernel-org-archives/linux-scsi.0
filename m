Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBD2C7618A
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 17:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjCNRbM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Mar 2023 13:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjCNRbL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2023 13:31:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844EE9F059;
        Tue, 14 Mar 2023 10:31:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 808E8B81AA1;
        Tue, 14 Mar 2023 17:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BF9C4339B;
        Tue, 14 Mar 2023 17:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678815062;
        bh=TCw/AN/Un6bpx1N00J+z/9cj1Si2ZLC5bXYvaaXHbJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RT336Dqro1Vvp6z3vHVDTOzldVLFQhP9GHbt6GCR9ohPrJ/T171dOczOyvFvLBU8P
         QSR9sZcYLdEaaLnQVT0UTtAd3coc7EaaBd11pXeq2jTqQFZPLHQa2iKE8VlBW0lSgw
         Nb53Rx/qZoqcFAO7rkFy8zoDogPkI1i9CgHCZPVIuzaUaMu7myIk6TzPMj83EW4AUd
         tYI3vMBp30Yl106WwXWZ/kIaj8DbyOajqUNwCyzDXhjjRQoElRjWqje5bUpAWQuwqg
         zrORMZ1564WqDhbrrZidfw9s5xpsDXQqhDKvHncDPKfYyICvrkZKE6QaPEHiNUDEqD
         oW4FX4kd2HW4A==
Date:   Tue, 14 Mar 2023 11:30:59 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        target-devel@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v4 09/18] nvme: Move pr code to it's own file
Message-ID: <ZBCvU0ldBvvTqz+y@kbusch-mbp.dhcp.thefacebook.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-10-michael.christie@oracle.com>
 <20230314171322.GE6780@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314171322.GE6780@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 14, 2023 at 06:13:22PM +0100, Christoph Hellwig wrote:
> > +++ b/drivers/nvme/host/pr.c
> > @@ -0,0 +1,155 @@
> > +// SPDX-License-Identifier: GPL-2.0
> 
> I'd feel much more comfortable if we had a copyright notice code
> here.  This code was written by Keith, maybe he can help to fill
> in what the proper notice should be?

Okay, this was initially introduced with 1d277a637a711a while employed with
Intel, so let's add for the history:

/*
 * Copyright (c) 2015 Intel Corporation 
 *	Keith Busch <kbusch@kernel.org>
 */
