Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9F95349B9
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 17:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790702291; cv=none; b=Fl3KwkNknmxOt/g1MVfQBbasYpre3q2eZcQrnI+Xh1gzKu3grXkDzdvxB8YDyHvOxmpRaVZJQ0wylfY2kh4ZBcrIJ/pcqJRFjOYmdaBXymvOsWEKApxXuoeF5mxRK4SA96d2ssz+lYFXzDdLTwwTN1hJII0r00sBW8uK/FlvjGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790702291; c=relaxed/simple;
	bh=OvsILOG8Ej2YA/Fq7D+IipynWYq28vFLoMxtEUoSKyw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ceCxz8KulTbsGI9Jpat2GAdBNHY3mtiGTTMFiMci/TK809D1qdZxJhPT6wahFQWgxAeKqsVfTklI7fGifHDJUqgU8yJFbpFLOjlEBlwt8zo4G3TjixseihKoGoa1PKZ2GuKNuXTb95a6Lmg8h9hg+epZDjHH6rnJc/VKX+Z9bgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HgnZmSEk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZxhhS/t9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HgnZmSEk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZxhhS/t9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790702287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OvsILOG8Ej2YA/Fq7D+IipynWYq28vFLoMxtEUoSKyw=;
	b=HgnZmSEkfjM9xgs6ob13hbSJZPbYodlGLYbPryd52As4u4nMdCwAM9Yu0MHJSdw8R0xNPG
	8iqgs3/0fyRcf6xMdAmREUaFwQb9hT+NfqjjqMLapyf3M4bOYiFUZHtvXIskXCMnOv84iz
	uYcqcAUfj8T5k2W4Jymfff3HXfLIdzI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-C_Rwhgd4Me68IKX0zMuGEw-1; Tue, 29 Sep 2026 13:18:06 -0400
X-MC-Unique: C_Rwhgd4Me68IKX0zMuGEw-1
X-Mimecast-MFC-AGG-ID: C_Rwhgd4Me68IKX0zMuGEw_1790702286
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-53333acddb5so82774711cf.1
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 10:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790702286; x=1791307086; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=OvsILOG8Ej2YA/Fq7D+IipynWYq28vFLoMxtEUoSKyw=;
        b=ZxhhS/t91uyLFvFCUlpWrUSSGC2H44Yaw3c74ONik01oIduHxTH3rMhhJDc7p/dcOx
         rf3BCxygPf87no08yNk7z9XHTZJl6GvL5BxQfX/t24Hr8LPnk2LrpMgLdhrxInQhX7fe
         9TP0j9FixLGM9+SKOrMfVYAcq58iba1sUwRbqkKWZRk/84Dko2/SVBVf21Qi1G3hrl8+
         4J0u+EzL1WGKvAX4lD95Obvcv/gSXXCrxN3eOkR9Lmmc6exjNtJxJD1SdcP6CgUclol0
         vFqdG3ShhxOEwvapgIcDURtGLFxUt1Hzz2kQVzRCl2t/ZHqc+BVHqs4g6mqSWvAmnr7v
         wbOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790702286; x=1791307086;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OvsILOG8Ej2YA/Fq7D+IipynWYq28vFLoMxtEUoSKyw=;
        b=aglBMf+tbtFUNZQv6Ocb9WvDY8Wky+Jo+6qQwAXM0dEgQlHj+aiv0YiEMWH8fgfWFf
         rYOovebTeSpKwwnGD0dtNueczgEYWEkuWTrrGGTZ10ysuX4DWp9zDpCXCEfjFCbBTpco
         2syi8UEz7t/RjKzqutvpMBgwHZCvSLsnnib4I/ln9Bwq/QF8TNTYuSgP+oZxjL2k2v5q
         pGzC5Yc13NollsmqjwwUotNZtzaEbvx8BX9KG07xAFdhvsteSeWgnrwq0O0xCsYB8jE5
         PN30A0dUempmHFyniwv+nCu6WNiyfVab/piWNbLho8BCBmNq7RYLDr++7mibN4gJiYPy
         MgsQ==
X-Gm-Message-State: AFuF++nH5zzrqG6hGA1zeb7TBWss/9SlIiBSQV3YSdpwBQ4sSGomTuCv
	1GJO30onv3a67rB88edwJ4D/vUssdfgmUhwxN2hVQcdjc82nHqNmAAnpN/3WR2Qc1Sl/m+iBL4s
	cAB6vrSIx2pjRCTBpXoXLTqp745MAlt3zJ1c8bZ1f7v96kO5022JedsOkeIMuRdE=
X-Gm-Gg: AYBFou1i0B2heh5vS/Wx+QG5Fz0WDWE5lubwraftHZhumu4CHOpTOymhPYQIFyMSaIe
	+SYCMzD0C1m+MSLPlhnuCq+k+7Y7E772NXy7Cd/nbFZOOoIJg4QFy1I0R4gH23OUFvGNsKdVvzI
	G2m9UqQ+C5wryUGZ44EEBYf/Ktzwha4N6G9tNBytP1dPrHzhJZm0FZXvQvLdf9bEEytp7445065
	sDZYw5h2qiXNXLEOqULacmDT+rnbuwdLxDRUOHQtl0w05CUCHg2bMxebH83Bs9Nh5tmhxjPMXwZ
	JxlESqQUlRG+1p5vT1jznzJbEqnIEYHYIHu+sF7q6wfVNa5j0SVU6kXVVEAk4c08/aR+YWGs7zu
	rDBjB0jDpbdQh0xaeFx1+MFUos8OWhtQ0nCQv
