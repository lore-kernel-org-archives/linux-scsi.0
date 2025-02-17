Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5366122A4CF;
	Mon, 17 Feb 2025 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739815067; cv=none; b=GI/GjNkY0YxK8bTTryel/CBWNvxbs9OXxipcpF2WgP9/xqDnOk29grBvyyNxg4zRrDdJBjGhkBtgrhk+IfnuJM+LAJUQrh/7uVhqfmUfFIUgvQafxfVNooaHAN7lwrHoTFuDGPGzSQUnaLoBwnFD2mrrJax+bk2ateUWQMjlqzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739815067; c=relaxed/simple;
	bh=BishsF5BsUZJfTkqHEunUzQ8ATvlt20PXXSDxxzD3DY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YuD5PqVU/36I+SVf5pq+XScWj2oBVvUGmlxO1hLKzUHfEYNDdQAttj1rNWF5mEh6FfkJ1CkTegr5oGVetS9gW92RiqXXynMttiezhoagnCasVF4ux75el22/cGbXdJ2n+kTxmU5uiUpvuYwhxb972/+j5IW9XyNO64j7oiWn34A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nt0mEqSC; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nt0mEqSC"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43964e79314so41895305e9.3;
        Mon, 17 Feb 2025 09:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739815064; x=1740419864; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BishsF5BsUZJfTkqHEunUzQ8ATvlt20PXXSDxxzD3DY=;
        b=Nt0mEqSCYX17a+sd0sTZSN61Mx+BQ54dfDOFpxjz9usjN0iEU/AmclskTTUdYtbe4s
         mrsIxzNRvZz5k1QBfNmYxfOXOqcQp0n4oUi+XCdYD7X0X6eiZIABt787u+G99RyjuFpX
         kmGlq+naTXxQgwNRDwtOeaVaDWgpOt11atldmsdA83dXnGEE3gvH53JmRtmBV9DAR3dh
         xmwinjHrflDqbITEMAAZUgDrzoV39V5IejKwacnsAgvRdMXyd4iUz4pJqEdeSA4zNxnR
         caYBk5CCvwXlyAkIu/+CYqrC34c3a8jyDCQNQCM92ArybSBZUr2nDm3fSyzqd1hkRjXS
         GHnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739815064; x=1740419864;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BishsF5BsUZJfTkqHEunUzQ8ATvlt20PXXSDxxzD3DY=;
        b=ZBot+3D2ipzVIonGVaZ+SHqYbMg0A/gmHgP1qabqM3DEDOzecw3K46z23D6TdBr//Q
         J9sVLSkHlXxMKL8gYA+SnAJkyXhUEurvoP5GEj/P/98sOKDjBlp6ejNhd3AunNnvFhqk
         Of+NbxK1nwj860BQ7wK9DSrMOUn8k/cI1Rv9BRIoV3XPdjl0QQON4+LW27KJ/Wz4bvBc
         KW1YgJWTaQx2JXJNUK3T3zdWYbuGtLaOycHx+nKnipVCEhLG5RNRhUisGpxso2H/fOr4
         e/eiOJvy/mVQ5lsvBLNfK2S8U9qVYQ69UpgeY/8zs7wAuetc6O8P9Q11rFUTbrfSVgUU
         5cKg==
X-Forwarded-Encrypted: i=1; AJvYcCUxKjII2Sj3dk6x2AwYLGeIMpPaQj4IL+NAuiLEMheN1u57FAQtzafpVwl1C2TZRGiGrO3ReJOWQCBaSg==@vger.kernel.org, AJvYcCVyVqeUzRNZssHvoXg8Oj1/GNSTMCsrC4kVv+B6MoVm44lMZH0LzJDYLyhUpVX206ONQqK72Wa+Kp2ceUo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1lIHV32ZRejEZHK5BdqdpRXd1uLsEL7RDn/Ga3vYHWFkf0Dwo
	7KHUS0Ua5Yo8m4LdH0sUGdq1o1AIherhh87XeG9voF5vpiDak4Z87SEFIzkk2zw=
X-Gm-Gg: ASbGncvkLIdBNElzCqjn/TGrB+DTW84axB/etvgphKRpTWL9vh5wC6RvCu9Kt2FgtC2
	cxNMW9IF6B+MWyZUxKuIbtiU8l3a1H10DaVrQhujnVhWPMV4AgL17Bj4MlEUvNAI4YYZvYK/6N5
	c1KwVrh0cONeOpfG6U7p7TGJfnbFKl3LcNbVWtfIvwtJ6q+vtYNp2NqAQT4IQQZODdpWlaGL4jn
	oPKS4M0wxT9JMiPcl2WG91H8DhZVu25GK1/OVUUQTJS+4d98ijDzkoZZnP3QABGfILjZlTQjfIp
	2pWh7BYfjYhCrW/SXw==
