Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F07538E13F
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 02:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612140; cv=none; b=M5ajytdQFJ3EEIEYXL4Jp5HmPLAiX5bISdegKtXLDqpE2fmJYDPg9j0QsaiX1HRBVVHQYLfkJ9hoVAySjno6HH5zfjxG7uqq6NlTi2GpDyZ0ekQOT0ScD1gufylge5h7zxiyuVWUWrreCYeIaR6YziU92xONQ68+MxIiQ3gxn8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612140; c=relaxed/simple;
	bh=1CZwOASK/76jNDdkktG9dXbS6l4UhkjoQiSdtr1cGcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fddlCRZFp5jzQCqWTbCDu6n/M+ivwgppYlYReWrJmRCeuOeSUzfZ1PFEHT33ZbBHdZSupL2EE/OaywPb4Ad6nJSeRBKUdemJbpixP97DSnVNxFLq4pnv6LEg96e7iquXZ8aOVT3XDWt/dxKCQ9KEcnDj11/NhcYOof5jcPrybCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MQXfxx9m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MQXfxx9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96FC1F0089D;
	Thu, 17 Sep 2026 02:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612116;
	bh=hCwkixPctvdBCxfSK7J1H2LZIwZR7epjh3O4HUzZJy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQXfxx9m5QcYaukVL8cUrzYHpSAJG2AIE5KAalMzHLVN1DdpsghD3uDpxJe9JnOYj
	 pUX7flAIfh7vCpYAVuRIjPzW3sQMq9wvFrX1PCJjTt+bWlS01u+UJS3JQPGgilHMTN
	 vAgzj8Dc2igtLXxXBV5JzHLr2jleZ0sEAQYROXZtVqxu5pcraoSVgOw1fckQGPchCn
	 SDSgRqI3ziAMUA/Sd3m0OXjz1fUENSnQCjVhx6tp15xJsZBLIvmP+806LhibxKrO3L
	 4/Pq7BDjutIDfx/i8uQVqoNhGN3zntjcBy55gLhekAIrfGxJ0NH4i/rAJ8ePWim+MH
	 nAu7zdoIKHK8g==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	Karl Mehltretter <kmehltretter@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] scsi: pm80xx: Fix the use_msix, use_tasklet and read_wwn parameter descriptions
Date: Wed, 16 Sep 2026 22:28:18 -0400
Message-ID: <178961190572.3672510.14951536653027118589.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906170925.2524-1-kmehltretter@gmail.com>
References: <20260906170925.2524-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sun, 06 Sep 2026 19:09:25 +0200, Karl Mehltretter wrote:

> The MODULE_PARM_DESC() lines of use_msix, use_tasklet and read_wwn all
> name a parameter zoned, which does not exist, and the use_tasklet one
> repeats the use_msix text. modinfo shows three "zoned" entries and no
> description for the real parameters.
> 
> Name the right parameters and describe use_tasklet.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: pm80xx: Fix the use_msix, use_tasklet and read_wwn parameter descriptions
      https://git.kernel.org/mkp/scsi/c/264bf9655c3d

-- 
Martin K. Petersen
