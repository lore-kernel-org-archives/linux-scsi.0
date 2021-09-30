Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E94AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 07:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3567D6136A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 07:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348697AbhI3HYO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 03:24:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348693AbhI3HYN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 03:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632986550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jfzpsPgEjlpqMHG2xdpGJiWBvA9KF/85Qovky68nwHs=;
        b=MlvZb3DRkrpgQ7M4qhADmcNZ1GxC1cofS7UwcfQ/ub0R5agp23nMGJgqnpROCpPMFpzmOa
        ERy62+EtL5WV4amkh8ZCis7t6azM99qqbc87b6WIYFpBibSDc+SuOvP4GKzBp441hSlAoT
        ESGHLeVErQBe/DTyUmea3vZW257grmc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-BULgIIk8NyStpAOywpXbhw-1; Thu, 30 Sep 2021 03:22:29 -0400
X-MC-Unique: BULgIIk8NyStpAOywpXbhw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2A91808237;
        Thu, 30 Sep 2021 07:22:27 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E58F91002391;
        Thu, 30 Sep 2021 07:22:19 +0000 (UTC)
Date:   Thu, 30 Sep 2021 15:22:14 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>
Subject: Re: [PATCH 1/2] driver core: tell caller if the device/kboject is
 really released
Message-ID: <YVVlpttsxZQ+S9X1@T590>
References: <20210930052028.934747-1-ming.lei@redhat.com>
 <20210930052028.934747-2-ming.lei@redhat.com>
 <YVVQZ/yVpFJ7Abg5@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVVQZ/yVpFJ7Abg5@kroah.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 30, 2021 at 07:51:35AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Sep 30, 2021 at 01:20:27PM +0800, Ming Lei wrote:
> > Return if the device/kobject is really released to caller.
> > 
> > One use case is scsi_device_put() and the scsi device's release handler
> > runs async work to clean up things. We have to piggyback the module_put()
> > into the async work for avoiding to touch unmapped module page.
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/base/core.c     | 5 +++--
> >  include/linux/device.h  | 2 +-
> >  include/linux/kobject.h | 2 +-
> >  lib/kobject.c           | 5 +++--
> >  4 files changed, 8 insertions(+), 6 deletions(-)
> 
> I really don't like this as you should not ever care if you are
> releasing the last reference on an object or not.
> 
> Why are you needing this?
> 
> And if you really do need this, you MUST document how this works in the
> apis you are changing here, so I can't take this as is sorry.

Please ignore this series, and I have one better approach to address the
issue, will send it out soon.


Thanks,
Ming

