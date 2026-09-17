Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D8C392825;
	Thu, 17 Sep 2026 02:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612170; cv=none; b=jIxjsjJkOHC8+U2QGu7SqA5cY7GGIdeKTjjfJkTpIQvEVoy3OwzVa8jzCnJzUpjLT3u3ReAt2MDbSPrtoy5V5P6pfBmlWMT+xdWuF9E7I5y81xL3fNsJ13sweHYsMrYfG8STsjECaaz/6xune5IWacaOHbi8kvniZ1fwtWGe6/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612170; c=relaxed/simple;
	bh=gKCf9G1OziX0p9Csqvkd7+kJuhpu6eAUnKhLv5d9diw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eoZ0drHrct/ynQ3Aq3KQsLbclrL+89alhWLOIDlC3n0qFF0gL9F1lm1NJXHYadxQtpPFMppsXNPZcHObYYNakcRpIyb4/FZkONGh3SMr4kHY96Lu6x6mqZHN793PD4tN9gET/b0PTJjbS2Duht0D8Hm7rMRUK445TFXm8NWPLpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ceN61Dhc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ceN61Dhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1261F0089D;
	Thu, 17 Sep 2026 02:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612153;
	bh=fEVAPOQk6jwt+Jf+SkWTcogcQHa4kbYgmMZhQ7yy+3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ceN61Dhc7mUBHHP1sN8XXZmBWqGbSG0jJT1avrRETIx2I+xhVUeNazoiKcClM89lr
	 iMYw0J2l6lRcvUDxjkiUxMjOeJPd5/aC4TNb6lDzSXjAG5q131Rt1KNzKxavIlkZ1p
	 JoZ4L6B62xtTTfyfKMkylQwgYXyG6tnsaays5GAZ9dbYSd6QAPI4MppOZfKGzzrirT
	 R6LvbafM8XwYBBeNWgRZOgYYjKScbZcTCtVr0Jkh26bqNxKBe4L7QlknigFTgh60P1
	 UXHNcO4Md9JW5G4lF1MFmyDhCIZ5UqpDBy6Ja7Og0vW0tfYMo9VCOyaBxoi3f0uL3X
	 a4hf73YMlMGeA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: stanleyjhu@google.com,
	beanhuo@micron.com,
	beanhuo@iokpp.de,
	James.Bottomley@hansenpartnership.com,
	alim.akhtar@samsung.com,
	bvanassche@acm.org,
	can.guo@oss.qualcomm.com,
	sumit.garg@oss.qualcomm.com,
	jenswi@kernel.org,
	"Martin K. Petersen" <mkp@kernel.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	op-tee@lists.trustedfirmware.org
Subject: Re: [PATCH v5 0/2] ufs: rpmb: make RPMB usable with OP-TEE key derivation
Date: Wed, 16 Sep 2026 22:29:02 -0400
Message-ID: <178952247934.2757716.8897400080333552916.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831154804.719528-1-jorge.ramirez@oss.qualcomm.com>
References: <20260831154804.719528-1-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 31 Aug 2026 17:47:59 +0200, Jorge Ramirez-Ortiz wrote:

> This series makes UFS RPMB work out of the box with an OP-TEE that
> implements the standard eMMC RPMB key-derivation flow, without requiring
> any fundamental changes on the OP-TEE side.
> 
> RPMB provides an authenticated, replay-protected storage area whose
> security relies on a secret authentication key. In our setup that key is
> never exposed to the kernel: OP-TEE derives it in the secure world from
> its hardware-unique key and a device identifier (dev_id) that the RPMB
> core hands down. OP-TEE's implementation targets eMMC, where dev_id is
> the 16-byte eMMC CID, and both the fixed length and the raw-CID layout
> are baked into its key derivation.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/2] ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN
      https://git.kernel.org/mkp/scsi/c/a8a34238e5e6
[2/2] ufs: rpmb: use a fixed-length RPMB dev_id
      https://git.kernel.org/mkp/scsi/c/657eff806d38

-- 
Martin K. Petersen
