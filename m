Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E905DC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 08:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C55482177B
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 08:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgH0IzZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:55:25 -0400
Received: from verein.lst.de ([213.95.11.211]:37310 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727814AbgH0IzY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Aug 2020 04:55:24 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0E8A568B02; Thu, 27 Aug 2020 10:55:21 +0200 (CEST)
Date:   Thu, 27 Aug 2020 10:55:20 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH 01/19] char_dev: replace cdev_map with an xarray
Message-ID: <20200827085520.GB12111@lst.de>
References: <20200826062446.31860-1-hch@lst.de> <20200826062446.31860-2-hch@lst.de> <b2126993-b861-1899-bb42-cb7f461094d4@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2126993-b861-1899-bb42-cb7f461094d4@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 27, 2020 at 09:25:07AM +0200, Hannes Reinecke wrote:
> Do you really need the mutex?
> Wouldn't xa_store_range() be better and avoid the mutex?

We need the mutex as we need to grab the kobject reference under it.

xa_store_range is only available with a separate config option, and
has really strange calling conventions.  So I'd rather not pull it in
here, especially as most cdev_add callers are for a single minor only
anyway.
