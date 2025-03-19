Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F0C1361;
	Wed, 19 Mar 2025 03:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.143.206.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742354319; cv=none; b=WK/F1sFuIGQffO+r4r/Ug7mbxtd3SZ4OPjqGU5jpsaFhCEd6r+5LGsQTw82Pq/DVdbl//2bqpkl7Jy+u5lSs/g7SCo2DB+Xe1yzMTTz0fMQZTlgkgt7+ORxgebExHc84xVqb5NQCeWzPtubWvPItlh/k2dqiF1b5ozrFAsbAYJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742354319; c=relaxed/simple;
	bh=dLdFIyfLiXSUbECZJmbOR/5Wc21Lzle+PUGE5qwmTV4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fz0CktxwK0g6I2qKiADXvLKASutcwPqr8oNaHPf3DjNHPa69rHEkbF3OzwbC86V7rOW94Ph9ia5y0AIaehboWx+k+iIFo5KNxDn2TokVh6kiVo/w1rX7jXFi2WG7MSRO7zgZu0TtXgc/u/wep8DhlXTO2Kb5lJ9wZ2rmwhm1wPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=118.143.206.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: Ror2QvmWTTWZ0xKXFXsAJA==
X-CSE-MsgGUID: /z1CtNACSZmoVjUjo7RQ/g==
X-IronPort-AV: E=Sophos;i="6.14,258,1736784000"; 
   d="scan'208";a="109195084"
From: ZhangHui <zhanghui31@xiaomi.com>
To: <bvanassche@acm.org>
CC: <James.Bottomley@HansenPartnership.com>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <ebiggers@google.co>, <linux-kernel@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<peter.griffin@linaro.org>, <zhanghui31@xiaomi.com>
Subject: Re: [PATCH] ufs: crypto: add host_sem lock in ufshcd_program_key
Date: Wed, 19 Mar 2025 11:17:21 +0800
Message-ID: <20250319031721.69179-1-zhanghui31@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <048d2f33-2697-4ede-9814-d8e9f3aeb732@acm.org>
References: <048d2f33-2697-4ede-9814-d8e9f3aeb732@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BJ-MBX15.mioffice.cn (10.237.8.135) To YZ-MBX07.mioffice.cn
 (10.237.88.127)

On Mon, Mar 17, 2025 at 03:32:51PM -0700, Bart Van Assche wrote:
> On 3/17/25 4:01 AM, ZhangHui wrote:
> > On Android devices, we found that there is a probability that
> > the ufs has been shut down but the thread is still deleting the
> > key, which will cause the bus error.
> 
> How does this patch guarantee that crypto keys are evicted before the
> UFS driver has been shut down? This should be explained in detail in the
> patch description.

This modification does not guarantee that ufs has entered shutdown before
evicting the key. Drivers should not make assumptions about the behavior
of user access.

If ufs has entered shutdown, evicting key flow will return -EBUSY.

> > Let's fixed this issue by adding a lock in program_key flow.
> 
> There are multiple synchronization objects owned by the UFS driver. Why
> 'host_sem' and not any other synchronization object?
> 

The host_sem is held in suspend/resume, shutdown and err hander flow, so I
think host_sem is used to mutually exclude host controller power failure
and access.

thanks 
zhanghui
