Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167A815D5A3
	for <linux-scsi@vger.kernel.org>; Wed, 29 May 2024 22:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717023215; cv=none; b=QXG+8kJNo9uaezdDvtP9qHHB5qvN9wB6fr8+EdMsbT7Xp+aqcEQo9bueZf1Kt7fJMHDOoSR7BcG3vKr017oWRdJBtlF6OH4FeiRYBDWdloWz+BaPY3Zt6sTDKQvgyy8fMgu1MM2xQBxSknZdb5tb1nbKVZPL35Tn9DYEgPrm5pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717023215; c=relaxed/simple;
	bh=5PQPktahBptfBR86n8C1DaqXEcEoR0i9ULaNYmBa1to=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jrZsNRG0n37TIdM5uUMAgdEhuNSm020Gv64PEZ+86forwrWJlAf0CPXSrGwpWhqR987kOn9YKcZQeqqo0O6qNKFzg3ytbhWnynzWVgyVCn02FjDdEEQNXABkaq4Jqh5As2Njf/UfLBtUTkoK2tmiXeIc4bwPIODfyXggXFm/51Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pEL7lcVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pEL7lcVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F41C113CC;
	Wed, 29 May 2024 22:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717023214;
	bh=5PQPktahBptfBR86n8C1DaqXEcEoR0i9ULaNYmBa1to=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pEL7lcVBqNsbC9a0PIHhPL6Z4vBOwCsRV6rq1MrrT3cLjz+T+5Os0ChbSBtVDFWbm
	 RQXv/ZlSuOq2I971UH7lwTxWMA9Oaw4gvDUlB5i4EWCtQ9rd8OQPzXPyHgaljAcXVD
	 MRpq5gLVUoFndrFrkl4TVc8Gi7pZy+wyNTky2OC/1QUmxnrIyGVrXvyJI0wghbJf+9
	 jxBCY8h6qZy+68rQyPa7+AAAC63Xp7Uc2wDPoIoV4ItUvNoFfRXaYwnva1W/X5xv6Z
	 v4vlTrSnEXb1utHr5xRO2DBXcpBbovk7cwe4LUr6HiHMgHvpY01APm5zzgSLrEdi1A
	 91oy8b9TJW8jA==
Message-ID: <a3567a41-c464-4259-aad7-e8fb803a5906@kernel.org>
Date: Thu, 30 May 2024 07:53:32 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpi3mr: Fix a format specifier
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240529205226.3146936-1-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240529205226.3146936-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/30/24 05:52, Bart Van Assche wrote:
> Fix the following compiler warning when building a 32-bit kernel:
> 
> ./include/linux/kern_levels.h:5:25: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘unsigned int’ [-Werror=format=]
> drivers/scsi/mpi3mr/mpi3mr_transport.c:1367:25: note: in expansion of macro ‘ioc_warn’
>  1367 |                         ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",
>       |                         ^~~~~~~~
> 
> Cc: Tomas Henzl <thenzl@redhat.com>
> Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
> Fixes: 3668651def2c ("scsi: mpi3mr: Sanitise num_phys")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

