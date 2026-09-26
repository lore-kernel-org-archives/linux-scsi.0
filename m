Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AACA2C1594
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 02:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790389841; cv=none; b=jsLpoMBct6bF2CFVB/4bL13hbGFmSRnlDDYgBHkDTj7BSnXVG+PrtqHNx0MFmN0KAtVOuwZh9EQAMDz22xu2jD7hJW9xJ9A5ETP2OqK3trIQzAEW8+OX9ynTZoxnKcsTWY/6H3z+HTjsEAkLByDHisqYnuzRIlWpSqHvoRA7cJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790389841; c=relaxed/simple;
	bh=IPVFuaabkzbJdCPN2lwp2UE+vgXUgKVQfhwOMeaTuN8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=JG9wPQ/cx2GdzDCnFEi2l5Hb0JFWK+z/MzHU4HhjSgFb4/VjG5Bfc6t3KYcGqgfh/ORJnCJLyj7DsmBooM76SuyDdUdmSxITdGfgsKstzGWfSYuxNCEHY9XuPv04PbmHRiOSaAD0b0087Nl/9OhigO0KmYWvetoPVKgeiDYDjzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bshKGTia; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bshKGTia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB101F000FF;
	Sat, 26 Sep 2026 02:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790389839;
	bh=LekUX8XsOEkUZaYG/ud+BHEQxw0g1s9GsSaIwr3EFk8=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=bshKGTiajj3qyx4AOMn10qxr6nLoBNoXpPsoz1BqHWCsYP3Ss0ZO2q+ft2CP3kJiF
	 vuxb2ACtZvDl8cWyX91uJRm2oiEFW2C4bW/O6i+dnhwvu0OcfLtiPYr+6mo3D46Bms
	 YuQyaoDwhRP8++I9+mXJWf0M7Y3zi6ZNhn3H8p9bPIxFwwrcqxbXqcyRRnPFZOftCo
	 Xwc6LyASPFM0/huJ0yDF19O2xqPskTjnyN6cpVY0qNWgfZSMUdy2Wpz0jAF0ZTC9tt
	 Wcq0YQiP8miBVerbTYv1A/VMhxChWVLBt0n8mBGjUw7DZwfCvdOJDpF6QhljU6xYCm
	 AxAKF2nbUD9Lg==
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>,  <martin.petersen@oracle.com>,
  <avri.altman@sandisk.com>,  <alim.akhtar@samsung.com>,
  <bvanassche@acm.org>,  <santosh.sy@samsung.com>,
  <h.vinayak@samsung.com>,  <wsd_upstream@mediatek.com>,
  <linux-mediatek@lists.infradead.org>,  <chun-hung.wu@mediatek.com>,
  <alice.chao@mediatek.com>,  <cc.chou@mediatek.com>,
  <chaotian.jing@mediatek.com>,  <tun-yu.yu@mediatek.com>,
  <naomi.chu@mediatek.com>,  <ed.tsai@mediatek.com>
Subject: Re: [PATCH v2 0/2] ufs: fix POST_CHANGE pairing and AHIT race
 condition
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260914085148.136429-1-peter.wang@mediatek.com>
Message-ID: <yq1jyo8pwwc.fsf@mail.kernel.org>
References: <20260914085148.136429-1-peter.wang@mediatek.com>
Date: Fri, 25 Sep 2026 22:30:38 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


> Patch 1 fixes a bug where POST_CHANGE was skipped on a failed gear
> switch, leaving the host in an inconsistent state if resources acquired
> in PRE_CHANGE were never released.
>
> Patch 2 fixes a race between the sysfs AHIT update path and the
> MediaTek host driver's power mode change path. A mutex and depth
> counter are introduced to serialize AHIT register access and ensure
> AHIT is correctly restored after the last disabler completes.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
