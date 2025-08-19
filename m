Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAF126B764
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2025 19:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755632237; cv=none; b=d6UQ3SYzFY7xWIPWch+WoH9qbu+oa0CdA2fzpNOlgFeJYaqieFRjR3qOCknYHTQJKMLfknGIIP7ZJdii8zWwa0DHbeo4W8pECI34+8aiY+p1viIqjbVIPDRbwrd63VVBV3RlpM0n1u9lhRzUNMPyw4RZ2bYyWRZvE/kzimCaA44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755632237; c=relaxed/simple;
	bh=1KZIwnqHwRB4LHWu80gnn34Xsfhn9OpCS83tGcn7lVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y9YmB6ngdb/7QcUl48idzkuAziFvtTemKlFfZbfYJ53YSVZ0pZcn+zSJnDMAAriIynjgfaP3uXMIw/6ZTq/BBhhCmQwoo+wpnIZ969K0lcZoUCOI48umzntBL/duRltoqtOH8ZvWrVz6yLefd0qfPTJS2wanZdoCBDbTRJIBifA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uk/5qxZi; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uk/5qxZi"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c60GM2vVbzlgqVY;
	Tue, 19 Aug 2025 19:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755632234; x=1758224235; bh=N62o951/gtkPmoUuh4w/g+hz
	mIj3AXBog7To7Bztkng=; b=uk/5qxZiSnIodJvaP9DDullVXi0eFo1Mf8gr9Tw3
	+Sn0JCs8ln2mg/8cm1HSE9Fx13M9YoMrhKJDNBny2TzMy1gLFfzRNpP0ZzZIi58G
	emOG6POMP7dV9/Ib3w9eU3yJqJ7Bz9EGBPk2Z1lIg45y+C75gcZYeGcQS/b2+cXS
	pY51CiLLsoBRk54tE2E97DFXQhvR+HVDVm98jZczouJAzwHzhNyffwuLvOUEo4PR
	ugvwkU58YlbxYEoWKKBVaVzeb9nTm2K3MOMJp+ec4Hyesk8F1PVVjkolutbcs60w
	HKwCasoI4+5UwliAG6ZhbEaQ8iSCeo2RPUmk0YpLB/E1eQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 86Nj8XCnSXUl; Tue, 19 Aug 2025 19:37:14 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c60GH1MHpzlgqTy;
	Tue, 19 Aug 2025 19:37:09 +0000 (UTC)
Message-ID: <8e94f8e0-46c7-4f2a-8d1d-97778a1d3a22@acm.org>
Date: Tue, 19 Aug 2025 12:37:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/8] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, dlemoal@kernel.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-4-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250815211525.1524254-4-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/25 2:15 PM, Ewan D. Milne wrote:
> This has read_capacity_16 have scsi-ml retry errors instead of driving
> them itself.
> 
> There are 2 behavior changes with this patch:
> 1. There is one behavior change where we no longer retry when
> scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
> for failures like the queue being removed, and for the case where there
> are no tags/reqs since the block layer waits/retries for us. For possible
> memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
> retrying will probably not help.
> 2. For the specific UAs we checked for and retried, we would get
> READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
> from the main loop's retries. Each UA now gets
> READ_CAPACITY_RETRIES_ON_RESET reties, and the other errors get up to 3
> retries. This is most likely ok, because READ_CAPACITY_RETRIES_ON_RESET
> is already 10 and is not based on anything specific like a spec or
> device, so the extra 3 we got from the main loop was probably just an
> accident and is not going to help.
> 
> Original patch by Mike Christie <michael.christie@oracle.com> modified
> based upon review comments for an earlier version of this patch.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
