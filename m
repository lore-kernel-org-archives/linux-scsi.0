Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BC7257844
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 05:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782277883; cv=none; b=L9y/ugRpxs8KTKZv9Y8eKDBOUQCsXn1jrqqaIBz21IXZ8CA8yRzYPe7cBQqSSRk71/yDUUzfCIwv43bw0IThKlpmnl7r2zcqCneVkyqVoXqgci82MTLiI+FWBX9lES9GQeHvnrJfI17MYpP5/5jJ+WAycPnx6mVcB8bCmB9AYQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782277883; c=relaxed/simple;
	bh=Z8WuipphTBZbyJfzkyTWRK779qoCatgDyCka9KpBwD4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hO2zDvOJ6JyPtD6kBAJl00a1LDJ0NCkHt6yQ7Z9VGD1JrFEwCATX00hN1FQ4TNtCdUi10g+IjwEXUIoTJKXw7vv1mzfbc+qwXw4R9gfUV/BjEAzStXP0LGzfppEN508gZF1aHn+rP6Z/W0HEJnoXg7vjH8Opu0Vc3+jSpaQjYso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aclgPSRW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aclgPSRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F271F00A3F;
	Wed, 24 Jun 2026 05:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782277882;
	bh=wqk9tNFhNj/ou59lRtMcTIrHrtAipSOPKSZ/me19Jlg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aclgPSRW8IQ6JJqkbzcmBWGZL5FqPTtTq70vnEVyDYds7eed35h+REtp9qmolRKzR
	 4hohFuDBtCWx2U9sxf4U7C3NGwp7V/rHMJos6fIu7Cx7e9zL0ACeErWKiHwHuQWcPi
	 +WJnZOEowH6xd9RBXQ5OqWn17/5CSaGvhHYJPQhbUe2kuIsEyglPMq8UiYLDvUJt1l
	 y1UVISywzFJDSx+CRYbvFYC3vXTda8JBOHif3LxUFP+utRNrd1rjB+1KK4cJ7PeXyJ
	 7yQxrvEDWfl5vTE1uvhKLYRh7kUhhmeyBV2577U6tNkt46Ys+mJ0x2xWeQxQeiw/vA
	 KT0Q6b8k0Ljiw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 02/13] scsi: fnic: Use fnic_num for non-SCSI
 identifiers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624044334.3079-3-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
 <20260624044334.3079-3-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 05:11:21 +0000
Message-Id: <20260624051122.50F271F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Unconditional use of fnic_num in fnic_fcpio_ack_handler trace ev=
ents breaks event correlation for FCP initiators.
--

commit 899ac498b451c2fff04272de1bf2b696b5332d70
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Use fnic_num for non-SCSI identifiers

This commit updates the driver to use the fnic instance number for
NVMe-facing FDMI and debugfs entries, and for trace events. It aims to
reserve SCSI host numbers strictly for FCP initiator paths.

[ ... ]

> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 0759540f66753..b92260583c67b 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -894,7 +894,7 @@ static inline void fnic_fcpio_ack_handler(struct fnic=
 *fnic,
> =20
>  	spin_unlock_irqrestore(&fnic->wq_copy_lock[wq_index], flags);
>  	FNIC_TRACE(fnic_fcpio_ack_handler,
> -		  fnic->host->host_no, 0, 0, ox_id_tag[2], ox_id_tag[3],
> +		  fnic->fnic_num, 0, 0, ox_id_tag[2], ox_id_tag[3],

[Severity: Medium]
Will this unconditional use of fnic_num break trace event correlation for
FCP initiators?

Other FCP-specific trace events continue to use the SCSI midlayer-allocated
host_no. By changing fnic_fcpio_ack_handler() to use fnic_num
unconditionally, a single FCP I/O sequence will interleave two different
identifier values in the trace buffer (e.g., host_no 2 vs fnic_num 0) on
systems with other SCSI controllers.

Should this trace call check IS_FNIC_FCP_INITIATOR(fnic) to log the host_no
for FCP traffic, similar to the debugfs and FDMI changes?

>  		  ox_id_tag[4], ox_id_tag[5]);
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624044334.3079=
-1-kartilak@cisco.com?part=3D2
