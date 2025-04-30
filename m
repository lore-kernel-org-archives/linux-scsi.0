Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64B411187
	for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2025 01:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745977012; cv=none; b=rd1jhl9+CjkbzwUFx9z8NIfgjwafh5lEdA8zRKzby0h4vKgtomn1KSlXvBRpf7QilkgzSddvgV8Iu2m+4M3Znyrk+LtyKjgfrAU8Uq1bjgxeFDb/3cthyoLgIsEeTT8k7WnqawJE/vUuVlB6CPMuPGRuMNFTP8P+Jebflq1Yyi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745977012; c=relaxed/simple;
	bh=8hIrgiEsPsWuoBwRtZoK8cMgMpFtEq4I5UiSjoqyvgU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WFac1aoymZoXAuMdTLl0/DssJZI3W7VivKfTv9Z23T6+T0eshp/dSnRn0HwHX+0MjQIloXRUndlNJVHemJZ5Fwxf4EZ1PTQjOA+KQi875K8U+8MgMUZtImDUT/shBNtJbuwncafl9iaQdmWljT5632J3giWeXHdx09pfuzJnTic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nNNn21xL; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nNNn21xL"
Received: from phl-compute-12.internal (phl-compute-12.phl.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8B9852540219;
	Tue, 29 Apr 2025 21:36:49 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Tue, 29 Apr 2025 21:36:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1745977009; x=1746063409; bh=lXtmYKmM+kLolKVr6MLT45PItAjhInNaFFT
	UQ66S0vY=; b=nNNn21xLHwds027493PbUXZFdwb7RM6yKPq7+j9yt2nc1GICHci
	sfCWY4me2ALWZHf3ASZpXsbr/t1btceANo02pEnyA0AKehCH+Cl9WOSOvV3yxMiG
	ha7MI+Y7QpJ+jD4RjSqE5popyrN+wSGeZqTx/BegEUeTItG29PlU7QvugoxYpL3k
	euIHh0Bk/mL1ZJlqqpVLghxrWFsVu46Jl+2ZQ2EXa8nEJ2klpmeL/SZ+Dr46R5rc
	fFhI8fsSS9BGMRyAbPODsWLt16CtQ6T2Bx5ijm4ct/qwOspUY+CjLpPhbWxEnt4P
	OXTQYyuVXDivZ0fufK4iwUlCbVXM68TI+ww==
X-ME-Sender: <xms:sH4RaPYSD_Il7S0M2mID4NsGO9mL3qgqwizUVYdAmVDGvdpWOhUVow>
    <xme:sH4RaOYyMrLopypTHH84rdBJVUttHWx8vp9nvjEsz3kPV91R-lqJQBa416gjxlagz
    fnTaXmUJ7JbOukhJIo>
X-ME-Received: <xmr:sH4RaB-oglDBVItNy6ZX37oIp-EcnybmsTkW0EOF4cc72jwnUEntV6_r0soyhQoohiZiMY3aOGUxdOupnGZsW0U7_3VBGY_Ag4M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvieehfeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepfffhvfevufgjkfhfgggtsehttdertddttddv
    necuhfhrohhmpefhihhnnhcuvfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheike
    hkrdhorhhgqeenucggtffrrghtthgvrhhnpeelueehleehkefgueevtdevteejkefhffek
    feffffdtgfejveekgeefvdeuheeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgpdhn
    sggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehnrghthh
    grnheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepohhnvghukhhumhesshhushgvrdgt
    ohhmpdhrtghpthhtoheprghlihgrkhgtseifvggsrdguvgdprhgtphhtthhopehlvghnvg
    hhrghnsehtfihisggslhgvrdhorhhgpdhrtghpthhtohepmhgrrhhtihhnrdhpvghtvghr
    shgvnhesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheptgholhhinhdrihdrkhhinhhgse
    hgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqshgtshhisehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtoheplhhlvhhmsehlihhsthhsrdhlihhnuhigrdguvg
    hvpdhrtghpthhtohepphgrthgthhgvsheslhhishhtshdrlhhinhhugidruggvvh
X-ME-Proxy: <xmx:sH4RaFrbJM5lV8M-uzGSDXczNSRgvq8nG6xeCoGQy58JuqJSu66sWA>
    <xmx:sH4RaKoFAGK-hVmcVkDZ6SG7cGE86ZEn1VSjDCzts4bBgpV4AgGNBQ>
    <xmx:sH4RaLTBt-QfFvpxmM8N8ELdlERkiWQIfK9Lr9_AS6vsfSC3GV5bcA>
    <xmx:sH4RaCrD0pYPJCa1Kb6pk_WIoHM8j4kVS3ysEFBxbX9cWVVE5t-Zaw>
    <xmx:sX4RaOzBUmJuu7VnfZCKdCdlSHfwxicqfMAmiHo7SoiXYBeHM08ctsiK>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 29 Apr 2025 21:36:46 -0400 (EDT)
Date: Wed, 30 Apr 2025 11:36:55 +1000 (AEST)
From: Finn Thain <fthain@linux-m68k.org>
To: Nathan Chancellor <nathan@kernel.org>
cc: Oliver Neukum <oneukum@suse.com>, Ali Akcaagac <aliakc@web.de>, 
    Jamie Lenehan <lenehan@twibble.org>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Colin Ian King <colin.i.king@gmail.com>, linux-scsi@vger.kernel.org, 
    llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] scsi: dc395x: Remove leftover if statement in
 reselect()
In-Reply-To: <20250429-scsi-dc395x-fix-uninit-var-v1-1-25215d481020@kernel.org>
Message-ID: <91ba6cf2-ca95-1ebe-837f-ecc89f547ea2@linux-m68k.org>
References: <20250429-scsi-dc395x-fix-uninit-var-v1-1-25215d481020@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


On Tue, 29 Apr 2025, Nathan Chancellor wrote:

> This if statement only existed for a debugging print but it was not 
> removed with the debugging print in a recent cleanup

The patch you called "cleanup" has a "fixes" tag. Strange.

I think it's unreasonable to refer to a patch which alters object code as 
"cleanup".

I also think it's unreasonable to put a "fixes" tag on a patch that 
doesn't alter object code (for any shipping config, for any supported 
toolchain).

Those assertions could be tested automatically by CI. And maybe that could 
prevent this kind of regression.
