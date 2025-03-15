Received: from kurisu.lahfa.xyz (kurisu.lahfa.xyz [163.172.69.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56214204F61
	for <linux-scsi@vger.kernel.org>; Sat, 15 Mar 2025 17:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=163.172.69.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742058741; cv=none; b=Y3TQrH+QIrUdXL1x8HK9BfLVasD0UhlljPU/8eZk3h+i7MhMfUAeFNRUu41ButLG29XJ2ZAvEO5pIqAnVfu91D+C6SKiMtieF47F2IpV6TmlLi0RxgT9d1/62RauJ00E8QNB+X0FPK4MefKvHAukWpi16uIVa8liEP+aFxa7mj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742058741; c=relaxed/simple;
	bh=nA7fUl0/Z4EoW8bLQDu0wuehhA01FRQFr9386UD7JvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B2HSVNHpEdWXeEkFnP9MVTxCeWToWKW7zlgYVBF4xfT9cQWySNF8PrjrRR/t43QreCNhQQde/IRno41oX11lD94CZXtJmtRRTgZXYQ79ymBmD9EyJwpZQB/Ts7XXv2jNSSRjTAeN/qGBYzFU9Im8OvoyHBnaTUb/BE+qETNYe6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lahfa.xyz; spf=pass smtp.mailfrom=lahfa.xyz; dkim=pass (1024-bit key) header.d=lahfa.xyz header.i=@lahfa.xyz header.b=eNf9tRHH; arc=none smtp.client-ip=163.172.69.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lahfa.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lahfa.xyz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lahfa.xyz header.i=@lahfa.xyz header.b="eNf9tRHH"
Date: Sat, 15 Mar 2025 18:12:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lahfa.xyz; s=kurisu;
	t=1742058729; bh=hj1cqQt24Qrr9LTAkI72thV9Qm1XhtPqljQP4/3a5sg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eNf9tRHHEO/DC0wN5i0/Y0BUz/K1s0fsnLXfdecR4giGWhi8TsQ0fy51K6AvG+0r7
	 IhrNv1ICXhS+DQaxri9dEYExjrac9be8f2y21da1v+4RnTdGbNadUQtcubfHoxcJai
	 K9Ix1QRNYF1cNgStAAf7s9ogJ8/zTDg6yAdPvn2s=
From: Ryan Lahfa <ryan@lahfa.xyz>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Samy Lahfa <samy+kernel@lahfa.xyz>, vt@altlinux.org, 
	chandrakanth.patil@broadcom.com, kashyap.desai@broadcom.com, linux-scsi@vger.kernel.org, 
	megaraidlinux.pdl@broadcom.com, shivasharan.srikanteshwara@broadcom.com, 
	sumit.saxena@broadcom.com
Subject: Re: megaraid_sas: multiple FALLOC_FL_ZERO_RANGE causes timeouts and
 resets on MegaRAID 9560-8i 4GB since 5.19
Message-ID: <bdptpiqtujqtlco5aopy2e3psmormwqwl2umwkdwygmnqlaxam@5cryrc7ehrcu>
References: <20240216100844.aabjlexbwq6ggzs2@altlinux.org>
 <20250309135728.3140904-1-samy+kernel@lahfa.xyz>
 <yq134fkpapb.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq134fkpapb.fsf@ca-mkp.ca.oracle.com>

Martin,

Le Mon, Mar 10, 2025 at 10:24:53PM -0400, Martin K. Petersen a écrit :
> 
> Samy,

(I work with Samy.)

> 
> > I have just ran into this issue, controller resets and timeouts
> > (running mkfs.ext4 or mkfs.xfs to reproduce) and bisected it to the
> > same commit :
> 
> Can you try the patch below?

Tested, this works, I do not see the error we reported earlier.

Tested-by: Ryan Lahfa <ryan@lahfa.xyz>

> 
> Thanks!

Thank you for the fast answer.

Kind regards,
-- 
Ryan Lahfa
