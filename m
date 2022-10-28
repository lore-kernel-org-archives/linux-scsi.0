Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B39FC38A02
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Oct 2022 16:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiJ1Qio (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Oct 2022 12:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJ1Qin (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Oct 2022 12:38:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473EE1E0994;
        Fri, 28 Oct 2022 09:38:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02694B82B82;
        Fri, 28 Oct 2022 16:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3087C433D6;
        Fri, 28 Oct 2022 16:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666975119;
        bh=HXelviQ+MhpOhcX5RBLW3YOkJdCOHX0A2A4aYPoP8MY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dbs2sNTixTdBY62ULqMxeRkkpymOcnd/LbZG3/XDhQF3HY55RukqG5APWzkmspOmt
         3ZOyoo79HUEJkjwxXVRtXXVhf3rqYMRfVy+oSlvBsxCrFpuVNBM3vuDCfrid0YwHpG
         Nyqm1GD3g0gmH7OGgGueG4EXYKk2ZkyfDklJli3DH8orwxFZui+CL/ZCq1Lug0TK/Y
         uRUEyxPyZ1SMBfTyNSpcG428UBaIMq551VTv276oO4n5eB2nwwVP85ozJrfxtdTT3m
         /YPO0Uei8MPnswq/ljK9+FRvQ3gxk9j4+F+sBB5+qBFHtcqqc18ZJic9QyxJqz4lnE
         IhNegMQKpiXeA==
Date:   Fri, 28 Oct 2022 10:38:36 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        target-devel@vger.kernel.org
Subject: Re: [PATCH v3 08/19] nvme: Move pr code to it's own file
Message-ID: <Y1wFjHzza1QYTzdG@kbusch-mbp.dhcp.thefacebook.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-9-michael.christie@oracle.com>
 <Y1q6so/3Hx9GZmTz@kbusch-mbp.dhcp.thefacebook.com>
 <370e66bd-81d0-5451-850e-50a4172ed64f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <370e66bd-81d0-5451-850e-50a4172ed64f@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 28, 2022 at 11:06:29AM -0500, Mike Christie wrote:
> On 10/27/22 12:06 PM, Keith Busch wrote:
> > On Wed, Oct 26, 2022 at 06:19:34PM -0500, Mike Christie wrote:
> >> This patch moves the pr code to it's own file because I'm going to be
> >> adding more functions and core.c is getting bigger.
> >>
> >> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> > 
> > Good idea.
> 
> Credit goes to Chaitanya.
> 
> One question for you. I wasn't sure about the copyright. I saw
> you added the pr_ops code in 2015 when you were at Intel. Do you
> want me to add:
> 
> Copyright (c) 2015, Intel Corporation.
> 
> to the new pr.c file?

I think I was just the last person to touch the code, but it was mostly
developed elsewhere. So "no", don't bother propagating the (c).
