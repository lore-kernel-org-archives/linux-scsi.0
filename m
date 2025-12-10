Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E5D1494DB
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 22:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765406711; cv=none; b=TfnACJqvD7zJ2CyvCpjATEOtyBSwzjX4Pc+KZgkO1HsS+FG6gO4Dbuamob9biwuIjxEiQuXHTAps2ZBrFMiXF70zb4IKyltBrzi70qcLpibso+u9yVA89DEDcw2LCagGH6zlSxxnOKoW8ls+EyoLWQe7Dqw8IdH3CZuEVYyOues=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765406711; c=relaxed/simple;
	bh=F8wDMLR+rE6vB+IU6VHsmx+VpD4YowSl7bw9UYhjoCc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=H7qRI9SLYxo9CrHbjT71eXIN40n/rnJoU8fToH/UMWRUg90TNdnma1fCorut0zJJHs5srkvRgFK2IbRN6IYQyI+gFPoi+ApUW/HXEkQwk16w35g22DSnAaZQu8y7atEarFnV5O9bLnvwjZLYIUsGC1Di/9wcBw0yXZBh+oE2360=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VSzpe43Z; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VSzpe43Z"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765406706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vv7jw0YtjWobu2NOG4bl68llMTBn+GzU2lUUPiSfLB8=;
	b=VSzpe43ZtJGVlpkYlryr7CGbdc2zK6VwYjEs0GfXEljAD2PPXsb2Qd3hiZKBn1eNfc4fUy
	nHwJDfXBT1E/InskyNNLLr7KiHpwNuRoG7oFmrHIhGP+jbvDjAvCv5Ai78GwM3eZ0Xdli6
	/zCjzUH4BJMV9JZnRnoWqeF9rM2VJls=
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
In-Reply-To: <20251210222100.66ac5c88@pumpkin>
Date: Wed, 10 Dec 2025 23:45:02 +0100
Cc: Christoph Hellwig <hch@infradead.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <2A50F908-C2F2-437F-A817-889C507FBF13@linux.dev>
References: <20251210143322.596158-1-thorsten.blum@linux.dev>
 <aTmOB6-uRMV4BT1H@infradead.org>
 <E269B89A-5111-4AB7-A875-92A3EA13B4E1@linux.dev>
 <20251210222100.66ac5c88@pumpkin>
To: David Laight <david.laight.linux@gmail.com>
X-Migadu-Flow: FLOW_OUT

On 10. Dec 2025, at 23:21, David Laight wrote:
> 
> [...]
> 
> You'd need to run sparse.

I compiled it with C=1 and there are other, unrelated sparse warnings:

CC [M]  drivers/scsi/pmcraid.o
CHECK   drivers/scsi/pmcraid.c
drivers/scsi/pmcraid.c:73:1: error: bad constant expression
drivers/scsi/pmcraid.c:74:1: error: bad constant expression
drivers/scsi/pmcraid.c:75:1: error: bad constant expression
drivers/scsi/pmcraid.c:76:1: error: bad constant expression
drivers/scsi/pmcraid.c:78:1: error: bad constant expression
drivers/scsi/pmcraid.c:79:1: error: bad constant expression
drivers/scsi/pmcraid.c:84:1: error: bad constant expression
drivers/scsi/pmcraid.c:85:1: error: bad constant expression
drivers/scsi/pmcraid.c:89:1: error: bad constant expression
drivers/scsi/pmcraid.c:90:1: error: bad constant expression


Compiling with V=1 also confirms that sparse is running:

# CHECK   drivers/scsi/pmcraid.c
sparse -D__linux__ ... -D__KBUILD_MODNAME=pmcraid drivers/scsi/pmcraid.c

