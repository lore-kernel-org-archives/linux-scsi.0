Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84525C64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 13:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DA1920644
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 13:01:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="io0lvFER"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730781AbgLANBQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 08:01:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728436AbgLANBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 08:01:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606827589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y0fFNDxGbQNOcsUGaCDG6x16itFRDEvyd8G3CtWJQeY=;
        b=io0lvFERhTqP5Yue456HpSaviXdzCGx2U6Gfr3xjCQVImIxQ5mNewoyC4uQIyJW6Sk6RFd
        lKIB1Yu7iCWG0XiVR64YD2s0HnNuWq12/6Ci3Bge5BEDzFVpLBT7UXVmnD8iIDsCRPeZ2w
        FsM355nQw+qeXAmtXYmZKsTfuxfy5xI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-9D66DZ3WO26x0-ajTcL9ug-1; Tue, 01 Dec 2020 07:59:46 -0500
X-MC-Unique: 9D66DZ3WO26x0-ajTcL9ug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FC60800D53;
        Tue,  1 Dec 2020 12:59:45 +0000 (UTC)
Received: from localhost (ovpn-114-82.ams2.redhat.com [10.36.114.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 965BD5D6AB;
        Tue,  1 Dec 2020 12:59:44 +0000 (UTC)
Date:   Tue, 1 Dec 2020 12:59:43 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        Mike Christie <michael.christie@oracle.com>,
        fam <fam@euphon.net>, linux-scsi <linux-scsi@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
Message-ID: <20201201125943.GE585157@stefanha-x1.localdomain>
References: <20201117164043.GS131917@stefanha-x1.localdomain>
 <b3343762-bb11-b750-46ec-43b5556f2b8e@oracle.com>
 <20201118113117.GF182763@stefanha-x1.localdomain>
 <20201119094315-mutt-send-email-mst@kernel.org>
 <ceebdc90-3ffc-1563-ff85-12a848bcba18@oracle.com>
 <CAJSP0QUvSwX5NCPmfSODV_C+D41E21LZT=oXQ2PLc6baAsGGDQ@mail.gmail.com>
 <ffd88f0c-981e-a102-4b08-f29d6b9a0f71@oracle.com>
 <CAJSP0QUfqd=QNFa-RikH4dVcLmfcP-pYCwznP3W0zobYkM+KDw@mail.gmail.com>
 <CAJSP0QVu4P6c+kdFkhw1S_OEaj7B-eiDqFOVDxWAaSOcsAADrA@mail.gmail.com>
 <20201120072802-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20201120072802-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WBsA/oQW3eTA3LlM"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--WBsA/oQW3eTA3LlM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:31:08AM -0500, Michael S. Tsirkin wrote:
> On Fri, Nov 20, 2020 at 08:45:49AM +0000, Stefan Hajnoczi wrote:
> > On Thu, Nov 19, 2020 at 5:08 PM Stefan Hajnoczi <stefanha@gmail.com> wr=
ote:
> > >
> > > On Thu, Nov 19, 2020 at 4:43 PM Mike Christie
> > > <michael.christie@oracle.com> wrote:
> > > >
> > > > On 11/19/20 10:24 AM, Stefan Hajnoczi wrote:
> > > > > On Thu, Nov 19, 2020 at 4:13 PM Mike Christie
> > > > > <michael.christie@oracle.com> wrote:
> > > > >>
> > > > >> On 11/19/20 8:46 AM, Michael S. Tsirkin wrote:
> > > > >>> On Wed, Nov 18, 2020 at 11:31:17AM +0000, Stefan Hajnoczi wrote=
:
> > > > > struct vhost_run_worker_info {
> > > > >      struct timespec *timeout;
> > > > >      sigset_t *sigmask;
> > > > >
> > > > >      /* List of virtqueues to process */
> > > > >      unsigned nvqs;
> > > > >      unsigned vqs[];
> > > > > };
> > > > >
> > > > > /* This blocks until the timeout is reached, a signal is received=
, or
> > > > > the vhost device is destroyed */
> > > > > int ret =3D ioctl(vhost_fd, VHOST_RUN_WORKER, &info);
> > > > >
> > > > > As you can see, userspace isn't involved with dealing with the
> > > > > requests. It just acts as a thread donor to the vhost driver.
> > > > >
> > > > > We would want the VHOST_RUN_WORKER calls to be infrequent to avoi=
d the
> > > > > penalty of switching into the kernel, copying in the arguments, e=
tc.
> > > >
> > > > I didn't get this part. Why have the timeout? When the timeout expi=
res,
> > > > does userspace just call right back down to the kernel or does it d=
o
> > > > some sort of processing/operation?
> > > >
> > > > You could have your worker function run from that ioctl wait for a
> > > > signal or a wake up call from the vhost_work/poll functions.
> > >
> > > An optional timeout argument is common in blocking interfaces like
> > > poll(2), recvmmsg(2), etc.
> > >
> > > Although something can send a signal to the thread instead,
> > > implementing that in an application is more awkward than passing a
> > > struct timespec.
> > >
> > > Compared to other blocking calls we don't expect
> > > ioctl(VHOST_RUN_WORKER) to return soon, so maybe the timeout will
> > > rarely be used and can be dropped from the interface.
> > >
> > > BTW the code I posted wasn't a carefully thought out proposal :). The
> > > details still need to be considered and I'm going to be offline for
> > > the next week so maybe someone else can think it through in the
> > > meantime.
> >=20
> > One final thought before I'm offline for a week. If
> > ioctl(VHOST_RUN_WORKER) is specific to a single vhost device instance
> > then it's hard to support poll-mode (busy waiting) workers because
> > each device instance consumes a whole CPU. If we stick to an interface
> > where the kernel manages the worker threads then it's easier to share
> > workers between devices for polling.
>=20
>=20
> Yes that is the reason vhost did its own reason in the first place.
>=20
>=20
> I am vaguely thinking about poll(2) or a similar interface,
> which can wait for an event on multiple FDs.

I can imagine how using poll(2) would work from a userspace perspective,
but on the kernel side I don't think it can be implemented cleanly.
poll(2) is tied to the file_operations->poll() callback and
read/write/error events. Not to mention there isn't a way to substitue
the vhost worker thread function instead of scheduling out the current
thread while waiting for poll fd events.

But maybe ioctl(VHOST_WORKER_RUN) can do it:

  struct vhost_run_worker_dev {
      int vhostfd;      /* /dev/vhost-TYPE fd */
      unsigned nvqs;    /* number of virtqueues in vqs[] */
      unsigned vqs[];   /* virtqueues to process */
  };

  struct vhost_run_worker_info {
       struct timespec *timeout;
       sigset_t *sigmask;

       unsigned ndevices;
       struct vhost_run_worker_dev *devices[];
  };

In the simple case userspace sets ndevices to 1 and we just handle
virtqueues for the current device.

In the fancier shared worker thread case the userspace process has the
vhost fds of all the devices it is processing and passes them to
ioctl(VHOST_WORKER_RUN) via struct vhost_run_worker_dev elements.

From a security perspective it means the userspace thread has access to
all vhost devices (because it has their fds).

I'm not sure how the mm is supposed to work. The devices might be
associated with different userspace processes (guests) and therefore
have different virtual memory.

Just wanted to push this discussion along a little further. I'm buried
under emails and probably wont be very active over the next few days.

Stefan

--WBsA/oQW3eTA3LlM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/GPj8ACgkQnKSrs4Gr
c8g9UAf/Qor9MVeSJMu8Q5hSTOXxx74/+SFNAXBVf1tTx1aGgpJ+CNftEcU3Xfgr
iivW/d6OvJ8GmHwgnyJWSS1v9xfUnRTzXDL5YLOl/83NLXu3blxk0uKktWqQ7Ddw
6jU/TZY6ECdFSXvZp3vTShNWDVyBvlFUiVvOapacS+REKPrEyLONQkHgjLn+M301
FdU79eYtPx9oGpMNYlIOZ6aw7NYZQ8UfUlL4QnA/qnTh+/1fvUuPugGxvMGuPwe7
u00eDVlluvcxLhAkte9OPGq4aSif5Zx5zqNntJU2H66skeiB01eV3KGsYwFDnePu
Nu/pwCfxOiRCDGZUxj/6jLejURcr1g==
=oHMn
-----END PGP SIGNATURE-----

--WBsA/oQW3eTA3LlM--

