Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C17A3D6F
	for <linux-scsi@vger.kernel.org>; Thu,  1 May 2025 00:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746058805; cv=none; b=ZVUnPARAYOzTWmZhjdIv3FSgcdR3lbeHVex1vqC4JYV40+PPNxiPLxzgSHVoTI5oF55Fj59Y3RmpXSjVUFaSJqIQecoeVuGgsQ6seLWNfmBhBwrR3WACPSqzdUfSiZ78mq3ZNhrGuWsGiDOL6c2LOR/VD26ZN4X9qSyZD+CZzm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746058805; c=relaxed/simple;
	bh=/46Q97vcy/33zGgkHbh7iEVragIn3KetTP89aed2zxg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cs+kTPYfaObeVN+jy2g71duOJheQ+RbzYLHmesUJvfNaq/ei2I441Vsud0eGPaaZWWsr/RfmKVD2C0FIA49QeurU4vHxJrTlcrBlaihXHxzE/DqdVQImyj1ko/MvM/2dsAgcNBvAoHdWcsR1my6zmMMywm24Dmb0mJlKzxgWFU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QFHocaF2; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QFHocaF2"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 07275114025A;
	Wed, 30 Apr 2025 20:20:02 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 30 Apr 2025 20:20:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1746058801; x=1746145201; bh=/5EPHsjwidgwd+da4u+ZT6nCp9gLDKf6842
	v7sb19qk=; b=QFHocaF2YzTUp7w8H07S+Ot/pOK5t/iD4XNDlcpz7upNRheve34
	qsvSA/cMtvH9Uc0U+Ub0Uizor9H/TCPj9kHX18tfi7lDoBIH2Vn7xtxFPRX7NDhD
	cXn8UkfeJN+0SkbFpRxnoWOQ8RR2Hhc/SoCkSmMQPchB/B7gKJEzjpq+guLI5INm
	cAusnVzyFl2Q7Qv+3tk58eqEcSM3GbZPprklMUZ2UNm5cLlkOXV9mPqPFC2QB5sE
	c/HBCdawobTFOPGCs2IL/B34eBnFBtFgkI8YceUStnTng1ddldfu0D7A5clsMDS4
	mupdjjm9vqxdVzgUceMJIZlKG6VYBcc9SEg==
X-ME-Sender: <xms:Mb4SaK25KeIILb10NEoqYQ2Zq1haCIRBp1_E9Z8PPQgiEy0_G524MQ>
    <xme:Mb4SaNGYB0LWmvj1_0TJMzAJi5YMW_aC7GSesJGK5htce1emFbAfFXPeg5QuwBKxh
    sudtvS6-jZ_jAmLh0M>
X-ME-Received: <xmr:Mb4SaC4vlAZQnPsUWPhHOGEGnHck5LI9fWajqQiQwdAC2stBelLZSZvCGFega7YHSQLvasq_x0Jh23PddUrgRo_qoGLhPKk8FOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvieekuddvucetufdoteggodetrf
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
X-ME-Proxy: <xmx:Mb4SaL3WxpZT9vEmf1ngsv79rVHsOy1cQljiU41H-d0kmFlDYJK3kQ>
    <xmx:Mb4SaNEAF_CR6Cjj4MdnC8H_yph85c4BoHM1427ZwNZROM21gG2t0A>
    <xmx:Mb4SaE-7GWSiKZ1wAtgp5Qh6fpwpxaef9Uonlcth5yFPQVjPCpC3Mg>
    <xmx:Mb4SaClMr15tHggT73n8zeDmbqM_mkWU77OGIH2-0lvQHf9Lh6cQjQ>
    <xmx:Mb4SaKba0hnM9KLESdBdag9QDJGk3eJRk91zeLQcGykzQwPMIDHl0z6s>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Apr 2025 20:19:58 -0400 (EDT)
Date: Thu, 1 May 2025 10:20:05 +1000 (AEST)
From: Finn Thain <fthain@linux-m68k.org>
To: Oliver Neukum <oneukum@suse.com>
cc: Nathan Chancellor <nathan@kernel.org>, Ali Akcaagac <aliakc@web.de>, 
    Jamie Lenehan <lenehan@twibble.org>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Colin Ian King <colin.i.king@gmail.com>, linux-scsi@vger.kernel.org, 
    llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] scsi: dc395x: Remove leftover if statement in
 reselect()
In-Reply-To: <06495223-342d-4759-995f-f62234fb1020@suse.com>
Message-ID: <f0842307-a0e9-6e50-e6be-b25e38ca7120@linux-m68k.org>
References: <20250429-scsi-dc395x-fix-uninit-var-v1-1-25215d481020@kernel.org> <91ba6cf2-ca95-1ebe-837f-ecc89f547ea2@linux-m68k.org> <41bc286e-6e6b-4ae8-ad6a-3bdf56cd172b@suse.com> <bd660f83-434a-85dc-0037-7830f58acd6f@linux-m68k.org>
 <06495223-342d-4759-995f-f62234fb1020@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


On Wed, 30 Apr 2025, Oliver Neukum wrote:

> On 30.04.25 11:43, Finn Thain wrote:
> 
> >> yes, I was unsure about terminology used for code that is by default not
> >> compiled, but would not compile if the attempt is made to compile it.
> >>
> > 
> > Yes, I realize that you were referring to the intention as "cleanup" and
> > not the actual patch that got merged.
> > 
> > I'm afraid my message was poorly expressed. I don't have a problem with
> > your fix. I was only interested in the general case.
> 
> Well, in general I think such code is problematic. In general I think we 
> should use dynamic debugging statements. The issue seems to be of 
> terminology. However, we can hope that this will go away and become 
> moot.
> 

I think you're saying that the general problem is the style of the 
debugging code that everyone disables. I'm afraid I don't see it that way.

The general problem here is a bad cleanup masquerading as a fix that got 
merged because of a missed opportunity for automated vetting.
