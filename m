Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54015511E73;
	Fri,  9 Oct 2026 18:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571725; cv=none; b=q3970USSqDcB/3K8B5QWGkEfe3BBk8b/jAbaSGODqjcNvbdkFunlyNOelBM6Mp+dDRWbTDP3ufJ7JP2f/FWaXJnAq3HzELlZfHibiH3r38LZVh2WzJie6rZmesQJd/zGSY7WQN98GOmBB5optjLv2xoFAD2UEQ3JtvTm341FMR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571725; c=relaxed/simple;
	bh=LfJvDFNDixbvgbvbALUIlQV9E4F1Hb5P1YLX6fvGO0s=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Ve62MZHSkcLjWqnqb3PANUMuoObFF/0j5SSWOAY147ddDYrEkbBw0lPDca1vPQCzc/HgHIRUGSviIELlXrFb7CG9V6LBk1B2SpIARXQLG6AKRPCBDPdkWSUHejHKnYmrEbnsx8GTq/ogAUShq+YgD4Te6UAa4lW5UHQ4cmOANEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=anh0FGAR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="anh0FGAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F651F000FF;
	Fri,  9 Oct 2026 18:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571724;
	bh=LfJvDFNDixbvgbvbALUIlQV9E4F1Hb5P1YLX6fvGO0s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=anh0FGARTlPPdhEZbG3n5RQyiaWGuHqWeBzYEy/H+4vUgnW9ONrhyi/6wZZA9YFeS
	 MVhve4DEjLR0/rrwXHE2e+Fk/I+6+iONkfWXuPu4vumrKrWS7r5hGMwlXwrfeJgrfu
	 oilBKNhPwmOBgAjV9JfOhcXg7cBqmOXMcF0sIMyX9plpnI4bMYj2thGBPKg2cmil+u
	 bmhGQqFXJ3lYeDJKXrIlFbuWSCQlTTSjEMyNBslOGBH570Pa8CsfE/2Xd5Kfgd+dfj
	 5yZjsLt7BknuXoh/uv1vT1jhS2rTCI7dFQYObs6rePNde+G0pS4ZOIqlod/SCEwJOv
	 ZtA+USt3t5qQg==
Message-ID: <sashiko-outbox-165977@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 36/38] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-usb@vger.kernel.org, kvmarm@lists.linux.dev, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, selinux@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, bpf@vger.kernel.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-36-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-36-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:48:42 +0000
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
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D36

