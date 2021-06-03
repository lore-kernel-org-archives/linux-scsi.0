Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38972C47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 14:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15EAB613F1
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 14:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhFCOjs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 10:39:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229744AbhFCOjr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 10:39:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622731082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=awF3rK7dRpOei0bYGNfeYmW5cxqhvdc1qb6GqP+cefk=;
        b=Q+AJfK7+j6pnrg8LtTGcNuptWgSNiBBwuSL3lCpVTlFOygpBkudDQBePzfGZArBb7kYHOD
        35lsIyIABl1hyW6KNEItDuWjG+Ma87Mt0gYfzhXD5/CfvcVGM80pECpfkRb81wHunotdMn
        9F26kn3t65nnKLnSKTSa8eqP2oZw3Xk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-fr8FIAB6M32CRVDe3Mhacw-1; Thu, 03 Jun 2021 10:37:43 -0400
X-MC-Unique: fr8FIAB6M32CRVDe3Mhacw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06865805EF2;
        Thu,  3 Jun 2021 14:37:42 +0000 (UTC)
Received: from localhost (ovpn-114-228.ams2.redhat.com [10.36.114.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 924535D705;
        Thu,  3 Jun 2021 14:37:38 +0000 (UTC)
Date:   Thu, 3 Jun 2021 15:37:37 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: vhost: multiple worker support
Message-ID: <YLjpMXbfJsaLrgF5@stefanha-x1.localdomain>
References: <20210525180600.6349-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="H4b3lFVzSqimIVsY"
Content-Disposition: inline
In-Reply-To: <20210525180600.6349-1-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--H4b3lFVzSqimIVsY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 25, 2021 at 01:05:51PM -0500, Mike Christie wrote:
> The following patches apply over linus's tree or mst's vhost branch
> and my cleanup patchset:
>=20
> https://lists.linuxfoundation.org/pipermail/virtualization/2021-May/05435=
4.html
>=20
> These patches allow us to support multiple vhost workers per device. I
> ended up just doing Stefan's original idea where userspace has the
> kernel create a worker and we pass back the pid. This has the benefit
> over the workqueue and userspace thread approach where we only have
> one'ish code path in the kernel during setup to detect old tools. The
> main IO paths and device/vq setup/teardown paths all use common code.
>=20
> The kernel patches here allow us to then do N workers device and also
> share workers across devices.
>=20
> I've also included a patch for qemu so you can get an idea of how it
> works. If we are ok with the kernel code then I'll break that up into
> a patchset and send to qemu-devel.

It seems risky to allow userspace process A to "share" a vhost worker
thread with userspace process B based on a matching pid alone. Should
they have ptrace_may_access() or similar?

For example, two competing users could sabotague each other by running
lots of work items on their competitor's vhost worker thread.

--H4b3lFVzSqimIVsY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmC46TEACgkQnKSrs4Gr
c8haPggAr/8lGql69lIQrCD9sUNPvVDvTO3r+S7svNqfhMUpvJ+df1CrE/hWLnzc
H++l75ZD8kBFbsem2XbZ4S7wkcOU2iF21BKNhSUu+Mw6S0kzE0Q1XXG1xDRWzmJs
rN5VguzigMJ1J/+/FqhKEjvWOgFQgQIpWWQ29qP+m91DMLZ3zB/boDfTMCYtBSGk
l0pW6WWfss5a9kie1YEkQ90I6BvIoDKUF5uDwoJvD3MweslUGDqjduJsBNlTWN1Y
ywvTkEiHAo+YJlNrQAuJkv1MR62wSoddxERu/3MGvuD/GRzYf2vSxsMFEbNL2P+O
iMKCMek0JfRa1u921sgglNbHQ9z1Wg==
=UByy
-----END PGP SIGNATURE-----

--H4b3lFVzSqimIVsY--

