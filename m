Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D884C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 10:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A46C2076A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 10:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594980382;
	bh=JbyDqpmt2sPD/UxN3Y83aUYetjdoycCBc3mkCb5lonQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GpxCgrsiT9ZV+HdEyUOZWv9JrBY0XTgSGgkzGZhMliXQ/2saNc/yDPiRTG5kqT9VN
	 y/r4gIs5uRwvYUjcMSPD+nBgjSkYA0cCF7zWC37VAQR3Y19FcD4leVfMmLOx3HQvPO
	 xNHqVjJfVpz3sZNsuyydFL63A+xzwlfnvRHWjVx8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgGQKGV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 06:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgGQKGU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jul 2020 06:06:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C2C22063A;
        Fri, 17 Jul 2020 10:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594980378;
        bh=JbyDqpmt2sPD/UxN3Y83aUYetjdoycCBc3mkCb5lonQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b4vI/unL9mzCnUrhkILocriCxzMcWN/IBsmvvfkg0pVfilr//N/UGySLWP/PMZgcZ
         niis0Q1Rz7TvGRkDaaY9Cq+6E3rQ+DSx0OQlb1uWXtopx8kIWFkx9PW9e6LnvgNyuB
         jD0Jml31eD6fF9mz+UqNFXup1VYel/JqYYMMsyBo=
Date:   Fri, 17 Jul 2020 12:06:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     tasleson@redhat.com, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [RFC PATCH v3 5/8] ata_dev_printk: Use dev_printk
Message-ID: <20200717100610.GA2667456@kroah.com>
References: <20200623191749.115200-1-tasleson@redhat.com>
 <20200623191749.115200-6-tasleson@redhat.com>
 <CGME20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee@eucas1p2.samsung.com>
 <d817c9dd-6852-9233-5f61-1c0bc0f65ca4@samsung.com>
 <7ed08b94-755f-baab-0555-b4e454405729@redhat.com>
 <cfff719b-dc12-a06a-d0ee-4165323171de@samsung.com>
 <20200714081750.GB862637@kroah.com>
 <dff66d00-e6c3-f9ef-3057-27c60e0bfc11@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dff66d00-e6c3-f9ef-3057-27c60e0bfc11@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 14, 2020 at 10:50:39AM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> On 7/14/20 10:17 AM, Greg Kroah-Hartman wrote:
> > On Tue, Jul 14, 2020 at 10:06:05AM +0200, Bartlomiej Zolnierkiewicz wrote:
> >>
> >> Hi Tony,
> >>
> >> On 7/9/20 11:18 PM, Tony Asleson wrote:
> >>> Hi Bartlomiej,
> >>>
> >>> On 6/24/20 5:35 AM, Bartlomiej Zolnierkiewicz wrote:
> >>>> The root source of problem is that libata transport uses different
> >>>> naming scheme for ->tdev devices (please see dev_set_name() in
> >>>> ata_t{dev,link,port}_add()) than libata core for its logging
> >>>> functionality (ata_{dev,link,port}_printk()).
> >>>>
> >>>> Since libata transport is part of sysfs ABI we should be careful
> >>>> to not break it so one idea for solving the issue is to convert
> >>>> ata_t{dev,link,port}_add() to use libata logging naming scheme and
> >>>> at the same time add sysfs symlinks for the old libata transport
> >>>> naming scheme.
> > 
> > Given the age of the current implementation, what suddenly broke that
> > requires this to change at this point in time?
> 
> Unfortunately when adding libata transport classes (+ at the same
> time embedding struct device-s in libata dev/link/port objects) in
> the past someone has decided to use different naming scheme than
> the one used for standard libata log messages (which use printk()
> without any reference to struct device-s in libata dev/link/port
> objects).
> 
> Now we would like to use dev_printk() for standard libata logging
> functionality as this is required for 2 pending patchsets:
> 
> - move DPRINTK to dynamic debugging (from Hannes Reinecke)
> 
> - add persistent durable identifier storage log messages (from Tony)
> 
> but we don't want to change standard libata log messages and
> confuse users..

All of that mess with symlinks just for a common debug printk?  That
seems excessive :)

Just use the device name and don't worry about it, I doubt anyone will
notice, unless the name is _really_ different.

thanks,

greg k-h
