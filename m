Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241E0C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 15:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9D1561245
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 15:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhDRPvu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Apr 2021 11:51:50 -0400
Received: from mout4.gn-server.de ([87.238.194.231]:39026 "EHLO
        mout4.gn-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhDRPvs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Apr 2021 11:51:48 -0400
X-Greylist: delayed 1078 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Apr 2021 11:51:47 EDT
Received: from mout17.gn-server.de ([87.238.194.244])
        by mout4.gn-server.de with esmtp (Exim 4.92)
        (envelope-from <lkml@mageta.org>)
        id 1lY9Pz-0005mU-80; Sun, 18 Apr 2021 15:33:03 +0000
Received: from lc0.greatnet-hosting.de ([178.254.50.20])
        by mout17.gn-server.de with esmtp (Exim 4.92)
        (envelope-from <lkml@mageta.org>)
        id 1lY9Pz-00064f-34; Sun, 18 Apr 2021 15:33:03 +0000
Received: from chlorum.ategam.org (ategam.org [88.99.83.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: work@mageta.org)
        by lc0.greatnet-hosting.de (Postfix) with ESMTPSA id DF015E5103C;
        Sun, 18 Apr 2021 17:33:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mageta.org; s=mail;
        t=1618759983; bh=aIb+3JQGrzBG0FwrkfudyZqWQwRxYBchgNGVY8AgfXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=GVvXHf9lhGo3a5IQR4rJDZyU7nPCVGrgEY1VfZPb5n+bpaIKuehgiXsZFh+ycoBnN
         i0c5v6mN9b9XC0HZdXYHALKptKp2yS86SFsSc5/CkIYgGLQtuXEKJ61eAjgKwTL+Nn
         gmT0pHl2Y6DDLNkUfkIr6S26gXUIW5Q4WPdy8AU6eyS1CcBnIKstvaWDz8aEKBjUTX
         Z15T0VzbQ6XS7lFChOrly17SrYY1dSpbb0K5kXPYJZQnsqmvnkplYyKWAK667h/2hu
         K9JmvnnXVW3EUAh1G6vDhmRaS3tSHMckSYWuvdXcoQHp7LWgSNEFwVW1prQovjPtAB
         JArXtwLky0ybw==
Date:   Sun, 18 Apr 2021 17:32:59 +0200
From:   Benjamin Block <lkml@mageta.org>
To:     Muneendra <muneendra.kumar@broadcom.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de,
        jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Benjamin Block <bblock@linux.ibm.com>
Subject: Re: [PATCH v9 03/13] nvme: Added a newsysfs attribute appid_store
Message-ID: <YHxRK33kf7OSVlxf@chlorum.ategam.org>
References: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
 <1617750397-26466-4-git-send-email-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617750397-26466-4-git-send-email-muneendra.kumar@broadcom.com>
X-Virus-Scanned: clamav-milter 0.102.4 at lc0
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 07, 2021 at 04:36:27AM +0530, Muneendra wrote:
> Added a new sysfs attribute appid_store under
> /sys/class/fc/fc_udev_device/*
>
> With this new interface the user can set the application identfier
> in  the blkcg associted with cgroup id.
>
> Once the application identifer has set with this interface it allows
> identification of traffic sources at an individual cgroup based
> Applications (ex:virtual machine (VM))level in both host and
> fabric infrastructure(FC).
>
> Below is the interface provided to set the app_id
>
> echo "<cgroupid>:<appid>" >> /sys/class/fc/fc_udev_device/appid_store
> echo "457E:100000109b521d27" >> /sys/class/fc/fc_udev_device/appid_store
>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
>
> ---
> v9:
> No change
>
> v8:
> No change
>
> v7:
> No change
>
> v6:
> No change
>
> v5:
> Replaced APPID_LEN with FC_APPID_LEN
>
> v4:
> No change
>
> v3:
> Replaced blkcg_set_app_identifier function with blkcg_set_fc_appid
>
> v2:
> New Patch
> ---
>  drivers/nvme/host/fc.c | 73 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 72 insertions(+), 1 deletion(-)

Hmm, I wonder why only NVMe-FC? Or is this just for the moment? We also
have the FC transport class for SCSI; I assume this could feed the same
IDs into the LLDs.
