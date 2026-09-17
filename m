Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC1936F91F;
	Thu, 17 Sep 2026 02:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612142; cv=none; b=D2iDVinms+59MtCmizKPx44Fzru7c8XdTC4Q+d7rNuBf81ARVy/gI/AUdEEeAswMdloLvwNbVpnePXyNkoMePF5Sujdipd5JZD9IVqs90Nyqu+xbB+TnkxkLfpVki07pqwU0QUbEzw9+wE+ZVCpazaYuSYSJqcf9TJaF4c7tf0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612142; c=relaxed/simple;
	bh=6T0htSUKggTZSOVYP5NupG0kBLY0eJqrRFVzqPEVOgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f2y0YMLUBoAbRiJiEa++Ivye1+hD462XllMbqWPgOvmS5J6FHvVQbDKSCcxCgJoaZ0sf3MX1FdDZU1X12Ntw/MXEK9lhQDMOkEPm9Wxcz77Ok1M+o5V4fEnqEykvxvDom3n62tVMq69vZoutocSxlWGFzc66J44nUvljny0O+Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XIwgSBng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XIwgSBng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDA01F008A1;
	Thu, 17 Sep 2026 02:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612120;
	bh=hIpu4x3R6eS/r998XLlVkZd76MGS2NwC15636aNwGtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIwgSBng5ahUjY8A0tk/E828hYUSrb1nfg3x66f1s2hOOSvkCGHMY4oqDqc2CvsUc
	 4Uhh2Iu1VRPuAhcG8LX4n8KLplMqbIYM9LEr9GbZSrJ+1RZlebUZ96uwicxzjkAJzf
	 CWjwXQzTeoBhOl26RPHRyO08sW3juh8Uu/SIU0QuL/N6Xxuaaax4o6Uo9FWIn/4SQ8
	 go2JdvnbLYtZWI0QOw/Ao0BHpr+lIsOXDgsf4unqs8yZZklLZAW02dN60Tm3fx7a5q
	 MRubnMNL6A9iSLPCd7CFTg2hrcGmUH/A+cQ4iJdT/8GPLRuTj1I0Tcz6DrH8QHJbCv
	 XkvNtzz3kVmuQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <mkp@kernel.org>,
	Stanley Jhu <stanleyjhu@google.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Brian Kao <powenkao@google.com>,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: ufs: core: Keep internal commands dispatchable during error handling
Date: Wed, 16 Sep 2026 22:28:21 -0400
Message-ID: <178961190588.3672510.10414436987166637617.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912131625.2301486-1-stanleyjhu@google.com>
References: <20260912131625.2301486-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 12 Sep 2026 21:16:25 +0800, Stanley Jhu wrote:

> Commit 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
> switched UFS internal commands to allocate requests on
> hba->host->pseudo_sdev->request_queue, which shares the host tagset with
> regular LUNs.
> 
> During error recovery, ufshcd_err_handling_prepare() calls
> blk_mq_quiesce_tagset(&hba->host->tag_set), marking all queues in the
> tagset as quiesced, including pseudo_sdev->request_queue. When
> ufshcd_verify_dev_init() subsequently issues internal commands (e.g. NOP
> OUT UPIU) via blk_execute_rq(), blk_mq_run_hw_queue() skips running the
> quiesced queue, resulting in an unrecoverable circular wait deadlock.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Keep internal commands dispatchable during error handling
      https://git.kernel.org/mkp/scsi/c/b52d695d0620

-- 
Martin K. Petersen
