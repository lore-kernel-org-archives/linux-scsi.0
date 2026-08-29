Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF0220E030;
	Sat, 29 Aug 2026 02:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787969597; cv=none; b=ONvvbhR1dKfs+n9V9mfnqPG+uTel3yauhdAXppib9mpZKhyjfTcWvkQ1oxrKqqMGYIo4M8+yTU7mxa0WOiC8K1vOSW3myjO3Edktf7itkszt+34wWMs/gxXUJDb3zkAr/GsRUNo3LV9CW8KwW+1lZqlZekNAIadopanH3xh34Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787969597; c=relaxed/simple;
	bh=BntTroK2FOEKBYfm+590Ym86Oymsk3FCXSRJ6ctKy6Y=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=Dx4gCOfYJ+M8B68XfVd4UosrVDJ4+yX5MgWWWTyUtF1GMLUwqyubSuXd64L89T+2PHdzoi/HF2ZkryQW3A0wGfwk3YrXkjcwgbrc6x4zSsKiig5olSqY3YuuABnR2Ilgrb/XlATMRr1Rf8chZ3yhrFIA/cGBUhQ81W5Ul4MQNOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LBN1+aqW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LBN1+aqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9D51F000E9;
	Sat, 29 Aug 2026 02:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787969596;
	bh=gTB4sVEt1Pcz0foZVH+mABYXhAB4n9ZdKxOXexEkdkQ=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=LBN1+aqWfXpIgOT9DNM55YSRSJTH/ShGq5VDMiFAed/oyBNfasCW22N8VE4N6gxv4
	 RuZETFBM7RSh3FKOPJ1JYfh+j47eNYoj6YwcU13p1Mi0DjADGfheYBessZh06otbIN
	 OuIU4YIz2QD4wrU78zcpYq+jLOYCJ4mykbAt7j7cHHCEPggXbQBnXZTNShIE6K8Iht
	 /eDbp9uhUtNeV6e2ku77JijguskWrVvA2RKFl5dw0djkydGWdxkZlTlApn6L4Jl0Od
	 aQMvFIp2kUmSIJV1jI6+5HAeJ+ODqgmha7x2vi3Ozf/VTP+jZXZkvhDGN5upPvy/eQ
	 8OWbG5G4a+9uw==
To: sangram kumar yerra <sangram.k.y@intel.com>
Cc: Martin K Petersen <martin.petersen@oracle.com>,  James EJ Bottomley
 <James.Bottomley@HansenPartnership.com>,  Bart Van Assche
 <bvanassche@acm.org>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  adrian.hunter@intel.com
Subject: Re: [PATCH 0/2] scsi: ufs: ufs-pci: Intel UFS 4.0 HS-Gear5 and MCQ
 support
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260818112830.453402-1-sangram.k.y@intel.com> (sangram kumar
	yerra's message of "Tue, 18 Aug 2026 16:58:28 +0530")
Message-ID: <yq1v78tisi9.fsf@mail.kernel.org>
References: <20260818112830.453402-1-sangram.k.y@intel.com>
Date: Fri, 28 Aug 2026 22:13:14 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


sangram,

> 096cd6b7adf2 ("scsi: ufs: ufs-pci: Add support for Intel Nova Lake")
> added the PCI ID for Intel's UFS 4.0 controller (8086:D335), reusing
> the existing Meteor Lake variant operations table. That table is
> missing two things this controller needs to work correctly at UFS 4.0
> capability: a PA_INITIAL_ADAPT sequence for reliable HS-Gear5 link
> training, and the MCQ resource/runtime-config hooks required for
> ufshcd_alloc_mcq() to succeed. Without either, the controller still
> works, but silently falls back to Gear5 link instability or legacy
> single-doorbell mode respectively.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
