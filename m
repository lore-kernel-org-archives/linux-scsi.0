Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B76C5519F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2CAB24655
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:15:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XjqOhUG/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgKQQOu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 11:14:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726781AbgKQQOt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 11:14:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605629688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wsI8dT8PpexMe9TuKFjAgUNaAmV6auVjRCkQ8lpeHW4=;
        b=XjqOhUG/OLTGhjFQ9UAFIzW7fDWKHk/bWzX5jyU7G8/W8+N8dlFhKlfKA4wDt7ViTnrbmI
        ZC7HgkdedT+kxRS98c7SEFKPbeU0oaUxwBvnDceTlbsyk7rxcMbNttBynJxGmD9l4l+5/v
        yFUVl0TSBzREX040TVmgdAQWBjTiZJY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-mCQTzDWuOOqXoqcnilpHFw-1; Tue, 17 Nov 2020 11:14:44 -0500
X-MC-Unique: mCQTzDWuOOqXoqcnilpHFw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 576FA8042A0;
        Tue, 17 Nov 2020 16:14:43 +0000 (UTC)
Received: from localhost (ovpn-115-113.ams2.redhat.com [10.36.115.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82F3B62A4F;
        Tue, 17 Nov 2020 16:14:39 +0000 (UTC)
Date:   Tue, 17 Nov 2020 16:14:38 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 09/10] vhost: add VHOST_SET_VRING_ENABLE support
Message-ID: <20201117161438.GR131917@stefanha-x1.localdomain>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <1605223150-10888-11-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1605223150-10888-11-git-send-email-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X35wERi4JU/f1kly"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--X35wERi4JU/f1kly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2020 at 05:19:09PM -0600, Mike Christie wrote:
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 2f98b81..e953031 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1736,6 +1736,28 @@ static long vhost_vring_set_num_addr(struct vhost_=
dev *d,
> =20
>  =09return r;
>  }
> +
> +static long vhost_vring_set_enable(struct vhost_dev *d,
> +=09=09=09=09   struct vhost_virtqueue *vq,
> +=09=09=09=09   void __user *argp)
> +{
> +=09struct vhost_vring_state s;
> +=09int ret =3D 0;
> +
> +=09if (vq->private_data)
> +=09=09return -EBUSY;
> +
> +=09if (copy_from_user(&s, argp, sizeof s))
> +=09=09return -EFAULT;
> +
> +=09if (s.num !=3D 1 && s.num !=3D 0)
> +=09=09return -EINVAL;
> +
> +=09if (d->ops && d->ops->enable_vring)
> +=09=09ret =3D d->ops->enable_vring(vq, s.num);
> +=09return ret;
> +}

Silently ignoring this ioctl on drivers that don't implement
d->ops->enable_vring() could be a problem. Userspace expects to be able
to enable/disable vqs, we can't just return 0 because the vq won't be
enabled/disabled as requested.

> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index a293f48..1279c09 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -158,6 +158,7 @@ struct vhost_msg_node {
> =20
>  struct vhost_dev_ops {
>  =09int (*msg_handler)(struct vhost_dev *dev, struct vhost_iotlb_msg *msg=
);
> +=09int (*enable_vring)(struct vhost_virtqueue *vq, bool enable);

Please add doc comments explaining what this callback needs to do and
the environment in which it is executed (locks that are held, etc).

--X35wERi4JU/f1kly
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+z9u4ACgkQnKSrs4Gr
c8ic5gf+O5o6weTp4soPZPFPYRPFV5BCzOnFZJnbdZ9ZiVoApnqC2iOnZTeJjwov
Tut0vqNrK6AaS/CHM6zo5pPSiwcITUlDy94VuB4fwtxprI3+b5FSbVBT5jZsdqpX
Axm3VoQu7RaqcWhPS0Sj6QRGy3bL6aruaoDM5zIlBO2p78bQsxqhgZxPKnoaG63s
deG/jgvNvGZgJ+EYd+CxvdaNvQP9ktK8MTWryuMdzYo/lOo1sGLyfdsimQPQNYs1
PrG1/vyYUDRBYwoUFuKRuopp/2GLMHDXeZXf4ZvqyPT4CYFH6CFJ7TK5ae4a15R7
HqqpOBChKzwUplk9si9SdpffMI+CJQ==
=Jr92
-----END PGP SIGNATURE-----

--X35wERi4JU/f1kly--

