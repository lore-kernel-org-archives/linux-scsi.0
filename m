Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537314;
	b=XG+EBXbQkvr7ETB68xQNGGFPswnA84XC99NOylt1w4hzIFIRxVZNkbJOKATt1K3berVI
	 oQ3ugx+2p/WUv0hXBrfKdaf7SW76LPsgRVC9Qn4PiTEcWgBD15CocdBe89CUOl3LO5WqG
	 qTWTP/XJ/03l/2TgymeWvWCSlvcroFA8r2hjrTAqkExHx/Kj+WVHbM6WRu3Fg9U44KXxn
	 mpsRg3h/T8rBGE1vTRUGKY9bcJ8pkNaH7ULOL2aRxfLndURaeLfY/qAGhSaSlSCP1sbIW
	 0rFwa+b7FtZPTpDH0dDca6zByqQyMIQukcdvRP17H4sIvjl7GI6xtBF/W6vaxrhm9uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537314;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TI0NdJ9/bEfQMbBupp6XllzEDj7G34TXXoLZDBoxo1U=;
	b=uL2GLek9SlW9KfgcUI+MKmOsV8W7irFe3YI9krYrvErFhWo9w4LkYkR5cZ5rd1P1r1uQ
	 9CMthaduZy7onXYa4UDnAR7xVBwSgDvOS9gfutFlfhTCP8BbGLfSa6OocFD9a0buDCFHb
	 Ubqj3pAdWxx3bw18ZfArmhEGwgjUjtZzduyNTdaIkIDaJy1cU7F2tz8vL/utTIdwecnp2
	 ERXqNRbeDPiV7fYXVJFcfdmqeq/u0dvO/D8tZhlQwpLXKkFVXiqvB3fA+pUJQbeOuX7LP
	 acjix/DcdcGu6S+2X6JcmDdybl0CUxf/8xyzOSN79wvT9sxdMKhce4U542eySkS5bhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GejII3UG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F045606A31E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GejII3UG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFC61F000C6;
	Tue, 24 Nov 2026 16:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537314;
	bh=TI0NdJ9/bEfQMbBupp6XllzEDj7G34TXXoLZDBoxo1U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GejII3UGKauXNbMoXpNMTJp52K8hzIjLj89yWIlAP5JJqW+CF2UyRdizFUyrUp3UZ
	 MM59V262lG9Y2em1mKEcgzi8Mg6QAbKmn1jqO4qweYnC/uFOo0M38aRT+M/3v7vzQs
	 6SdDmybAprcWgIaSAZ9pVo8eA6JX9pP/r2dODgoFXZW0oCXn9DnyWRbL9whkSCg+s7
	 lcAotdIUCFkQm2tnFpEbS2Tq8AV6mJoHs476PsK9eKGij/RGGNnDuemw/QymzZvnB/
	 HAQ9UNNzyWgoAhkXxcdY7gddYRKVPFU0JKj7Au9gkonivk9y3RN8awWGHF47+xnfzm
	 qTIIvP5S0XawQ==
Message-ID: <sashiko-outbox-231546@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 04/13] scsi: ibmvfc: fix stale rc and IRQ mapping
 leak in ibmvfc_register_channel()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261124-ibmvfc-fpin-support-v19-4-2aaffe5fe7d2@linux.ibm.com>
References: <20261124-ibmvfc-fpin-support-v19-0-2aaffe5fe7d2@linux.ibm.com>
 <20261124-ibmvfc-fpin-support-v19-4-2aaffe5fe7d2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 16:21:53 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scsi: ibmvfc: missing Fixes: trailer for
  ibmvfc_register_channel() bug fix
--

commit 181fd7f6a2341ee658bfbec7bffd68ba8ad3084c
Author: Dave Marquardt <davemarq@linux.ibm.com>

> scsi: ibmvfc: fix stale rc and IRQ mapping leak in ibmvfc_register_channe=
l()
>
> The default: case of the protocol switch in ibmvfc_register_channel()
> jumps to irq_failed without setting rc, leaving a stale value from
> h_reg_sub_crq() (0 or H_CLOSED) that the caller sees as success even
> though the sub-CRQ was just freed. The mapping created by
> irq_create_mapping() is also never disposed, leaving scrq->irq non-zero.
>
> Set rc =3D -EINVAL in the default: case. Introduce an irq_mapping_failed:
> label that calls irq_dispose_mapping() and clears scrq->irq before
> falling through to irq_failed, and jump to it from both the default:
> case and the request_irq() failure path, eliminating the duplicate
> inline dispose/clear in the latter.
>
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>

[Severity: Low]
Since this fixes the default branch of the protocol switch introduced in
eb85f1d76aac ("scsi: ibmvfc: Add protocol field to ibmvfc_channels"),
should this include:

  Fixes: eb85f1d76aac ("scsi: ibmvfc: Add protocol field to ibmvfc_channels=
")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124-ibmvfc-fpi=
n-support-v19-0-2aaffe5fe7d2@linux.ibm.com?part=3D4
