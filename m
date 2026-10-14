Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA9F4078FF
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 03:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950232; cv=none; b=pHfo8whdWTnNUnJLDKUzyduu6Vnj05EfYLUHA0bJ2au9cVp6jGGcpSoWWWOHSfVFm387F6A5fGY6YCqVwcVVKSusxrxmDbi6qdydHHAlOLaJ/Li4QfeZExycXz7fEsed3mEhQ+4VciG69EMgnXCNZxQD4HIxZa8ZPbaTRw/S1ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950232; c=relaxed/simple;
	bh=nRPKd/kyvamZt4BcpQwGrULMOthBjHjhRESFhKu+VgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RG+NOQA313L6q/4A0mGWAKdHlZzsqX14vt2ANiDsLwqnOohRhKNwQGJKGtLkNdo5SRfKz03e7lCD2bquQFrJyVWYYE9u0LC/wuhMt59x3/UZftLzJ5Z3j3FfkaZk2EMFvk7bmIyKtY4S0fgbm+fH+eygfrIKXl2TaTgm42z/1fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IRYN99+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IRYN99+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABB91F00898;
	Wed, 14 Oct 2026 03:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950231;
	bh=YQFj7WXFOFX1O2hnMhFK+0cA2GaW0x2iC9rfTsuSEiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRYN99+BIaFnqkI/L+WJAsKWCLfIRfsp8kMf3vrQPNhcCm85XTexStDD8oZLP2743
	 cnNEZu1S92m7BL+mju6X7bw4WznRcPp3v6bKXD7NF8PoBRC0P3zg2kq4pfZuC1zgIr
	 EiJKM3EUNvTkLH3VN1KWl3I/qkBD2ez2euQHIBOMU92l87dPFcbZbGSjy1dworqFyn
	 GAyBZs28KN0svcme0ChwU90SLNjcqG3ghYi6jejnL0IYHem2wDVeyJOJK8YCEhhnn/
	 dBiKnSQ9su8/bJOCWv/0GoBSMlzoLwsP8ZMsbKpFxrP4JUtHvremjv+E0hQg9CjswC
	 xYTMqe8hZohwA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH] scsi: core: Micro-optimize the hot path
Date: Tue, 13 Oct 2026 23:56:46 -0400
Message-ID: <179159633699.2229379.5509909679470630605.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <1ac0d4d0c06e55943e188d0dee9b6f2475715f21.1790359761.git.bvanassche@acm.org>
References: <1ac0d4d0c06e55943e188d0dee9b6f2475715f21.1790359761.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 25 Sep 2026 11:09:45 -0700, Bart Van Assche wrote:

> Every code path that inserts scmd->eh_entry into a list uses
> list_add_tail() (see also scsi_abort_command() and scsi_eh_scmd_add()).
> list_add_tail() overwrites the next and prev pointers. Hence, the only
> code that depends on the initialization of scmd->eh_entry is the
> BUG_ON(!list_empty(&scmd->eh_entry)) statement in scsi_abort_command().
> Remove this statement because scsi_timeout() already prevents
> scsi_abort_command() from being called twice for the same command by
> setting SCMD_STATE_COMPLETE. Remove the scmd->eh_entry initialization
> because the only statement that relied on this initialization has been
> removed.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: core: Micro-optimize the hot path
      https://git.kernel.org/mkp/scsi/c/d2398f2e2e5d

-- 
Martin K. Petersen
