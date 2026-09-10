Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68853672A5;
	Thu, 10 Sep 2026 01:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789004931; cv=none; b=M+upvGYB/MiqdaSjPh63KSE4eNDcWOLSIaZGVPBUeA0NN5vV3d0TsER0ziCWEs0NYt0IXJCRXf5Bu0dAAS2gM2fU/lqSl9VyJ+Yh3et2WKZaFFfSGM/1V9jZnk340tSZh+uhijn2U0KemtBDEGWjRFTC3Cxk358/F1FPBPYcVoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789004931; c=relaxed/simple;
	bh=yBOgzpMMrxtv1IF+gmXxYrYjjbUQflXBd/lhjKk5ONs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=ZSp9ACgAvH37cdHDWeYiNGc9tFnjIc5LVK7uGtuamgqE4/CA3xfulLMf7vP+JyryXjolBzOjSYdN8boc0B2gV9k+YsBWIt6ZW0Lohtx2umvHxcNl1oJHjeKXha4kvCABAYC6GPa3110NVj+DM/HGhKeTHFsrnUsMAsSiypgLGBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPAMNLHW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPAMNLHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922061F000FF;
	Thu, 10 Sep 2026 01:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789004926;
	bh=4PyBsnf1+ULG+pXM5gmo2KDbb1r7rtj8XmW5dqJR55k=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=BPAMNLHWYVVq/e+tKmyBGho/U2EdZc86zWdJpbWW4th70md5bOW7e0dl973NPCxgV
	 KtRA6lD9fuYgwknMISYElvlM8VI4G9q4/EXEVoMUArSdRCil+3+XJy/aERYh6CnGwU
	 aHYzCo+VupcRtQ7O1wli2FJrM2bycsRxQUbQzDdorUQiNnZLdjHZtRupOHi5A2QtPR
	 /z8Jqwtd9Flqny096NaU6HaDmW69c1FpopBnfBjK7cpp3XxaTs33EPUfxb7+cl5fW5
	 nYCVJHwGTKURYGcsdLMc5leiHdSJ+NcYMHEez1Uo4DTN+dNDgSJk4Hcl812i9Yke+N
	 I6OXWnNs3JuXA==
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
  "Martin K . Petersen" <mkp@kernel.org>,  linux-scsi@vger.kernel.org,
  linux-m68k@lists.linux-m68k.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: zorro7xx: Use individual zorro_driver_data
 structures
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <7deafe83754415c5beb280f3c1808e153029e890.1788169600.git.geert@linux-m68k.org>
	(Geert Uytterhoeven's message of "Mon, 31 Aug 2026 11:49:20 +0200")
Message-ID: <yq1pkylc1xp.fsf@mail.kernel.org>
References: <7deafe83754415c5beb280f3c1808e153029e890.1788169600.git.geert@linux-m68k.org>
Date: Wed, 09 Sep 2026 21:48:45 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Geert,

> Using an array of zorro_driver_data objects and referring to its
> elements by index obfuscates the code and is error-prone.
>
> Improve readability and reduce code size by replacing the array (which
> includes an unneeded sentinel) by individual zorro_driver_data objects.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
