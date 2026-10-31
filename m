Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793410826;
	b=ZQ7aSlcm+95NWe1ycMWH4b4JXz0U0ZhNQRrgOGzVlpD1aykrjLWv3DOxgW+5ODp3W4Rg
	 6f3lvw+wvfOiGSXisXC2JJ6a1755VaLX3Op3+FARFG91yaYAhlE0Q1xF7BhtqfUILVXui
	 o54/c2woDjLl5mewOgrpL4+2+efEJyEhjCjY2yXTg9cKa/dXAh1VvLE83K5JqxfISbrFA
	 EgZX06berX+LzhBuu3QvJRVPVMIBl63OvYd6JuOscnKO69d7lN/LAs1lHy94UV6SMAqkl
	 b5QKZHXX5MS+Dj60yQ3JewtKJH6fjfeklXF7A3l4O1DqTEWNMbw1n0TXm8lmAiNxyRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793410826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=2t0RcGd/7teWs7LIzlpmlSpF5GPOOwLxfjFfZfOYR+o=;
	b=AISK3V8WuhENAGwxAFDtRedJQK628tzkyAA9Zo7bo+gFULvSzdaQgXDa3Whqc8BK6AcU
	 8X6py0QbnqF7UnVeVEO0qTKj9c4/UHwjJQy2EHESWPKkfJhBMK4sGSgOVb05bAEBe6Y5v
	 OCiezQTrc5dG29QDpz4v7ze9Wi+9/nINg46M1YEE5+4j9WoC/rsSAylRBSHTlz2ZN3W7X
	 fJ6c4UCQQMPyxNTiu8fwdQmW05IKT1hBHn/RRBCCXXCWN6/WAR0p/FZ0NVOvGXPaZV8tl
	 LmesgaEyeAx4d425tfvBZ+9mCqGr3qIktuNOAObpld16SF4WlZBTaefW3kB/kMZTBzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R+MbIE1n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5757606A332;
	Sat, 31 Oct 2026 01:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R+MbIE1n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925611F0093A;
	Sat, 31 Oct 2026 01:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793410826;
	bh=2t0RcGd/7teWs7LIzlpmlSpF5GPOOwLxfjFfZfOYR+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R+MbIE1nUNsZk35w09nru6Ky4tHNsa24llykO0JLApygBbcSPCas9v4Ds5j5aFU1A
	 /FPb4LPEZSJD9m5JPZ5h6YGf28hrEPBoGAqcR9OpShxRYTy85skiBlzz2Le8X6LXos
	 7Pk/m3gPAhwnn95qezYbXb08Ka7Aem8oLCemt1+GLM5OU5YPf95diOCmIoat1+BTpt
	 2zOfY6dtp5q0PicnlQExI5dmlChreWe/LBpZFNLtmbd2H1RYOAH5G3tkyYJJ7CdsiC
	 qcAjPsAsP5xzOm0+yKOI9yLFoF1E04Psc5wxdhdkQH/TjNiLF6ci/+P/qPLfxwRos7
	 mbxb6JcWU30vw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Giuseppe Piscitelli <ooonea@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: Drain target cleanup before module exit
Date: Fri, 30 Oct 2026 21:40:11 -0400
Message-ID: <179340755630.952351.18201943224015271945.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026202342.668361-1-ooonea@gmail.com>
References: <20261026202342.668361-1-ooonea@gmail.com>
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

On Mon, 26 Oct 2026 21:23:41 +0100, Giuseppe Piscitelli wrote:

> Target destruction queues cleanup in an exclusive async domain. The
> module loader's async_synchronize_full() does not wait for exclusive
> domains. Wait for target cleanup after removing the hosts and before
> removing the debugfs root and returning from module exit.

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: scsi_debug: Drain target cleanup before module exit
      https://git.kernel.org/mkp/scsi/c/34c99ce29939

-- 
Martin K. Petersen
