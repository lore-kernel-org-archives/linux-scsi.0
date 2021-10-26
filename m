Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A0EC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 15:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51C7B60F9D
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 15:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhJZP1s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 11:27:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37315 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235446AbhJZP1q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 11:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635261918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QM/9UCwQ8oBZJ6JKzcC7/uj3qirKZzJm8RxVkn2E47E=;
        b=Sysba+3CYpWJ8c1jtSG3cjvkp/3j5W0nrFCRF5/NPCcV0ia2918RymqOF63Wu7M14E7vXv
        LNB/dXX9joYn0dlSMAiWVtWarcl6/Ps/QMsG4u05VPf9hFI0ojE/MA9TidgObViBhZZJdF
        aO7ynjFG0151+wsN2AuBsL0HepCPKak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-zdISh-XHPfibN3ZwupSPTQ-1; Tue, 26 Oct 2021 11:25:14 -0400
X-MC-Unique: zdISh-XHPfibN3ZwupSPTQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5461F1006AA2;
        Tue, 26 Oct 2021 15:25:13 +0000 (UTC)
Received: from localhost (unknown [10.39.195.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FF8B60CA1;
        Tue, 26 Oct 2021 15:24:56 +0000 (UTC)
Date:   Tue, 26 Oct 2021 16:24:55 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
Message-ID: <YXgdx7xJDeY8bxlg@stefanha-x1.localdomain>
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zc46aFOoY3T2Uv3H"
Content-Disposition: inline
In-Reply-To: <20211022051911.108383-13-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--zc46aFOoY3T2Uv3H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 22, 2021 at 12:19:11AM -0500, Mike Christie wrote:
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index c998860d7bbc..e5c0669430e5 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -70,6 +70,17 @@
>  #define VHOST_VRING_BIG_ENDIAN 1
>  #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
>  #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
> +/* By default, a device gets one vhost_worker created during VHOST_SET_OWNER
> + * that its virtqueues share. This allows userspace to create a vhost_worker
> + * and map a virtqueue to it or map a virtqueue to an existing worker.
> + *
> + * If pid > 0 and it matches an existing vhost_worker thread it will be bound
> + * to the vq. If pid is VHOST_VRING_NEW_WORKER, then a new worker will be
> + * created and bound to the vq.
> + *
> + * This must be called after VHOST_SET_OWNER and before the vq is active.
> + */
> +#define VHOST_SET_VRING_WORKER _IOWR(VHOST_VIRTIO, 0x15, struct vhost_vring_worker)

Please clarify whether or not multiple devices can attach vqs to the same worker.

Stefan

--zc46aFOoY3T2Uv3H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmF4HccACgkQnKSrs4Gr
c8iknwgAmdVxdhAce87cUgfAOlnZ/vClHX44+6Q5cD7xX1ItrMMyWuf3/gLYSQgR
3GUOnH2bjReakIb5+JWiEFVueiN/pZDnyY9Le9M09lE6ghye3YqPko5hE1UkixSC
+b+OGOAOc55ZQrlE7ML9bSyYzHH6a2gmv7e+LFuf2U8QjcC4Lea6yxkPXschogEH
vvSOYQ4CW0Fcj++k4Kj0hdHkjdpW1Ile/6ftyaWCU3uQQiboLR0ZymEeaZr5PQjE
B5UaGdx9MU3HdRQGWmyK2O58L51juqxCKk251cd07yOcGuM4aMPzSYCxnqEEBtJ+
ckdnUMAmBwWOQHB4ZJBf0ORdo36JzQ==
=rC6W
-----END PGP SIGNATURE-----

--zc46aFOoY3T2Uv3H--

