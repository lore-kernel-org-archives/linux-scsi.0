Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793475136;
	b=NSzqC9FpnSLdL5QLPA4zy8q/1ys3Y3g7mqxSe1FA/2VawZgVHv4lJwGpswDdaoijyKXj
	 w9g/OTkJbqfDpnG7l09ZO0mzL84axOljeqcIdG1S81BWCWmlQGTZL37nL/HqSLqe+Ilf9
	 TDxPjadzfCF0kWQSJqRlytwCHCJ6DJwUHWWa5+j4rKwFqhDZyD6c+9iwZuqYzlcQ7W9pP
	 oTmYf1SkqwjeDxa5HQYZgShDE+V8ZhwKuxKHGkwxhSrTXoy2Mrr2tkKKRaMH+ArJPJP10
	 hpYy6xCSKCkB9zAesY3l5f93M7F9hNZAWOIxoKRFmrRvY2QVQIbloeLZdJh5pCRSriA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793475136;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=LqPdDt5VQv4vWlTmOIPQc4BQmHZm8cy8wBs338iSEeY=;
	b=EtMzGOdC7HBQ+r9y9v0FnalD8BPV7UAeqDjLExxBWA48kZ1HlwBvpS0fhYSrrz9tmz4P
	 /P6EPk5WUCi5MZ8xt3vDfQPWIqYh49BTFF/oHoiTzpzdFAJSh5OY0ReY0HWV1ndRMGNDG
	 mMa5/sdvN8WMTPODc788JRry9T1v0ehqX2H+HG0QeRZiKmWSOCmzP/OtXVqN2GWyckZ27
	 QMsgPS7+jUpdhVRI0bqrKSlZRt6CLIjfDKXGOQVSghyfQZsHOJwyosKhyg6scjufPLShV
	 sXGV0pp+egb0rWLLn7hR7T0b47H+kvo+k+8QooO03GNXh7uxM4iTfbTTCOCFglq2V+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DJO53Rpy;
	dkim=temperror header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=KiOymRsA;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9D5606A31C
	for <linux-scsi@vger.kernel.org>; Sat, 31 Oct 2026 19:32:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD9D5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DJO53Rpy;
	dkim=temperror header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=KiOymRsA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793475124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqPdDt5VQv4vWlTmOIPQc4BQmHZm8cy8wBs338iSEeY=;
	b=DJO53RpyEiSQqxUJgsroZehLYM/gmk66BPnJSh3mJYoCLzFyB2jmFklenLS499edFLbtF0
	4sstbhPVbfsfsj7v+mzlLeGyUGoRNgQl/PGkcR9DnQzlEioZunqv07TouOSbQ5Ly/lq52s
	6q4y3owP3hZj5bgtsoWxovUm5IYOBV4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-csKpj6KBOkecelS_08fnVQ-1; Sat, 31 Oct 2026 15:32:03 -0400
X-MC-Unique: csKpj6KBOkecelS_08fnVQ-1
X-Mimecast-MFC-AGG-ID: csKpj6KBOkecelS_08fnVQ_1793475122
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93cb98809caso304430585a.1
        for <linux-scsi@vger.kernel.org>; Sat, 31 Oct 2026 12:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793475122; x=1794079922; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LqPdDt5VQv4vWlTmOIPQc4BQmHZm8cy8wBs338iSEeY=;
        b=KiOymRsASOMSimgKgwyUtbMA9yA/NZVruPP7YxTMyS/MmcoulRn28uRxu74ocoiWcN
         FAnJNHGYlUll2WJcMUh4UUXoIqVJeJbKuT4izNcUFhmEMTQDOvliwh5SmLI0JaUX2ydf
         VtK1oHJuyVGWREbju4CWmzCsf6JXomkqsdi6h1XSavtZfydywgdHU9sIYjedtp8o+NCZ
         zHYtKUMjJIeu5e9bgQGV1npGLEX5TDzhZXOEH4CzkOC0H5tLbGL2Iuzdd18HrdRbG9r/
         yvVK0a8cCVnD7FFKoOLhkKZqwi6/7f4jBQjBlS4zwXiH8B/Hkfnr0M2EI09xRgORczV7
         jxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793475122; x=1794079922;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LqPdDt5VQv4vWlTmOIPQc4BQmHZm8cy8wBs338iSEeY=;
        b=V48e8JEXYltn8Q3nAFDt2g/U4XsyPyWX7xEkdx1LVhT/7p86k3eJwM8zYa8OuMHbbY
         T25X+8xRrMwolUt1pR2gx6tn7uWb7lMAV2AA2ynwC2EDgW2sGC7NBFq9T6TugCVWgQ+Z
         ANilvLTGnUVU0IjsHonF2z8SGC4E16wXCzF90jLeFwkLWYoIlJhoguXdPWv/eLhYWMFh
         JSwrqbqbqeeeNrpbVrK1JZFmWzqKItX5pzWYX1cM64nnbiQMzb1ytsZZgNx/QOWvFc7T
         uxO/EoPWOgXKFOjEDCCQH3hPH1HCGPdFqY7XS+Y5c6XAnvN+45huVfcPnS2ju1KMdFRg
         usPw==
