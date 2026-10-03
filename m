Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9843164D6
	for <linux-scsi@vger.kernel.org>; Sat,  3 Oct 2026 14:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791038167; cv=none; b=hsMyvBCGd+nhJtrROuQXzJqBW5/OJ3pTshlrRu6TxvddIDocXoNUrl/tyiJ3ak1uGD16qPvjIAkREsB4WJxgYsW+NYbxlqCHyZP5gddvExbfEygMtU8gLyn8AslDzIm+OC3PIgeCKDwMDyzPxKpvE/75tAOioIt4CfTUwCKErZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791038167; c=relaxed/simple;
	bh=WZ2FTtuMmF5voiFaoq6Pni4Nx9S0IZqfADBwXjioktY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=r30M0OZMn67YcyqsZlBFEkzyfTIj6JS0TYrIguNgW+DI9KvlQ0jw4MTSBUHkbTAorknziImR0gd3+xV37hXZdd0tDbRVkV2jI0NHK7EioUKffZlQ3yY2y/vNdhWPD8smowBTO5KSY/Rr0DbbNPpvSdIz0o0oX/sct6K2/1auTU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=baHnPmii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="baHnPmii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B681F0089B;
	Sat,  3 Oct 2026 14:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791038166;
	bh=+jTba1Wq7wqP3/v0NRACm5xQEcoI9ajUiOrOr3k69ys=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=baHnPmiiO2WTh/G52FEGofYE/l7UGrAXvcNG6KlUYhjrvgsETuJlhLx4kDGAldAsP
	 U1b3t+4T3tx9IgzuvNJMRwQyQJx2ZBRMJYnOFjo8+9P4CIqThp0zQ4w9Wkoj0fhtzq
	 lXeArZazDfDdGZ+tEJup5wzaDtIGN4Tamdg9O5z2BUPwLq/JwzzVBa7uGupaOtxJHe
	 G7xisemnUm1C7k9gtxZVhrHbVAooSCFCLG84ZqsT58sMn3i5H6UVQfIQxRdARFb+Z0
	 1ALP04yA6IqFHsrpqv8gSAVwGJH3DRG9O78LrqFbZL+fduW6hBN/My5pHVm+25wMSc
	 wgv1D7S+xVEKg==
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org,  "Martin K . Petersen" <mkp@kernel.org>,
  "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,  Kai
 Makisara <Kai.Makisara@kolumbus.fi>,  John Meneghini
 <jmeneghi@redhat.com>,  emilne@redhat.com,  bgurney@redhat.com
Subject: Re: [PATCH v4 0/4] scsi: st: Restore drive settings and state after
 reset and MTLOAD
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260929192821.997675-1-loberman@redhat.com>
Message-ID: <yq14if2lulv.fsf@mail.kernel.org>
References: <20260929192821.997675-1-loberman@redhat.com>
Date: Sat, 03 Oct 2026 10:36:04 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Laurence,

> After a device reset st blocks tape access until one of MTREW, MTOFFL,
> MTLOAD, MTRETEN, MTERASE, MTSEEK or MTEOM clears the reset condition.
> Testing the reset handling on scsi_debug and on IBM LTO drives found that
> several settings and parts of the driver state do not survive the reset
> or an MTLOAD.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