X-Google-Smtp-Source: AGHT+IHkf7qxSWRjn3ZuexWv6uPWOwV8EF/JpQ5P/8SUC64HisS4WFLUsaTrZSCZNVxe5DRUCwq1nw==
X-Received: by 2002:a05:600c:19c9:b0:436:f960:3428 with SMTP id 5b1f17b1804b1-4396e75e27bmr101166075e9.29.1739815063299;
        Mon, 17 Feb 2025 09:57:43 -0800 (PST)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06da56sm159576265e9.23.2025.02.17.09.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 09:57:42 -0800 (PST)
Message-ID: <f36a311db0b37d8dbed42875a1b42d30ffb8df28.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix memory crash in case arpmb command
 failed
From: Bean Huo <huobean@gmail.com>
To: Arthur Simchaev <arthur.simchaev@sandisk.com>, martin.petersen@oracle.com
Cc: avri.altman@sandisk.com, Avi.Shchislowski@sandisk.com,
 beanhuo@micron.com,  linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, bvanassche@acm.org
Date: Mon, 17 Feb 2025 18:57:41 +0100
In-Reply-To: <20250217164330.245612-1-arthur.simchaev@sandisk.com>
References: <20250217164330.245612-1-arthur.simchaev@sandisk.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-02-17 at 18:43 +0200, Arthur Simchaev wrote:
> In case the device doesn't support arpmb, the kernel get memory crash
> due to copy user data in bsg_transport_sg_io_fn level. So in case
> ufshcd_send_bsg_uic_cmd returned error, do not change the job's
> reply_len.
>=20
> Memory crash backtrace:
> 3,1290,531166405,-;ufshcd 0000:00:12.5: ARPMB OP failed: error code -
> 22
>=20
> 4,1308,531166555,-;Call Trace:
>=20
> 4,1309,531166559,-; <TASK>
>=20
> 4,1310,531166565,-; ? show_regs+0x6d/0x80
>=20
> 4,1311,531166575,-; ? die+0x37/0xa0
>=20
> 4,1312,531166583,-; ? do_trap+0xd4/0xf0
>=20
> 4,1313,531166593,-; ? do_error_trap+0x71/0xb0
>=20
> 4,1314,531166601,-; ? usercopy_abort+0x6c/0x80
>=20
> 4,1315,531166610,-; ? exc_invalid_op+0x52/0x80
>=20
> 4,1316,531166622,-; ? usercopy_abort+0x6c/0x80
>=20
> 4,1317,531166630,-; ? asm_exc_invalid_op+0x1b/0x20
>=20
> 4,1318,531166643,-; ? usercopy_abort+0x6c/0x80
>=20
> 4,1319,531166652,-; __check_heap_object+0xe3/0x120
>=20
> 4,1320,531166661,-; check_heap_object+0x185/0x1d0
>=20
> 4,1321,531166670,-; __check_object_size.part.0+0x72/0x150
>=20
> 4,1322,531166679,-; __check_object_size+0x23/0x30
>=20
> 4,1323,531166688,-; bsg_transport_sg_io_fn+0x314/0x3b0
>=20
> Signed-off-by: Arthur Simchaev <arthur.simchaev@sandisk.com>
> ---
> =C2=A0drivers/ufs/core/ufs_bsg.c | 6 ++++--
> =C2=A01 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
> index 8d4ad0a3f2cf..a8ed9bc6e4f1 100644
> --- a/drivers/ufs/core/ufs_bsg.c
> +++ b/drivers/ufs/core/ufs_bsg.c
> @@ -194,10 +194,12 @@ static int ufs_bsg_request(struct bsg_job *job)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_rpm_put_sync(hba);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(buff);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bsg_reply->result =3D ret=
;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0job->reply_len =3D !rpmb ? siz=
eof(struct ufs_bsg_reply) :
> sizeof(struct ufs_rpmb_reply);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* complete the job here =
only if no error */
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret =3D=3D 0)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret =3D=3D 0) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0job->reply_len =3D !rpmb ? sizeof(struct ufs_bsg_reply)
> :
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 sizeof(struct
> ufs_rpmb_reply);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0bsg_job_done(job, ret, bsg_reply-
> >reply_payload_rcv_len);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return ret;
> =C2=A0}


Arthur,=20

The change appears logical because we only need to copy the payload
when the operation is successful.=C2=A0

However, I don't fully understand how the memory crash could occur. If
the function in question is `ufshcd_send_bsg_uic_cmd`, it wouldn't
involve RPMB access, meaning `rpmb` would be `false`. In that case, the
size used would be `sizeof(struct ufs_bsg_reply)`, which has no
connection to the advanced RPMB functionality.=20

Kind regards,
Bean
