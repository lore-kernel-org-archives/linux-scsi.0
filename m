Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5D61F4631
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 17:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790703931; cv=none; b=Aq8SPcVqWFTAE8dUXJraKBdsesUYwoGJigHys4DGpL7VcoG1d0n3Uuhc1h5O+0QMbIb+jusjWhQ+/o7kbwL8Cj0ZlHgtHYH8LtaK5xZgJeeXhqljaupcWTmhLe2aq2FnmgJeqHSoO08RJjMM8DwmjNqQaXI/WmPXgjc7nv8naJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790703931; c=relaxed/simple;
	bh=m8GNpK5JV9kE4mB/foZwXcAVTeg2QKwXuAhaxveK0rA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cKbB7kuz77K57wcNnWxkKliagkxEH1aj8gwXwueIjTw3kLb3oov28JmdTiTQYed01H+ebOz1hzW2EQ3MCkMCQKTQGH+66Byf4+qaaSIUc2GVZJ96bG8FCU5ICwS3hOtjUwR5It8LXMFlpaVYl6h0yKXPuAV+oVTZVdbzwO1jJEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X1Qs83HK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mIM6rPN/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X1Qs83HK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mIM6rPN/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790703928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p+/ZhVDWLPZxvmMp9jtbl9VESILtaLIBrhjShuwTPLg=;
	b=X1Qs83HKdN9dXLdNtuZRJxtkXa2Gdy6HDdWy5F8HmabOxY6lo+Okfz+F356Z9YThStLE6s
	pk4OgP3qxogLBmLFrAPu6RJtzlZzgdeWRnS9NX0pS0HjdVrt9BGcfpLtFuNp/RUz4+xlLf
	gs+Hi9p5q4q2dy8FvKCCuMmD+G6NFvo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-CW_mBx_PMkCzKDKEkK58_Q-1; Tue, 29 Sep 2026 13:45:23 -0400
X-MC-Unique: CW_mBx_PMkCzKDKEkK58_Q-1
X-Mimecast-MFC-AGG-ID: CW_mBx_PMkCzKDKEkK58_Q_1790703922
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-53323d5b9ffso61461001cf.2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 10:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790703922; x=1791308722; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=p+/ZhVDWLPZxvmMp9jtbl9VESILtaLIBrhjShuwTPLg=;
        b=mIM6rPN/vbTTGxumwVIpBOSM3u/IW+bGx5H5pVv8ApoxshHH+u6c782e72HuUgKKTL
         OzJOBRWwqUKHwnKm94jWytfKCCamXaWpqhM3iBW4S5vaH5h0Hs+e0YtnUfX1NlsrBA7+
         eFTtPJ5OvNDJe/d8eyUG9DwZhp9CK9jV9hD2kUy2AI43Ubh+i0kVIy4Ly8hAmU8XegzB
         mrlG3kmtghCSmUwHbmSAgGLEkRlagE/GPcb6N/e8raWc9ubkyMINKw7PpF/yn4A8O5Cm
         exZv6zwLl5Gkec/akqrPDRKzkyVdYSnZ3c4tJP/1Mw9XOF+UySEKzIKDsoJLjhb9i1aK
         l6oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790703922; x=1791308722;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p+/ZhVDWLPZxvmMp9jtbl9VESILtaLIBrhjShuwTPLg=;
        b=2xn/Q+g7Wd2DE2g9PW8JXiUXx5OTPAyHedz7mxlmutEb4CeGCdeYqos2tC3XCp8Y2K
         06HdeRe2BPrGG6MdL6q4KGG8z4CDRSSwoUu8rM6JCHTANjqRhGjxdd1qysFwuRKBGUJQ
         kiSvky/utNnfcL8kpjeNWk7ciUFSghMkaTxBNDxfWCIRq/iOqh5NEaS1z7icad64Dirz
         pTSgTTRCtkczlSuz7K9cfFfET0YrlXfji4GJFREZp9N8WJB9wbV0uCwbN0XMyuBZNVVZ
         Pts3mOZb9T/UG9S097+HQWoHvvk5WYXZ4MDmXjmKJsQAyM5ZWXI74XOhkTtOPnRDPXMm
         xNNw==
X-Gm-Message-State: AFuF++ltJo+a4ngDvivsuH7hau7RFY69Yht3ZsU6ZWaFs+UtxQ8v35Yu
	BtrOjvMv6nLcKmo1eK4StM85tcosp/qFrPQLcAwT1w4MlmELf1aQsNi615GEdBKGE5o6is6SAmB
	LuWM66Seae3advbq+P+giJZHcYu7J+qo4o8Kc3gbUdV7th/y42IKwbmC7QYOVzMY=
