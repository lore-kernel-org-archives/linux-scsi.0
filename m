Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56332FA3746
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 17:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbiJ0RQv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbiJ0RQc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2022 13:16:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E804D14BB7E;
        Thu, 27 Oct 2022 10:16:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0E47B826F9;
        Thu, 27 Oct 2022 17:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51187C433D6;
        Thu, 27 Oct 2022 17:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890989;
        bh=Zv1urG2jYQaq1bwAIZsRNHzXXofeTcjsquQZ1JK/QeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JGJsYnEuWS+K6DSZJyqGk9h7+UlxzI7TXzj+qO22QI7ToXiO1fVWN+j76gB8sX7Cz
         ojM/f3uvD0/0q3cMHCrXNwuHAo34g3e5Kf4BPaNDJDFaE0ddx2xdihE+jErpS2Q0pw
         TTflV6I2WpUCJlR3OTvSSAsfXcnW6nCASi9kpvA5yGYF2Jdvfqv37dBALCjlnKpPoK
         Fv6Iv3G58jhDYxSiv7ItE1rsTg1yExOqftvAJ3uBAQF80p/aqpnas8l6CD9jK+IIlb
         1m5EZNGdZIQMM1Qz5dPM0UrTRxUT2uqsGvV9pr5YKSZc+RP2yxYLxCctGqrKlCWoV3
         LIHunXvjG0suw==
Date:   Thu, 27 Oct 2022 11:16:25 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     michael.christie@oracle.com
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        target-devel@vger.kernel.org
Subject: Re: [PATCH v3 10/19] nvme: Move NVMe and Block PR types to an array
Message-ID: <Y1q86YvRtZPBJDck@kbusch-mbp.dhcp.thefacebook.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-11-michael.christie@oracle.com>
 <Y1qhXQYOpEUk2uqF@kbusch-mbp.dhcp.thefacebook.com>
 <a74266ce-3839-5d2f-abc4-cb30045d811c@oracle.com>
 <75564e1d-3169-cd50-ea17-53ef96a3a35e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75564e1d-3169-cd50-ea17-53ef96a3a35e@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 27, 2022 at 12:13:06PM -0500, michael.christie@oracle.com wrote:
> Oh wait there was also a
> 
> 3. The pr_types come from userspace so if it passes us 10
> and we just do:
> 
> types[pr_type]
> 
> then we would crash due an out of bounds error.
> 
> Similarly I thought there could be a bad target that does the
> same thing.

Well, you'd of course have to check the boundaries before accessing if
you were to implement this scheme. :)

But considering this isn't a performance path, perhaps these kinds of
optimizations are not worth it.
