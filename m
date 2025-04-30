Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7428235049
	for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2025 09:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746006231; cv=none; b=fRbzYIkkay2nbYGiBfbb4DYUnDlKIuQ81rkqqYVFlZ6kWKEcuC+5qR5umqf6pDrxW+deF6wwhbkYTRXe8sUv+8oTGt0YqlFfjYhws1VfXdOYJIx3+w7gsMXn+c8sp1PfmdHvn3CHKRB8x2fhmTy0TJYBKcNxp0DvrgGyRuid8Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746006231; c=relaxed/simple;
	bh=XtgqRvORrPWozkHd3wu+8pxwh28bhcQUDC7Hvz9WiSQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=o2MxDpjzaMGZsfNlpMSm7TFJM85c6BMWNXLYMDr3i+d1C+O98hLfOHvXnRfh1CXJLzuczCcZ2DOg5LcebeML38ndkRsgWL0K3yEpbl9qw5qM1uABX9jk34wkx6gOedczBqq4WLJeAwYtuP0qqzQNqC7F8oi2P1wuqCs5UbSM5sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DVoZmBqT; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DVoZmBqT"
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 61D3325401FD;
	Wed, 30 Apr 2025 05:43:48 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 30 Apr 2025 05:43:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1746006228; x=1746092628; bh=e6+T/yiIRZeSdwbVaMs14nVoOrBRt6wVS86
	ZtjyG5lE=; b=DVoZmBqTv2uEiNgbfT3LBKRTY/n0uKym4SuVZsiVro+G0VXBiqe
	x0C3v7c8VJM9l1dTsPvac69Y6w4BM0gOJDz27wRYOAu6At9Vp6BvPr/5t4ZTPpM1
	GrrMnZlEec7+cBNM7KlD63lCfBsYgTQ4rqWJEPetDuHxXxR72ex1BAtT6Afx5q6x
	Ns0J76uJdodduXfpRF/9J26TQoUO6OTgkz3vS+AxzG3dypAG5DW5p8a6+vko5Y5V
	3p41Ke3V3oqfGC3OHNTZnfkxsd06QkHagjU0L9fDcSFvG52Q1N6CwWy3jtHVwBNw
	aIDooiZJWl+kyKYT+NrZaPUz44UaFtnuDPw==
X-ME-Sender: <xms:0_ARaKVsuPOovVCIwa-6VEQZKtEilyFKkoS0GqZJgPxscnz5APjNqg>
    <xme:0_ARaGmcNP2-4vF_Ff8AA4mLTd55ZqL0OJwpgZ_0bGNVUIOTad8JxgjrXcFmXv-Xo
    oLD98pSWbogHZ7N7m0>
X-ME-Received: <xmr:0_ARaOZGGUq6b5pTYafrlPmoOJQvdOcspkwhAFVrNPgXtc-1ru4z6P73paBYg5lMeSMrebrazDy7ZS0N4-fgW8rJmte3BusI-rA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvieeifeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepfffhvfevufgjkfhfgggtsehttdertddttddv
    necuhfhrohhmpefhihhnnhcuvfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheike
    hkrdhorhhgqeenucggtffrrghtthgvrhhnpeelueehleehkefgueevtdevteejkefhffek
    feffffdtgfejveekgeefvdeuheeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgpdhn
    sggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehonhgvuh
    hkuhhmsehsuhhsvgdrtghomhdprhgtphhtthhopehnrghthhgrnheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtoheprghlihgrkhgtseifvggsrdguvgdprhgtphhtthhopehlvghnvg
    hhrghnsehtfihisggslhgvrdhorhhgpdhrtghpthhtohepmhgrrhhtihhnrdhpvghtvghr
    shgvnhesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheptgholhhinhdrihdrkhhinhhgse
    hgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqshgtshhisehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtoheplhhlvhhmsehlihhsthhsrdhlihhnuhigrdguvg
    hvpdhrtghpthhtohepphgrthgthhgvsheslhhishhtshdrlhhinhhugidruggvvh
X-ME-Proxy: <xmx:0_ARaBVAYVf6a0ChJENHbm0CxbZGjiYnP7lokulSYH9eoIw-2use6w>
    <xmx:0_ARaEnrmhkUkAa3Gqv5pULs2d-9r01OAA5W6mO5im6eNNfSn0ijRg>
    <xmx:0_ARaGdgjMw-mL_Gm3eU_rqmyUKVAdImsNJ8kotksOkk622L2jD2CQ>
    <xmx:0_ARaGEn89mprNRBVWSG-XQPuaxH2VPGlSQ460VyQHy2P0YDMbTgTQ>
    <xmx:1PARaIsVXTMXwCutb80s8s4v6dyrhiiffPcMvZsdmcI7h_gYSQ9P_o94>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Apr 2025 05:43:45 -0400 (EDT)
Date: Wed, 30 Apr 2025 19:43:54 +1000 (AEST)
From: Finn Thain <fthain@linux-m68k.org>
To: Oliver Neukum <oneukum@suse.com>
cc: Nathan Chancellor <nathan@kernel.org>, Ali Akcaagac <aliakc@web.de>, 
    Jamie Lenehan <lenehan@twibble.org>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Colin Ian King <colin.i.king@gmail.com>, linux-scsi@vger.kernel.org, 
    llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] scsi: dc395x: Remove leftover if statement in
 reselect()
In-Reply-To: <41bc286e-6e6b-4ae8-ad6a-3bdf56cd172b@suse.com>
Message-ID: <bd660f83-434a-85dc-0037-7830f58acd6f@linux-m68k.org>
References: <20250429-scsi-dc395x-fix-uninit-var-v1-1-25215d481020@kernel.org> <91ba6cf2-ca95-1ebe-837f-ecc89f547ea2@linux-m68k.org> <41bc286e-6e6b-4ae8-ad6a-3bdf56cd172b@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


On Wed, 30 Apr 2025, Oliver Neukum wrote:

> On 30.04.25 03:36, Finn Thain wrote:
> > 
> > On Tue, 29 Apr 2025, Nathan Chancellor wrote:
> > 
> >> This if statement only existed for a debugging print but it was not
> >> removed with the debugging print in a recent cleanup
> > 
> > The patch you called "cleanup" has a "fixes" tag. Strange.
> > 
> > I think it's unreasonable to refer to a patch which alters object code as
> > "cleanup".
> 
> Hi,
> 
> yes, I was unsure about terminology used for code that is by default not
> compiled, but would not compile if the attempt is made to compile it.
> 

Yes, I realize that you were referring to the intention as "cleanup" and 
not the actual patch that got merged.

I'm afraid my message was poorly expressed. I don't have a problem with 
your fix. I was only interested in the general case.
