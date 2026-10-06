Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445383D4138;
	Tue,  6 Oct 2026 21:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791322581; cv=none; b=souDiw0SDcbt5TKfesanHHgqVsxecaaleXfzajIXLUlqC8ZDnbkhUiI/inDJoauxAQKhYTidVEqkeyaafA+OBNlo3hA4EQXkzVOVEaq9vwyfY8SFj7v2t/cp8Y6+qF/Og54LJxpecxMecrDMxplu2PDQtBpxNPTGupUFx6cgQWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791322581; c=relaxed/simple;
	bh=X/u9/zQouyMql90kHUrJbahLtW+juletInkJKAapzVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tnvz1Z3bcLDLWSmqMFBQKMkeKQ9zZDkVM0wiMHyzArcguoJ3SvKCSuhrKvSvZSEO+rAMHBQ/gl2pav5hxV+XkyQxH31sC7sMXeocIdnYm/OIB70I09L3Ftqw/1iukFI9PGE6PdI/sbqjvoMXpSI39ppxLxDE27MkG0/O5K52IYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YuCiQJ5g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YuCiQJ5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234A61F0089B;
	Tue,  6 Oct 2026 21:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791322579;
	bh=9chzaMnrqzwZ9cpwqYC3aGHe9/nrZ3RT/cFttQHPTcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YuCiQJ5gQI0F/xMKPNviCEOiMLu1Zq0bYOh3dDSXpdeSHVKGQypknrOPDaKeFulDR
	 dSDyejOsi0MYzSqj1cEVwxTs+CKzsptmEHbimBpRMiq/JtFP/WraYVlRtvaLSW6qHY
	 YXBAm7HepRVB4Hxv065eVYrZQVX/EuLR13TerUYRlkZXyr9Knu+/iD+T469YgcoJRY
	 DWGUFAiCNxdKX2iEQ/janOdzGoWab12BdgTiL2zzPnbR+Oh9540ztI6PsvI/WcQSAU
	 sRK08Sd7kAKjKs7f7LrzMYjl4iljNZ5ddPvZrLRnicTNbOsz8qIF2NZ5Zepv4DYVsa
	 zeKsTTZb1ffjA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Simon Liebold <simonlie@amazon.de>
Subject: Re: [PATCH 5.15.y] Revert "scsi: sd: sd_zbc: Use logical blocks as unit when querying zones"
Date: Tue,  6 Oct 2026 17:35:39 -0400
Message-ID: <2026-10-06-1-daily-reply-0007-sd-zbc-revert-5.15@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261005150713.3919586-1-simonlie@amazon.de>
References: <20261005150713.3919586-1-simonlie@amazon.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This reverts commit 9c78f3cf7785f3de5afb3d632f0d81c2cb0e9020, the 5.15.y
> backport of upstream 43af5da09efb.

Thanks for the analysis. Queued for 5.15 with the reverted commit
corrected to 9c78f3cf7785 ("scsi: sd: sd_zbc: Use logical blocks as unit
when querying zones"). 5.10 has the same problem, so we also queued the
matching revert of cab3909d1be5 ("scsi: sd: sd_zbc: Use logical blocks as
unit when querying zones") there.

-- 
Thanks,
Sasha
