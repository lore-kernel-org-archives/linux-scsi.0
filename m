Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794247167;
	b=vln/R8jrt8RqSxVf0Zf8q6hP16egVD6a5dxh4QD68aCnH8y55D/HDYuA0DcXJUERJcpx
	 ywp10oncmHYcmwjyBTS63f3ZlX2uX+p7wBpS0SihFhF/rEsxwu5Np5gSemhsoErVNYlb8
	 4O/dkvkfO8sTkZN/S0W6TDSu3LNhMphZ1AXDYrJONazCWWXzjxu62/GuM/v9OQothmv4M
	 f+KrRiqyxrMYA3WSsoJnbt9SBAEu9u0r1HyCZKBj1la0Cmjr6J+q8fWsAr9OMHrkrGpW+
	 ULwCndmmr4lKCgW0GqF2wvwjijShC+ncji091ZE0KTR2Efjqu6WTC8bSaSsYx9shzvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794247167;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=5dqNClxJY2X/ydhuoqmWfWtFVn8+jew8N2sUbCuLKyM=;
	b=CHiA7UuYaSP3rlBB5o2368fPdC31MTSHYRAbojr3eAQYb6t2JCHn6gFHlVT495fLGlOr
	 y88jLlIv6kb33EiXfXE+uGtCkT1CK/Xp5fu1eO142I2mk5KOSsHtIH0PMoupZ+Ur9j7vf
	 ObB3jBeZjGCq5kAWSgGFTKzpcTSQjedT3kWnsxEqVYL4owX6b1CSqfPnU6mdAtpjQojts
	 OOx1p0Q8g8VI6w1V7ceKNWjkd/MCy3ajWG8dY1wW+4A+YQwg6aot9qye6fY4ABkP9d0SQ
	 HGrmXk+ZcKRv/iHA2SL8mmD6i+zWojKrsv9SU4c5ZXY8lDLdr2HQ/NBTMRmFjoYYc3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HAoTm5oP;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=M28fVnkQ;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0F6606A326
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 17:59:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF0F6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HAoTm5oP;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=M28fVnkQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794247165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5dqNClxJY2X/ydhuoqmWfWtFVn8+jew8N2sUbCuLKyM=;
	b=HAoTm5oPw/njpG0+kDsy7rhsGLw+Km98sjG1UsmW2hi4qyLHoD9BYL0oj4pE30COdLosQf
	K3Igs5U16/RsRZTyi8PoqGMvKI6uTcklJoclIUxMqO8CAXDxcqZ/JMk58P+HCf05XofDs/
	pf17jmGUWCv7MOUhMWGUpPqSq04z4Dk=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-k9CJE2TEPzWbQI0aqddmcg-1; Mon, 09 Nov 2026 12:59:24 -0500
X-MC-Unique: k9CJE2TEPzWbQI0aqddmcg-1
X-Mimecast-MFC-AGG-ID: k9CJE2TEPzWbQI0aqddmcg_1794247164
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5351f1b26e6so18723251cf.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 09:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794247164; x=1794851964; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5dqNClxJY2X/ydhuoqmWfWtFVn8+jew8N2sUbCuLKyM=;
        b=M28fVnkQl3GwR5BKgo2Obry2k8F49tDasgUl27g0x352ZUIlkAfp6J9G8ZiV/iPChX
         fIhIhxbE+S9Ug1onDYbPPz/bv4ujUwIrbEYVmVFB+P0FRLVVgtdMIgWBwe2zSrXd9Lfw
         v0XkthfEW3BUCHHp4VGHuliARRZoqMjjy4hmZtmNbh2Qr83lioZLDxJdhmUw1atqSQC/
         15X5icSeq/5Q6yS4tjZgntaNdAsMObl449Jrpee3fYiFARvJNHOPZak2ny+JWfIFSi1F
         dSuKY4q5j6c7WQsQJsesLQdtLuIO+dFp0PHYWWspW02aD2fhp6XcgVL1l6vI973vlIVV
         6iBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794247164; x=1794851964;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5dqNClxJY2X/ydhuoqmWfWtFVn8+jew8N2sUbCuLKyM=;
        b=bTOOzW9JnrVGS3cXrkykjDWpbP4Z9rUqbkuZgHb3GbnMrGXShsfAFsRN99MxCwNrJV
         Djh3/lhLlpqyHjh3bVkdGOA3mo/uYs+0p37PEefZVYect5vdG8iboqY5QkBFHd+PAw18
         bSOdgdPEoOSC2drYiARsZNC9vhCJ+Vu0wtvpr6yxfeemHNOgXvkCO3skmKMiB4QBIRAa
         stMpxd+7dxc17RMnQeel5BpTqCXp7szBMtm6dRNOquJx4plbtEo7YQR7fjG5vExFZyLu
         nJML0+37b02mdO6QkO6NucESw+qS5OVpaq38Rtd+v3/Uk0XvN1ZdbnDMPBrvwGijYRla
         6d9A==
X-Forwarded-Encrypted: i=1; AL+hErG5fX3kt/r5NXCijluLBwWC0pBwD6MgGUHBRLUra1AiYwGLj6jvX4CdJRKjOOBH1ZCqM5Ka9F/UObCR@vger.kernel.org
X-Gm-Message-State: APuU4Z91zf8GESOJ4sAcqZjTv7IN8hfmkdVhH9PmD2k+v8OAIfXTfq/o
	kk311grJDmPO1JU3F45N6BrVn9FisKbO66KPaL9zp2DVtBEWXu8zdgq9xE6w6PieV70cXajpFaO
	2B2miyqOJkYAunI5CP0Bsfs24RWbGQQ0zZaC54JCrzHSGQz67HefOnZqP4aeYbk4=
