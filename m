Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B219CC433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 12:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8463E206D4
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 12:46:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CIJOM8H2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgHCMqA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 08:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729060AbgHCMp4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 08:45:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6F4C06179F
        for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2020 05:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=492MNrBqydj+qwahaphzXy6n4DDjKuX2fhC6YH3TFgI=; b=CIJOM8H2Hx3K7K51fpsYG4tgEB
        TE7OfwFxRB/+M5Ehkfs3UQumEQCLRWv60Z7Jc6dsDYIVCoHgXD6iER1/YLSPLH1l+i0Zrffv7NCXO
        FQrwBEftQRzj4vuL56FxVOkj8ojeeEJuz07ig/i58nhvaf+viz+aNBguczMnZyiKDiajAz9Iqy4e4
        KgRiP7EHTsMXESzWd/2vAhUDWM8xFhLcjMZaejvBFIB9DZCo5oI+WrnBHvZ3Q3zWEbu2ipnlX/k/F
        NEZ526zI7Fu6qs1m+/vzYlso2cAXevtdjx/dqwtb8CxCGMutBbFofYob6u9laeNvHBb1dBCXzo9/N
        eTGqGRVw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k2Zqh-0007EI-8v; Mon, 03 Aug 2020 12:45:51 +0000
Date:   Mon, 3 Aug 2020 13:45:51 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        jinpu.wang@profitbricks.com, martin.petersen@oracle.com,
        yuuzheng@google.com, auradkar@google.com, vishakhavc@google.com,
        bjashnani@google.com, radha@google.com, akshatzen@google.com
Subject: Re: [PATCH V5 2/2] pm80xx : Staggered spin up support.
Message-ID: <20200803124551.GA26520@infradead.org>
References: <20200803122923.6826-1-deepak.ukey@microchip.com>
 <20200803122923.6826-3-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803122923.6826-3-deepak.ukey@microchip.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 03, 2020 at 05:59:23PM +0530, Deepak Ukey wrote:
> From: Viswas G <Viswas.G@microchip.com>
> 
> As a part of drive discovery, driver will initaite the drive spin up.
> If all drives do spin up together, it will result in large power
> consumption. To reduce the power consumption, driver provide an option
> to make a small group of drives (say 3 or 4 drives together) to do the
> spin up. The delay between two spin up group and no of drives to
> spin up (group) can be programmed by the customer in seeprom and
> driver will use it to control the spinup.

Isn't this something we should implement in libsas instead?
