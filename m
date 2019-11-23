Return-Path: <SRS0=GkA7=ZP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C85EC43215
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Nov 2019 07:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF8162071B
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Nov 2019 07:28:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hw7ATIl7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKWH2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Nov 2019 02:28:46 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30969 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726208AbfKWH2p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 23 Nov 2019 02:28:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574494124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0VpnZxogNfmq2zNOxOpvLIFykqFG115bnmJucwdOn3c=;
        b=Hw7ATIl79D+5HDUKbY622mwKXiC7i4wkPxvkLAo8D120Xjde+Dduohk4zpFhq7UzGldH6b
        wE8Fq8XEvKQBAAD4Cl7Wt+hyVfR1IQ70ZsKCfw802FvCERe1gG+oI2l6Yeu0C9XYTUeMGu
        QN0+AHjkyds2HmoV/OTym+qp5l+As6g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-sWOOPYRKPNKL7Lq1o5RkHg-1; Sat, 23 Nov 2019 02:28:40 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E2DA1800D40;
        Sat, 23 Nov 2019 07:28:37 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 38DDE10013A1;
        Sat, 23 Nov 2019 07:28:24 +0000 (UTC)
Date:   Sat, 23 Nov 2019 15:28:20 +0800
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
Message-ID: <20191123072726.GC25356@ming.t460p>
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
 <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
 <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it>
 <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
 <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
 <20191109222828.GA30568@ming.t460p>
 <fa3b0cf1f88e42e1200101bccbc797e4e7778d58.camel@unipv.it>
MIME-Version: 1.0
In-Reply-To: <fa3b0cf1f88e42e1200101bccbc797e4e7778d58.camel@unipv.it>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: sWOOPYRKPNKL7Lq1o5RkHg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 22, 2019 at 08:16:30PM +0100, Andrea Vai wrote:
> Il giorno dom, 10/11/2019 alle 06.28 +0800, Ming Lei ha scritto:
> > Another thing we could try is to use 'none' via the following
> > command:
> >=20
> >  echo none > /sys/block/sdh/queue/scheduler  #suppose 'sdh' points
> > to the usb storage disk
> >=20
> > Because USB storage HBA is single hw queue, which depth is 1. This
> > way
> > should change to dispatch IO in the order of bio submission.
> >=20
> > Andrea, could you switch io scheduler to none and update us if
> > difference
> > can be made?
>=20
> Using the new kernel, there is indeed a difference because the time to
> copy a file is 1800 seconds with [mq-deadline], and 340 seconds with
> [none]. But that is still far away from the old kernel, which performs
> the copy of the same file in 76 seconds.

Please post the log of 'lsusb -v', and I will try to make a patch for
addressing the issue.


thanks,=20
Ming

