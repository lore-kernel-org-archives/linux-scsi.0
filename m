Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3954FC5519F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 13:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDE692225B
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 13:04:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W00FUIo6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgKQNE3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:04:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20396 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726035AbgKQNE2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 08:04:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605618267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kNa5O/Hj0HBQuu1Ns8AweW8QzcPZsqmg4/YkfGYf+Iw=;
        b=W00FUIo6G7zd3/vrLyGRB3w56n8CP1fw1pco3aQeWqqOX05+7DXFke6dV4P+y5MwRluCeW
        OXOug9bkIhNkU+ifixMOfxG+azFfVROrShyI8qwn4hpxMknXclGvGx3dFznWVUAQzlOzFK
        kKpjDW9CpHsXXhYYPi2BJEzE4u7bblM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-MyAQ-weGMI6SqUW7jvbcQg-1; Tue, 17 Nov 2020 08:04:25 -0500
X-MC-Unique: MyAQ-weGMI6SqUW7jvbcQg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1334A6D585;
        Tue, 17 Nov 2020 13:04:24 +0000 (UTC)
Received: from localhost (ovpn-115-113.ams2.redhat.com [10.36.115.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EA7D55760;
        Tue, 17 Nov 2020 13:04:18 +0000 (UTC)
Date:   Tue, 17 Nov 2020 13:04:17 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 01/10] vhost: remove work arg from vhost_work_flush
Message-ID: <20201117130417.GK131917@stefanha-x1.localdomain>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <1605223150-10888-3-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1605223150-10888-3-git-send-email-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EVcIhgQsEzAXu06J"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--EVcIhgQsEzAXu06J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 12, 2020 at 05:19:01PM -0600, Mike Christie wrote:
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index f22fce5..8795fd3 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1468,8 +1468,8 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
>  	/* Flush both the vhost poll and vhost work */
>  	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
>  		vhost_scsi_flush_vq(vs, i);
> -	vhost_work_flush(&vs->dev, &vs->vs_completion_work);
> -	vhost_work_flush(&vs->dev, &vs->vs_event_work);
> +	vhost_work_dev_flush(&vs->dev);
> +	vhost_work_dev_flush(&vs->dev);

These two calls can be combined into a single call now.

--EVcIhgQsEzAXu06J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+zylEACgkQnKSrs4Gr
c8hrVwf+Mw0t1WPblvn8yE7/N+vf0dXbjADIoB7GyZgfdmFl4j1KGKlUh0ou0Kqb
Jth2D1ZdGZH640h2T+KEiGahhxXOP5yKL3GuEQcy80cd/93c+jpR4QRnUvg8xCSH
CrVg4cIAuf8cZAUXDjj7a5VeL7z3yI6Diq6iWX6Y8I8JOMtYBdI4DUeLJjUagIiL
qv65Rakq6rUcSDuQtl0uJopuWBM9sdntAUCrJLbBZakQThdBW7eu+L0TUbWI+w2k
iCSNazGQV2yqgRWfN8cKqC2bPG2rVVmghPK3XWCLkjSoNnnEizR/d1BrRLOHs/Rg
YoNm0XOtXilZ2v9oOenhdNIoekvUpA==
=j25G
-----END PGP SIGNATURE-----

--EVcIhgQsEzAXu06J--

