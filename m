Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF3C414410;
	Wed, 14 Oct 2026 03:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950258; cv=none; b=fuoU3vS17ZkeV1zeVzSqbNxY5GqoY+L+Tz0VnabDCSeKO4IVJPTg52WoJdQIjilxLVYF/RB4TQ4608A5S6ND+mHTiZRYetT5o1VoLmZUbccJAI0pucC4qMCqSY87b6Q88EsamAUi0KMGOgMummZ/wDoUCszkPaLE2Yw7217lfLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950258; c=relaxed/simple;
	bh=diUCE9BiR+sJaRN1GfNSMYLFo31sBhyw1y01tHVES40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=btX+W/naKV02VZBG9RSYX5e6i8AAXmd5yibFfbxdMqMFjjnUG9Aj0tz4tIZ96iY6xGX6HR0N2RbAyTuaF1WR1QVqwaLXnjs1Y/HtKAH/wRUVT6jsgMixckCNMYcrVkshjv+Aq52Rqq2HONRMQFTXot7qEhILfGQ9MtfBPV56ra0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WNz+BVPk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WNz+BVPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924681F00898;
	Wed, 14 Oct 2026 03:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950257;
	bh=eSd13mBE9Oom744JU6LE90MD2uZ8STosKq32EJDeVKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNz+BVPkUcOvE6cAorizdUGcRaeGXQDx/vSKtO0LNe1CymIZbUwWgKrkfb+cvCcto
	 fpA+51tmf0NuCks3R4fxOP31SpiWvpjZ6dSYPO3cjlbj91t0oTk4kZVDgT0JBWvjJ7
	 a1ANuwfNKuvsnClkEMIj3OmDXrrCF0UpiPjD3DR5z5vSvMEee03DFG79zxalwVAs+g
	 LThpXvWmNmaZFW+apRo6NOBx7rTZNGyd7PmC/6Km2vh3830zyQNvVxsf72WkXwVHAV
	 VCqp60L0cZz7paDbR2KOwNb5o3BJ3IepZ+eOChffIN6FkbzEsY5zlnD/xu4u6HZtvw
	 Q8fYlwuYtF16A==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Yu Zhang <yuz08559@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	michael.christie@oracle.com,
	d.bogdanov@yadro.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Disable interrupts while holding delayed_cmd_lock
Date: Tue, 13 Oct 2026 23:57:27 -0400
Message-ID: <179194999403.3016381.12964304644212104831.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927091329.13482-1-yuz08559@gmail.com>
References: <20260927091329.13482-1-yuz08559@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sun, 27 Sep 2026 19:13:29 +1000, Yu Zhang wrote:

> target_do_delayed_work() takes dev->delayed_cmd_lock with a plain
> spin_lock(). It runs from system_percpu_wq, so interrupts stay enabled
> while the lock is held. Every other acquisition of that lock uses
> spin_lock_irqsave(): target_handle_task_attr() and
> transport_complete_ordered_sync() in target_core_transport.c, and
> target_non_ordered_release() in target_core_device.c.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: target: Disable interrupts while holding delayed_cmd_lock
      https://git.kernel.org/mkp/scsi/c/04a67a8b1a44

-- 
Martin K. Petersen
