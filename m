Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795533015;
	b=KetSNwfu3TjYviRZi3H9UjLBTKd2Boa9kVRBRxHA2Cim/ZDEasBjl40MpAUXNm0GOuge
	 y6w/ZbSYny7p88GPiROzAW6esIW46kJkpxwNV5zwpW8pQwrwfp32MTivcnCvmSl7Z35xv
	 Ve7kL5yUh95hLm43Qr2KUzyS6z8YkfR8loA8Z46iPSpt4npsAeP7M9jScDqgAzP+2zM1t
	 xNTJf2FDUlaRY971jQm9kt58C7ZrQH3tJVSRayayqaJKeAPyybg3Oqq+BScLXrclp10jO
	 ciFUnIMpPj0or9nwPb22ADF2whI/WE+UQnd1cGG1BfCCrpKL+3FQEAOaPryjuBE5hyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795533015;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gVNJ0uqLyARnDvL36IG6Zi8OmK9cdSH1QOk2+cR4NeE=;
	b=BKI4T5/RADXF6CWqIFYc5v6ePd+als44SoeUy7XRSciVwyDx5N1Wg+et93QPva9loju3
	 xpgkeEVgM1K5eLB7jr6q4qvwAf1/yJfocYXW6Mb7OTDAU3j6XamPcOi095Hhh87Fxx1QW
	 uVzsfS1z78YP42/Q2Kp3XWR6j4X4F7oLwOSB+XOFPePXbAQDKliklfCG+QRedLgjoesjQ
	 dtGuXQyxVqBc25p6L8dRk42N2zaMeklOQJ0z2qRpacoLHLPo7hST9GzwN3TbEXl+RTMuI
	 wf5X3lhuSnuhLO806i3NpD5acg3JjymzBc+2ea+QcU+k+7MlvRVMspUwDIPbY4fRJng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EbYqG5iG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DB6606A321
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 15:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EbYqG5iG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317B11F000C0;
	Tue, 24 Nov 2026 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795533015;
	bh=gVNJ0uqLyARnDvL36IG6Zi8OmK9cdSH1QOk2+cR4NeE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EbYqG5iGHG9LN5cpVhFcRWYD3lp30JVX/R6TlP2tFLGwF5NgAmS9mI3rzNZC/LOax
	 mWPiKRCPsnAsOaN2MHkJnNUREp9bzqKBAie/RxrCaCGHeArDyA6XmGerDjIp5XgaG8
	 pLSjgTiwJmn3TyQruis3Nox1hJXJVJu3ja3TfzE/ViOueLl1JNAAdEgsBi3cymIs5D
	 NxfQfEK8Bam9S8UOI3nuYKx05V8yD4Q3LwYPDGsWcVq1lfzNazkFQ7qwdN2CrLKdr9
	 VKHY9uD1JiRiUsAc5pQEepPhpb1BbPnC1uwtlM1QrJfDEaNsc8H1G9nuZGax1H7tYs
	 7ib1hKUR077og==
Message-ID: <sashiko-outbox-231392@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] qedf: Fix use-after-free in qedf_xmit error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261124150103.166306-1-jtaubepe@redhat.com>
References: <20261124150103.166306-1-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 15:10:14 +0000
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
- [Low] scsi: qedf: missing Fixes: trailer for qedf_xmit()
  use-after-free fix
--

commit 836b89bd048da8c05c1796d7b58ad9a04dabef00
Author: Jesse Taube <jtaubepe@redhat.com>

> qedf: Fix use-after-free in qedf_xmit error path
>
> In one of the error paths in qedf_xmit, we were freeing the skb and then
> accessing the Fibre Channel frame header destination ID field stored
> in the skb. Save d_id from the skb before freeing it to avoid a
> use-after-free.
>
> Signed-off-by: Jesse Taube <jtaubepe@redhat.com>

[Severity: Low]
This fixes a use-after-free that has been present since the driver was
introduced.  Should this include:

  Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver=
 framework.")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124150103.1663=
06-1-jtaubepe@redhat.com?part=3D1