X-Received: by 2002:ac8:5e10:0:b0:533:37c2:107d with SMTP id d75a77b69052e-53337c213femr167498711cf.33.1790702285548;
        Tue, 29 Sep 2026 10:18:05 -0700 (PDT)
X-Received: by 2002:ac8:5e10:0:b0:533:37c2:107d with SMTP id d75a77b69052e-53337c213femr167497791cf.33.1790702284919;
        Tue, 29 Sep 2026 10:18:04 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53369b34e5csm178321cf.12.2026.09.29.10.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 10:18:03 -0700 (PDT)
Message-ID: <d62e7b249c7b6ecea55be64a6b8165d2d4aa9956.camel@redhat.com>
Subject: Re: [PATCH v2 2/2] scsi: st: Record the tape position after a
 successful MTLOAD
From: Laurence Oberman <loberman@redhat.com>
To: "\"Kai" =?ISO-8859-1?Q?M=E4kisara?= "(Kolumbus)\""
	 <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <mkp@kernel.org>, 
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, John
 Meneghini <jmeneghi@redhat.com>, emilne@redhat.com, 	bgurney@redhat.com
Date: Tue, 29 Sep 2026 13:18:02 -0400
In-Reply-To: <DACF75C2-73E1-4906-AAAA-A0C21CC0B859@kolumbus.fi>
References: <20260928132539.56876-1-loberman@redhat.com>
	 <20260928132539.56876-3-loberman@redhat.com>
	 <DACF75C2-73E1-4906-AAAA-A0C21CC0B859@kolumbus.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-29 at 15:39 +0300, Kai M=C3=A4kisara (Kolumbus) wrote:
>=20
> > On 28. Sep 2026, at 16.25, Laurence Oberman <loberman@redhat.com>
> > wrote:
> >=20
> > Commit 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls
> > allowed
> > after device reset") allows MTLOAD to clear the reset condition
> > because
> > the tape location is known after MTLOAD.=C2=A0 But the driver does not
> > record
> > it: reset_state() sets the file and block numbers to -1, and
> > do_load_unload() leaves them there.=C2=A0 check_tape() sets them to 0
> > only for
> > a new session, which requires a new-medium unit attention.=C2=A0 Drives
> > that
> > do not report one when the medium was already loaded (seen with IBM
> > LTO
> > drives) keep reporting file/block -1 in MTIOCGET and no BOT,
> > although the
> > tape is at the beginning.
> >=20
> > Set the file and block numbers to 0 after a successful load when
> > the
> > current partition is 0, where LOAD positions the medium, and reset
> > the
> > EOF state as MTREW does; otherwise a read after loading at EOD
> > fails
> > with EIO.
> >=20
> > Fixes: 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls
> > allowed after device reset")
> > Assisted-by: Claude sashiko
> > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> > ---
> > drivers/scsi/st.c | 14 ++++++++++++++
> > 1 file changed, 14 insertions(+)
> >=20
> > diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> > index 0a4263bef9cb..f4393a8e8fb1 100644
> > --- a/drivers/scsi/st.c
> > +++ b/drivers/scsi/st.c
> > @@ -2686,6 +2686,20 @@ static int do_load_unload(struct scsi_tape
> > *STp, struct file *filp, int load_cod
> > else {
> > STp->rew_at_close =3D STp->autorew_dev;
> > retval =3D check_tape(STp, filp);
> > + /*
> > + * LOAD leaves the medium at the beginning of partition
> > + * 0.=C2=A0 check_tape() records that only for a new session;
> > + * without a new-medium unit attention (the medium was
> > + * already loaded) the position and the EOF state would
> > + * be left as before the load.=C2=A0 Set them as MTREW does.
> > + */
>=20
> Should the following be done for all values of STp->partition?
> And the code should set STp->partition =3D STp->new_partition =3D 0
> to match the LOAD behaviour. (Usually
> STp->partition =3D=3D STp-> new_partition
> and the partition would not be changed even if STp->partition
> is not correct. But if later the partition is changed to the wrong
> value,
> the change does not occur.)
>=20
> > + if (retval =3D=3D CHKRES_READY && STp->partition =3D=3D 0) {
> > + STps =3D &(STp->ps[0]);
> > + STps->drv_file =3D STps->drv_block =3D 0;
> > + STps->eof =3D ST_NOEOF;
> > + STps->at_sm =3D 0;
> > + STps->last_block_valid =3D 0;
> > + }
> > if (retval > 0)
> > retval =3D 0;
> > }
> > --=20
> > 2.55.0
> >=20
>=20
> Thanks, Kai

Thanks Kai. A LOAD leaves the medium at the beginning of partition 0,
so v3 now sets STp->partition =3D STp->new_partition =3D 0 for all
partitions, as check_tape() does for a new session. I reproduced the
problem on an IBM LTO-5 with v2 (MTLOAD while in partition 1, then
MTSETPART 1 was not performed). Fixed in v3 with your Suggested-by.

