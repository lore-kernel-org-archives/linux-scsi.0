Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5447C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 09:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C00C8207CD
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 09:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgH0Jjx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 05:39:53 -0400
Received: from verein.lst.de ([213.95.11.211]:37505 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgH0Jjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Aug 2020 05:39:52 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 386C568B02; Thu, 27 Aug 2020 11:39:48 +0200 (CEST)
Date:   Thu, 27 Aug 2020 11:39:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH 01/19] char_dev: replace cdev_map with an xarray
Message-ID: <20200827093947.GA15976@lst.de>
References: <20200826062446.31860-1-hch@lst.de> <20200826062446.31860-2-hch@lst.de> <20200826081905.GB1796103@kroah.com> <20200827085353.GA12111@lst.de> <20200827091859.GA393660@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827091859.GA393660@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 27, 2020 at 11:18:59AM +0200, Greg Kroah-Hartman wrote:
> > I looked at it, but it does get registered and shows up in sysfs.
> 
> It does?  Where does that happen?  I see a bunch of kobject_init()
> calls, but nothing that registers it in sysfs that I can see.

Hmm, true.

> 
> Note, this is not the kobject that shows up in /sys/dev/char/ as a
> symlink, that comes from the driver core logic and is independent of the
> cdev code.
> 
> The kobject does handle the structure lifetime rules, but that should be
> able to be replaced with a simple kref instead.

Yeah.  I'll let you handle this stuff, as you obviously know the area
better than I do.
