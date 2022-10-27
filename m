Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B707FFA3742
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 17:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbiJ0RFC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbiJ0RE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2022 13:04:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5516B65839;
        Thu, 27 Oct 2022 10:04:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C841FCE278E;
        Thu, 27 Oct 2022 17:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BC5C433C1;
        Thu, 27 Oct 2022 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890294;
        bh=A8LdF2tGHUEAm/4didZpC5DSvR31YfIaG7z1pihdEXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X6USWytVrptYSj/qv2yDplVsny321+kt4+q8m8QOvwNs1xF+Wor2WcndO3fwlPHUq
         Eh/y5VtMvWfmkWcAkCIxT3bvkt5IhrbjFr9TGSYhmdZ8nApZOydHWQyDKkwZIOUL8/
         /CsAf/+icHjY64MWBmXjAS0f27yd/1MReBJkO9bbEZ4EHTVhmJAPxgaSI8sL69K+4G
         iA8fCeliHU/BIDzAYEiAWsXQUZA/VwZHA6mQ78Z7dJhmt1PO27TSqmVgQxZka9Sdg0
         JD9iyy6k2x5lpA5qSs0e0O5Vaoc2L0KVu05+wmAyqI8J4PSeHUMkd4NgcBSeeFJnfz
         UFDq2FuNJzU3A==
Date:   Thu, 27 Oct 2022 11:04:50 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        target-devel@vger.kernel.org
Subject: Re: [PATCH v3 06/19] nvme: Fix reservation status related structs
Message-ID: <Y1q6Mh2yx/F9/3+Q@kbusch-mbp.dhcp.thefacebook.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-7-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026231945.6609-7-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 26, 2022 at 06:19:32PM -0500, Mike Christie wrote:
> This fixes the following issues with the reservation status structs:
> 
> 1. resv10 is bytes 23:10 so it should be 14 bytes.
> 2. regctl_ds only supports 64 bit host IDs.
> 
> These are not currently used, but will be in this patchset which adds
> support for the reservation report command.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>
