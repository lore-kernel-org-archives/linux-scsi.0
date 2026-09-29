Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CD93A6B81
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 18:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790705788; cv=none; b=PSQp3MlLKxvwz6FPi9edcCIv4R165PuIhcnwul8w5jv3jHK5FRcgyI4lgPyOX6fRwSiTpitJHbfw7KR5CGzqtx3ASjUyy28lCzSo0Uyee0swOGuKf18Au8viI1ndhBvQbFTrL9D8JC9D6/wTRknyrzyFx5jKUf++gpEhI58NUpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790705788; c=relaxed/simple;
	bh=YCOb8LDZQC/rFtiiD6EqbvAIQhYPDU6nw0PJYCmY6lg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ck1+wyNQBl+kZtRFr/G1Nuv7BxwYbn3xa1Dd8g8K0DATxlbWtQTjqvMMqqS3AS2huIl6K3iQJfV5pJSvz8kRRDyAZO4pHT3VeVlx76RsNd/1ifgi4xmtOlkyPYhgxOSwkofYBsYZx7ZRSbUnUXoED0zFlhA4UyDfjJJkT+/XMp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fW8nttZu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TqJ9dOT8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fW8nttZu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TqJ9dOT8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790705786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W1luB7NLM4bPb8otE9nxg2bzJ3BE46DMUdvlMv2Kr3M=;
	b=fW8nttZumv3yCtZzZraT4xTmzsz3Se1fNg5XF/FnUM2hmHzNfQrhBqdRiraKsbc7x/7YGO
	NIr4hdiuwCV1P1ckINk0fXti2tWG9xl7SuHuemG3U8c9V3lPkKZ7fT7G7yH9zejNlyzLRs
	BxzngpQ4qZEJpgMEk+/NQNTPWY0xcRU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-kxjItc56MSWMjjVw61-3sA-1; Tue, 29 Sep 2026 14:16:24 -0400
X-MC-Unique: kxjItc56MSWMjjVw61-3sA-1
X-Mimecast-MFC-AGG-ID: kxjItc56MSWMjjVw61-3sA_1790705784
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91792488228so8125616d6.2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 11:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790705784; x=1791310584; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=W1luB7NLM4bPb8otE9nxg2bzJ3BE46DMUdvlMv2Kr3M=;
        b=TqJ9dOT84RZZCXQ7jQx+QKDoalnfkre6uuYd5tSsJ+tuX3WbqrEMgv9ZNZvwseD+cj
         Mn0Qvx28vBOwWeJxRQZJNywd62AG3nibXK5YwkEXnm6DTKz+0LSnb2xI9BsUOrWUayyg
         eDb7Rk64y4Y0O2V8apVWrzLETeD2RWLpV9rLD85phSmgDRZvWynmuIcyPHaeyedRXudr
         003d1iT0ytTrQibZ7mfUiLrFGdtbA0zEbsTDWgy2+oI1WG9sfMw0bYlh734vVnX7fbkh
         ItlA28/nGBJBJil+it6nEI41jT8fb9v2BHW78mVO5ZDjgld4IZyVgas6RlcFRCJmsJi3
         DtQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790705784; x=1791310584;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W1luB7NLM4bPb8otE9nxg2bzJ3BE46DMUdvlMv2Kr3M=;
        b=gHyKyB+UAWBLwJKfWIUtscsc5OcKPLsHQmnEGkgl+g+ozJWTncvzDSE4EKzo13qpmw
         g9hv9ziPRM25eL8OkWIkwkUQU1NDuVdOoWYhjyaeAer1GJAZZZzd2U1hxUlPiVRtoQ0L
         sPuDCp0A7VoHKkjxoEiyQ6EH0PRe1PgRtG0BfVtdNQbH0eHjHL4/ykNvhMjmiM07fwRL
         AHTiV9y9v5zQCuI8uXsVy+8/S/HTMjbnlhRpzyLi/b1BB33IBbVzWWldoU+UvsnoQpgS
         uT8MXD4up/2vNGLLiWlY+6Uipdgy/KnwAwqSCF50MYUHPOVMsMsOpAGCfpenwXhpGazQ
         T4oA==
X-Gm-Message-State: AFq9FYLDfIgOxk5aYBmperpyaT9MuzOxMy2y7iFACME9WGEjydOOizUu
	TdqGa1gKMjtJblz89nnQtGZZKsTQ/kHnT6KPXAvNSAioRtq+vdhE0u0z1nh/x7IrtqC+fv6lVCo
	6XxRKtbQKqVgSzCAYNkTXpbN4XA1r+3WHunJFj90YgMP0XkuL/USrTjRQDIVKX/IjjO4tcwc=
