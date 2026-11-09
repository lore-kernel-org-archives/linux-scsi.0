Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196546;
	b=y7Zgf3VaO6gyMnnsNGnsju3HO70dg0xa90K1l3ab3IiEcxnfViEPf752fZcZNaQruxhY
	 ToQA3gzyegsvUedlUyXIvSvhrNwrHiQPZ4E2Pog8nEco0Wqh08HiWvV+ekmx7CbLngXbI
	 jZYVjGJnQ0Y/tlxJ9BEnPOX+TM9Ht08fRok40h+Hd760X9baPr7Q/RIgPgQfnPtd+whpH
	 +Z2K48yn2Nwy+6wZVa5drF3zzb/Y/OpxliHYTjIDd0/IM7mp+0UPCuDEHCaGhlO5O2iWM
	 +ZjXTV9uFnpVoH6OF4YNnDkCVHuhjCpOezXtk4kwMAYRQ8/dobFvmoG/ZpKjaoOVAjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=2Hhffl64yBNN25IaNaa/RCK/SwEV54eln5oc5w+qX2E=;
	b=5EkGKahiYJRudhBsVTi7HEadB7H2tD2al9MtexxYFJ287Y1QLB++fWLPg6DQhMBY9cyr
	 e+Mt90rkUG15uQjOh9xsKiGRL5fCL2/QrlxEytZJghYs80iMsTYuww5v8LCg8egjK2kLT
	 OQV6VZJSb2Vy/OZIYXTPK1m/GZLyq6+r04qGouN9EeHyKHK31IrTG+S1xCY8M3qAUFUJ7
	 raq2biZIeFowrOAFNSVRLtsQo03aCNhxF/jqtEQtZhK7gNT9T8p6YNBvdqlJ6QaPYTZ+s
	 Dugll6FCW9w1EIv5zU21q3iWcZK0bP2aIqo5bPqJLMxzrsJES6EKGKfJwATJhDuldiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aqkMQrMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B34606A33A;
	Mon,  9 Nov 2026 03:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aqkMQrMk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06111F00902;
	Mon,  9 Nov 2026 03:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196545;
	bh=2Hhffl64yBNN25IaNaa/RCK/SwEV54eln5oc5w+qX2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aqkMQrMk8aimyTm29gZ5sTznqObxHcjn7VVB1WnL50PA4V3HxUXA1HToxtX1PjgCj
	 NrXhG1pmcnswlT27LpkPQvY3UJIwG+Q0tMEp2A1WHgUEwkRZOOstUGP6lFS2x0CnPS
	 D2gWxMmUW3a5z3wyynNWgAvYMJ+5D5QOopwncaos/ZPwx09AqK0H1bq3jVKF0I7e7O
	 bU3l7Tv6NNIL1YQ34CykZkI3jk/ciZaI6tDqSc5DULMrnAYjws57WVgPD+7n4NePTq
	 f5/rlpql7R8XWAv1mK8JWZQMOkBptaLt7zUKBmElP0CNaZiPgt1wz9TYysIf3bO2xT
	 atjmX54vykZAg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	"Milan P. Gandhi" <mgandhi@redhat.com>
Cc: linux-scsi@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: mpi3mr: Validate reply frame size bounds
Date: Sun,  8 Nov 2026 22:55:26 -0500
Message-ID: <179419615243.1941224.17714090451921058754.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105122401.266559-1-mgandhi@redhat.com>
References: <20261105122401.266559-1-mgandhi@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 05 Nov 2026 17:54:01 +0530, Milan P. Gandhi wrote:

> Firmware provides reply_frame_size in dwords, which the driver multiplies
> by 4 to compute facts.reply_sz (u16). If the reported size exceeds
> U16_MAX / 4, the multiplication overflows u16 before assignment, causing
> under-allocated DMA reply buffers.
> 
> Furthermore, several paths assume a minimal reply frame size:
> - logdata_entry_sz calculations underflow or hit zero when reply_sz <= 20
>   bytes, leading to zero-size allocations and divide-by-zero crashes.
> - Unsolicited status descriptors and fixed replies (such as struct
>   mpi3_iounit_control_reply, 64 bytes) require at least 16 dwords.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: mpi3mr: Validate reply frame size bounds
      https://git.kernel.org/mkp/scsi/c/e550f2b2b4aa

-- 
Martin K. Petersen
