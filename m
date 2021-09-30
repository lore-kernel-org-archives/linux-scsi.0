Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CB3C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 05:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A746C60FD8
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 05:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348123AbhI3FxW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 01:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348054AbhI3FxW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 01:53:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 302E26124A;
        Thu, 30 Sep 2021 05:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632981100;
        bh=dtYD0MdeZk6JzANytCUH9SpBxEtTLeR2QdaLgmvaS8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=POi33AfD6ee3waLXg68x1FG6tl39tU0OqBC756yAXk2mkScdeW/Nn2HRSme7jLR5+
         74WPa5B+Uap2xKv72qXx0b5VCZuA+3VAht5LAzhbkMyuC9cQxiRgy7NriVy/TCXiy4
         W8MmOyfiEaf7joJp2MVrYsl5tfZKnYKEyTKvX7dc=
Date:   Thu, 30 Sep 2021 07:51:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>
Subject: Re: [PATCH 1/2] driver core: tell caller if the device/kboject is
 really released
Message-ID: <YVVQZ/yVpFJ7Abg5@kroah.com>
References: <20210930052028.934747-1-ming.lei@redhat.com>
 <20210930052028.934747-2-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930052028.934747-2-ming.lei@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 30, 2021 at 01:20:27PM +0800, Ming Lei wrote:
> Return if the device/kobject is really released to caller.
> 
> One use case is scsi_device_put() and the scsi device's release handler
> runs async work to clean up things. We have to piggyback the module_put()
> into the async work for avoiding to touch unmapped module page.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/base/core.c     | 5 +++--
>  include/linux/device.h  | 2 +-
>  include/linux/kobject.h | 2 +-
>  lib/kobject.c           | 5 +++--
>  4 files changed, 8 insertions(+), 6 deletions(-)

I really don't like this as you should not ever care if you are
releasing the last reference on an object or not.

Why are you needing this?

And if you really do need this, you MUST document how this works in the
apis you are changing here, so I can't take this as is sorry.

greg k-h
