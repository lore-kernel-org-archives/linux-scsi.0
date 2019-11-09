Return-Path: <SRS0=dDgG=ZB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D45EC43331
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 22:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E2D1207FF
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 22:28:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WhrJ7Ost"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfKIW2w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Nov 2019 17:28:52 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41564 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbfKIW2w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2019 17:28:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573338530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9oSogd1HclYTh4TochWGFDAg+DdvKpv0K/UpcRLncNQ=;
        b=WhrJ7Ost4/wmId144i0InrnyxLiMEuBEa9Mi54r8AIC5XK342QypLQ+7Z4ic4mg1t+FDFJ
        seBNmzG+Dhc+0ps5SapNiHStIFnCoMFPOHnFWwfUT3gLMJaNUwzuqc4AoUKcNmgIyixIJ5
        j4+Z9vwVJXbyb88xOPItGzPo6xNhNdQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-PhgiX5CtNoOzD6MkuoOuLQ-1; Sat, 09 Nov 2019 17:28:47 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41DA480183C;
        Sat,  9 Nov 2019 22:28:44 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F580608B9;
        Sat,  9 Nov 2019 22:28:34 +0000 (UTC)
Date:   Sun, 10 Nov 2019 06:28:28 +0800
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
Message-ID: <20191109222828.GA30568@ming.t460p>
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
 <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
 <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it>
 <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
 <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: PhgiX5CtNoOzD6MkuoOuLQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 07, 2019 at 07:59:44PM +0100, Andrea Vai wrote:
> [Sorry for the duplicate message, it didn't reach the lists due to
> html formatting]
> Il giorno gio 7 nov 2019 alle ore 08:54 Damien Le Moal
> <Damien.LeMoal@wdc.com> ha scritto:
> >
> > On 2019/11/07 16:04, Andrea Vai wrote:
> > > Il giorno mer, 06/11/2019 alle 22.13 +0000, Damien Le Moal ha scritto=
:
> > >>
> > >>
> > >> Please simply try your write tests after doing this:
> > >>
> > >> echo mq-deadline > /sys/block/<name of your USB
> > >> disk>/queue/scheduler
> > >>
> > >> And confirm that mq-deadline is selected with:
> > >>
> > >> cat /sys/block/<name of your USB disk>/queue/scheduler
> > >> [mq-deadline] kyber bfq none
> > >
> > > ok, which kernel should I test with this: the fresh git cloned, or th=
e
> > > one just patched with Alan's patch, or doesn't matter which one?
> >
> > Probably all of them to see if there are any differences.
>=20
> with both kernels, the output of
> cat /sys/block/sdh/queue/schedule
>=20
> already contains [mq-deadline]: is it correct to assume that the echo
> command and the subsequent testing is useless? What to do now?

Another thing we could try is to use 'none' via the following command:

 echo none > /sys/block/sdh/queue/scheduler  #suppose 'sdh' points to the u=
sb storage disk

Because USB storage HBA is single hw queue, which depth is 1. This way
should change to dispatch IO in the order of bio submission.

Andrea, could you switch io scheduler to none and update us if difference
can be made?

Thanks,
Ming

