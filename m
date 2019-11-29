Return-Path: <SRS0=Uo2m=ZV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552EAC432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 00:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 209E42158A
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 00:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PtZ431xq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfK2A6D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 19:58:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726664AbfK2A6C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2019 19:58:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574989080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YKOhsyJn1dP0zC1+J6hJHDow0ML8eBqf8NPC79CS6u0=;
        b=PtZ431xqVbL5taTRT8OnZG9nzYCAOVzapubqhU7ChRPeLThl/mNHflHzXdjy3VbNAF5dMR
        OjNBrGRvALwaWzecz35bLa6Z1zRftOHe64HchWPKzhLnZh4BVSs5d4dsr9u/oYmi+5sGnx
        3p6TIwxiwaBwVkWPE1q9Y0GgDTCmW0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-mBbdDmH1NEWfEGu_KK9frA-1; Thu, 28 Nov 2019 19:57:53 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CE23107ACC4;
        Fri, 29 Nov 2019 00:57:51 +0000 (UTC)
Received: from ming.t460p (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B97F60BF1;
        Fri, 29 Nov 2019 00:57:39 +0000 (UTC)
Date:   Fri, 29 Nov 2019 08:57:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Andrea Vai <andrea.vai@unipv.it>
Cc:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>,
        Finn Thain <fthain@telegraphics.com.au>,
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
Message-ID: <20191129005734.GB1829@ming.t460p>
References: <e5093535c60fd5dff8f92b76dcd52a1030938f62.camel@unipv.it>
 <20191125151535.GA8044@ming.t460p>
 <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>
 <20191126023253.GA24501@ming.t460p>
 <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it>
 <alpine.LNX.2.21.1.1911271055200.8@nippy.intranet>
 <cb6e84781c4542229a3f31572cef19ab@SVR-IES-MBX-03.mgc.mentorg.com>
 <c1358b840b3a4971aa35a25d8495c2c8953403ea.camel@unipv.it>
 <20191128091712.GD15549@ming.t460p>
 <f82fd5129e3dcacae703a689be60b20a7fedadf6.camel@unipv.it>
MIME-Version: 1.0
In-Reply-To: <f82fd5129e3dcacae703a689be60b20a7fedadf6.camel@unipv.it>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: mBbdDmH1NEWfEGu_KK9frA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 28, 2019 at 06:34:32PM +0100, Andrea Vai wrote:
> Il giorno gio, 28/11/2019 alle 17.17 +0800, Ming Lei ha scritto:
> > On Thu, Nov 28, 2019 at 08:46:57AM +0100, Andrea Vai wrote:
> > > Il giorno mer, 27/11/2019 alle 08.14 +0000, Schmid, Carsten ha
> > > scritto:
> > > > >=20
> > > > > > Then I started another set of 100 trials and let them run
> > > > tonight, and
> > > > > > the first 10 trials were around 1000s, then gradually
> > decreased
> > > > to
> > > > > > ~300s, and finally settled around 200s with some trials
> > below
> > > > 70-80s.
> > > > > > This to say, times are extremely variable and for the first
> > time
> > > > I
> > > > > > noticed a sort of "performance increase" with time.
> > > > > >
> > > > >=20
> > > > > The sheer volume of testing (probably some terabytes by now)
> > would
> > > > > exercise the wear leveling algorithm in the FTL.
> > > > >=20
> > > > But with "old kernel" the copy operation still is "fast", as far
> > as
> > > > i understood.
> > > > If FTL (e.g. wear leveling) would slow down, we would see that
> > also
> > > > in
> > > > the old kernel, right?
> > > >=20
> > > > Andrea, can you confirm that the same device used with the old
> > fast
> > > > kernel is still fast today?
> > >=20
> > > Yes, it is still fast. Just ran a 100 trials test and got an
> > average
> > > of 70 seconds with standard deviation =3D 6 seconds, aligned with
> > the
> > > past values of the same kernel.
> >=20
> > Then can you collect trace on the old kernel via the previous
> > script?
> >=20
> > #!/bin/sh
> >=20
> > MAJ=3D$1
> > MIN=3D$2
> > MAJ=3D$(( $MAJ << 20 ))
> > DEV=3D$(( $MAJ | $MIN ))
> >=20
> > /usr/share/bcc/tools/trace -t -C \
> >     't:block:block_rq_issue (args->dev =3D=3D '$DEV') "%s %d %d", args-
> > >rwbs, args->sector, args->nr_sector' \
> >     't:block:block_rq_insert (args->dev =3D=3D '$DEV') "%s %d %d", args=
-
> > >rwbs, args->sector, args->nr_sector'
> >=20
> > Both the two trace points and bcc should be available on the old
> > kernel.
> >=20
>=20
> Trace attached. Produced by: start the trace script
> (with the pendrive already plugged), wait some seconds, run the test
> (1 trial, 1 GB), wait for the test to finish, stop the trace.
>=20
> The copy took 73 seconds, roughly as already seen before with the fast
> old kernel.

This trace shows a good write IO order because the writeback IOs are
queued to block layer serially from the 'cp' task and writeback wq.

However, writeback IO order is changed in current linus tree because
the IOs are queued to block layer concurrently from the 'cp' task
and writeback wq. It might be related with killing queue_congestion
by blk-mq.

The performance effect could be not only on this specific USB drive,
but also on all HDD., I guess.

However, I still can't reproduce it in my VM even though I built it
with similar setting of Andrea's test machine. Maybe the emulated disk
is too fast than Andrea's.

Andrea, can you collect the following log when running the test
on current new(bad) kernel?

=09/usr/share/bcc/tools/stackcount  -K blk_mq_make_request

Thanks,
Ming