X-Forwarded-Encrypted: i=1; AKwUvBwOwdzHOY+j3Gr/pog2GMfNxZ8fyvfh9MyL6pYgvkMdKQuExpwBpHlGsTTycPz55STF4IafxbutLpaA@vger.kernel.org
X-Gm-Message-State: AFq9FYLqJXHWeLHSB2LiceKFudERGi/ivVMNh1NSxKv0llD6VTURhVQu
	9oWIb1Wjjqh2qMEtt3sBXveon5wQeS1enWWGRqZ1fT3QLb0euwkeIsA4isR2QZHWI/GkKr9dKE2
	4EpX25f5mtLtGsPl0ovEgC7ygio+4Z9bYbFpv+UIsMhhR1ZQgWzbnwdUofGMxAuk=
X-Gm-Gg: AYBFou1JAXulgONzrUYar5nHXxh8vMfjW41OzQ19HRPPt6kgEsfPr/rPugIBpw43/JB
	U9lXqCNPeljhRfrlnpmpHMACOFb7dtq9XkegOXX9o69n39VX1GSl7B5V0opzS542oCchfJExgCe
	nuzO48Vxm58CwTuTTTUlpUNTQOVjuwZbVaJxt8kJ7NHct/YzPG8nyhVC5vdbNlfzpyrwF2uu/fo
	AtzR6uH6fPaP6f6Eg4lGjnLoOyAPw5wtYENaSpJ5XUqH+xAdFWKElX916+K1C1q3WXARv1frImC
	46bhWv8nEow4zDoAbw0fGWsgsb+qBMYKfsLL8uxxu7z6Gts8TQWhrYMbg8zBUNoASfTZ275JmIL
	bo5Tx4ZHAEtYLAAlUNZacgnTkVdjC2vx+36b5Ypn3wdIFBv8y8GAuhRcY3+shV+1dlNLLYDU5mo
	JrjAo3gubEAL9jPfMFYuW6JrMq0kOvXdy/kYv5DRb754gqUX+l+vqq7u076CepLFbj
X-Received: by 2002:a05:620a:4627:b0:93f:362a:a893 with SMTP id af79cd13be357-944217ee29amr994958885a.50.1793475122351;
        Sat, 31 Oct 2026 12:32:02 -0700 (PDT)
X-Received: by 2002:a05:620a:4627:b0:93f:362a:a893 with SMTP id af79cd13be357-944217ee29amr994956085a.50.1793475121796;
        Sat, 31 Oct 2026 12:32:01 -0700 (PDT)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([47.14.98.102])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425aa8fc9sm440822885a.33.2026.10.31.12.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 12:32:00 -0700 (PDT)
Message-ID: <721baf73d784b73015899bfe0ebca07bd8bf2a69.camel@redhat.com>
Subject: Re: [PATCH] scsi: scsi_devinfo: return an error when the proc write
 fails
From: Laurence Oberman <loberman@redhat.com>
To: shao.mingyin@zte.com.cn, mkp@kernel.org, 
	james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 31 Oct 2026 15:31:29 -0400
In-Reply-To: <20261031222133489hI-BEIDpFMxrtlntnLiFb@zte.com.cn>
References: <20261031222133489hI-BEIDpFMxrtlntnLiFb@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Sat, 2026-10-31 at 22:21 +0800, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>=20
> proc_scsi_devinfo_write() calls scsi_dev_info_list_add_str() but
> ignores
> its return value, so a write to /proc/scsi/device_info always reports
> success, even when the string is malformed and no entry was added.=C2=A0
> Users
> and scripts then believe that the quirk is in effect.
>=20
> scsi_init_devinfo() already checks the return value of the same
> function
> and fails the initialization.=C2=A0 Return the parser error, but keep
> returning
> the number of bytes written on success: a proc write handler that
> returns
> zero for a non-empty write would look like a short write to the
> caller.
>=20
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> ---
> diff --git a/drivers/scsi/scsi_devinfo.c
> b/drivers/scsi/scsi_devinfo.c
> index cfc259fd0141..b1f3bcd739b4 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -688,6 +688,7 @@ static ssize_t proc_scsi_devinfo_write(struct
> file *file,
> =C2=A0{
> =C2=A0	char *buffer;
> =C2=A0	ssize_t err =3D length;
> +	int ret;
>=20
> =C2=A0	if (!buf || length>PAGE_SIZE)
> =C2=A0		return -EINVAL;
> @@ -706,7 +707,9 @@ static ssize_t proc_scsi_devinfo_write(struct
> file *file,
> =C2=A0		goto out;
> =C2=A0	}
>=20
> -	scsi_dev_info_list_add_str(buffer);
> +	ret =3D scsi_dev_info_list_add_str(buffer);
> +	if (ret)
> +		err =3D ret;
>=20
> =C2=A0out:
> =C2=A0	kfree(buffer);

Looks good to me.

Note that a multi-entry write can still partially apply (entries before
the bad one are added, then -EINVAL is returned), but reporting the
error is a clear improvement over silent success.

Reviewed-by: Laurence Oberman <loberman@redhat.com>

