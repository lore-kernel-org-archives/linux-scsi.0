Received: from fgw22-4.mail.saunalahti.fi (fgw22-4.mail.saunalahti.fi [62.142.5.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F9F1EEE6
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 14:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762353729; cv=none; b=SDdobleKkFYjfiSFHU9Aq3KWDo0dGY0TGKCKNkQvWsDyNnZECh86f5lobXKCkxd+zZasDqTZsxITEh+GHZg8SlY5gcyKawLNOdz21J/hPsqvZ/+t8TDEY+N01vzcFH8q13SiWkc87ZRl1bqpC5zpDiJgIKz+43qNYeycOKwX3CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762353729; c=relaxed/simple;
	bh=8JCzYi9gWIBPJT2725Pqz1MGC9Tzc6ud9CwZ5KbYAA0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=naW4NhfzOi+dvLnJqUNl37uFYPqT9OAzJtzQX7VwXPrek6z0leNMFw+FmkzFlI15Oxs1Ansdu3ZOsI9NCGqvFQf3MfyaKU4BdcTVpFMee7af+GU6bCvQnudn9MwJmrJX9GZOoRxPiWqnCAcqVQHxquOY4yDUpbjA0fN+ZYKwF44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=BQoRkfBG; arc=none smtp.client-ip=62.142.5.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="BQoRkfBG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=9eshtKRYbhDh0bRl+exwpgpS+Fj6+mYIgQqul2sOiQ0=;
	b=BQoRkfBG7/2Gzn8FgTFMUfG3j8FDPAOZFhdLJdEzo+DzwlZk/S9KdRTMDsqkX0US26i7E40IvDdBG
	 wuoTLObCIR2qJlcdQj3DuLVBqvi6LKTSoKdJmAXhv8aqbQ27Dh4uUML5APDUIn6DB1UReSSJpALtSO
	 VbjmHuhqBIf+aPjzJ0fGxs2Hc21jNIHLugappzX6vmqj8k8/o2oRJgXoZeDSo2VdKJ/TNBxf2meeoH
	 0pwCIReUCtEIyQ2kx5spUbNSrtNtS6Mdu+Jt88Y7jJZiKejxZWhXzVN/1QowcwjPHxLZ1qxiMGMzSN
	 955j1FyZyLqmpfLTQ4vTZALHYqcb9OA==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id 6e9eff18-ba55-11f0-a98a-005056bdf889;
	Wed, 05 Nov 2025 16:40:54 +0200 (EET)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH 2/2] st: skip buffer flush for information ioctls
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20251104154709.6436-2-djeffery@redhat.com>
Date: Wed, 5 Nov 2025 16:40:43 +0200
Cc: linux-scsi@vger.kernel.org,
 Laurence Oberman <loberman@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <092825E2-8A25-470E-8D1C-C272262D3F2F@kolumbus.fi>
References: <20251104154709.6436-1-djeffery@redhat.com>
 <20251104154709.6436-2-djeffery@redhat.com>
To: David Jeffery <djeffery@redhat.com>
X-Mailer: Apple Mail (2.3864.200.81.1.6)



> On 4. Nov 2025, at 17.46, David Jeffery <djeffery@redhat.com> wrote:
>=20
> With commit 9604eea5bd3a ("scsi: st: Add third party poweron reset =
handling")
> some customer tape applications fail from being unable to complete =
ioctls
> to verify ID information for the device when there has been any type =
of
> reset event to their tape devices.
>=20
> The st driver currently will fail all standard scsi ioctls if a call =
to
> flush_buffer fails in st_ioctl. This causes ioctls which otherwise =
have no
> effect on tape state to succeed or fail based on events unrelated to =
the
> requested ioctl.
>=20
> This makes scsi information ioctls unreliable after a reset even
> if no buffering is in use. With a reset setting the pos_unknown field,
> flush_buffer will report failure and fail all ioctls. So any =
application
> expecting to use ioctls to check the identify the device will be =
unable to
> do so in such a state.
>=20
> For scsi information ioctls, avoid the need for a buffer flush and =
allow
> the ioctls to execute regardless of buffer state.
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Tested-by:     Laurence Oberman <loberman@redhat.com>

Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>

Thanks,
Kai

