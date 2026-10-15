Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF07C3E0234;
	Thu, 15 Oct 2026 03:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792033385; cv=none; b=r/hCgwtLcSqYX0G8arYoKy1mmXgji9L+X6B4Ukr3QoX7LvltAPPyqXaqVWdEuj+gsQlcpopLSkIJAvuBEVRYAjFTaJwXNO3mhw8udhmtmip9NHMAb3DaiDHQzG1r2jE79FpklPtCIeEOc3e5eJh6q3s/oQfbs11I4u8ht1MHq4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792033385; c=relaxed/simple;
	bh=kC1ijqn4i9z1ReBxdUz4XLFfyrUxJrSnnVrMeOMazBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M6QsPdqElS6uPhvjqrGkWEF/GbBljxQKr5NFGZt8UGYJQ/o4/EpFOx4YsRtwqqVbbbzFFscCGAbWovkXCuIYDBJmFiUJICHTIzWNfFDf8eQkL6V09pg1+axMw0fnYL8xfO6iGH0a2jlYAl089mmb+2qWGdLHXBA8EU38qm8CSwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HfmYLSj0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HfmYLSj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F151F000C5;
	Thu, 15 Oct 2026 03:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792033382;
	bh=eqJdmKi9QXILdgTVNVkHkpEEQXOyk/l7KlVYBXAJZ3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfmYLSj0BAKvFP9JfrV5YwWZHViILj8MmEyV7XpofDDFTAL+dr4jtsFl3iVgKF80r
	 pjeQ2OTrkfv9Ie1Em5puJMB+5fKdLNmy6anA3y83cKJQMqHLK8OqVFh8AUIzERI5yf
	 BZbL70ZOnbi0shncWbE1vb6zQEEgsrgHDeTMYS8UwzwAuyW1JKFvZdfrdaYTBm9dcV
	 sK74DMwFtGYnoKRyCLo+TSbCE5p8qVrGKfsb1saWqBjxVfEts9nxOvx/b5yd3iGbTs
	 eBZiP6aZCz7qPnEQqw0JPnvywS4o02eOKgi1HZyNqhRrvGsm8xSOOUxRcWBoLoC6a0
	 FQq5Lf84CQ/MQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: john.garry@linux.dev,
	yanaijie@huawei.com,
	jejb@linux.ibm.com,
	Xingui Yang <yangxingui@huawei.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxarm@huawei.com,
	liuyonglong@huawei.com,
	kangfenglong@huawei.com
Subject: Re: [PATCH v4] scsi: libsas: Fix SMP IO deadlock during HA resume
Date: Wed, 14 Oct 2026 23:02:56 -0400
Message-ID: <179203336205.3648956.704006086639368879.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928040234.992912-1-yangxingui@huawei.com>
References: <20260928040234.992912-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 28 Sep 2026 12:02:34 +0800, Xingui Yang wrote:

> smp_execute_task_sg() calls pm_runtime_get_sync() on the host before
> issuing an SMP command. When that command is itself issued from the
> HA resume path, the get_sync() deadlocks: it waits for the ongoing
> resume (the device is RPM_RESUMING), while the resume is blocked in
> sas_drain_work() waiting for that same SMP IO to complete.
> 
> The deadlock needs an expander-attached SATA disk. During
> sas_resume_ha() -> sas_drain_work(), DISCE_RESUME ->
> sas_resume_sata() -> ata_sas_port_resume() requests ATA_EH_RESET,
> and the hard reset for such a disk is done via SMP PHY CONTROL
> (sas_ata_hard_reset() -> sas_phy_reset() -> sas_smp_phy_control() ->
> smp_execute_task_sg()). Direct-attached SATA resets through
> lldd_control_phy() and SSP devices use TMFs, so neither hits this.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: libsas: Fix SMP IO deadlock during HA resume
      https://git.kernel.org/mkp/scsi/c/81e097a064b2

-- 
Martin K. Petersen
