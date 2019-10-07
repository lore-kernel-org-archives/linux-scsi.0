Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64A5ECE58C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 14:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80F25206C2
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 14:15:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NDTVFRKY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfJGOPK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 10:15:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21403 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726334AbfJGOPJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Oct 2019 10:15:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570457707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i2NSkb50IVryQXLw9O3vRkThPVWFBIGSRHW7GXjVPwY=;
        b=NDTVFRKYHHFNG3V0ELYONrNXYi47QihJE+VzNb23u8Q4nReXaZoNRTlETmXL2ka7yie2Db
        Rq8l+sdMpw4rzilG+WJhQGsJr+JBqJKanysPA1AzGkw7IOHAWzZu4phPqkZ+vsnPxRTK8c
        oq3GjgwAqLXwSGHXzZjlprxQfxhd6mE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-6zLpNOoIP_aeQlOibVkm-Q-1; Mon, 07 Oct 2019 10:15:06 -0400
Received: by mail-qt1-f200.google.com with SMTP id m6so15352088qtk.23
        for <linux-scsi@vger.kernel.org>; Mon, 07 Oct 2019 07:15:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YReYWI/fOrvdtdTEUqVrafxqkwPbRzondQLvOyaMuNc=;
        b=cRH74L1OKjgfXiPgEchOzUsgTXRi9XAI9xuZlemYzD1VKGo0wFO97ClexyyXqi020D
         ril6nwaNSGnlDLQoq/rFhW49f6NsdaVJZd3c2iKQ967DMv8LzieUt8l4ppH3TgsQocgR
         M9XB7xqhr7Yc8vWk3uXVUpT87jDfS6LGPYe6BkdUKUq5g59+vAbRIg2jAPuYXw8XD9cs
         zhW3FFJKtNj5DHdHVgIHYz59fOAKQWEMSJ+DXDl68aDuZOcGkZn+9nnKoms0XXTLJjQN
         C5OqFFky21Tqn3J6/opuXuQ9EcY+/d8UyAG8seyAUj/8RBVsJxhM28Z6RdU+Pz+75Yvq
         NJzg==
X-Gm-Message-State: APjAAAXpbe8fNkFZ/kThtIZ1GdYeYyWlWUBK903BmAAQE4a4Dy+R8cmF
        gmSnQi0kwDXc89ty0kwTFbPpM8AR6GqJKM49PE7L4HhoG0CE4qj/LL2gHMW+4in286Y74n6ptJJ
        htUnZp+YFFqcJbf39k5dMVw==
X-Received: by 2002:ae9:f503:: with SMTP id o3mr23052861qkg.3.1570457705651;
        Mon, 07 Oct 2019 07:15:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxNpID4ZPTT7yj0NVXIwHIk6V7d2o0N11OrNmzqf6Nb63xSzMyPW/Vcgqe6Yk98s/ccZjYMiQ==
X-Received: by 2002:ae9:f503:: with SMTP id o3mr23052792qkg.3.1570457705096;
        Mon, 07 Oct 2019 07:15:05 -0700 (PDT)
Received: from rhel7lobe ([2600:6c64:4e80:f1:aa45:cafe:5682:368f])
        by smtp.gmail.com with ESMTPSA id z12sm9018449qkg.97.2019.10.07.07.15.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 07:15:04 -0700 (PDT)
Message-ID: <ee4761c0e73e738c1148fe7d75cb4fa9f4c5383b.camel@redhat.com>
Subject: Re: [PATCH] scsi_dh_alua: handle RTPG sense code correctly during
 state transitions
From:   Laurence Oberman <loberman@redhat.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Martin Wilck <martin.wilck@suse.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Date:   Mon, 07 Oct 2019 10:15:03 -0400
In-Reply-To: <20191007135701.32389-1-hare@suse.de>
References: <20191007135701.32389-1-hare@suse.de>
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7)
Mime-Version: 1.0
X-MC-Unique: 6zLpNOoIP_aeQlOibVkm-Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2019-10-07 at 15:57 +0200, Hannes Reinecke wrote:
> From: Hannes Reinecke <hare@suse.com>
>=20
> Some arrays are not capable of returning RTPG data during state
> transitioning, but rather return an 'LUN not accessible, asymmetric
> access state transition' sense code. In these cases we
> can set the state to 'transitioning' directly and don't need to
> evaluate the RTPG data (which we won't have anyway).
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 21 ++++++++++++++++--
> ---
>  1 file changed, 16 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 4971104b1817..f32da0ca529e 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -512,6 +512,7 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_port_group *pg)
>  =09unsigned int tpg_desc_tbl_off;
>  =09unsigned char orig_transition_tmo;
>  =09unsigned long flags;
> +=09bool transitioning_sense =3D false;
> =20
>  =09if (!pg->expiry) {
>  =09=09unsigned long transition_tmo =3D ALUA_FAILOVER_TIMEOUT *
> HZ;
> @@ -572,13 +573,19 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_port_group *pg)
>  =09=09=09goto retry;
>  =09=09}
>  =09=09/*
> -=09=09 * Retry on ALUA state transition or if any
> -=09=09 * UNIT ATTENTION occurred.
> +=09=09 * If the array returns with 'ALUA state transition'
> +=09=09 * sense code here it cannot return RTPG data during
> +=09=09 * transition. So set the state to 'transitioning'
> directly.
>  =09=09 */
>  =09=09if (sense_hdr.sense_key =3D=3D NOT_READY &&
> -=09=09    sense_hdr.asc =3D=3D 0x04 && sense_hdr.ascq =3D=3D 0x0a)
> -=09=09=09err =3D SCSI_DH_RETRY;
> -=09=09else if (sense_hdr.sense_key =3D=3D UNIT_ATTENTION)
> +=09=09    sense_hdr.asc =3D=3D 0x04 && sense_hdr.ascq =3D=3D 0x0a) {
> +=09=09=09transitioning_sense =3D true;
> +=09=09=09goto skip_rtpg;
> +=09=09}
> +=09=09/*
> +=09=09 * Retry on any other UNIT ATTENTION occurred.
> +=09=09 */
> +=09=09if (sense_hdr.sense_key =3D=3D UNIT_ATTENTION)
>  =09=09=09err =3D SCSI_DH_RETRY;
>  =09=09if (err =3D=3D SCSI_DH_RETRY &&
>  =09=09    pg->expiry !=3D 0 && time_before(jiffies, pg-
> >expiry)) {
> @@ -666,7 +673,11 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_port_group *pg)
>  =09=09off =3D 8 + (desc[7] * 4);
>  =09}
> =20
> + skip_rtpg:
>  =09spin_lock_irqsave(&pg->lock, flags);
> +=09if (transitioning_sense)
> +=09=09pg->state =3D SCSI_ACCESS_STATE_TRANSITIONING;
> +
>  =09sdev_printk(KERN_INFO, sdev,
>  =09=09    "%s: port group %02x state %c %s supports
> %c%c%c%c%c%c%c\n",
>  =09=09    ALUA_DH_NAME, pg->group_id, print_alua_state(pg-
> >state),

This makes sense to me and has affected recovery timeouts in the past.
Code looks correct to me.=20

Reviewed-by: Laurence Oberman <loberman@redhat.com>