X-Gm-Gg: AYBFou34ufcBk9+OIBgmeRx+0pFwLOZWaM+JGtegmq3MPREPHOjtSp4qM8/AAIZrwem
	8jCz/wSn+032sG2Cljnbv08wp/EDuYOH9i14nBNrN41PnpxWEb4h9kPHRC5DizBta8HVbSEl3nY
	rwDfwoxKDfktrXepf22Kp6nH/IhkIr7R9j5+3te/9Gmtlhmw4YnkLbn+D3QmVHVAT1DvqqXVzty
	27b+VNMP5uLpgdSiIpUxdiUC9CM74PnC+ck43f1/uMd2UGZn5RSrk5MCqMVTv/w78gQNFxHBM/s
	EzBFv0AcVZ8vel5kQmSCQMKImZjJchIgPB5bShLSa5pmuamtQA+uw3IuW7vQiXQaBQUQhuRHx98
	G5y17Ez4Iw1wALiFw3LBG3/ru9BWnB7IVWXmv
X-Received: by 2002:a05:620a:40cf:b0:936:77d7:55a4 with SMTP id af79cd13be357-93c9fb42879mr42479685a.19.1790703922294;
        Tue, 29 Sep 2026 10:45:22 -0700 (PDT)
X-Received: by 2002:a05:620a:40cf:b0:936:77d7:55a4 with SMTP id af79cd13be357-93c9fb42879mr42473785a.19.1790703921777;
        Tue, 29 Sep 2026 10:45:21 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c9f2e00d1sm25614685a.6.2026.09.29.10.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 10:45:20 -0700 (PDT)
Message-ID: <9a9da14629887529cbdc7efbe5809f19ed140d23.camel@redhat.com>
Subject: Re: [PATCH v3 1/4] scsi: st: Restore changed drive settings after
 reset also for MTLOAD and MTRETEN
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Date: Tue, 29 Sep 2026 13:45:19 -0400
In-Reply-To: <20260929173335.0562F1F000FF@smtp.kernel.org>
References: <20260929171813.844733-1-loberman@redhat.com>
	 <20260929171813.844733-2-loberman@redhat.com>
	 <20260929173335.0562F1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-29 at 17:33 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> - [High] scsi: st: MTLOAD in immediate mode attempts premature
> settings restore
> --
>=20
> commit 17d984b3de3a58216a78afa696892ddd4aea0bbd
> Author: Laurence Oberman <loberman@redhat.com>
>=20
> scsi: st: Restore changed drive settings after reset also for MTLOAD
> and MTRETEN
>=20
> A device reset returns the drive's density and block size to their
> defaults.
> This patch attempts to re-apply values changed by the user when
> recovering
> with MTLOAD or MTRETEN.
>=20
> > diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> > index f1c3c49466379..0a4263bef9cbb 100644
> > --- a/drivers/scsi/st.c
> > +++ b/drivers/scsi/st.c
> [ ... ]
> > @@ -3819,6 +3848,9 @@ static long st_ioctl(struct file *file,
> > unsigned int cmd_in, unsigned long arg)
> > =C2=A0
> > =C2=A0		if (mtc.mt_op =3D=3D MTLOAD) {
> > =C2=A0			retval =3D do_load_unload(STp, file, max(1,
> > mtc.mt_count));
> > +			if (!retval)
> > +				st_restore_changed_settings(STp,
> > restore_density,
> > +							=C2=A0=C2=A0=C2=A0
> > restore_blksize);
>=20
> [Severity: High]
> Does this code attempt a premature settings restore if MTLOAD is
> called
> in immediate mode?
>=20
> If a user application issues MTLOAD with O_NONBLOCK and STp-
> >immediate
> set to recover after a drive reset, do_load_unload() will issue the
> load
> command and return immediately. This unconditional call to
> st_restore_changed_settings() would then cause MODE SELECT commands
> to
> fail because the drive is still asynchronously loading.
>=20
> Later, when the drive is accessed, check_tape() detects the new
> session
> and clears the changed flags, causing the drive to silently revert to
> its default density and block size. Subsequent writes might then
> produce
> incorrectly formatted tapes without errors.
>=20
> For MTRETEN, this patch correctly checks for !STp->immediate before
> restoring
> the settings:
>=20
> > =C2=A0			goto out;
> > =C2=A0		}
> [ ... ]
> > @@ -3837,6 +3869,19 @@ static long st_ioctl(struct file *file,
> > unsigned int cmd_in, unsigned long arg)
> > =C2=A0			retval =3D st_compression(STp, (mtc.mt_count
> > & 1));
> > =C2=A0		else
> > =C2=A0			retval =3D st_int_ioctl(STp, mtc.mt_op,
> > mtc.mt_count);
> > +		if (!retval && mtc.mt_op =3D=3D MTRETEN && !STp-
> > >immediate &&
> > +		=C2=A0=C2=A0=C2=A0 (restore_density >=3D 0 || restore_blksize >=3D
> > 0)) {
>=20
> Should MTLOAD also verify !STp->immediate before calling
> st_restore_changed_settings() in st_ioctl()? Note that follow-up
> patches
> in this series do not correct this omission.
>=20
>=20
Hello Sashiko,=20

This only affects MTLOAD in immediate mode with an O_NONBLOCK open;
with a blocking open check_tape() waits for the drive and the restore
works. In the non-blocking case the MODE SELECTs fail and the settings
stay at the drive defaults, which is the current behaviour without the
patch, so it is not a regression. I can add a "STp->ready =3D=3D ST_READY"
check before the restore in a follow-up and leave v3 as is.

Thanks
Laurence

