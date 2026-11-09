Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196541;
	b=beW5QEefVeRFB3tE/4oBHgkRBiu9c1IGwvT9Ya1bxnFg3apDF0gT+E5pROvqAPEpckHb
	 g3aij7XMiDkni+fVtcAxGYIZYQiCmfB0av6xyOCImQAuGbBlmY4RDZOHoayEXkm5VD09k
	 70t9a+yKa5dvbicm4F36r88532MyQMWaLtX4RqbTWx/GLRDRlSJPFJO6XeeMN5rAtpXOD
	 caMxYnZvl+sa5Hkh2+cVGymbrMkvDB1H/9w4i8ANCdsX4jMZug4Ap4cov6500WpZMWgfb
	 tR0a99w72T4v5ICZNPcD8kYRXQi3BSrFHLnebF7r+X5LujDYjhY1/ldB/sz7LfmIhsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=9DZrYBou0wg/1Gb6dnwG2jGA12oGBL9l4V7OLZB2URM=;
	b=bkmjSzIhEZT0oBS2crf+LrDnwSEZpv52sgTJC8m5QtAROINjwuSq0rbBvy9nSPRqNIfN
	 rXS0c32UiRu6W2BOMxfDzXexQZjwSlncvXuDL6zAkgJ+vCgGX0nLoQuvOAuTx4TSKUlp2
	 k0gayb5ntKWFqjV5KiwLnRTxwDNyutHaZj3U7hTfRBL0xWJNMt1XHVJ0ZqS+bgAtze4rY
	 gxluMr3AjAOgRXQ+Q7yC7fDW0tGKMdCHR0N4m5tuYgJWc6qbgdLKgggzijzO9CQVf88NP
	 c0xnDxlrUwi/Zk6/6SdD/vWE02/HAzkJw303sKyihu7syldSCouumdnfkd1LLtbjI2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OKsWuHLw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CBD606A336;
	Mon,  9 Nov 2026 03:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OKsWuHLw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0D91F0089F;
	Mon,  9 Nov 2026 03:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196541;
	bh=9DZrYBou0wg/1Gb6dnwG2jGA12oGBL9l4V7OLZB2URM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKsWuHLwF1a4++WPxUlKfVMHDeeuRXFptf5fU0hG2huagtkYbv3QjiKs/ZgEsW4oK
	 FdcatqkYAoL5gfNOOR7GTFCoZaDv+WdzFIP+6UZapovQlHDveIaNp5elP4zWf9IAqB
	 yns+eUv4R2sBOps4jUkMAqmOzz42VsoLrOvSVqXlvQOEONmyHtJQsmoFGxQkKbIe4t
	 GBUJWW1nrJnnvc+LTrkuIn/MbML2wC/9fE+RPMu2sGp3B1cHXVEYixXXp5i3h+DvsY
	 DEKLVH6ZczYkHypWalWT+vF7Y2DivtpjyhXRXNroUngFuvgYNw5TuQrAj2T32yUUJ5
	 IS6098zGRrq6w==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: mani@kernel.org,
	Joonhoe Kim <26rote@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: qcom: Reprogram ESI after a host controller reset
Date: Sun,  8 Nov 2026 22:55:22 -0500
Message-ID: <179419615233.1941224.7749122326945889734.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022165006.1275-1-26rote@gmail.com>
References: <20261022165006.1275-1-26rote@gmail.com>
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

On Fri, 23 Oct 2026 01:50:06 +0900, Joonhoe Kim wrote:

> ufs_qcom_config_esi() returns early once the ESI interrupts are set up.
> ufshcd_config_mcq() also calls it after every host controller reset,
> which clears the ESI base address, the vector mask and ESI enable. After
> the error handler has reset the controller, the completions then arrive
> only on the legacy interrupt while mcq_esi_enabled stays set.
> 
> Allocate the MSIs and request their interrupts only once, but program
> the ESI registers on every call. The MSI message is not cached for
> platform MSIs, so keep the one written at allocation.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: ufs: qcom: Reprogram ESI after a host controller reset
      https://git.kernel.org/mkp/scsi/c/b3da73f09499

-- 
Martin K. Petersen
