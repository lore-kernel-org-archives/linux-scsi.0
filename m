Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D021898F2;
	Wed,  1 Oct 2025 19:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759347853; cv=none; b=Aa3UOaltZUi7EkPyRhGpZgykn0zkrYNrG+bakfLlRZP1+RMEGR/ty/7mDh4s2Iiw+ajiXrUN+JtlnsdgXh8RGQl6L241ZtGNrCvRfuOchadMCYfuKwa7FteaQeakL37MRE+PzTimaQAr4bMiu0Dyrc4vZpO3ug3qHxCQ3aabyDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759347853; c=relaxed/simple;
	bh=sZC9Cc5qimBHaJMXkgIGAMY0M5BLPARika85afPbJpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lpTeGn+r0w5N7VXbpPjKddTR7vafx+xxSGRIbH6oyzsZXZOzf9S2mu9fjN9F/4vop13M7Ytzdz6jIwiT9Jfaack9aiTkXzRtBhkx1mmvkmwDq11nU6qhA388MynyY6h3wEKEz72qtq8nOpDk/qeO8FXLgmWMixlhSZF1l+DN5SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=K75bn2d0; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="K75bn2d0"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ccQNP3d0fzltJQn;
	Wed,  1 Oct 2025 19:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759347843; x=1761939844; bh=sZC9Cc5qimBHaJMXkgIGAMY0
	M5BLPARika85afPbJpQ=; b=K75bn2d0qFfR2XlspY2sw+RRqlRSYl9K/7RfKmgu
	nhxsjmgQIn9VcZAc4QyFGE4wf6vvJnBXyLTPo69DJ6hClBfQmFyDsdth+KUvNhpg
	sz67ZKgW3L9PyIxnGdC5NAnJrnkPj7J0h2Rd9C2H3qqX3tWO47NQB+86HrcXINn6
	WrQWdCAVybUAEmpLdJ63vsPIpuq5r6DBInRfnn3qAYFMJD683iwkGb3x0+92U5iu
	nCpEG9bi2LVi1q2cad6LoqfevxudWNonvd/IDwmXeFRDqjfNKA4+wGQijPmIzs6y
	AytfUnRemBhPKSBmBbsni5LlNsrEruvG/Q7pGLZituHb6w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xj_rEbvumcNI; Wed,  1 Oct 2025 19:44:03 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ccQND0PsXzlh0dl;
	Wed,  1 Oct 2025 19:43:54 +0000 (UTC)
Message-ID: <f184dd1a-1339-4d62-9e24-cf18672f4089@acm.org>
Date: Wed, 1 Oct 2025 12:43:53 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] rpmb: move rpmb_frame struct and constants to
 common header
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, beanhuo@micron.com,
 jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251001060805.26462-1-beanhuo@iokpp.de>
 <20251001060805.26462-2-beanhuo@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251001060805.26462-2-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 11:08 PM, Bean Huo wrote:
> Move struct rpmb_frame and RPMB operation constants from MMC block
> driver to include/linux/rpmb.h for reuse across different RPMB
> implementations (UFS, NVMe, etc.).

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
