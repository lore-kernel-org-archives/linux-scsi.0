Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535BD313286
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 18:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758824016; cv=none; b=fHQnQWui2dk1QS4Blh/n+5J0bct2mLnyG54utaD9kz9f0Ql5EPzA9IL613Vui7NvQALy5lE+bOw10yLzvSE34OlT/DCJV+jzg4c6j+bPr1b3AgPbghnXdQBkHkL3n5kVoLTZmfnT2Iddhbc2XW60dQOsOJUfoEvBPwbUgg0zhzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758824016; c=relaxed/simple;
	bh=LZH9YHW7mPrs0buqxYoniyurTyYOsm0Ano0rkj4FeAM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=cOpEcZsoFxwyNfnmz9sjwmWT4nkcI1ZPs88nlKYPh4B9w8ceH83p2LXPSJ0ij4XHgkiYYF/td30HwlMpPaDPPeW7BT2hSDY3ieBRsGgUn57eUs2CofjF3Nv+rMdRXtj9WQ463U4nSNNz665h6t8Xn4uAJyNjfbewO6KsYMIFL0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DFxCrlnI; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DFxCrlnI"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758824002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UacBu+e7h28pImvcl/11NeynkdBMBbjWx5rs93iSc54=;
	b=DFxCrlnILMnBYmDiPKrRvqoWpNacaT3v3ftHQ4Pk9Vn5+ppuEvneJeR4gnzqLiLDPRnz9F
	wWas/sQFv3iD0BWIzT2x0NwrCc4FfU5LKyiiXI6/u5S4ypinekPqKCTFq5RN7Ae2ZUq6C6
	5S/wKlEI8xegx+GRTNhvCo4cf2rvtwM=
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] scsi: bfa: Replace kzalloc + copy_from_user with
 memdup_user
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <yq1ikh7qo5u.fsf@ca-mkp.ca.oracle.com>
Date: Thu, 25 Sep 2025 20:13:09 +0200
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
 Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <F0B8FDF9-027D-4CCD-A5CA-91E7B2FF4950@linux.dev>
References: <20250918144031.175148-2-thorsten.blum@linux.dev>
 <yq1ikh7qo5u.fsf@ca-mkp.ca.oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
X-Migadu-Flow: FLOW_OUT

Hi Martin,

On 25. Sep 2025, at 04:10, Martin K. Petersen wrote:
> 
>> No functional changes intended other than returning the more idiomatic
>> error code -EFAULT.
> 
> How can we be sure that this doesn't break existing applications?

I guess we can't because the error code is returned to userspace as the
result of a bsg_job? That wasn't immediately obvious to me.

Thanks,
Thorsten