X-Gm-Gg: AYBFou2iva/U8nPawAZlDFZ+brXbmUgEjknjhNv3jSACFkUqOCY6xyRBq5YI/NxIy0e
	luBR6cVcq9pdXNh90aJfhxuDJpBDK2WrK/ROtsdhsc5YaGkxYUUkIWDZKJTwHIsjyGsi8ovqAwq
	swnfs7mbA30IfEILGeUaWNaslXKVOgP8qb0wLeuWm4aE7qygku3KHwfO+saQQoN4PR+T1FGfKz2
	APtRXNZLX+ffhUyjebefaG4PoY44m4V+prXfPLhBlZA8u0SQ7oGR8D+KYHNhrtiJDmsOD01oZB9
	+o456KeVS+k6+vYv7KAbqLycnnoebuZJZdQRuJ1gXZKqt1GUm5sUi0/tvv37vsQzH6YPP6D7ydq
	CIVTl7VQd+khsEOKRTKfACBJJe7j5X+FAQkF1
X-Received: by 2002:a05:6214:486:b0:915:e9f2:8e5c with SMTP id 6a1803df08f44-9178265bcbfmr79144456d6.33.1790705783747;
        Tue, 29 Sep 2026 11:16:23 -0700 (PDT)
X-Received: by 2002:a05:6214:486:b0:915:e9f2:8e5c with SMTP id 6a1803df08f44-9178265bcbfmr79143996d6.33.1790705783146;
        Tue, 29 Sep 2026 11:16:23 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-917987a0ef3sm1424346d6.13.2026.09.29.11.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 11:16:22 -0700 (PDT)
Message-ID: <1a3b5b8507179a68c9db951d715d7c5622611ff1.camel@redhat.com>
Subject: Re: [PATCH v3 2/4] scsi: st: Record the tape position after a
 successful MTLOAD
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Date: Tue, 29 Sep 2026 14:16:21 -0400
In-Reply-To: <20260929174142.172051F000FF@smtp.kernel.org>
References: <20260929171813.844733-1-loberman@redhat.com>
	 <20260929171813.844733-3-loberman@redhat.com>
	 <20260929174142.172051F000FF@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-29 at 17:41 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> - [High] scsi: st: data corruption via rogue filemarks after MTLOAD
> --
>=20
> commit fa623b9485fe23a48925ee926b259a954fdd216e
> Author: Laurence Oberman <loberman@redhat.com>
>=20
> scsi: st: Record the tape position after a successful MTLOAD
>=20
> This commit records the tape partition, position, and EOF state after
> a
> successful MTLOAD, similar to how check_tape() does for a new
> session.
> This fixes an issue where the driver would incorrectly report
> file/block
> as -1 because drives didn't report a new-medium unit attention when
> already loaded.
>=20
> > diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> > index 0a4263bef9cbb..e5b2e2d4872d3 100644
> > --- a/drivers/scsi/st.c
> > +++ b/drivers/scsi/st.c
> > @@ -2686,6 +2686,22 @@ static int do_load_unload(struct scsi_tape
> > *STp, struct file *filp, int load_cod
> > =C2=A0		else {
> > =C2=A0			STp->rew_at_close =3D STp->autorew_dev;
> > =C2=A0			retval =3D check_tape(STp, filp);
> > +			/*
> > +			 * LOAD leaves the medium at the beginning
> > of partition
> > +			 * 0.=C2=A0 check_tape() records that only for
> > a new session;
> > +			 * without a new-medium unit attention
> > (the medium was
> > +			 * already loaded) the partition, position
> > and EOF state
> > +			 * would be left as before the load.=C2=A0 Set
> > them as a new
> > +			 * session and MTREW do.
> > +			 */
> > +			if (retval =3D=3D CHKRES_READY) {
> > +				STp->partition =3D STp-
> > >new_partition =3D 0;
> > +				STps =3D &(STp->ps[0]);
> > +				STps->drv_file =3D STps->drv_block =3D
> > 0;
> > +				STps->eof =3D ST_NOEOF;
> > +				STps->at_sm =3D 0;
> > +				STps->last_block_valid =3D 0;
>=20
> [Severity: High]
> Does this code risk data corruption by omitting a reset of the rw
> state?
>=20
> If a user writes data to partition 0 (setting ps[0].rw =3D ST_WRITING),
> issues
> MTSETPART 1, and then switches to partition 1, ps[0].rw remains
> ST_WRITING.
>=20
> If the user then issues MTLOAD, the ioctl clears the rw state for the
> current
> partition (ps[1]), but do_load_unload() then forces STp->partition =3D
> 0 without
> clearing ps[0].rw.
>=20
> Upon closing the device, st_flush() would see ps[0].rw =3D=3D ST_WRITING
> and
> unconditionally execute WRITE_FILEMARKS at the beginning of the tape
> (BOT),
> overwriting and destroying previously recorded data.
>=20
> Should STps->rw =3D ST_IDLE; be added to this block to prevent rogue
> filemark
> writes at BOT?
>=20
> > +			}
> > =C2=A0			if (retval > 0)
> > =C2=A0				retval =3D 0;
> > =C2=A0		}


Thanks, this will need to be fixed.

Correct, thanks. After MTSETPART, the previous partition's rw state is
not reset, and with v3 st moves to partition 0 after the load, so a
stale ST_WRITING there makes st_flush() write a filemark at BOT. v4
will reset the state of all partitions after the load, as check_tape()
does for a new session.=20

Please wait for V4 to fix both Sashiko reviews

