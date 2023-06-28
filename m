Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A14AEB64DC
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 17:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjF1R1S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:27:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232268AbjF1R0S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2023 13:26:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687973133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vS/6QLzpCxy9LuoqXzCu0hW+majuuoS94i0c6kB8rS8=;
        b=dyUhKMNyRj68Zs360eXHCF+MTP7DboE4PDvz1HBBz2zFy2msUZLcsMr4Sa71QsFj+gX3Wq
        aSZXOTV2XlVwSR9/JSnttYgcYRBcMfxjzrOTt93uwi0peyOqE1L5bSGeo2fZ6nqVnJgfk6
        i6bzKvwgCxLPa0Y8lMos2YKDQrx4x+E=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-uZxaDdoVNaK4loIUgm-6NQ-1; Wed, 28 Jun 2023 13:25:31 -0400
X-MC-Unique: uZxaDdoVNaK4loIUgm-6NQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-763a36c3447so572650185a.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 10:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687973131; x=1690565131;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vS/6QLzpCxy9LuoqXzCu0hW+majuuoS94i0c6kB8rS8=;
        b=CEstQHy1sx2iEIyTn2QNsUdWn5nFT2dSxedNBU2b+bYjtdL/0GB1g2yAjegAFkZEw3
         5AYVQplVDjp6G4mGDnU8kgX0lSidMmFH0tz6wdsQ8Y9dyZwEU1eqJvGb/3A7lbjnBEr3
         0Bq3O43WPmlNsQU39FAwK6wTQelpxMDWnvcPIUa1JfK1lrDsaTAzzCg5ar9phNyrXfyG
         9GizoAebTb3dVz7UDqIw1RA3w7xx2Uq/EPHotHDfVyLswI6pPXhgt0rrxIaD7TuPe1hD
         Davqw9O6ry1RBXp2qeN5EUInj0D7sIigxNN74hTy6173lzJc0Q1QYY1DP1kSMjmxKn+a
         1i1g==
X-Gm-Message-State: AC+VfDyBNm59j4GIinAGlDGY6DvDM+5cBKFAIDnlV1BXP+PPBnOXi6eM
        66bH2JOn8GvnggKQbgF+ntyeRzbqt3p4WtmPAqAGGXlMxdapfJyIo9S/5cW4nrpLNZg69QJtIVt
        xATKKlJihkH/9chBvT+n4kw==
X-Received: by 2002:a05:620a:2550:b0:765:6f3e:30d8 with SMTP id s16-20020a05620a255000b007656f3e30d8mr13351032qko.49.1687973131276;
        Wed, 28 Jun 2023 10:25:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6cE0Hqq2xueHpzbsrfE8lUB2v6sExazo6cr+dt19zKKEX2nYquPouEE42FcTo2RbibCzo4DA==
X-Received: by 2002:a05:620a:2550:b0:765:6f3e:30d8 with SMTP id s16-20020a05620a255000b007656f3e30d8mr13351015qko.49.1687973130995;
        Wed, 28 Jun 2023 10:25:30 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:7f10:16a0:5672:9abf? ([2600:6c64:4e7f:603b:7f10:16a0:5672:9abf])
        by smtp.gmail.com with ESMTPSA id a10-20020a05620a16ca00b0076639dfca86sm3094851qkn.17.2023.06.28.10.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 10:25:30 -0700 (PDT)
Message-ID: <9039f653c7687733c4d8f31c7398c47d02fad919.camel@redhat.com>
Subject: Re: [PATCH] scsi: scsi_debug: remove dead code
From:   Laurence Oberman <loberman@redhat.com>
To:     Maurizio Lombardi <mlombard@redhat.com>, jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Date:   Wed, 28 Jun 2023 13:25:28 -0400
In-Reply-To: <20230628150638.53218-1-mlombard@redhat.com>
References: <20230628150638.53218-1-mlombard@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-06-28 at 17:06 +0200, Maurizio Lombardi wrote:
> The ramdisk rwlocks are not used anymore
>=20
> Fixes: 87c715dcde63 ("scsi: scsi_debug: Add per_host_store option")
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
> =C2=A0drivers/scsi/scsi_debug.c | 8 --------
> =C2=A01 file changed, 8 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 8c58128ad32a..9c0af50501f9 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -841,11 +841,6 @@ static int sdeb_zbc_nr_conv =3D
> DEF_ZBC_NR_CONV_ZONES;
> =C2=A0static int submit_queues =3D DEF_SUBMIT_QUEUES;=C2=A0 /* > 1 for mu=
lti-
> queue (mq) */
> =C2=A0static int poll_queues; /* iouring iopoll interface.*/
> =C2=A0
> -static DEFINE_RWLOCK(atomic_rw);
> -static DEFINE_RWLOCK(atomic_rw2);
> -
> -static rwlock_t *ramdisk_lck_a[2];
> -
> =C2=A0static char sdebug_proc_name[] =3D MY_NAME;
> =C2=A0static const char *my_name =3D MY_NAME;
> =C2=A0
> @@ -6818,9 +6813,6 @@ static int __init scsi_debug_init(void)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int k, ret, hosts_to_add;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int idx =3D -1;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ramdisk_lck_a[0] =3D &atomic_r=
w;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ramdisk_lck_a[1] =3D &atomic_r=
w2;
> -
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (sdebug_ndelay >=3D 10=
00 * 1000 * 1000) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0pr_warn("ndelay must be less than 1 second,
> ignored\n");
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0sdebug_ndelay =3D 0;

Looks good to me:

linux]$ grep -e atomic_rw -e atomic_rw2 -e ramdisk_lck_a
drivers/scsi/scsi_debug.c
static DEFINE_RWLOCK(atomic_rw);
static DEFINE_RWLOCK(atomic_rw2);
static rwlock_t *ramdisk_lck_a[2];
	ramdisk_lck_a[0] =3D &atomic_rw;
	ramdisk_lck_a[1] =3D &atomic_rw2;

Reviewed-by: Laurence Oberman <loberman@redhat.com>

