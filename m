Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883B8C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 10:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6226A2075C
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 10:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cIIgG+2S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfKYK3v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 05:29:51 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27230 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727443AbfKYK3v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Nov 2019 05:29:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574677789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tv195vcCTyb1XtBdCI9s4s+MghEYNPbsBSDtuLLrQsU=;
        b=cIIgG+2ShttPaoaEZUUOTZiTe3Moa7Bs6TF3nTeTola6TK7nTOfvldWLg1BKeO4wIDM7G8
        Lf61PPNMVA+dBwL/DM4/syAaIw+Frd5ceF4JlVH6vbhx98K9rHVxjQ24MMzTgkyOKSq3hg
        45cLN1DcIp8Y0z7UxrJZERNA/1+xVgs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-69Jp-3oiOsOoxYKAfdhpaQ-1; Mon, 25 Nov 2019 05:29:44 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98CFC800581;
        Mon, 25 Nov 2019 10:29:42 +0000 (UTC)
Received: from ming.t460p (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDBB7600C6;
        Mon, 25 Nov 2019 10:29:32 +0000 (UTC)
Date:   Mon, 25 Nov 2019 18:29:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Andrea Vai <andrea.vai@unipv.it>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
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
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Message-ID: <20191125102928.GA20489@ming.t460p>
References: <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
 <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it>
 <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
 <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
 <20191109222828.GA30568@ming.t460p>
 <fa3b0cf1f88e42e1200101bccbc797e4e7778d58.camel@unipv.it>
 <20191123072726.GC25356@ming.t460p>
 <a9ffcca93657cbbb56819fd883c474a702423b41.camel@unipv.it>
 <20191125035437.GA3806@ming.t460p>
 <bf47a6c620b847fa9e27f8542eb761529f3e0381.camel@unipv.it>
MIME-Version: 1.0
In-Reply-To: <bf47a6c620b847fa9e27f8542eb761529f3e0381.camel@unipv.it>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 69Jp-3oiOsOoxYKAfdhpaQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 25, 2019 at 11:11:00AM +0100, Andrea Vai wrote:
> Il giorno lun, 25/11/2019 alle 11.54 +0800, Ming Lei ha scritto:
> > On Sat, Nov 23, 2019 at 04:44:55PM +0100, Andrea Vai wrote:
> > > Il giorno sab, 23/11/2019 alle 15.28 +0800, Ming Lei ha scritto:
> > > >=20
> > > > Please post the log of 'lsusb -v', and I will try to make a
> > patch
> > > > for
> > > > addressing the issue.
> > >=20
> > > attached,
> >=20
> > Please apply the attached patch, and re-build & install & reboot
> > kernel.
> >=20
> > This time, please don't switch io scheduler.
>=20
> # patch -p1 < usb.patch outputs:
>=20
> (Stripping trailing CRs from patch; use --binary to disable.)
> patching file block/blk-mq.c
> Hunk #1 succeeded at 1465 (offset 29 lines).
> Hunk #2 succeeded at 3061 (offset 13 lines).
> (Stripping trailing CRs from patch; use --binary to disable.)
> patching file drivers/scsi/scsi_lib.c
> Hunk #1 succeeded at 1902 (offset -37 lines).
> (Stripping trailing CRs from patch; use --binary to disable.)
> patching file drivers/usb/storage/scsiglue.c
> Hunk #1 succeeded at 651 (offset -10 lines).
> (Stripping trailing CRs from patch; use --binary to disable.)
> patching file include/linux/blk-mq.h
> Hunk #1 succeeded at 226 (offset -162 lines).
> (Stripping trailing CRs from patch; use --binary to disable.)
> patching file include/scsi/scsi_host.h
> patch unexpectedly ends in middle of line
> patch unexpectedly ends in middle of line
>=20
> Just to be sure I have to go on, is this correct? Sounds like an error
> but I don't know if it is important.

Looks there is small conflict, however it has been fixed by patch, so
it is correct, please go on your test.

Thanks,
Ming

