Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56EC28934F
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765381225; cv=none; b=pemVXW8bDSuOg9/F+5OmzuguGBmESMqcmCIo2KGIadqBpfP48V+QOK8yfAdy6TFPTRsja5UkaOIiAu0RyvahM0ZvLKsyoAk5fkXVifstZJQbkGx2E9zSyyLjKirNZesefp7J2WPSplfUyRFtomb64DZf1iXiNwbm/mwA58CjlgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765381225; c=relaxed/simple;
	bh=1PiJ+iiqZ/T/uCrvrMSAR304fJnymq+YYrnRLemZjr0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=UcHj6Wu05nEtTT//Ux7cd5NF6C7dd+xWPaJ471S8sYS/RQj2nJNDNSCHmjSXn+FXgNVRhFbJPXVRGKVICIwwm5v1zh/0f8dCjOLZ8vTMCAq25jPKl2P6ggQx7YXspTTiNym13h0crddW5+USllCW46EJIxqF93+QVvKyXgMs3aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qafr9isu; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qafr9isu"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765381209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jI0jCCFNU5JVr14ZTp1bdDkTTbDsgs3xxoGAkvXWW1M=;
	b=qafr9isu4TuT2qA3Uw3eJ3NgKWlW09DTs3ICtXMky6n6ABt0CWfKj7uGuKJbULto/NQdcH
	GN6ciuqHuhFwAEzWYPrgGuW7K+xSthIabpYF7FzyyiNYxCh852sTt4ZGhjt/p0/2coFUES
	ZbWapLDi/WAXh986FyqfDx0MB3L4wRM=
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] scsi: pmcraid: Replace cpu_to_be64 + le64_to_cpu with
 swab64
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <aTmOB6-uRMV4BT1H@infradead.org>
Date: Wed, 10 Dec 2025 16:39:36 +0100
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <E269B89A-5111-4AB7-A875-92A3EA13B4E1@linux.dev>
References: <20251210143322.596158-1-thorsten.blum@linux.dev>
 <aTmOB6-uRMV4BT1H@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
X-Migadu-Flow: FLOW_OUT

On 10. Dec 2025, at 16:13, Christoph Hellwig wrote:
> On Wed, Dec 10, 2025 at 03:33:21PM +0100, Thorsten Blum wrote:
>> Replace cpu_to_be64(le64_to_cpu()) with swab64() to simplify
>> pmcraid_prepare_cancel_cmd().
> 
> How does this not break the __le64/__be64 annotation checking?

I'm not sure and didn't investigate, but it compiles without warnings.

