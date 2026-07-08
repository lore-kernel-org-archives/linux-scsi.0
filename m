Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418143F23C4
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 07:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783497483; cv=none; b=QrfeE0d8bO/284uhZB4MEP27TVD3AT69cBP8dDVP13iAkhrOwAJ056ro7gjO0Vl4dyVl3m9kpDI0PXcY2OEziNg1HZTMpojqBU1T1ZwLVPlwnvReimj0gQ3RHFNBVHAqUJw3tUZIcb49W2xoeQnc727ZH9/Rmfcpl8smLWvfKRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783497483; c=relaxed/simple;
	bh=oHFrKOxs4d74venaBNt3pkoZJY6jbprN87xP+J56jZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=adoGEDuc1fpqP7ywEAO/fLJNT7vcgAmAgTUwwtfCWuZt3dQXVex2aCUub0/wKnsP/klbLvdqC9xEbpehTXITsdhp9UG2BCx+5EtR2PYy3jDxlZqaY8kBkCU9X6XNhd742yBIli2z2r1b90viZz4knK9Z1AK7tFTHQqs2F3xuPQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gtLUJyvi; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gtLUJyvi"
Message-ID: <31718d0f-b170-41a4-8a3f-9d15582e98c8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783497475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mR4lfWo7GfjucSPv2Zh86OoqsbXdlAXQPR4Rl3VBAQU=;
	b=gtLUJyvitG1d9WCXrxgFW2eRcIpSWAyBYObX8fyETCP+QkANN5jlNqGsmwvWm/ylnu5ZZm
	bPqY/rMHFqDgQtihrc1dvq+empAlXgSzyX5/QJCKsYJr62nHMxaJxI7ahru2GY5usjns9z
	hv+zh6MPUEdkyIO7Y+OEU3yhIh3m/N0=
Date: Wed, 8 Jul 2026 08:57:52 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/3] scsi: sd: fix error handling in sd_probe() after
 large pool creation failure
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, john.g.garry@oracle.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 dlemoal@kernel.org, linux-scsi@vger.kernel.org
References: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
 <20260707030333.22245-2-yangxiuwei@kylinos.cn>
 <26757492-f9e0-49bf-bc77-4a6f3ae64276@oracle.com>
 <20260708072249.264705-1-yangxiuwei@kylinos.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260708072249.264705-1-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 7/8/26 08:22, Yang Xiuwei wrote:
> On Wed, 08 Jul 2026, John Garry wrote:
>> However, would it be simpler to always create this pool for LBS enabled
>> (and not just when we probe some disk which has sector size > PAGE_SIZE)?
> Yeah — same idea as sd_page_pool at init. sd_probe already has quite a
> few error paths; I had a go at consolidating them in v1 but dropped it.
> Moving the pool to init seems like a cleaner approach.

Sure, but - as I said - it may waste memory if we (likely) have no disks 
with sector size > page size. Maybe it's better as is (to alloc in probe 
path).