X-Gm-Gg: AYBFou2K0eJapW1XpqYb3RLBx0GTFW4M7Cg4ygZGV4rhTG5DScFnZJHc/F7ONNGnrKI
	5x0d7sr76l8X5EWSLybMpIsF17TsYGIM4oDaFpuQrj18yQyjKi/Pel3DyLkJf5nUxFSPKeQU740
	gl2hwFH8+2QR04tzdfhYff2dUIuBvtK/wq3wDnU1VMLa47LS2QXyWWb1cs7UVZPav8sYEi+H/V1
	d8JX9sbPXmcVp4mg+H1ZD1FtauCxpSeTTFvSdfPqiVfsf/gfhOvvIkXI224AqnlLIeSVuVTI2YQ
	YMUVe2y12gQMhR5tnwXFTsNkRiJNuDurKnuIMWN+G/fcFqBKCkoEjoyfMm+YtOcQVEMzH42DtjY
	cp1WXUyzXTpCeOZMPbuK6PZM+V5e/JiASl6daT0cVsq2NPOQnTWgGvnpybzbUZM2pTyD15JNpf6
	RWMrR9q2lYVT+zherO1q4jW9XfFCy0ZYz6zskewrWYEow66VG/3dVPmPU1OyjCojzs3A3Qnbk=
X-Received: by 2002:ac8:598d:0:b0:535:2763:16a2 with SMTP id d75a77b69052e-555294b79e2mr804921cf.43.1794247163856;
        Mon, 09 Nov 2026 09:59:23 -0800 (PST)
X-Received: by 2002:ac8:598d:0:b0:535:2763:16a2 with SMTP id d75a77b69052e-555294b79e2mr804571cf.43.1794247163360;
        Mon, 09 Nov 2026 09:59:23 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550af5f09fsm2892451cf.6.2026.11.09.09.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 09:59:21 -0800 (PST)
Message-ID: <23fa65c5e6296ddae57135658f7b24942f1ee534.camel@redhat.com>
Subject: Re: [PATCH] scsi: ch: Remove the minor from ch_index_idr after
 device_destroy()
From: Laurence Oberman <loberman@redhat.com>
To: Changyul Lee <lcy8047@gmail.com>, "James E . J . Bottomley"	
 <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
 <mkp@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>, linux-scsi@vger.kernel.org,
 	linux-kernel@vger.kernel.org
Date: Mon, 09 Nov 2026 12:59:20 -0500
In-Reply-To: <20261109160651.986356-1-lcy8047@gmail.com>
References: <20261109160651.986356-1-lcy8047@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-11-09 at 11:06 -0500, Changyul Lee wrote:
> ch_remove() removes the minor from ch_index_idr before
> device_destroy()
> removes the "sch<N>" device. A changer probed in between can get the
> same minor, and its device_create() fails:
>=20
> =C2=A0 sysfs: cannot create duplicate filename '/class/scsi_changer/sch0'
> =C2=A0 ...
> =C2=A0 ch 1:0:0:0: ch0: device_create failed
>=20
> The new changer is then not attached.
>=20
> Replace the IDR entry with NULL instead, so that ch_open() still
> fails
> with -ENXIO for the changer being removed, and remove the minor after
> device_destroy().
>=20
> Fixes: da707c54c342 ("[SCSI] ch: fix device minor number management
> bug")
> Signed-off-by: Changyul Lee <lcy8047@gmail.com>
> ---
> Reproduced in QEMU (x86_64) with scsi_debug (ptype=3D8, add_host=3D2),
> which gives two changers on two hosts. Two threads, one per host,
> delete the changer through sysfs and rescan the host in a loop for 20
> seconds. Without this patch, device_create() failed 992 to 1151 times
> per run in three runs. With it, it never failed in two runs, and
> /dev/sch0 can still be opened before and after a delete and rescan.
>=20
> =C2=A0drivers/scsi/ch.c | 6 +++++-
> =C2=A01 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
> index b2c9fb71c9e0..390425671a3a 100644
> --- a/drivers/scsi/ch.c
> +++ b/drivers/scsi/ch.c
> @@ -952,11 +952,15 @@ static void ch_remove(struct scsi_device *sd)
> =C2=A0	scsi_changer *ch =3D dev_get_drvdata(dev);
> =C2=A0
> =C2=A0	spin_lock(&ch_index_lock);
> -	idr_remove(&ch_index_idr, ch->minor);
> +	idr_replace(&ch_index_idr, NULL, ch->minor);
> =C2=A0	dev_set_drvdata(dev, NULL);
> =C2=A0	spin_unlock(&ch_index_lock);
> =C2=A0
> =C2=A0	device_destroy(&ch_sysfs_class, MKDEV(SCSI_CHANGER_MAJOR,
> ch->minor));
> +
> +	spin_lock(&ch_index_lock);
> +	idr_remove(&ch_index_idr, ch->minor);
> +	spin_unlock(&ch_index_lock);
> =C2=A0	scsi_device_put(ch->device);
> =C2=A0	kref_put(&ch->ref, ch_destroy);
> =C2=A0}
>=20
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4

Looks good to me:
Reviewed-by: Laurence Oberman <loberman@redhat.com>

