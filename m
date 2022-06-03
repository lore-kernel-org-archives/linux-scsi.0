Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F789CCA473
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 19:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346407AbiFCTp0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 15:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243277AbiFCTp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 15:45:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C2339BA8;
        Fri,  3 Jun 2022 12:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44B37B82473;
        Fri,  3 Jun 2022 19:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABB0C385A9;
        Fri,  3 Jun 2022 19:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654285522;
        bh=XJaRD04oRRXFBbqfn+wig4ArZZfb1t/k8rqJpmWG+Io=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a/QxqztmMqOnYCtI6bSqJU2okwbGR15O9RuE7N1KEw13uUhZXJrJ1IudWdLeJEvCx
         XVs6iaAFb3ne62yIqZzjaPYbgKMAjWWJuwhfvqhjsuyfxszSojXpHKdad4qNc7XVE/
         KuG9aKwNQTzY6dMg1mUNRhIbJfYj03Ee/3pOi0Bg0kMszz+hW1UNg26aQ6VwCn0EHu
         ifsTz+LvU0Zwmjq5O/sATbYVfCQnCOyA70qCtppn5/DALHpVo42xEZp7PqIrR6YJNW
         b/w9rP6iVl0JD8PEVi+s/EL4v54biQEKEJsQlcZR6+1AX6oLVV78A96o/Mcm+Ges3L
         hrBWp3ATDk1yw==
Date:   Fri, 3 Jun 2022 13:45:19 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 09/11] block, nvme: Add error for reservation conflicts.
Message-ID: <Yppkz4HIPVxr54hn@kbusch-mbp.dhcp.thefacebook.com>
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-10-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603065536.5641-10-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 03, 2022 at 01:55:34AM -0500, Mike Christie wrote:
> @@ -171,6 +171,7 @@ static const struct {
>  	/* zone device specific errors */
>  	[BLK_STS_ZONE_OPEN_RESOURCE]	= { -ETOOMANYREFS, "open zones exceeded" },
>  	[BLK_STS_ZONE_ACTIVE_RESOURCE]	= { -EOVERFLOW, "active zones exceeded" },
> +	[BLK_STS_RSV_CONFLICT]	= { -EBADE,	"resevation conflict" },

You misspelled "reservation". :)

And since you want a different error, why reuse EBADE for the errno? That is
already used for BLK_STS_NEXUS that you're trying to differentiate from, right?
At least for nvme, this error code is returned when the host lacks sufficient
rights, so something like EACCESS might make sense.

Looks good otherwise.
