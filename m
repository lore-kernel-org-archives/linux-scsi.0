Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4F7C4743C
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 13:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3238B61164
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 13:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhFUNnb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 09:43:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229747AbhFUNn3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Jun 2021 09:43:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624282875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9QPtVyM3DHK6LzpFdTxuxCdYlW2bJr3j+UgwCyDNveA=;
        b=NDd8F59dALOZyxotnEE5v7R3yIcdc3XWTLAZd1HjnkwEkhZtPTlkEZqXySAsTfMsfDFZN4
        s/9fEopIfz4LyHXt8Nnd05c/dQhAjkjDS8uOLVTcvdJuV5in340RnaOyovdtGAp3zVlgrp
        +OAQsYX9n49dZUQx5oJseeX7U2igcFg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-41FiQ0ZPM726h4u7NBFUJQ-1; Mon, 21 Jun 2021 09:41:12 -0400
X-MC-Unique: 41FiQ0ZPM726h4u7NBFUJQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F72B100C662;
        Mon, 21 Jun 2021 13:41:11 +0000 (UTC)
Received: from localhost (ovpn-114-233.ams2.redhat.com [10.36.114.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCE1717B4C;
        Mon, 21 Jun 2021 13:41:07 +0000 (UTC)
Date:   Mon, 21 Jun 2021 14:41:06 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 7/9] vhost: allow userspace to create workers
Message-ID: <YNCW8ipev/vjfZHW@stefanha-x1.localdomain>
References: <20210525180600.6349-1-michael.christie@oracle.com>
 <20210525180600.6349-8-michael.christie@oracle.com>
 <YLjnk5GpFaCCOqCU@stefanha-x1.localdomain>
 <0c1aef53-4850-8c46-0706-9b7276716e68@oracle.com>
 <YL45CfpHyzSEcAJv@stefanha-x1.localdomain>
 <6882ef4d-8382-5b0d-272e-779e6fa9e7da@oracle.com>
 <YMHH+das0nmMBbt5@stefanha-x1.localdomain>
 <c98dd627-f330-b49c-6716-1caf737c73da@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="I0LHcjb+o7BPR6nT"
Content-Disposition: inline
In-Reply-To: <c98dd627-f330-b49c-6716-1caf737c73da@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--I0LHcjb+o7BPR6nT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 17, 2021 at 09:49:07PM -0500, Mike Christie wrote:
> Again it's io_uring. Check out fs/io_uring.c:__io_account_mem(). For RLIMIT_MEMLOCK
> it just does the check and increments the user's counter itself. It's simple like
> option 2, and it handles the issue where the process doing the ioctl wasn't having
> its RLIMIT_NPROC checked/updated.

This can work too. It doesn't cover cases where code called indirectly
acquires resources, but that's probably fine for the vhost worker thread
case.

Stefan

--I0LHcjb+o7BPR6nT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDQlvIACgkQnKSrs4Gr
c8hrMQgApIZoel70cxrnsWve344wJ86e71dzAJ7IgIyQPXMxS1dQKBLDwe3PDUzX
S/F+YpRfuVRpzpjN0ZrLWDR/ybvbpfx5sC71AyQtPbpBeeKEG+6VfeARWOdCL7PW
S+unE6FGodF7zc2hL4RBslnMJtJvo0hUcD8GVr71geGvkldImDzviMFuielMK5RA
5oZuvRh2Sh/NGqioFShB/8+2WHMPKYiiz+W0oa9up+sWZMRV70x59iUw/KMV7ArS
vQAQU7yRHkG8M8zqQSnfT4aTmCCO0+jzYhD3VShjeqz4vlOk5OI0Cubc3gdNcKN8
LRCc6Al6ZM2aCvam/XHVzWQJgLvaZg==
=ZFlv
-----END PGP SIGNATURE-----

--I0LHcjb+o7BPR6nT--

