Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219DE36EAB8
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179480; cv=none; b=Y2JKz49TQriCxuxS+Fu4SXZ+GSh/AWCyq5wzEZOnWyH2yeEA6i3Ccy9WRdyoC3urY113uzbZH6H8Xgt8hcx2BZBicVx0VsLHxe58+sLYyMDBPbPCAFzS5MsYQI4w8auz4qJZnjt3HZMsCU+2uVWSI5rPXrDeZ7joEM1yXJ74+o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179480; c=relaxed/simple;
	bh=j/CTeDwY7LSKnXYZzzwVtwGB31GH4k7c+Y9YJalEU8k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bK8o/CkZqi+MAA/TG2Ymk/5Zz9XpVNqGAsbaAfLkF1D5x3wM7OrAeN6Hg9/g1XqXF77syE02bTVbnYEkSVs5EgAjZgjNR9b6xui0OQE+hHr8odZ1JpjRlVN7alJgN9iiGBfROB0lsQqVPzMqZjTtM1TOZdP3lm/Y46U+GVYQbRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jugG+rR3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jugG+rR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B691F000E9;
	Tue, 23 Jun 2026 01:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179479;
	bh=E3FhlBmONlciTMC1sO0A6jp+t8o7ud3levL7gA6kHOY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jugG+rR3OFj3Th1iVjX77DYs6WxT71f4+IfUzbn+DQP2OH2T6giyq9ZqDA0faCmAN
	 rvdcpgeoXBrxRvo9ohRQ5urrRQgcxQ26bXuIAmWnV1yaceJ9gu4onazAc5nrtUrUSg
	 Vw3FXxuq0B6RIfyrmEwUes+k2ZisuxoKFn0vjZjzouw+/Lunp/Q0i47AASCnCYnHeo
	 nAFWXSOaD/Z1xeruIZVtufAuRm8ewyJGm9CVvzfA2wRXdjW5nD5nnJGAJ1Mp2JkY/X
	 qHtyPzQJbNUULpJv/R0UHTDF6TL/R/WbgpqKiFQAs7QVVeTbVhZNUGxSnvm7pA7j6q
	 OhzlNXkuR41vQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 22/29] ibmvfc: extend ibmvfc_debug visibility to
 ibmvfc-nvme.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-23-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-23-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:51:18 +0000
Message-Id: <20260623015118.E8B691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Core driver debug variable declared in protocol-specific header
--

commit 719e4b33f0990bbcd15f1244a436cf69d36807ef
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: extend ibmvfc_debug visibility to ibmvfc-nvme.h

Export ibmvfc_debug so the NVMe support code can use the
existing ibmvfc_dbg logging macro.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.h
> index 0465e87198817..3aa2857887950 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
> @@ -22,6 +22,8 @@
>  #define IBMVFC_MAX_NVME_QUEUES	16
>  #define IBMVFC_NVME_CHANNELS	8
> =20
> +extern unsigned int ibmvfc_debug;
> +

[Severity: Low]
This isn't a bug, but should this core driver debug variable be declared in
the core ibmvfc.h header rather than this protocol-specific header?

Declaring it here creates a confusing dependency where the core header reli=
es
on a protocol header for its macro dependencies.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D22
