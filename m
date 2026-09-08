Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C2D4B4868;
	Tue,  8 Sep 2026 20:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900071; cv=none; b=WxtL0T5YN9YuBm1DxSZ3GyYlsXsrYpx7XICHpvwXJDE005A3leXhud1QrZSPAUI7189l+K0J3LbmvOfr2U0ZBcZMPWa0p7lBEVefa7PJm36hWTuyrB6i0Sc3HueIETtroWiTmynlaQ2Ha89jy1QRx3uyphOliRUKGw/ui0uBeCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900071; c=relaxed/simple;
	bh=KlMui0tOmb7Sc1nBWmJZ+BibtB0dMUp4///hYzc+Beg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=c93GPjLaKxyVoU1QzapNp+nQT1JH14Sucx+RYLrfq2hxzT5RnltWcR9M+A7nvIdfBVF1O/IIAxPLiBXeZHOFiIGrBmb5KlaLmO4fgs5uYLUdgPYfTm5FJJHJERgKrbvqvC7UqicyKzgU/1B6w1dY3vSivLNMdXgGHmLAUCYIeZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efqBqlBZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efqBqlBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87F21F00A3A;
	Tue,  8 Sep 2026 20:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900070;
	bh=KlMui0tOmb7Sc1nBWmJZ+BibtB0dMUp4///hYzc+Beg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=efqBqlBZ4eKgUVT26CK9mC4xouR7DXfpL0kb16fyhUVNNrwyMjMn+yBQU85uRLV3H
	 p1TJsDtLA+pATPWmXZZzSEtJJe7rszXIOPJOsmOdiEc4DYa2lA5ZhnhpuJVNNiv7VS
	 bLixrm/zFsMXO19R57pR36A6MrSENsSKfKp1eZC93QTaPkoPKqH5BrI1ZBtmcRNbaD
	 FiYfNEVphIG1obkQaIzSNwULo+/JeiDhUpcB1u+ExVjygQwx0nQXexm2V7VAXtkdsB
	 I+gdcQ5ODCIpJIhuanDDx5ZAVX8xJWwCs4cBSIp7NS4Dn00zMmIFH7NWAHMkZWM3JT
	 eF35UZ/ybeujQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 36/39] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Oliver
 Upton" <oupton@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, bpf@vger.kernel.org, linux-s390@vger.kernel.org, linux-perf-users@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org, selinux@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, dri-devel@lists.freedesktop.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-36-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-36-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:41:09 +0000
Message-Id: <20260908204109.E87F21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted =
to
> predicates which explicitly express what is actually being checked for
> rather than the nebulous concept of possessing 'special' VMA flags.
>=20
> In any case 'special' is not so special a term of art in mm - it includes
> VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
> other cases too.
>=20
> Therefore make things less special by eliminating these now unused flags.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D36

