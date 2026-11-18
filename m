Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977424;
	b=A+CP6ifGzP3JdEmiCuOH9vDGxE2z2R7NNW3DEyw+tIKqDldyJfRjCU90iu/6jBOj8KPW
	 vA6OKM1j+fRW6m/e6bnqXeeNMbrKtCvTuL4xOiKDubR76ZTAPggeAcMI5V9OFcDNue19s
	 YJcMJ4veE/6l8M21Vgwgo9VdaxlFUltmEuqFYVP6dXe/6ZpLMOeu8vdbHsJDHPWDFXTt5
	 qUtGrlRu2gUwfmcjpmz3lEsoOFCuwjmHCHmhT8P2+7e3jipPG5OEp7kP8un8NP2ytZzKS
	 Y0kLzK28Ylj6A6/DJnH0aDPPqzkhJJWqLljYZ332ClU2+TqznGffPj2XvsRawUbCAOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=rzp3hcX/FXKZusoPJLjI3ICrBSw2UzLr4nYO3kIebBE=;
	b=ZrT2uyYWX41lqwlUZ7yqDtRdrErCRgLu+bNtxIG8ayQpMU7C/cYFZ8e1fCtl3/LnCrVi
	 1taEnO5FxmwLHmjRi1NJccLu+Vy93kDFQiC430JrOAo0cjxbmm5es5026ZrrbMA+HlRsU
	 jYcxYpX6DQzOdLD0XFD8QMMqYKMZXUMZ6KrNgXPePOCaQWK3vLNZG+roIY9+MX0LJ8f/+
	 mQKwXukM8UOKnYFDxamyYL6hsIJ6BhMMccV4cXDWFmw+5WpC1veZOyhZCUh/jEO92xnBs
	 PFnC805eOG9AcJ9R38VbRXbzuly15jJxx/K9S26k4xGzBNzoN1ppAVprFfONzosywmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U9d6i9fY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AD3606A882;
	Wed, 18 Nov 2026 04:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U9d6i9fY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DDF1F000CF;
	Wed, 18 Nov 2026 04:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977423;
	bh=rzp3hcX/FXKZusoPJLjI3ICrBSw2UzLr4nYO3kIebBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U9d6i9fYE7bPM5Kz8gqHOJW+MmgHLb95xUPZ03zOKkYEq9MfTedsDNSvLinm84CqK
	 ZEONdmfdUv7zI20Oe1lUS3tqeY3ifj3LoRvwQxAwShNHCxDQ4Ur+XpNmgkrEhMzRps
	 v+i2BiUeuZeZ5fC5b6FQxIBH0h5HW9Z1NjlX7put/7DqvRLgHR7FcQnQWk4h/JXvzc
	 Hu5XPQJQwxCbg7pbFjIcff5zEe33CJiG8o+sdPEcUIV6dG/KVVA8R7baHHmemOIFRp
	 vyGZIEMdDM7KNtAYh8kRAdRG2b/ROzzcDna/Okn/OfIj36TsTF1pDJeTMMNWzLVNAs
	 KPhxOL2blnysQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: james.bottomley@hansenpartnership.com,
	linux-scsi@vger.kernel.org,
	shao.mingyin@zte.com.cn
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_transport_fc: reject truncated FPIN payloads
Date: Tue, 17 Nov 2026 23:50:14 -0500
Message-ID: <179485091822.1479907.10517928234355213712.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261031222243820vSs-SXTIpNSHpWeC2dJ38@zte.com.cn>
References: <20261031222243820vSs-SXTIpNSHpWeC2dJ38@zte.com.cn>
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

On Sat, 31 Oct 2026 22:22:43 +0800, shao.mingyin@zte.com.cn wrote:

> fc_host_fpin_rcv() computes the length of the TLV area as
> 
> 	bytes_remain = fpin_len - offsetof(struct fc_els_fpin, fpin_desc);
> 
> without checking that the payload is at least as large as the fixed
> FC-ELS header.  For fpin_len smaller than the header size the subtraction
> underflows to a huge u32, and the min_t() on the next line also reads
> fpin->desc_len at offset 4, which is outside the payload when fpin_len is
> 4 or less.  The TLV walker then parses memory that is not part of the FPIN.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: scsi_transport_fc: reject truncated FPIN payloads
      https://git.kernel.org/mkp/scsi/c/db1fe578b7ea

-- 
Martin K. Petersen
