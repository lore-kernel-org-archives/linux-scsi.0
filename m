Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CF644CF22
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 15:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787757624; cv=none; b=LTtVfjJe5VwYzXXprAm+ISp5EhQsye00Hj3j0jlgijk3DCv43hQv6pzonWRoSMs6cCVo1JOLHLO36DfeQN9Au3Cwx6CNWGYnefRrorHyBBnH9XRdprFTOyfGDosf4BCzno/UZbBprUfn7/j86fp5Jtv0ZRnsH9kl3w31nodisRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787757624; c=relaxed/simple;
	bh=eDlDQpgoYiKPyV4G+3FDTutNQmTGNc5sCFB4YzWIYjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rFofI341DeK65q544uvRcd5luJ1CaZILvmrKa6wmj0eLzDh0aw0ATP5qxXL/YXYl8NhglnKBoJyw8XmnxHMbCMUP4jVFUSNazU3YlKffcZGeY3LxeeNs3IETK6ZzHFSYgs0zQTEXmYkfYu3HKLhREpDl20Zwp9bP6yLR5EmdRUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMmItnG1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMmItnG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8C31F00A3D;
	Wed, 26 Aug 2026 15:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787757622;
	bh=b0VSdBgGpA7b8Vl/BFYUwb9ADz7Si6V5hangtffdsvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oMmItnG1gfINF6RGdeNVtddz85OlNB0HHh1PEODbOriOypUUez1WuoY3BKmlsnBKv
	 jk+p5aXxmr1Lg+qq1au+nVvjzVs31wyMQrfEHresge2Khg1NXTO28tDffOuZn/NwQo
	 ZGkJsEmyv7bp+AdmsPLYuiI7XiOuDUGy/wwkAIf7/WoaECbYQi12OwuPfAAWxLexJV
	 dN/MxtSxbPi4br3a2idHoxX1wpasaVAfna+aBkyUX+eDX4bFu1PLdeQRGsL20dLPy1
	 niKLEwe15wbY/Zg+PU+TKyzCD5FNsbXBP/KGjrjoccBCYWHc7h0df/tMNFYhBsVuvV
	 Gjr5kxSU1ANxA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: James.Bottomley@HansenPartnership.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	Dongdong Hao <doubled@leap-io-kernel.com>
Cc: dlemoal@kernel.org,
	hare@kernel.org,
	hare@suse.de,
	yjzhang@leap-io-kernel.com,
	kezijie@leap-io-kernel.com,
	jzzhang@leap-io-kernel.com,
	baikefan@leap-io-kernel.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: leapraid: standardize NCQ priority sysfs attributes
Date: Wed, 26 Aug 2026 11:20:09 -0400
Message-ID: <178775714076.3862282.613117789741680651.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814090526.395704-1-doubled@leap-io-kernel.com>
References: <20260814090526.395704-1-doubled@leap-io-kernel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 14 Aug 2026 17:05:26 +0800, Dongdong Hao wrote:

> Replace the earlier LeapRAID ncq_cmd_prio_enable attribute with the
> standard sas_ncq_prio_supported and sas_ncq_prio_enable names documented
> in Documentation/ABI/testing/sysfs-block-device, and rename the
> per-device NCQ priority state to match.
> 
> The earlier ncq_cmd_prio_enable name has not yet been established as part
> of a released userspace ABI, so no compatibility alias is needed.
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: leapraid: standardize NCQ priority sysfs attributes
      https://git.kernel.org/mkp/scsi/c/46f861d300e8

-- 
Martin K. Petersen
