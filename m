Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2B230B527
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 11:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761307195; cv=none; b=u/16yaM5+cqX5BOydl6PrGF1ONQMnb2BlAjF2PCsrX6JoCVhnFZdrWJ/VdnoqxNk02H3DcZ6OAH4TDEQRLeIWLAzXLgzAPT3F57wRPTTqH9NQj7e2huRouAK0DYn+xiNgrU9L8HLiWDQaTP/vdRlweVtq5yneR3EwQ0MTCPnf8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761307195; c=relaxed/simple;
	bh=DPkRapFx3wQC4jsOf3+1TPlNi7+JsNGZws7j/yKGKhI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=rPO3AYrCFB2K++4bk/xEakPqgQHwKqce5p5FrjMne7PWHgRl90uJxNfdGRq1FPWkGnQ/tKtJbm3TmgZTvoHaCadkoybLf6TP6poehzgiTWKGhX5YOVJucLZBwaNHhXa3GE+bwnBVvQHuQSAC+u4wdKcez34SC9jViHCOPpVi2iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=lQ/lTqRL; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="lQ/lTqRL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=DPkRapFx3wQC4jsOf3+1TPlNi7+JsNGZws7j/yKGKhI=;
	b=lQ/lTqRLhtD1qwBGl0w1eTZmeY4GCe8CnGdVdIfZjbRjtaKMOzlGJX21d3Nu2PwtJn4H3anmg0xdS
	 p904oIdg1yX+gBNvkELSZnk/qxVjDm64WlwFcTXBz7LNwbHwrydIVVlehYjwPGRN3W6uMrOXKSuVwl
	 Vk10JT1d6Vf4qeboohmHA0WJYAbPOnEkGp+uuKYCuOozNEM1KBoaRxrQ57nFjLIF5hsnaJJJiLAdEM
	 Zoo7+HdI0acMOur1nUGnsV6fyXE6CXjrwDKff3iiEv0GBs5a7hcNDugx1PqkIzx055Qk4b7+KtR5T+
	 QTq4SWfA4+7Kyt+jxmL1Eju9s5j/dtQ==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id c7dd5739-b0d0-11f0-99c6-005056bdd08f;
	Fri, 24 Oct 2025 14:58:40 +0300 (EEST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] scsi: st: skip buffer flush for information ioctls when
 there is no buffering
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20251023140531.5197-1-djeffery@redhat.com>
Date: Fri, 24 Oct 2025 14:58:30 +0300
Cc: linux-scsi@vger.kernel.org,
 Laurence Oberman <loberman@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1D000F1D-7FE1-434C-AAB7-DEFF0FDD4106@kolumbus.fi>
References: <20251023140531.5197-1-djeffery@redhat.com>
To: David Jeffery <djeffery@redhat.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)


> On 23. Oct 2025, at 17.04, David Jeffery <djeffery@redhat.com> wrote:
>=20
> With commit 9604eea5bd3a ("scsi: st: Add third party poweron reset =
handling")
> some customer tape applications fail from being unable to complete =
ioctls
> to verify ID information for the device when there has been any sort =
of reset
> event to their tape devices.
>=20
> The st driver currently will fail all standard scsi ioctls if a call =
to
> flush_buffer fails in st_ioctl. This effectively allows ioctls which
> otherwise have no affect on tape state to function as an indirect =
method
> of flushing buffers when the tape is being used in a buffering mode.
>=20
> But this also makes scsi information ioctls unreliable after a reset =
even
> if no buffering is in use. With a reset setting the pos_unknown field,
> flush_buffer will report failure and fail all ioctls. So any =
application
> expecting to use ioctls to check the identify the device will be =
unable to
> do so in such a state.
>=20
> Instead of always failing the ioctls, allow the ioctls which will not
> otherwise interact with the tape to bypass the call to flush_buffer if
> there is no buffering occurring in the st driver.

In principle, the driver should allow after reset commands that are not
affected by rewind at reset. In practice, there are cases that have not
been handled, like this one. This is, however, somewhat nasty case
because st has to know about the internals of the scsi stack. But,
something has to be done because this is a practical problem.

Your patch should solve this problem, but there are some things that
I would like to address.

The patch includes a huge jump over most of the code. This makes it
a little difficult to understand. I think it would be better to handle =
this
condition locally around the call to flush_buffer(). This would make it
clear to see what this does, without having to check the code being
jumped over.

Another thing is handling the non-empty buffer. Could the patch just
skip flush_buffer() unconditionally? I don't like to have code that
mysteriously fails in some cases without a clear reason: why can't one
ask the IDs even if the buffer is not empty?

This problem also provides an opportunity to slight cleaning the
code by moving handling of pass-through to a new function. The the
rest of st_ioctl() would then just concentrate on the MTIOC_* ioctls.

Thanks, Kai

P.S. The patch seems to miss a newline after the new function.

