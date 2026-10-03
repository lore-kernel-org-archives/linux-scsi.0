Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B2717C203
	for <linux-scsi@vger.kernel.org>; Sat,  3 Oct 2026 13:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791035395; cv=none; b=jjOtG9C+9t9HCUtXNWXaTmvNRkIU5VoHLurwej2r2F1X7flIoLN2oklEFkyi/oMHpsWzs1NY2kqmMqtYNOa8hYE3AVmRj8+qEV0eRxNnO7T6zkHW/0FVhzluetcJ19+6DnYlg+ElanDvLk8YzhS4ml+gevrMFK3+GEhAG+XQDbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791035395; c=relaxed/simple;
	bh=O6EFXITDilFwfF91Hnffo2g5VzLo26npkLe+31KakJw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=DxAm7YcLg9hJLD3zvQUKZZSkufXTOboS6DCjVpKsttMJTrbJlWW+J3iGH+Sz41oL1/bswQRQUZR/1vWPVsXfr2/TuP2872IyhWsGXc76VUSjlSiKMGlTcC5+lfATQmKxlOr7RM13rvD+9h6RImPPeqzqPBAYqBQrYBPcKrcWFgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBTXY0Ry; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBTXY0Ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7701F0089B;
	Sat,  3 Oct 2026 13:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791035393;
	bh=26BMkq0cpmroXOgLfjDEHAgQZkkvq83pSpGupTKwanU=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=kBTXY0RyxhL2XAc9uR2P/1eM9jBNBQLRtV0RotcXT5SFWJ12B4ueLDWfv5CdjNEIQ
	 h59XM44evTU2xLIaDBSzjhgcLKxjylMqa5cOB+HQ5K7S8MiVkxIkKPGf+gJjMCJYsw
	 e8wrb+2q26FDD38m4j14h1hBZq2lD9gr8NTZ9G6pQuegYzdB/4AcxUIltvs4DAskcu
	 EkV42OUCfMFat2x2qsVYrP21E9+5HWzkJuz3J7A1FVKplVt7+k/oDl0t+/MFo9tTLy
	 uxKfZCIh61vXuUI502/7qXXRSmO+ojCLKTNV/dY6iPK4SbykDWjUO9mJwKgfx09CTm
	 QWmSkK2SMt1jg==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org,  John Garry <john.garry@linux.dev>,  Hannes
 Reinecke <hare@kernel.org>
Subject: Re: [PATCH] scsi: core: Micro-optimize the hot path
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <1ac0d4d0c06e55943e188d0dee9b6f2475715f21.1790359761.git.bvanassche@acm.org>
Message-ID: <yq1ld8elwqy.fsf@mail.kernel.org>
References: <1ac0d4d0c06e55943e188d0dee9b6f2475715f21.1790359761.git.bvanassche@acm.org>
Date: Sat, 03 Oct 2026 09:49:52 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Bart,

> Every code path that inserts scmd->eh_entry into a list uses
> list_add_tail() (see also scsi_abort_command() and scsi_eh_scmd_add()).
> list_add_tail() overwrites the next and prev pointers. Hence, the only
> code that depends on the initialization of scmd->eh_entry is the
> BUG_ON(!list_empty(&scmd->eh_entry)) statement in scsi_abort_command().

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
