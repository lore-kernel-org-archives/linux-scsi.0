Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CAF31F984;
	Thu,  3 Sep 2026 03:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405043; cv=none; b=APytfFxInXop2r1PkBQmJuVLd1q/ifKybdlP0dVK3gpMJnRVxIw8QRF6VQEBg4m08zvQ6wblNq9dwzITgym/pKgA++dA1kyI9qMMxxkMeS8ncO+V56uY3fssCQZUe1IGKkCw9eNneGdURg2AWKo5XAktdIYc7Ctr3OrfJYYlicM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405043; c=relaxed/simple;
	bh=V5ar/mTbt6WcF4MhpPLBe+BTyzngPSMw2s0RcyPoOak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tcV8rXprMH8aW2tYuz03JewTjFi3uW6muFkUzg1HGGlw8wQV4iIZq656gJbBAVvOGOzOx2jjDzOj6OVgU6fWaN/1VRaAiALI0Aww2p7DtdsCwhilinTjZ/7zYntrGGcgUcDF6SUtEMXO3BDDXZ0UIh4C5iK75tnnkE5/iae583s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tv5BpOOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tv5BpOOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82E71F000E9;
	Thu,  3 Sep 2026 03:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788405040;
	bh=C1WxTIrO/5DqW7m07LK+X1npwcnswb77jDwrlm+LuaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tv5BpOOsNgoiK/YATz226P/GV6ARTttPv60cfWZ6MP2HuHSH0QM75GIAm9ULA9e4P
	 W4eoVwuBcWXKvBKY6Up32ZZRgOavZT+BX2p5ny5WwJPGAWxUCjsVtv4aZL8LJqbjHd
	 41ciMSvsrzB5479LTiw0ats5I/Gu+tquC0E/FXOMQ72uQUrphhugMkgt81J3ARj8LQ
	 3A43pqFknVdV5+U3fyZt38nbYCrE7ZfI3VNSgMMS4J0AUwHTKuUjD+ynU7W/feHR2D
	 VnH3tD9fKjNECi0bbfJ0JZjlFwUesJEBDUB8h++8FOk758h2UYJM4qo3HXE6gCP9ez
	 wwuYBeqD5JumQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: James.Bottomley@HansenPartnership.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: axboe@kernel.dk,
	bvanassche@acm.org,
	csander@purestorage.com,
	fujita.tomonori@lab.ntt.co.jp,
	io-uring@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	rc@rexion.ai
Subject: Re: [PATCH v4 0/3] scsi: bsg: io_uring passthrough fixes
Date: Wed,  2 Sep 2026 23:10:17 -0400
Message-ID: <178840472605.670675.14991842842016414580.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817080730.967879-1-yangxiuwei@kylinos.cn>
References: <20260817080730.967879-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 17 Aug 2026 16:07:27 +0800, Yang Xiuwei wrote:

> Three patches for the BSG io_uring passthrough path.
> 
> 1/3: cap sense copy to max_response_len (and stop stuffing that
> limit into scmd->sense_len). Noted by sashiko on v3:
> Link: https://lore.kernel.org/linux-scsi/20260817015247.B9CF61F000E9@smtp.kernel.org/
> 
> 2/3: fix TOCTOU on the shared SQE.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/3] scsi: bsg: cap io_uring sense copy to max_response_len
      https://git.kernel.org/mkp/scsi/c/ece06de72673
[2/3] scsi: bsg: fix TOCTOU in io_uring passthrough command setup
      https://git.kernel.org/mkp/scsi/c/4b3c5965fca9

-- 
Martin K. Petersen
