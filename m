Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5C0392C20;
	Thu, 17 Sep 2026 02:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612134; cv=none; b=AmNivtHVphow4Q34rAlWE2VL8W+lBjMZlwPvz6qwJpfDyoJtOQl6CAIW8nkvXeOqYrEjmf/53HWSaKrHV1NclTPn0uwvW/WIcnOC3yv2uSwchUJB/VA6FgvXCVmXiFJSOHle2hK3iFhRvMpsWovjmoieZ4D78hreezw/T2LAU3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612134; c=relaxed/simple;
	bh=QAmGo5ya1lEzgebcyO2c25lvgrfDOlaC7TkM1OT6KBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SIhZ59KOneINMPkkdWjpjem4OmkL8f7DSnDZ3SmMWYuoSUU2+cxzDrq5CsHc+CgVJQq20KoWeXaDidu1I1WhMJTAHcoQdZUzc7/eZk/9A2hnX6KyEomBm14BxWvbG2QQ/QCV9DeC27LzSPecv096vxmQTNQMrkAjsQ+kNkA3W7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDgyvGX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDgyvGX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0154C1F0089F;
	Thu, 17 Sep 2026 02:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612118;
	bh=K3oyNZntK8zxhJ9bZu28xpBS5eax1KW4PDBFgPVykOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDgyvGX0BIVTsOSbHB2zkr6qz/sUztLLTyoJBmkE3OdbKmiCa4N2N1rWH2agrdlWY
	 aFoDTf8EoHk/dDfTT0JhXO7HoKk7Grw8T57he8eB2FiI35EhH+dUTONYnA7SP07/d7
	 thSrrqBmKOR63wKCYFQyAsM4JI69RyWPxdl7NE5m7rrtuhy/hHKsGSx8a1dp+IRP8f
	 QVfG3SHWJk1Oj6ayWqwNl01kbmTCiGZI1PGQ0lNIuprTQL9SWJFxs37QRoCVD0MQe2
	 H9SlMcqYw/DCh8BO7hQoIWmSeTCQscX1wIaDoYHYoUQp0fhKvTugqVF2N2EEoNsTRu
	 T4nGRluCnp0yQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	ZHOU Jiaxiang <me@fxti.xyz>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 1/2] block: fix zones_cond out-of-bounds write on zone report
Date: Wed, 16 Sep 2026 22:28:20 -0400
Message-ID: <178961190604.3672510.18119102289310587808.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <7815D1B293A8F55E+20260916135822.32584-2-me@fxti.xyz>
References: <7815D1B293A8F55E+20260916135822.32584-2-me@fxti.xyz>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 16 Sep 2026 21:58:21 +0800, ZHOU Jiaxiang wrote:

> blk_revalidate_disk_zones() sizes the zones_cond array from the disk
> capacity and zone size, but the index used by blk_revalidate_zone_cond()
> comes from the device-driven report_zones() walk and is never checked
> against the array size. A device reporting more zones than fit the
> array makes blk_zone_set_cond() write out of bounds.
> 
> One way to reach this is a zone count exceeding 32 bits: both
> blk_revalidate_zone_args.nr_zones and struct zoned_disk_info.nr_zones
> are unsigned int, so a disk advertising more than UINT_MAX zones (e.g.
> 2^32 + 1024 zones of one 512-byte logical block) gets its zone count
> truncated to a small value, undersizing the array while the report
> walk keeps counting upward.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/2] block: fix zones_cond out-of-bounds write on zone report
      https://git.kernel.org/mkp/scsi/c/7c431d61b69a
[2/2] scsi: sd_zbc: reject disks with too many zones
      https://git.kernel.org/mkp/scsi/c/b6ec0f797459

-- 
Martin K. Petersen
