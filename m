Return-Path: <SRS0=dDgG=ZB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E55C17440
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 10:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF27F2196F
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 10:09:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="blY6In19"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfKIKJa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Nov 2019 05:09:30 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23977 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726349AbfKIKJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2019 05:09:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573294168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=COvRkfB7QtwqnVTHt3MVS0PoIAM0aB4odeSnRONVuV8=;
        b=blY6In19Qh645f6S3D5+mJFJIRMZu3daa/CKH7TR0bbBVBuEqw7To6jIeHF0BPBWb5fR5S
        8PEHnMnfW4H7gupuIF27lNsZAYYCzsLa1CjveAcC0CMMNwvtYwZ+VxSNDKwek3HR/k6zA6
        FP6nuJGufhLJ7EsXnqVT2LIxw7Nm+4o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-Hi_ndLc_MxiC1ic0MmTclQ-1; Sat, 09 Nov 2019 05:09:24 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCE591800D7D;
        Sat,  9 Nov 2019 10:09:22 +0000 (UTC)
Received: from ming.t460p (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F31EA5D9E2;
        Sat,  9 Nov 2019 10:09:09 +0000 (UTC)
Date:   Sat, 9 Nov 2019 18:09:03 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Andrea Vai <andrea.vai@unipv.it>,
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
Message-ID: <20191109100903.GA7696@ming.t460p>
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
 <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
 <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it>
 <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
 <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
 <BYAPR04MB5816ECD4302AD94338CB9072E77B0@BYAPR04MB5816.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5816ECD4302AD94338CB9072E77B0@BYAPR04MB5816.namprd04.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: Hi_ndLc_MxiC1ic0MmTclQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 08, 2019 at 08:42:53AM +0000, Damien Le Moal wrote:
> On 2019/11/08 4:00, Andrea Vai wrote:
> > [Sorry for the duplicate message, it didn't reach the lists due to
> > html formatting]
> > Il giorno gio 7 nov 2019 alle ore 08:54 Damien Le Moal
> > <Damien.LeMoal@wdc.com> ha scritto:
> >>
> >> On 2019/11/07 16:04, Andrea Vai wrote:
> >>> Il giorno mer, 06/11/2019 alle 22.13 +0000, Damien Le Moal ha scritto=
:
> >>>>
> >>>>
> >>>> Please simply try your write tests after doing this:
> >>>>
> >>>> echo mq-deadline > /sys/block/<name of your USB
> >>>> disk>/queue/scheduler
> >>>>
> >>>> And confirm that mq-deadline is selected with:
> >>>>
> >>>> cat /sys/block/<name of your USB disk>/queue/scheduler
> >>>> [mq-deadline] kyber bfq none
> >>>
> >>> ok, which kernel should I test with this: the fresh git cloned, or th=
e
> >>> one just patched with Alan's patch, or doesn't matter which one?
> >>
> >> Probably all of them to see if there are any differences.
> >=20
> > with both kernels, the output of
> > cat /sys/block/sdh/queue/schedule
> >=20
> > already contains [mq-deadline]: is it correct to assume that the echo
> > command and the subsequent testing is useless? What to do now?
>=20
> Probably, yes. Have you obtained a blktrace of the workload during these
> tests ? Any significant difference in the IO pattern (IO size and
> randomness) and IO timing (any device idle time where the device has no
> command to process) ? Asking because the problem may be above the block
> layer, with the file system for instance.

You may get the IO pattern via the previous trace=20

https://lore.kernel.org/linux-usb/20190710024439.GA2621@ming.t460p/

IMO, if it is related write order, one possibility could be that
the queue lock is killed in .make_request_fn().


Thanks,
Ming

