Return-Path: <SRS0=rOw5=CI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E01C433E7
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 07:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2402920BED
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 07:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598772669;
	bh=Njak4YdzyT7v+1QG7LqknfkUzrGFlfnnqodG9TgquRM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=eHnk8fmwp1cmWI6cCQRt8LpRTPJn8/1HKUkLaDAapAHHpHXr4Sp1manY6VlgbjIec
	 gEFhdIfR0Ffe/FFmMi62XorBhyQOLgw5RQRHlgpr+exwUHVbKRz42kJ4TX9oOl+qyy
	 6sEzHPACKLnvsifmo3cQt7px561GAwWHoP4dLLtY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgH3HbF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 03:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgH3HbE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 30 Aug 2020 03:31:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B3D92076D;
        Sun, 30 Aug 2020 07:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598772663;
        bh=Njak4YdzyT7v+1QG7LqknfkUzrGFlfnnqodG9TgquRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KyDd/cCH3v1Dgpme+wDyQY+dFiQsRmeNrb4pZPJM0xobXoMRYA9BK88ehcFPPEATS
         pXjxQcnbtI56saQxhJGOot31HPm5spAVXFITvjaQeTRea0uOuwUu/EOAI3eyMNDqep
         qN9awzfygJzs6Si6Oz9dZ6rox0mURFFov8/mpcbc=
Date:   Sun, 30 Aug 2020 09:31:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH 01/19] char_dev: replace cdev_map with an xarray
Message-ID: <20200830073101.GA112265@kroah.com>
References: <20200830062445.1199128-1-hch@lst.de>
 <20200830062445.1199128-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200830062445.1199128-2-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Aug 30, 2020 at 08:24:27AM +0200, Christoph Hellwig wrote:
> None of the complicated overlapping regions bits of the kobj_map are
> required for the character device lookup, so just a trivial xarray
> instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
