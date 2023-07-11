Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFAF7EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 19:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjGKTXI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjGKTXH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 15:23:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F5C11B
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 12:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689103338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5L4gL1jU/yMtqKWO8Lo6ER789aDY2DD8s8HE57K9Xg4=;
        b=XNN+9fQqnO4wbcAjx8g6mK5kzC5EhDRFRO7mh/pLSCWeoWevrcoEzQlodxIyzkXhqxR7TT
        p/v9EY7RvDPO/WXelcJ3p8gMtsJxdEa4qxNHk7/1ASfv+3ZtUZZQihQIIqCb66U5zGVmmy
        8CEJfVGIFZfMY0XYp7F/0cBXGPNNmKg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-YSQzVWt8O8ed_hrD6mWfLg-1; Tue, 11 Jul 2023 15:22:16 -0400
X-MC-Unique: YSQzVWt8O8ed_hrD6mWfLg-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-40252a2fd0dso69065411cf.1
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 12:22:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689103335; x=1691695335;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5L4gL1jU/yMtqKWO8Lo6ER789aDY2DD8s8HE57K9Xg4=;
        b=Sv7H9qZpYyEKsP0WjpVMkgP4so2q1C+uG9ApUpqjeLweEgME6bBoqyjyGkQUJf7NEV
         wfdLv4CxD3P1czjWG6QtZaC2EKMWYkPjy2Oep35bN+XGKKOtEarvYgE/PGkTE0PmaU4s
         RRGN+J4FDURLShzkM9qM8AVJ+vHu/k8yp8WCDPg9AZl7SDDIcsUAIAKKqxT5DQS7mrTU
         BkUKCqVpSIOwtNMMwSiKLRbDxS7BqiGkHyNVwv/Rt/WaQaLdbZ5gPY+9ZM6sL59mBgmX
         jnWvegPlLSZCiPypMFn6FjXoqsCVaPTTzsVgYGgITEcYYvc/kgB6ZYByoGDq8B22AHaH
         J+yA==
X-Gm-Message-State: ABy/qLZQICrXww5WdnEnYjwvdBVpey0Ips+nYzAkfQLPsYGjIK7S14j2
        tuCc/RgTDopt0Mm4W92PpngN4NVcEgfsnmD4TXppHK5sacv7AkGHSxkYIpOOgA9V4TANRHKrjWN
        nV7hBWOGmAwTpps8fwu+spQ==
X-Received: by 2002:ac8:5a82:0:b0:3f9:cb01:9dae with SMTP id c2-20020ac85a82000000b003f9cb019daemr19882873qtc.50.1689103335121;
        Tue, 11 Jul 2023 12:22:15 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFbyIqIs01ss62/UzZAQ/RfsKO6ibX9AyyIrh1V9QH1OAiksqwxwZaxhGiWOwLV3lHnehN2uQ==
X-Received: by 2002:ac8:5a82:0:b0:3f9:cb01:9dae with SMTP id c2-20020ac85a82000000b003f9cb019daemr19882858qtc.50.1689103334879;
        Tue, 11 Jul 2023 12:22:14 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a? ([2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a])
        by smtp.gmail.com with ESMTPSA id ay14-20020a05622a228e00b003f9e58afea6sm1414293qtb.12.2023.07.11.12.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 12:22:14 -0700 (PDT)
Message-ID: <6f7c0c5a86ca6e36babea3847288820b08354c3b.camel@redhat.com>
Subject: Re: [PATCH] scsi: qla2xxx avoid a panic due to BUG() if a
 WRITE_SAME command  is sent to a device that has no protection
From:   Laurence Oberman <loberman@redhat.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, djeffery@redhat.com,
        emilne@redhat.com, jpittman@redhat.com
Date:   Tue, 11 Jul 2023 15:22:13 -0400
In-Reply-To: <e27a1fe9be4778a9114dd7e5349ecac107d45e7b.camel@redhat.com>
References: <77f405a048b07e4451b7d7adaeba7ce4a00b7efb.camel@redhat.com>
         <yq1r0plkc4x.fsf@ca-mkp.ca.oracle.com>
         <e27a1fe9be4778a9114dd7e5349ecac107d45e7b.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2023-07-06 at 09:41 -0400, Laurence Oberman wrote:
> On Wed, 2023-07-05 at 22:35 -0400, Martin K. Petersen wrote:
> >=20
> > Laurence,
> >=20
> > > In the current code, If a device does not have protection, qla2xx
> > > will
> > > land up defaulting to a BUG() and will panic the system when
> > > sg_write_same is sent.This is because SCSI_PROT_NORMAL is matched
> > > and
> > > falls through to the BUG() call. The write_same command to a
> > > device
> > > without protection is not handled safely.
> >=20
> > I would like to understand why the driver PI code path was chosen
> > for
> > a
> > SCSI_PROT_NORMAL cmnd. That doesn't seem right.
> >=20
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case SCSI_PROT_NORMAL:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0total_bytes =3D data_bytes;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0break;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case SCSI_PROT_READ_I=
NSERT:
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case SCSI_PROT_WRITE_=
STRIP:
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0total_bytes =3D data_bytes;
> >=20
> > All this transfer size wrangling in the driver should be removed
> > and
> > replaced with a call to scsi_transfer_length() which takes the PI
> > size
> > into account.
>=20
>=20
> Martin, good questions
>=20
> I am waiting on Marvell to decide what to do about all this.
>=20
> The patch was focused only on avoiding the nasty effect of what you
> mention happens in that code path, causing customers to have system
> panics.
>=20
> The patch is to avoid the panic at this point with minimal impact to
> prior code functionality.
>=20
> Regards
> Laurence
>=20
>=20
>=20
> >=20
>=20

Hello Nilesh and Marvell

Any chance to get comments/eyes on this please.
Given its causing system crashes we need to decide how best to deal
with it.

regards
Laurence

