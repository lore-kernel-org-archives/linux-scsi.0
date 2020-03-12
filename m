Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D46C10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 12:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A035D20716
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 12:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584014767;
	bh=y6Uol7v9TnlizNaNwTm5w9ARGHzQUkg/KMuRdqYvVWA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=L7LyNoGcHrdSm6dbiMD2iI5//zpSiGpMMJO3fn+d1KizQpnhe9wskUesPjhTSCbM2
	 oBWsjTykUEHI+L5duvMRwXjb6blV9yRPz+chJGwb8lePLX4Hk5hJeFSfZOALri/ApZ
	 wigXkWbt4DKGMIl8wTS5YhZYxanuXJBtPlRqlHIM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgCLMGG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 08:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbgCLMGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 08:06:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0E7B206E7;
        Thu, 12 Mar 2020 12:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584014766;
        bh=y6Uol7v9TnlizNaNwTm5w9ARGHzQUkg/KMuRdqYvVWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F65gGMYTun0gi5WQ6vw3ONma6WiZkRvas4h/BRGxndNjnDwJ8on9wim/+w36u1P1/
         Xm9TCcdquWWx8oTIcQ7xlcA37KAAewzf1f24M281/z/guA/YvqoR0nsGsaIaZUUMBC
         tLFMBAZm0RJhzelO466ogAOqiwgXQdvm4qMQuXto=
Date:   Thu, 12 Mar 2020 13:06:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-nvme@lists.infradead.org, Felipe Balbi <balbi@kernel.org>,
        linux-usb@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v1] asm-generic: Provide generic
 {get,put}_unaligned_{l,b}e24()
Message-ID: <20200312120603.GA257875@kroah.com>
References: <20200312113941.81162-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312113941.81162-1-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 12, 2020 at 01:39:41PM +0200, Andy Shevchenko wrote:
> There are users in kernel that duplicate {get,put}_unaligned_{l,b}e24()
> implementation. Provide generic helpers once for all.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/nvme/host/rdma.c                     |  8 -------
>  drivers/nvme/target/rdma.c                   |  6 -----
>  drivers/usb/gadget/function/storage_common.h |  5 ----

For usb:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

