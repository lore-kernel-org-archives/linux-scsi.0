Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998202;
	b=oe0HyNhnoYw1BrN4Zew/lHneerPqQxXz3ZT7fyfeMtGTobDyGrLEzbTqqnB/Dyn6AFUt
	 FBXIc6Ocr4oUL46u4EEx60EUiJyllDbmgUGY2LVxiUwbkLb46ANXGeGnIpYyJ+BnphAGQ
	 7wh5EI8t5AlYobmskSSl/PhbNWakQosrN3SCA+At7OXantLASjVy6BlnXJ5usSwaP79Dw
	 qXP/6Fz6dBZ8cqpOmlOpDM19nptNiAwZR9JRlnmfEH9T5HMcoOZcV8wnTvy9rj26Z9Sv2
	 by9cjuJ+OsihHEmgYdY55z3Q6HYq2ESi+y+7ypoGLipb1bcCpg4lJByAWRXd4JyPpEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998202;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/+TWt2UASyO3b9dRPR8xyx//ZRz2ZiyENc/slL/hggA=;
	b=MxUDWW8HYRAki3qQb9FIjGM1pXuOd9FuBBuHx4NLa8yxr9oEY/+c9UKgT3we1QvUe7Ad
	 5rfsq38hUhJGubSm7/F76iVSIyfV+S4gvrVH3Tk/itRE98bfDe8/jTQ9pdjQS7wLcDNTH
	 gMJmeyFUmNz2ur36YD2UYU7/1enIGnBHqG/D2wKbeM3YpvKzGeXlVvX7a9Gu1hcr2n3lk
	 5yUO7E2R99kDapC7joWqDoqjo9sZie+woSdqcKEmGob266SubKepr7ssURNTeVEOnuE6k
	 YWu1djhFO0G8R9t0Giout8HVWPsKerEvPTyRUTf6T+qts7mqfowFT+LX53GT8nPVvLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N20T+j97;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CD7606A325
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N20T+j97
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670431F000C4;
	Wed, 18 Nov 2026 10:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998201;
	bh=/+TWt2UASyO3b9dRPR8xyx//ZRz2ZiyENc/slL/hggA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=N20T+j97nhOmfnV5FVxsgHqOJvwuMM9KwhL3f30Ekvkbc2QX0ylDMccpwJgJlcsmI
	 HgYAoqdmyo1mZDJLln7sevzlHLOWGl2A6uMzAtEPB8celvFqIiB6F1Dg+FruB6+eW1
	 uMOfZZHjVHNgVw8CJyzDNfgOIt6LobxhAKSmvzH2vpCjpF+wC0tKmR2fUb/mp1mZn1
	 PvH76SdR336asNLhbR+Yi8kj7gix96OG42eDSj/9e482DbNdUJ+jPiDaPhIPQdmaNC
	 7SPpCar7wjk9F8tbsGNcYsCN790sahvPrKt6bC90dr+EHPsbQFTcXJ3N34AmKBt0vl
	 4+C69T8sYRkIA==
Message-ID: <sashiko-outbox-220711@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/37] scsi: mpt3sas: Fix unlocked use of raid_device
 in enable_sdev_max_qd_store
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-6-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-6-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:36:40 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scsi: mpt3sas: missing Fixes trailer for commit 8dc8d29a00e2
--

commit 684177668e14060ff21b25ff736981f016e8a747
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Fix unlocked use of raid_device in enable_sdev_max_qd_store
>
> Take ioc->raid_device_lock around the raid_device lookup and check
> for NULL before dereferencing it.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Should this bug fix include a Fixes tag for the commit that introduced
enable_sdev_max_qd_store()?

  Fixes: 8dc8d29a00e2 ("scsi: mpt3sas: Introduce module parameter to overri=
de queue depth")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D5
