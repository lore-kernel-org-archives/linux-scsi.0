Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792812314;
	b=tZ2PFjiz/SAbHzGc0c0TSgxu8TZKw4ktlAeDPdOwX0nE/tye4ovLgQaO7swTANxMpRxm
	 1bd/aaIuYaB0JL/bBt413fGn+xF0m0EZZF7qnlh1VbLHXgXUQzg6DH6oMJ4ogoIx7XJql
	 2mdcmlT8wMD65GvfR1sdHY0g0VNof1O5X9LrwL5eZx2SMIt53myxMD9hRiia97L6pgk49
	 W4QWlW1RADzWiRQU8srizovM2QgQoeznF2BzT22/HDkcD0IPxzDNVEHFSWOChZCYLrvHj
	 PfIFCrnXL/Ms17ATupUXc2o3LH86qBNFXQbwfq1zDNAoi4YGQVCz5WFQx5W8kiWdAUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792812314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hymg9CDIE1USMh8o3D//XzmzBFkdoHnA2hg7kgpiXhw=;
	b=hMqBtNlkRSPVHFEOe3r//JuihRiFx6p2OtIimFplnFlKuw2uAt34f4vjRW8QhEg/aF4G
	 isYqN5W5DfyN1ZquKPZBrYKZfaa/ZBu922gDG+uUsYIVRYcSLme2zuTCYgjfSmqr5ZNBi
	 RPsf2uCB/69FoRanZEAa7RuTPcV3BWIzoHER2tYXHYGxM92j7+NNi8pRwZ1+29TMSfj7C
	 wj2bofFx4myHcbtyYmBsS6qMlxqSLePW7ip3rQ2sbzUAaJbkV4TckHwiXT+B6WhYdasVt
	 bC66f3zxP4ID8AnhD3R2ssKbiNNwEZPB/2OzzQeNbZdT3HDpFu7AKrhWDT8NgRtEOYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lsrqjSzN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2636F606A31E;
	Sat, 24 Oct 2026 03:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lsrqjSzN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC711F031E0;
	Sat, 24 Oct 2026 03:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792812308;
	bh=hymg9CDIE1USMh8o3D//XzmzBFkdoHnA2hg7kgpiXhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsrqjSzNHs5XhWvGFVXcdZ+lPcE9io5CYZk2IVTUbbTpnd5ISM/MTkqSS/xSNKJGU
	 Qoowu1jCb3gKChBV94GOJn61fl5hs98ZGZi1TPcX9ZW2NL3OVwt4kePt1JwNCBeEm9
	 aZf7QdjxUIioYjUuJaBMPzB9kIgEzKKCxeikzVu4zZda0DH1T/6HA7nfg8skRO2VOM
	 moUTUYi9JlLHrnzrTvqsRa0FrGWmlEwXBo4tECeOh9uIP377qGecV8Vad/PbgeyA+1
	 TOIqlCXXAO5/34hz/HxqYuAFMtOKbKDGXd809tG0pIkFXMSZ3N6mRAvZxiEtEwxYGu
	 OjbyWmNI9aPIA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeuk Kim <jeuk20.kim@samsung.com>,
	Bean Huo <beanhuo@iokpp.de>,
	linux-scsi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: docs: Describe how to test with QEMU
Date: Fri, 23 Oct 2026 23:24:56 -0400
Message-ID: <179280384853.3823844.11941771751755362972.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012120059.1371653-1-stanleyjhu@google.com>
References: <20261012120059.1371653-1-stanleyjhu@google.com>
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

On Mon, 12 Oct 2026 20:00:59 +0800, Stanley Jhu wrote:

> QEMU emulates a UFS host controller and logical units, but the kernel
> tree does not mention it, so developers without UFS hardware have no
> documented way to exercise the UFS core.
> 
> Add a short section with the required kernel options, an example QEMU
> command line, and what the emulation does not cover.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: ufs: docs: Describe how to test with QEMU
      https://git.kernel.org/mkp/scsi/c/beba4caa4550

-- 
Martin K. Petersen
