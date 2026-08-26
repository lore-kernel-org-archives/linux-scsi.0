Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C704570CF;
	Wed, 26 Aug 2026 15:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787757630; cv=none; b=dbBELJTI/ivB4qX0gmDWnloYNgitA7/Z4QyoYAzmU1gR/mmYW34d5kFsVdGqUsVmTjvSSC9pYimb3n62LwD5LgL2TrOgNGUyYv2C+46f5Rdry9RSXd7eo7As81A6WoeEYERAOLzGPPxzSm+mY8dD94MnZw3hLPGWIbS6JuQEWVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787757630; c=relaxed/simple;
	bh=KAP+XpaNwe/g2ZaGkVOOmCGfUVEdO9UWJ91E5dQQH5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ua/uYC6E26rmOucYZlMv2H4X7/+idTDE+oPXsL+FARlKB95c1HfPXt+1etI+AN+/qtDUSXMKr1YdCFjF5sUbIa4xxeMtT2WgQ6o1CNoInFWRSKc9cCDOIMzSafVdDDB3K5BnsZ5TddhIwPtRoxndYo7tLI3tU9nenfhoXIJCmUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXhGbyaN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXhGbyaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE98A1F00A3D;
	Wed, 26 Aug 2026 15:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787757628;
	bh=UDJA46HMCYA52lpprfXaCwJh8TaC20qdfK34ztzWZ3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXhGbyaNEVu9UgbbM0NjeUjlaDhKwfPlj9qiaTgLvOk5WHazSlz0N38udA/rFAoj0
	 c64j4AZERIP/PAmJekyjOA3z7S7THYjYNi8EZSlw48Dh93D74iIKQgpoDvzdNCGac9
	 PQq1LDOqTLUgpGftUOBfazvKL5VIiWNEJxh4I5UPyY3Esg5Wu+QQGmyDlgIJzBrz/+
	 7B07IH9S2MO8xy5aucNEDY96fq4+o63PUQYbmT6WewssRaCk2A2pY6UvI6U78+jdbY
	 //14alsv3cFzyGMxpRKB+pl2ePA7YVZZ0DdE42oe8ZVzHdvx+h6qMaNwgMHLly/6hg
	 iYvJ1WYFGZ++Q==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: doubled@leap-io-kernel.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <mkp@kernel.org>,
	Linmao Li <lilinmao@kylinos.cn>
Cc: hare@kernel.org,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] scsi: leapraid: fix firmware log mmap lifetime
Date: Wed, 26 Aug 2026 11:20:14 -0400
Message-ID: <178775714074.3862282.15182194686976756373.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814033845.2971706-1-lilinmao@kylinos.cn>
References: <20260814033845.2971706-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 14 Aug 2026 11:38:43 +0800, Linmao Li wrote:

> The firmware log mmap path has two related lifetime issues.  VMA clones
> drop Scsi_Host references that they never acquired, and device removal
> can free the coherent log buffer while mmap is still setting up a VMA.
> 
> Patch 1 gives each VMA its own host device reference.  Patch 2 claims a
> temporary mmap activity reference under the adapter-list lock so teardown
> cannot miss an in-progress mapping.
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/2] scsi: leapraid: balance host references for firmware log VMAs
      https://git.kernel.org/mkp/scsi/c/970f69b6bf71
[2/2] scsi: leapraid: serialize firmware log mmap with teardown
      https://git.kernel.org/mkp/scsi/c/00b7c8d4ce44

-- 
Martin K. Petersen
