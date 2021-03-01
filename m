Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D625FC433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 10:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DC8D64E56
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 10:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhCAKDl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 05:03:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53906 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231312AbhCAKDZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 05:03:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614592907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=phFWwiwM2z02X+0WTR0f2+B0WhMaJ7FZ3+eZkAvMBEI=;
        b=cYL5UvDq8ysZPEr3gklJ/Q7Sdo2x91+mlcoECkx2Zk0FHyQqAKW8bgKghxrmZOcwyqcxKy
        F185InQkYei7lFz3hXjTFz7thgRVF2GXxFqzYHTpxzMZzSTGOoIY04jKT88tnR9VqO6kwG
        5jLKxJGPWxvNK2oknBi4adhnskhGM6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-_hrxI_rtODeo-Zn6DxYpqA-1; Mon, 01 Mar 2021 05:01:44 -0500
X-MC-Unique: _hrxI_rtODeo-Zn6DxYpqA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE7BAC7401;
        Mon,  1 Mar 2021 10:01:42 +0000 (UTC)
Received: from localhost (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AEC15C3E4;
        Mon,  1 Mar 2021 10:01:42 +0000 (UTC)
Date:   Mon, 1 Mar 2021 10:01:41 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bostroesser@gmail.com, mst@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 00/25 V5] target: fix cmd plugging and submission
Message-ID: <YDy7hW9C5i/D0Org@stefanha-x1.localdomain>
References: <20210227170006.5077-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AD7J2kWfNG1CQ9p+"
Content-Disposition: inline
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--AD7J2kWfNG1CQ9p+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 27, 2021 at 10:59:41AM -0600, Mike Christie wrote:
> The following patches were made over Martin's 5.12 branches
> to handle conflicts with the in_interrupt changes.
>=20
> The patches fix the following issues:
>=20
> 1. target_core_iblock plugs and unplugs the queue for every
> command. To handle this issue and handle an issue that
> vhost-scsi and loop were avoiding by adding their own workqueue,
> I added a new submission workqueue to LIO. Drivers can pass cmds
> to it, and we can then submit batches of cmds.
>=20
> 2. vhost-scsi and loop on the submission side were doing a work
> per cmd but because we can block in the block layer on resources
> like tags we can end up creating lots of threads that will fight
> each other. In this patchset I just use a cmd list per device to
> avoid abusing the workueue layer and to better batch the cmds
> to the lower layers.
>=20
> The combined patchset fixes a major perf issue we've been hitting
> with vhost-scsi where IOPs were stuck at 230K when running:
>=20
>     fio --filename=3D/dev/sda  --direct=3D1 --rw=3Drandrw --bs=3D4k
>     --ioengine=3Dlibaio --iodepth=3D128  --numjobs=3D8 --time_based
>     --group_reporting --runtime=3D60
>=20
> The patches in this set get me to 350K when using devices that
> have native IOPs of around 400-500K.
>=20
> 3. Fix target_submit* error handling. While handling Christoph's
> comment to kill target_submit_cmd_map_sgls I hit several bugs that
> are now also fixed up.
>=20
> V6:
> - Fix gfp function arg comment.
> - Drop part of git commit message about xcopy using GFP_KERNEL.
> - Allow user to pass in specific CPU to do completions on.
>=20
> V5:
> - Add WARN if driver has used simple API and target_stop_session
> - Added fix for simple API users (usb, sbp, and xen) for early failure
> (invalid LUN, write on a RO dev, etc) handling.
>=20
> V4:
> - Fixed the target_submit error handling.
> - Dropped get_cdb callback.
> - Fixed kernel robot errors for incorrect return values and unused
> variables.
> - Used flush instead of cancel to fix bug in tmr code.
> - Fixed race in tcmu.
> - Made completion affinity handling a configfs setting
> - Dropped patch that added the per device work lists. It really helped
> a lot for higher perf initiators and tcm loop but only gave around a 5%
> boost to other drivers. So I dropped it for now to see if there is
> something more generic we can do.
>=20
> V3:
> - Fix rc type in target_submit so its a sense_reason_t
> - Add BUG_ON if caller uses target_queue_cmd_submit but hasn't
> implemented get_cdb.
> - Drop unused variables in loop.
> - Fix race in tcmu plug check
> - Add comment about how plug check works in iblock
> - Do a flush when handling TMRs instead of cancel
>=20
> V2:
> - Fix up container_of use coding style
> - Handle offlist review comment from Laurence where with the
> original code and my patches we can hit a bug where the cmd
> times out, LIO starts up the TMR code, but it misses the cmd
> because it's on the workqueue.
> - Made the work per device work instead of session to handle
> the previous issue and so if one dev hits some issue it sleeps on,
> it won't block other devices.
>=20
>=20
>=20

vhost-scsi portions:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--AD7J2kWfNG1CQ9p+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmA8u4IACgkQnKSrs4Gr
c8jSPgf/S5SI1yNqWcTu22eKCdLBIyYRRnGJbeE8H3SIPZbR2aUc7T1spk7X9/yz
mmdbwuq1+j/MkhRIin79Ks29s5IJyBBre03aeCUMxzb5V4nmKgRHzkn0ahr4CH4R
kuAfZ/HxGDaCdNCE5paLwxDnymefbIg90hnhICDfAdE9aw0pjHVhWEqljOoUtVaK
LWd7lBHpTsz2bmFhPwo2IlhCZKbxAUT2ITs5a98qv7OB0FmrrE3i9eZDJERzjqjU
MdQacOLx+3pKKAHLdk7gkB3Tt3fYWeW/vkTqS4lQZ/3mfWbWHUx0xgN5Pl/vpgEy
b7JlHZKdr+ltqRYu7XTCmz+rqTyXzg==
=5d74
-----END PGP SIGNATURE-----

--AD7J2kWfNG1CQ9p+--

