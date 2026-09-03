Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D5B36E473;
	Thu,  3 Sep 2026 03:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405041; cv=none; b=uuw1mvZP63rNoO9AfrIh+VInJIE60VT9e3R8rPCkVvfd7YKmSs47sHuWLHU+0Fo56PAX0gqlrMA75p/77423EEJKJ6Ia8i0jtGVcqmhRI52RummVhSMbBHNPM0XGdt4DuRCCv/Y6/3FaBPFRXSspxY8XVmg82FCoH+JVDjZXMiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405041; c=relaxed/simple;
	bh=RJd40JkEZf+kQU/eK7Dy9hLTRWapXhsk2ucG9x4jLSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=td7LiLJJVmyUdLS+5v1fWN7U6xcCnMIAEr7SnyVWJM3DQkPq9qP+BKh27rhhin9NvP7Vmb9aGTThPIDWpVTqM7QOc2p0ZohAgditsJiD+oOpGt/oZF1DY3UXlzKPWedbDemNSzTOZ/qAuRv/NOJS2DzL5U8HfDaehoeHpbviO+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIRZZHi1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIRZZHi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671D81F00A3A;
	Thu,  3 Sep 2026 03:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788405039;
	bh=PH+5MG+KfhO/TuU48UqZC1IktPi1jIP9wzsCgbmWzCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VIRZZHi1gVHm2W+2yUeqlBTdaFPOf7tlDY9r0TvR4SsGrJyxN5+r3jMV2gHrWeOKX
	 chVNMxAa5C9ZYjzGuxVCqxhdpp/mpIH+4rxYTrbYT/8hkHMT3ohNGxYk07UY0Cc7vi
	 7ajTeY8JCqVDlvWFYmDbB81Jj3XG8gHqL6eh6ttHOxWWr+1ZZpZW2h7nLZbm1SZfLo
	 ZW8JTA/O41S3iXuGcAqb44kygKby4/rv6u76jf1PSqLCvwsRuAGLrNL+gPjpSBPx33
	 47o/9Rrt/2KhLH3OmZr01Nn0l4CWa2YJ1GfDYqkdudS0zjhf5abNVbMS5On8wN4Cjd
	 qLdlh506g475Q==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	megaraidlinux.pdl@broadcom.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	Thomas Lamprecht <t.lamprecht@proxmox.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	regressions@lists.linux.dev,
	Lukasz Magiera <me@magik.net>,
	Mira Limbeck <m.limbeck@proxmox.com>,
	Daniel Fernau <mail@danielfernau.com>,
	Mats Topstad <Mats.topstad@intility.no>,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: Limit NVMe request size to the PRP chain frame
Date: Wed,  2 Sep 2026 23:10:16 -0400
Message-ID: <178840472610.670675.12272571379596581093.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827175743.734593-1-t.lamprecht@proxmox.com>
References: <20260827175743.734593-1-t.lamprecht@proxmox.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 27 Aug 2026 19:24:24 +0200, Thomas Lamprecht wrote:

> megasas_make_prp_nvme() builds a command's PRP list in cmd->sg_frame, a
> DMA pool buffer of instance->max_chain_frame_sz bytes, spending one entry
> per NVMe page of the transfer plus one per page of the buffer for the
> chain pointer. The loop runs until the transfer is described and never
> checks the buffer bound.
> 
> max_hw_sectors comes straight from the MDTS the firmware reports for the
> drive. On drives with a large MDTS the only thing keeping the list inside
> the buffer was the block layer default of 1280 KiB, which needs 320
> entries, which fit into a 4 KiB frame as that holds 512. But since commit
> 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP") that default is
> 4 MiB, and such a transfer needs 1025 entries, so the list runs a full
> page past the end of the frame:
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: megaraid_sas: Limit NVMe request size to the PRP chain frame
      https://git.kernel.org/mkp/scsi/c/af8c27375733

-- 
Martin K. Petersen
