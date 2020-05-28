Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D691C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 19:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B79C2088E
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 19:53:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c+9WftXH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406818AbgE1Txl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 15:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406762AbgE1Txk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 15:53:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE79C08C5C6
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 12:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gPQtgDmyoOjUOuQxRrUqbFcDAYY6wgr/Xs8lH0QF5kE=; b=c+9WftXHXdCnprJeyCfZxoy/Sm
        Y6oFES/qzCKLXaOGxf30jUPOAkzHK5q1m6NEIFaLPhYAdlcUuw26keW7mteISjGkscXQiw7Oit5hi
        QmFxTmxaUxLaYcFbGMGHEwnBqzC5BDM9MsG1+LDT59mLmvAwB+ifQej2zoKcTSVmKUIlHMcNvKVvG
        pLYVMOpZbADKDX5lNFObkDn5o7MgxX/2hBr2H3mg62I6CCa1yt/RzNLT4IY+KgEJ8SKeGFPryEA3s
        YAP60je3kVUsqrXpAVizpley/cIXFZ4Qrb4RfW1HQrRaT5GRPrsEtheZTicVWp4Ie4X7uRPxRUp5T
        9vAfEqQA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeOat-00006v-97; Thu, 28 May 2020 19:53:35 +0000
Date:   Thu, 28 May 2020 12:53:35 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/4] scsi: move target device list to xarray
Message-ID: <20200528195335.GR17206@bombadil.infradead.org>
References: <20200528163625.110184-1-hare@suse.de>
 <20200528163625.110184-4-hare@suse.de>
 <a6b85428-f32c-e57b-fa3e-e376400819ac@interlog.com>
 <20200528185402.GP17206@bombadil.infradead.org>
 <40da0c89-054c-b02d-ce44-d4964cb9a228@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40da0c89-054c-b02d-ce44-d4964cb9a228@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 28, 2020 at 03:44:37PM -0400, Douglas Gilbert wrote:
> > And then maybe you could make a convincing argument that the spin_lock
> > there could be turned into an xa_lock since that will prevent sdevs from
> > coming & going during the iteration of the device list.
> 
> I tried that but ran into problems. The xarray model is clear enough,
> but there is a (non-atomic) enumerated state in each sdev (struct
> scsi_device object (pointer)) that is protected by a mutex.
> I was unable to escape those pesky (but very useful) warnings out of
> the depths of xarray that the locking was awry. When I've burrowed
> into xarray.c I have usually found that it was correct. So now I regard
> it as a pesky feature :-)

Fascinating.  So much of SCSI has to be IRQ-safe, and yet you can't look
at the sdev state outside process context ...

> > This patch seems decent enough ... I just think the decision to optimise
> > the layout for LUNs < 256 is a bit odd.  But hey, your subsystem,
> > not mine.
> 
> Hannes has the most experience in that area. He has only been using xarray
> for a week or so (I think). There is something important missing from his
> patchset: any xa_destroy() calls :-)

They're not necessarily needed.  If the XArray is empty, there's nothing
to do.
