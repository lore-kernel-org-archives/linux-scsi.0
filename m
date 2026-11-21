Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795226219;
	b=ofrssEGmQvyt9xpYjaWHEZKSyyMNCkknNsR3/t/BOxX/+AkOdRQpx96oCGPSGYie3ecF
	 aWm/nZ4sqkdEifIbKi0mTW5Qv7LPXaNxDYPWG76MUdGrihYdvavt2UcFRJ391eQP9b2R3
	 iljuJkaNqQp5HK6udqBkZJGxW7GRbl5AhXB484/3O70H1gzE79h3gYVdsDXc++JY815E1
	 q+0v5cl7iEuQoZUj/Y6zqrmxH6QRjL63Th8QT7/eK2GtniyyzO4Q0rX2x7J7rvet+2X9T
	 0DnXSqv8HXTasVv/7YhVOBMBiynuGAn3WnHLg0Cg0Js6cYdnX2+L/0HMQhRsTlpffDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795226219;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=8YU74oSWaUXyEg1JWnFYgk1bNUG9MnPuQkgEBSPuZFE=;
	b=D4mrWpEFMHWx2b5Tx2gF+wjfF7tG3QWMFjdJkUZTKGPKX7876CwjzLYT2g6J502/keYi
	 E1MpJ425NUQcKW24xG5GGr0aE6E3WCjsnKsodw1eFa1PAw6bZl/r3RQAWbPprojbOGDpQ
	 H1pc2D7OHj7pnOMKgtUUG/WJLUT3ViMqP/vBBbZ57VUIMEOdtshvf47JisUDY/RuKzz+2
	 SaJ+tI0zdTsSYHWIN9yf9xUScSePan4h4R0buZwOVJ/6C9Vb1RYxARfUMa6SVFYJPPZo5
	 pZ06XzdfjlKt6IVccbWrSJaRwhnRq7woQ/MGCHbD1yFNSlnDuXd9CjkRgNruIrjwHXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BQnQ1dKX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F862606A6B2;
	Sat, 21 Nov 2026 01:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BQnQ1dKX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D561F000C4;
	Sat, 21 Nov 2026 01:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795226218;
	bh=8YU74oSWaUXyEg1JWnFYgk1bNUG9MnPuQkgEBSPuZFE=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=BQnQ1dKX1Xxcw793fp9CCI9JE10SlzP/stIQcExIZqM2MB0LO9GUz/BWtEV/0aSEz
	 w6LX/PJFwg/fyS+naAQmogMZGd7D/CKC7RXRvfuHI1xJYhh00mQ/K+XXun6VAFrHX6
	 b8P+SWkc7Fy5k1IKoE22Kg6yR2LQ1VE0yw6a4zfYrto3trBhE+gStlIua93Sq51YJr
	 JslIxvKCcDF1eVI4d1hUn98P4Wh5OKgS7JKQIppEhhQLl4AwDO3cv63yA8LkZCU+M3
	 RGEEAx6jLBFwI5koq3GjvgXfa5lwKT8FyY5QNyk4ZqN6axQcj7w91NH0+++nIjjuP2
	 U89XwNq1bYzRQ==
To: Ian Rogers <irogers@google.com>
Cc: Justin Tee <justin.tee@broadcom.com>,  Paul Ely <paul.ely@broadcom.com>,
  "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin
 K. Petersen" <mkp@kernel.org>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  llvm@lists.linux.dev,  Elkin Cruz
 <elkin@google.com>
Subject: Re: [PATCH] scsi: lpfc: Fix format string and OOB copy in
 lpfc_read_object()
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261119170500.1514537-1-irogers@google.com>
Message-ID: <yq1a4n3oskh.fsf@mail.kernel.org>
References: <20261119170500.1514537-1-irogers@google.com>
Date: Fri, 20 Nov 2026 20:56:57 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Ian,

> In lpfc_read_object(), rd_object_name is a 26-element u32 array (104
> bytes, LPFC_OBJ_NAME_SZ) populated from rdobject via scnprintf()
> without a "%s" format string, and then copied to the SLI-4 mailbox
> request with:

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
