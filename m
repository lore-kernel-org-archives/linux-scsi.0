Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29E2EB64DD
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jul 2023 13:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjGFNmn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jul 2023 09:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbjGFNmj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2023 09:42:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452641996
        for <linux-scsi@vger.kernel.org>; Thu,  6 Jul 2023 06:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688650916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vO4btfhX4ZAItdeFz/fEresdSCPHu5MFb2Eoh6y7xXo=;
        b=YNWUIjwGay78Ngejva20v4DLGoF/cyOuXfmw/mOKsg1NI5nF/SFlZNDYY0s8y8ab9SDasH
        mnt8QP/AGhcXYGm0Qp7j/en/SHJVeDqyeqefbbIcdw0EmGLscSzh6DGyzlT8xyywjB1mh4
        nzESJfaQQOgPEhB5Lnfl+KEjI2Bu5z4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-wyCDjmkDNjWDY3110kRUHA-1; Thu, 06 Jul 2023 09:41:55 -0400
X-MC-Unique: wyCDjmkDNjWDY3110kRUHA-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7679e5ebad2so106116985a.3
        for <linux-scsi@vger.kernel.org>; Thu, 06 Jul 2023 06:41:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688650914; x=1691242914;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vO4btfhX4ZAItdeFz/fEresdSCPHu5MFb2Eoh6y7xXo=;
        b=eGTp4OvrbwDwxN6HOZJreFy0QUKKGaAq2Jh2PRbCT65Id7kj9W7SdbL/XhsJfdhrh+
         5ywoZxZVPDR7tFZDc/svYn+r0xBFsWpGHE4+2mn6kDYE+Xdk0VmZMYJjdQbKkPos7WGf
         WQvNHIYpq91NkmtM+UM3oYJfaWQb9W43UNxfSsNp4Zt3qJPkMCi3b2ajMVEBioVl2gQl
         ha3nSjwWm9MZInSNQM/RGD3LpdcGLZGUexItkljAlqGE9F91sAMzlvX008Q0rGw0mGPN
         Tr5q4SC6elCleHszgK3HKtzALkklMIDytq7H16+qSo1MCg18S/22xtwVxdgsD/mgJoQC
         zngg==
X-Gm-Message-State: ABy/qLbLR2RsLRWXquYLGRDeWm/JJzDjGax0a0y1F6uYfymKyKmndAJN
        c58HyTBLY09Ek4S9YpuI2muX+8+EENrJscbqI7VrMp2YnaZP0BqM2JBCl3riN22ItJoIj4S2bF7
        ceQ35z9ioB1uv5jifNpxBtmjVe1hf4A==
X-Received: by 2002:a05:620a:414b:b0:766:fd9f:17af with SMTP id k11-20020a05620a414b00b00766fd9f17afmr2324526qko.31.1688650914545;
        Thu, 06 Jul 2023 06:41:54 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEd4ZrYaC5I8uVZq+IPA8eC5TIKP4nrCJoJ/gvEUdUQT1lfebR2OsUQkVVkr/HYlI8Ad1XEIQ==
X-Received: by 2002:a05:620a:414b:b0:766:fd9f:17af with SMTP id k11-20020a05620a414b00b00766fd9f17afmr2324507qko.31.1688650914305;
        Thu, 06 Jul 2023 06:41:54 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:7f10:16a0:5672:9abf? ([2600:6c64:4e7f:603b:7f10:16a0:5672:9abf])
        by smtp.gmail.com with ESMTPSA id m11-20020ae9e00b000000b00762255dced0sm784771qkk.0.2023.07.06.06.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 06:41:53 -0700 (PDT)
Message-ID: <e27a1fe9be4778a9114dd7e5349ecac107d45e7b.camel@redhat.com>
Subject: Re: [PATCH] scsi: qla2xxx avoid a panic due to BUG() if a
 WRITE_SAME command  is sent to a device that has no protection
From:   Laurence Oberman <loberman@redhat.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, djeffery@redhat.com,
        emilne@redhat.com, jpittman@redhat.com
Date:   Thu, 06 Jul 2023 09:41:53 -0400
In-Reply-To: <yq1r0plkc4x.fsf@ca-mkp.ca.oracle.com>
References: <77f405a048b07e4451b7d7adaeba7ce4a00b7efb.camel@redhat.com>
         <yq1r0plkc4x.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-07-05 at 22:35 -0400, Martin K. Petersen wrote:
>=20
> Laurence,
>=20
> > In the current code, If a device does not have protection, qla2xx
> > will
> > land up defaulting to a BUG() and will panic the system when
> > sg_write_same is sent.This is because SCSI_PROT_NORMAL is matched
> > and
> > falls through to the BUG() call. The write_same command to a device
> > without protection is not handled safely.
>=20
> I would like to understand why the driver PI code path was chosen for
> a
> SCSI_PROT_NORMAL cmnd. That doesn't seem right.
>=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case SCSI_PROT_NORMAL:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0total_bytes =3D data_bytes;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0break;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case SCSI_PROT_READ_INS=
ERT:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case SCSI_PROT_WRITE_ST=
RIP:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0total_bytes =3D data_bytes;
>=20
> All this transfer size wrangling in the driver should be removed and
> replaced with a call to scsi_transfer_length() which takes the PI
> size
> into account.


Martin, good questions

I am waiting on Marvell to decide what to do about all this.

The patch was focused only on avoiding the nasty effect of what you
mention happens in that code path, causing customers to have system
panics.

The patch is to avoid the panic at this point with minimal impact to
prior code functionality.

Regards
Laurence



>=20

