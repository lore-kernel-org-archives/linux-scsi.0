Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE6C26ED41;
	Mon, 24 Aug 2026 01:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787535589; cv=none; b=JQfdUpJgvz7GbrIySsnHpWVYD74DrRFHrYXOoLU3Lay0YhKyQsi10WtEyuaWsBcwZHoGDKW8kRAERTL3HXwA6tqcjPMdzu9TTySZ7iC89gTlDFasQDz+9VsxroWS0qdUGHSEImCMK0qja+yljywYEpz2Je4AfemBblRtcCrkLag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787535589; c=relaxed/simple;
	bh=if9ehEio3/LdJIhJ5+JdVzJr6vz3Xq23YEYjDD5wjRE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=CoJTFMoUynYtMWj/he5Io/78+AewlvbW54GtfAuVMzW0KkkT/PKXyLPx9f0t4Ns4SwsNE5+qd/YzE/MuhxqBfE6PVR8V9F3uADtnduvvIfdL5hxaHP361h5LaaLfCpcq1KDkzqBxpTtjVAtHv7cvcm0ei8fmdQGSqnKUt5xZzyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NZhVm8sq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZhVm8sq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3651F000E9;
	Mon, 24 Aug 2026 01:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787535587;
	bh=MosCNLmX0s2XDvXfNC2OyDh+Zo8xsRa5ojo/fMl0hy8=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=NZhVm8sq44pfCM0iA5RY4WivhOAFFzwhMV+PvK+JKk0IBNFwfY6jgDNmMqttbKUA2
	 nTmNtlab2bUnjO0abWGu8Bj+Q8Dw4ijndHuStONCqbuJS2sAp4R7UGaF0fNSFuyDQB
	 RimFTG69PI7Z/QeLZOSgZLpRa/JgUXBJdKF7nBA6aOcCL7i5RyLiw9JQftGx7CwhXH
	 ex7IdA3VX8SAdJWQxII8XGl9zX0/PmMUVUhOPfjK2laHlgcZIMSPr5Q7UH3pzVAXsh
	 15g5U7zzpruy19DrqYrLQWF8kD9gZFDkcKytU4f/BLwvUgxaMUBhWHRDHw7KZrA7+i
	 WN/ZRFMCB/hPA==
To: Nathan Chancellor <nathan@kernel.org>
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <martin.petersen@oracle.com>,  linux-scsi@vger.kernel.org,
  linuxppc-dev@lists.ozlabs.org,  linux-kernel@vger.kernel.org,
  llvm@lists.linux.dev
Subject: Re: [PATCH] scsi: ibmvfc: Fix use of uninitialized rport in
 ibmvfc_do_work()
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260817-ibmvscsi-rport-wuninitialized-v1-1-0fdfb27a5f01@kernel.org>
	(Nathan Chancellor's message of "Mon, 17 Aug 2026 12:04:55 -0700")
Message-ID: <yq1h5kkpa95.fsf@mail.kernel.org>
References: <20260817-ibmvscsi-rport-wuninitialized-v1-1-0fdfb27a5f01@kernel.org>
Date: Sun, 23 Aug 2026 21:39:46 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Nathan,

> After commit 696d1cc2aaa2 ("scsi: ibmvfc: process NVMe/FC rports in
> work thread"), clang warns (or errors with CONFIG_WERROR=y / W=e):

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
