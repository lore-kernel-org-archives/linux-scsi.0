Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F314C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D15D120722
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:05:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TeU4gRbV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfK0CF5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 21:05:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32598 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725916AbfK0CF4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 21:05:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574820354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tDVp36nabNRQqX/ubAzsO0fGJuUT/91tz3HsosmbD1k=;
        b=TeU4gRbVEO07oITTV7+iU29n0JqNcJNdOLc3JEKQceVP23ZtyCjpdq1Dho1BxU+sEoF85i
        enVIzgzaZ6MI3Gj/BrbMM2ItIjQ5d25yiLrkcUd1QmWfDrkCC/NeNWkH3BdwDJNTz5VI3z
        Ki93g8MsPj25Xpgh3tWvjf4ww14Cp/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-z3YSTSHDMNiHhrpsN_vrBg-1; Tue, 26 Nov 2019 21:05:51 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16B18100551D;
        Wed, 27 Nov 2019 02:05:48 +0000 (UTC)
Received: from ming.t460p (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D7EA41001B3F;
        Wed, 27 Nov 2019 02:05:38 +0000 (UTC)
Date:   Wed, 27 Nov 2019 10:05:33 +0800
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
Message-ID: <20191127020533.GA7190@ming.t460p>
References: <20191125035437.GA3806@ming.t460p>
 <bf47a6c620b847fa9e27f8542eb761529f3e0381.camel@unipv.it>
 <20191125102928.GA20489@ming.t460p>
 <e5093535c60fd5dff8f92b76dcd52a1030938f62.camel@unipv.it>
 <20191125151535.GA8044@ming.t460p>
 <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>
 <20191126023253.GA24501@ming.t460p>
 <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it>
 <20191126091533.GB32135@ming.t460p>
 <e852331e72532dbfdc7981d958b1cd05ded41317.camel@unipv.it>
MIME-Version: 1.0
In-Reply-To: <e852331e72532dbfdc7981d958b1cd05ded41317.camel@unipv.it>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: z3YSTSHDMNiHhrpsN_vrBg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 26, 2019 at 12:14:19PM +0100, Andrea Vai wrote:
> Il giorno mar, 26/11/2019 alle 17.15 +0800, Ming Lei ha scritto:
> > On Tue, Nov 26, 2019 at 08:46:07AM +0100, Andrea Vai wrote:
> > > Il giorno mar, 26/11/2019 alle 10.32 +0800, Ming Lei ha scritto:
> > > > On Mon, Nov 25, 2019 at 07:51:33PM +0100, Andrea Vai wrote:
> > > > > Il giorno lun, 25/11/2019 alle 23.15 +0800, Ming Lei ha
> > scritto:
> > > > > > On Mon, Nov 25, 2019 at 03:58:34PM +0100, Andrea Vai wrote:
> > > > > >=20
> > > > > > [...]
> > > > > >=20
> > > > > > > What to try next?
> > > > > >=20
> > > > > > 1) cat /sys/kernel/debug/block/$DISK/hctx0/flags
> > > > > result:
> > > > >=20
> > > > > alloc_policy=3DFIFO SHOULD_MERGE|2
> > > > >=20
> > > > > >=20
> > > > > >=20
> > > > > > 2) echo 128 > /sys/block/$DISK/queue/nr_requests and run
> > your
> > > > copy
> > > > > > 1GB
> > > > > > test again.
> > > > >=20
> > > > > done, and still fails. What to try next?
> > > >=20
> > > > I just run 256M cp test
> > >=20
> > > I would like to point out that 256MB is a filesize that usually
> > don't
> > > trigger the issue (don't know if it matters, sorry).
> >=20
> > OK.
> >=20
> > I tested 256M because IO timeout is often triggered in case of
> > qemu-ehci, and it is a long-term issue. When setting up the disk
> > via xhci-qemu, the max request size is increased to 1MB from 120KB,
> > and IO pattern changed too. When the disk is connected via uhci-
> > qemu,
> > the transfer is too slow(1MB/s) because max endpoint size is too
> > small.
> >=20
> > However, I just waited 16min and collected all the 1GB IO log by
> > connecting disk over uhci-qemu, but the sector of each data IO
> > is still in order.
> >=20
> > >=20
> > > Another info I would provide is about another strange behavior I
> > > noticed: yesterday I ran the test two times (as usual with 1GB
> > > filesize) and took 2370s, 1786s, and a third test was going on
> > when I
> > > stopped it. Then I started another set of 100 trials and let them
> > run
> > > tonight, and the first 10 trials were around 1000s, then gradually
> > > decreased to ~300s, and finally settled around 200s with some
> > trials
> > > below 70-80s. This to say, times are extremely variable and for
> > the
> > > first time I noticed a sort of "performance increase" with time.
> >=20
> > The 'cp' test is buffered IO, can you reproduce it every time by
> > running copy just after fresh mount on the USB disk?
>=20
> yes, every time my test script (attached) mounts, copy, unmount (but I
> don't unplug and replug the pendrive each time). Is this enough?
>=20
> >=20
> > >=20
> > > >  to one USB storage device on patched kernel,
> > > > and WRITE data IO is really in ascending order. The filesystem
> > is
> > > > ext4,
> > > > and mount without '-o sync'. From previous discussion, looks
> > that is
> > > > exactly your test setting. The order can be observed via the
> > > > following script:
> > > >=20
> > > > #!/bin/sh
> > > > MAJ=3D$1
> > > > MIN=3D$2
> > > > MAJ=3D$(( $MAJ << 20 ))
> > > > DEV=3D$(( $MAJ | $MIN ))
> > > > /usr/share/bcc/tools/trace -t -C \
> > > >   't:block:block_rq_issue (args->dev =3D=3D '$DEV') "%s %d %d",
> > args-
> > > > >rwbs, args->sector, args->nr_sector'
> > > >=20
> > > > $MAJ & $MIN can be retrieved via lsblk for your USB storage
> > disk.
>=20
> ok, so I try:
>=20
> # lsblk /dev/sdf
> NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> sdf      8:80   1 28,8G  0 disk=20
> =E2=94=94=E2=94=80sdf1   8:81   1 28,8G  0 part=20
>=20
> so I ran your script (the second one, which you sent me in the next
> email message) with:
>=20
> ./test_ming 8 80
>=20
> but it fails to run (terminal output is in attached errors.txt).
> What am I doing wrong?
>=20
> It's still not clear to me if I need to start the trace script and
> then the test, or the opposite (or doesn't matter). The above errors
> are in the former case (I didn't even start the test, actually)
>=20
> Thanks,
> Andrea

> In file included from /virtual/main.c:2:
> In file included from /lib/modules/5.4.0+/build/include/linux/ptrace.h:6:
> In file included from /lib/modules/5.4.0+/build/include/linux/sched.h:14:
> In file included from /lib/modules/5.4.0+/build/include/linux/pid.h:5:
> In file included from /lib/modules/5.4.0+/build/include/linux/rculist.h:1=
1:
> In file included from /lib/modules/5.4.0+/build/include/linux/rcupdate.h:=
26:
> In file included from /lib/modules/5.4.0+/build/include/linux/irqflags.h:=
16:
> In file included from /lib/modules/5.4.0+/build/arch/x86/include/asm/irqf=
lags.h:9:
> In file included from /lib/modules/5.4.0+/build/arch/x86/include/asm/nosp=
ec-branch.h:314:
> /lib/modules/5.4.0+/build/arch/x86/include/asm/segment.h:254:2: error: ex=
pected '(' after 'asm'
>         alternative_io ("lsl %[seg],%[p]",
>         ^
> /lib/modules/5.4.0+/build/arch/x86/include/asm/alternative.h:240:2: note:=
 expanded from macro 'alternative_io'
>         asm_inline volatile (ALTERNATIVE(oldinstr, newinstr, feature)   \
>         ^
> /lib/modules/5.4.0+/build/include/linux/compiler_types.h:210:24: note: ex=
panded from macro 'asm_inline'
> #define asm_inline asm __inline
>                        ^
> In file included from /virtual/main.c:2:
> In file included from /lib/modules/5.4.0+/build/include/linux/ptrace.h:6:
> In file included from /lib/modules/5.4.0+/build/include/linux/sched.h:14:
> In file included from /lib/modules/5.4.0+/build/include/linux/pid.h:5:
> In file included from /lib/modules/5.4.0+/build/include/linux/rculist.h:1=
1:
> In file included from /lib/modules/5.4.0+/build/include/linux/rcupdate.h:=
27:
> In file included from /lib/modules/5.4.0+/build/include/linux/preempt.h:7=
8:
> In file included from /lib/modules/5.4.0+/build/arch/x86/include/asm/pree=
mpt.h:7:
> In file included from /lib/modules/5.4.0+/build/include/linux/thread_info=
.h:38:
> In file included from /lib/modules/5.4.0+/build/arch/x86/include/asm/thre=
ad_info.h:12:
> In file included from /lib/modules/5.4.0+/build/arch/x86/include/asm/page=
.h:12:
> /lib/modules/5.4.0+/build/arch/x86/include/asm/page_64.h:49:2: error: exp=
ected '(' after 'asm'
>         alternative_call_2(clear_page_orig,
>         ^
> /lib/modules/5.4.0+/build/arch/x86/include/asm/alternative.h:256:2: note:=
 expanded from macro 'alternative_call_2'
>         asm_inline volatile (ALTERNATIVE_2("call %P[old]", "call %P[new1]=
", feature1,\
>         ^
> /lib/modules/5.4.0+/build/include/linux/compiler_types.h:210:24: note: ex=
panded from macro 'asm_inline'
> #define asm_inline asm __inline


It can be workaround via the following change:

/lib/modules/5.4.0+/build/include/generated/autoconf.h:

//#define CONFIG_CC_HAS_ASM_INLINE 1


Thanks,
Ming

