Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6C3C4363A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 10:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 226D0221EB
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 10:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604054396;
	bh=irpFIfd9NROmenJUObzXR3j97r408rhWBz8JIUQUIkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ltRn6WPIq46AsAHu4acNZfyidNx3C8vTGZCgjv67z9ej/Ez3+N4ci9w1Jyp6K2ozp
	 bwEnhMYyhYx6D7c0rbsjNcnTVFpIaeAfeJXXjKt8mZaHt/nwY6nwaHPqrb+/XiLd3z
	 JIrYa+36/9wQrDMRVTPebdeB+d1iYJNs4PuCK6Tg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgJ3Kju (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 06:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgJ3Kju (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Oct 2020 06:39:50 -0400
Received: from localhost (unknown [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5CC220704;
        Fri, 30 Oct 2020 10:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604054389;
        bh=irpFIfd9NROmenJUObzXR3j97r408rhWBz8JIUQUIkM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dgrnx202rLOcpxgTDgcNFyXj6Xzz5OQyhz12BYY4iKh4VlgHyEoq5+MwYvXJMRd1r
         6lwnjv/wbvdV+IzvFWkrd5XZpXnek4xqI30imkqAwh3RStK6vcQhJjdvWSDccWnKFR
         2CZxpd8hAFVbtrHwFMCb5iJ0CYvm8r+Q9tTkKLXs=
Date:   Fri, 30 Oct 2020 11:40:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH 02/18] block: open code kobj_map into in block/genhd.c
Message-ID: <20201030104033.GA2392682@kroah.com>
References: <20201029145841.144173-1-hch@lst.de>
 <20201029145841.144173-3-hch@lst.de>
 <20201029192236.GA991240@kroah.com>
 <20201029193242.GA4799@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201029193242.GA4799@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 29, 2020 at 08:32:42PM +0100, Christoph Hellwig wrote:
> On Thu, Oct 29, 2020 at 08:22:36PM +0100, Greg Kroah-Hartman wrote:
> > After this, you want me to get rid of kobj_map, right?  Or you don't
> > care as block doesn't use it anymore?  :)
> 
> I have a patch to kill it, but it causes odd regressions with the
> tpm driver according to the kernel test.  As I have grand plans that
> build on the block ѕide of this series for 5.11, I plan to defer the
> chardev side and address it for 5.12.

Ok, sounds good.

Wow, I just looked at the tpm code, and it is, um, "interesting" in how
it thinks device lifespans work.  Nothing like having 4 different
structures with different lifespans embedded within a single structure.
Good thing that no one can dynamically remove a TPM device during
"normal" operation.

greg k-h
