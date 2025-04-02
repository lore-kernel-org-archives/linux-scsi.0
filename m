Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB0D1ACED1;
	Wed,  2 Apr 2025 19:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743621374; cv=none; b=mfpy+VLPZOEZhEX//PQeO/xHfhcJ70+xM84DcKgYJaoLLBACOYIlVtr38bzJr2H3I6JfVgd899TlEHiyrcrCW4BB9UW2L3cpXqHu7pD30pYLO/3DQ6R90On9afXtK/hi2OYDQsBSQdjgfjFKD1o//cjtxztvZLn2//hqPeznbD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743621374; c=relaxed/simple;
	bh=0WH1sGWtFYZtIVHWq6dERmJQ3aaewZqD4RXfkPSUVwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JM2awkidhYdpL0LK69f6JNMgg1AKU35kU9HV8dPmodPYp7OdangyNC+5Q8B69o0juUzGwIrdVx8051NL5eLbLBtMa22IFmQfu1/nJ/LRSiIbh6F3yxDixNYQbJ38ujSJlg9I2fiFymxRfjP/SJDAtB9Jj8cmlAMSsai/WBzgYwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=e5B4MHAJ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JzTYmOoZ; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="e5B4MHAJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JzTYmOoZ"
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id BBB5611400F4;
	Wed,  2 Apr 2025 15:15:37 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 02 Apr 2025 15:15:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1743621337; x=1743707737; bh=0WH1sGWtFY
	ZtIVHWq6dERmJQ3aaewZqD4RXfkPSUVwU=; b=e5B4MHAJgYkrv1yYQXHRdsq0K5
	dIj2GWoH6v4eZP9M3wJES3FQWLIvg6nNfxgmCzNe/fyWm0LVFWwGr93gJ3MWAqO0
	6y0j0v4Lzz01a8FfAk7LGx5OX65JoaPTp5InvOgpVmcllduUQQRc12URTj7rWjIj
	qKlAf6kSaJKqjo6IAqZ9CS0JCuERM+hOtl12qGXCGuU6QI4JDq4R1pt19JmWRoGK
	V9R5sKhY9BZftQ3Kmp6ADQVa/6gowrOAX672B3CirrB8errvvUxJONCPimihEKJW
	Erl46D4aAhM2d6mWg8VGYv8O6ALAl0fYhJPet8n2CKQoJ702P3YGUeQ5XKug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1743621337; x=1743707737; bh=0WH1sGWtFYZtIVHWq6dERmJQ3aaewZqD4RX
	fkPSUVwU=; b=JzTYmOoZkUbUc/j5PQNdimyZWySdNdwHs38pwBAz+I2lKneGCfr
	/s9HCta1QtmKbunM/NSoXYcLqLch33En7AKXdpVpGsM07PN/WC6vTbXdY8bAD8b6
	xW/7pkorsaxUyz8D3Vt3fXXOWtMS3DGbcSXPGvhHOj57GklOhtF41SdYGIBh+C1p
	wD2VNtroczLlKdqzyFG4a7yfZb17I+YFow54u8ANRoGRjbEbf+5oxzevOBXVM/pa
	Qw7ksSQ9lt52IvdlE8OpF6FBvGzdoIQTFTYTrwAYr/S1G1jNUjxG4Tdnw6vgGF1S
	g/g8vVoKX21gwR3fexWdrRLLYWpn/+hmmyA==
X-ME-Sender: <xms:2YztZwsHUXGev0I_oUl9ZJi9QAiuz3jI4bVkuqCgBtakPXSohgUanA>
    <xme:2YztZ9f97Vte9PZfY4Fc0xOupKaTGCVQEm141WRL86rgDYVucJz4X6YTEzTGjsXBL
    yuxI3vH5uUxCg>
X-ME-Received: <xmr:2YztZ7yW-GG4UfGEacZq97iZwnafYnbOhT2jZIyGFyFmVWpDmQW1ZACHutSd>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddukeeigeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhf
    fvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcumffjuceoghhr
    vghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpedvjefhvefhjeejfeefle
    ejteegtedvgeeghfeuveevgfffueelhffhhedugffhkeenucffohhmrghinhepghhithhh
    uhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmpdhnsggprhgtphhtthhopedugedpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohepghhorhgrlhgsrghrihhssehgmhgrihhlrdgtoh
    hmpdhrtghpthhtohepmhgrrhhtihhnrdhpvghtvghrshgvnhesohhrrggtlhgvrdgtohhm
    pdhrtghpthhtoheplhhinhhugidqshgtshhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtohepthgrrhhgvghtqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtohepshhkhhgrnheslhhinhhugihfohhunhgurghtihhonhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhdqmhgvnhhtvggvsheslhhishhtshdrlh
    hinhhugidruggvvh
X-ME-Proxy: <xmx:2YztZzOCeFAxSuIaiWb8IMCWa8x9PaM54bFkCOSgSZr2oG8iLOA_Hg>
    <xmx:2YztZw8GkQWjFBFWcwv8Oi_suR38H1AquawY4UicLI8YB9q2gKmRcg>
    <xmx:2YztZ7Wq68LGcHt_f3fpVmrvT3uw8FlGQmSQ3M8YzoW28anqlOkuBw>
    <xmx:2YztZ5feL4HPdDJV7uoQp1sI9714JCRw3SnqtW5sgYXw7JPIGMmv8Q>
    <xmx:2YztZ0HM9n_NvRHVTqIif6dinptlCwb5zQ2akYWAmLcdWdahze89sehz>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Apr 2025 15:15:36 -0400 (EDT)
Date: Wed, 2 Apr 2025 20:14:10 +0100
From: Greg KH <greg@kroah.com>
To: goralbaris <goralbaris@gmail.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] change strncpy to strscpy strncpy is now depricated. It
 may not NUL-terminate the destination string, resulting in potential memory
 content exposures, unbounded reads, or crashes. Link:
 https://github.com/KSPP/linux/issues/90
Message-ID: <2025040244-onward-attain-8e91@gregkh>
References: <20250402172504.101576-1-goralbaris@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402172504.101576-1-goralbaris@gmail.com>

On Wed, Apr 02, 2025 at 08:25:04PM +0300, goralbaris wrote:
> Signed-off-by: goralbaris <goralbaris@gmail.com>

I think something went wrong with your subject line :(

Also, don't use your email alias for signed-off-by please.

thanks,

greg k-h
