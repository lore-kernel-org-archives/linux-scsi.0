Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A406131E36
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2024 14:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708007226; cv=none; b=F/kHL82u4xzFIq00cfBstvTuJh2VShNMZsIWgx1JoNaQqx4NcIFib8bswaqkvpF+EMAvjvMjoXAqKDRcqqILyLVdDTfGCC0Bd04LoKVRnFvmLvxPqCAhna/Y/FtKhjPNLvTYMlk5MkrIMgMHcZJSNG7gEyU0ujB5XrOXgxHT2Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708007226; c=relaxed/simple;
	bh=/g4FW+oOB2iM4sSCm8qD7M5cPpwCh46wj+X4ppBYkxk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u2mbX4+qJ7rs0/JQf7KoGGMtzDeaEKjFOqmweZ3c6Cx+Om1pB1BlTtlquXBFk/QGgRs3Mgr+Z0KOuDltvfjqVWmQ1VS+IQ8iT5kNMPSrYNgr6Q1w/IZfofjALOEak0PyqAknaSz5P/sefNQNAzJwumB5gsCKkU7Uq75cI5E8i0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G8Qm2Yma; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G8Qm2Yma"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708007224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B9l5693qZWmB6x7VJfHJZ5mWmBqz6tLrM/ue4SOzjDo=;
	b=G8Qm2YmaCypTlhMdREwqgZ1FY57wEUwO/aNn0E5AMlwCgjfyCa7aTfn30Xq8bwc1BMMtW1
	pWfFomPMdD6DQB39rMvUYMVtbk2gxwpQ4NMVdM8Nx/5NVrZCda4Qm99/BfGTmywaMhwkey
	/JaEkMxvWa1tGfKDsBga5Pb+nFrxIA0=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-MS-dM_onMWiLBjUk0QZgPg-1; Thu, 15 Feb 2024 09:27:02 -0500
X-MC-Unique: MS-dM_onMWiLBjUk0QZgPg-1
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-4c03b3135e0so502060e0c.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2024 06:27:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708007222; x=1708612022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B9l5693qZWmB6x7VJfHJZ5mWmBqz6tLrM/ue4SOzjDo=;
        b=bTPC8cjc9266rrkNwxFqJGGLuZhAFIo/gwW8VKGGtKk3cQfmlZmjvaHwbGmt3Agj20
         YcVTryHRCHBpsGuv/Hx6l8GCkI+Ii9mK/4gdkrjqmdK3afJ3Fin54krM018GJhAu2Tqp
         h4r8kVxvT/HvmB/RILCIswnGzDDugj1poNPWATjsygd3y/VOdL4K0zhSyENiftgwkC00
         /hqpiln+dzg+8E5qDRRTGXOHFUFY4MsJ+Qxc5Zjx16W4sspRjCdJduo1Sjy30drhtoJG
         fvFDaIXt8wpvwa6TOpgeQY6o5oGxrugzANut9FJAwuX58jGXT4nh/oEQePiYfADX5kpA
         mXJA==
X-Forwarded-Encrypted: i=1; AJvYcCXdUdfO2nFIjo6mskLyh+e3V/rqkuVcwAPzZGTs30LRn+y5iInZzhSByLHyNc5zv1CIZtIKGTRgrDkfJqaJBXkDe/utNwZsIBGkqA==
X-Gm-Message-State: AOJu0YwqFg9XdS0sCFiwH50sxTfSqUnP3eoLFQAph3KvGDZhS6Q8PCO0
	DCXyZjKGm1vBa1RfGVJSoygX6UhFG1h0bzMSylEuHuk0QeKUemXalBgISiYfItxU5s/0XhlXpgl
	bhUNFjhqV9cQjdRYonDKl2KKSmNqhKXqW1O9tkE2E4ykKucCjs9kCkgROyYImut6nfPgfIhdUfx
	vduWdfaxJKg0MaqmqysY8wK+ilFz1TGqrpCg==
X-Received: by 2002:a1f:4b07:0:b0:4c0:2182:3cdc with SMTP id y7-20020a1f4b07000000b004c021823cdcmr1615184vka.1.1708007222276;
        Thu, 15 Feb 2024 06:27:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEPFdBPCt99dDFRIQMoqNgRwaiNJM8ZLESLcoslRShOrYtgNrryhRX4ESvuKuh/AVEQ3451CDAWOUwJTOWEPPo=
X-Received: by 2002:a1f:4b07:0:b0:4c0:2182:3cdc with SMTP id
 y7-20020a1f4b07000000b004c021823cdcmr1615175vka.1.1708007222049; Thu, 15 Feb
 2024 06:27:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215103508.839426-1-mlombard@redhat.com> <20240215103508.839426-2-mlombard@redhat.com>
In-Reply-To: <20240215103508.839426-2-mlombard@redhat.com>
From: Maurizio Lombardi <mlombard@redhat.com>
Date: Thu, 15 Feb 2024 15:26:50 +0100
Message-ID: <CAFL455mB7Ni4VW2crjWUBqb=3BYYKjG3YrNJpsaL8T0Lz+HM9g@mail.gmail.com>
Subject: Re: [PATCH 1/1] target: fix selinux error when systemd-modules loads
 the target module
To: michael.christie@oracle.com
Cc: d.bogdanov@yadro.com, target-devel@vger.kernel.org, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	james.bottomley@hansenpartnership.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=C4=8Dt 15. 2. 2024 v 11:43 odes=C3=ADlatel Maurizio Lombardi
<mlombard@redhat.com> napsal:
> +       /* We use the kernel credentials to access the target directory *=
/
> +       kern_cred =3D prepare_kernel_cred(&init_task);
> +       if (!kern_cred) {
> +               ret =3D -ENOMEM;
> +               goto out;
> +       }
> +       old_cred =3D override_creds(kern_cred);
>         target_init_dbroot();
> +       revert_creds(old_cred);
> +       put_cred(kern_cred);
>
>

I've noticed there is a leak in the error path, I am sending a v2

Maurizio

