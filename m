Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537638;
	b=TYwWE8GkW4+3THFi0KprCH4uDjZ4xPXE8nsM/N8ZjRcHKmUOwBzw7eL1AhJ2rXgnufO2
	 J7pGMAUpQpbzJq4Nn3VXUjfiDrQXxjfhCUYlY7mrNh4jSeKOA1uLuYcwnXyUjOAQo6dJu
	 1uLSbR/o5GO9A0f3Uj/w60dO3OUXBHHsasTzUJ7fO/CB3WS3cBkAb7ooUp2QxCuT7qRec
	 yuUXV2bh4tTw2M0+A/p3BOVp1KlYrHkQ94rkV6LAT6S9F3jM/IWJLHtFkHR/h/ZOwEo/h
	 Xdj2aIHODmwvETDJ1jE1I5bHdhwYsXJd1j8CFMWCY1oq72oqOtazfEd+4++BQTEzxjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537638;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VQ1y7JuLbu+OOXIatZrNbIoNCRGnhif/0fhcAEtPIRI=;
	b=eE8d3HMm3hF9nbgrXLq8BgiIv468/W679iB3fD/wwt/nkouBLVnP1ahS1FnmkGfns+ZB
	 siviuWKDBUVBdcY8H6RKqp003wvmJV2j+4SaK2lQcaE3CZdXFqc4LnPgXqx4wjCt/hlxI
	 HWplCk8Vm38dfxEXL0kkOcpRr/LSBDE25nIxiP7ADzTLKZpn55eqvo9qVNstvAlEKmxgj
	 VjSoZx3WVjpz26N1Z35lvPvM8ltNu606I2UIn41SD2AhcepAbe3QiSOUYWTUJP0AC18j4
	 bHnTDql6lS3YotWhO21YEW8ROkhLs8p2za/ixkPUFldFkxP/G3zpx6W03su4p6FMkww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DexHHXa3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A62606A31E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 16:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DexHHXa3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9001F000D2;
	Tue, 24 Nov 2026 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537638;
	bh=VQ1y7JuLbu+OOXIatZrNbIoNCRGnhif/0fhcAEtPIRI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DexHHXa33PPdCBdyBDnkZ/gE3dYGDvZDDMMKqRi0dGiYcnBtP/B9byhsVso2SXW2u
	 d1eWO6WsKHJWTqXQiA4BaTtLtxgb3Ar/4YNwBAZR1cqfFtmboIkRmUbIBSXR25a8j/
	 JH12HMYsd9mN1RpLEggaXR6rN290X1mtjFGCj3jTfVFRyCpiG9q8D5UHfODaC7UDo9
	 /GIQ4KtavHxj1DajM38Gr43sEyj/I500zZtAOvvgcIBCHFxIkxxhOFr9elaG3NnVYh
	 wh1JCRDZ/cbU4YhCAO50AaQhnjLyIte1wSS51weZSKW2VLvMvaxONtAjtsvXdjF2I+
	 oj5fZXKjL6FYw==
Message-ID: <sashiko-outbox-231560@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 02/13] scsi: ibmvfc: fix potential clobbering of rc
 after failed irq setup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261124-ibmvfc-fpin-support-v19-2-2aaffe5fe7d2@linux.ibm.com>
References: <20261124-ibmvfc-fpin-support-v19-0-2aaffe5fe7d2@linux.ibm.com>
 <20261124-ibmvfc-fpin-support-v19-2-2aaffe5fe7d2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 16:27:17 +0000
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
- [Low] scsi: ibmvfc: missing Fixes trailer for
  ibmvfc_register_channel() rc fix
--

commit 4f416ecd247fc5424d48d287f580eabfe039f889
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

> scsi: ibmvfc: fix potential clobbering of rc after failed irq setup
>
> Fix a variable-shadowing bug in ibmvfc_register_channel() where the
> irq_failed cleanup loop reused rc for the H_FREE_SUB_CRQ hcall result,
> clobbering the error code returned to the caller.
>
> Introduce hcall_rc for the cleanup loop instead.
>
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>

[Severity: Low]
Since this fixes the H_FREE_SUB_CRQ cleanup assignment in
ibmvfc_register_channel() that overwrote rc on error, should the commit
message include:

  Fixes: 0217a272fe13 ("scsi: ibmvfc: Store return code of H_FREE_SUB_CRQ d=
uring cleanup")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124-ibmvfc-fpi=
n-support-v19-0-2aaffe5fe7d2@linux.ibm.com?part=3D2
