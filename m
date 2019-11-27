Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B644CC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 21:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8853C20870
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 21:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfK0VuA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 16:50:00 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49304 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbfK0Vt7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Nov 2019 16:49:59 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 7D0BD22B48;
        Wed, 27 Nov 2019 16:49:55 -0500 (EST)
Date:   Thu, 28 Nov 2019 08:49:53 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>
cc:     Andrea Vai <andrea.vai@unipv.it>, Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: AW: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
In-Reply-To: <cb6e84781c4542229a3f31572cef19ab@SVR-IES-MBX-03.mgc.mentorg.com>
Message-ID: <alpine.LNX.2.21.1.1911280830520.8@nippy.intranet>
References: <20191109222828.GA30568@ming.t460p>         <fa3b0cf1f88e42e1200101bccbc797e4e7778d58.camel@unipv.it>         <20191123072726.GC25356@ming.t460p>         <a9ffcca93657cbbb56819fd883c474a702423b41.camel@unipv.it>         <20191125035437.GA3806@ming.t460p>
         <bf47a6c620b847fa9e27f8542eb761529f3e0381.camel@unipv.it>         <20191125102928.GA20489@ming.t460p>         <e5093535c60fd5dff8f92b76dcd52a1030938f62.camel@unipv.it>         <20191125151535.GA8044@ming.t460p>        
 <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>         <20191126023253.GA24501@ming.t460p> <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it> <alpine.LNX.2.21.1.1911271055200.8@nippy.intranet>
 <cb6e84781c4542229a3f31572cef19ab@SVR-IES-MBX-03.mgc.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 27 Nov 2019, Schmid, Carsten wrote:

> > 
> > The sheer volume of testing (probably some terabytes by now) would 
> > exercise the wear leveling algorithm in the FTL.
> > 
> But with "old kernel" the copy operation still is "fast", as far as i 
> understood. If FTL (e.g. wear leveling) would slow down, we would see 
> that also in the old kernel, right?
> 
> Andrea, can you confirm that the same device used with the old fast 
> kernel is still fast today?

You seem to be saying we should optimize the kernel for a pathological 
use-case merely because it used to be fast before the blk-mq conversion. 
That makes no sense to me. I suppose you have information that I don't.

I assume that your employer (and the other corporations involved in this) 
have plenty of regression test results from a variety of flash hardware to 
show that the regression is real and the device is not pathological.

I'm not privy to any of that information so I will shut up and leave you 
guys to it.

-- 

> > This in itself seems unlikely to improve performance significantly. 
> > But if the flash memory came from a bad batch, perhaps it would have 
> > that effect.
> > 
> > To find out, someone may need to source another (genuine) Kingston 
> > DataTraveller device.
> > 
