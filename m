Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB672322C9F
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2025 19:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755631699; cv=none; b=fxVwdaqZvc3/TU5P01BrRaFo40ga1Vuk11GWSlRFJXQEuQHw6X1PmRPGfSuJ0E2pax+qc0bOKebDfZjAGQdkO3eOp8HYt+hGrs515au7gxbAZfpNR0ARctYno9CVXa3MBIgjPlJJsMHh0gV4ohFuGsMaEt8ebXSFAS7LUJA/VW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755631699; c=relaxed/simple;
	bh=KT4GvZigG6yKnqty/9EcAf5Ia7vCnSci7jfL2GO8bDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mUzMNPQHGoHsWFg7IS/Xqg9hXPF6NmVogI8PcdAHRFRR5g/zajfsm8U9EF7Z8KIOx3pL0YYC1qlYmUTwPA/x/vy0jQ+C9X4XJr6gGV/OcX8dK/6nff703iqMPZnOd4/87IWHhLE3o1j6Ym7QSdgUQXU5o39N63KOujM15NJbmN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Djwpe4qI; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Djwpe4qI"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c603y6F5DzlgqVc;
	Tue, 19 Aug 2025 19:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755631693; x=1758223694; bh=KT4GvZigG6yKnqty/9EcAf5I
	a7vCnSci7jfL2GO8bDU=; b=Djwpe4qIOHLgS8tgR8AzI8+siwzi8Z5BBh/Gdi3g
	OFf9vCD4TOiKaSImAK04hRqmItTghACY2u6qHGWdvfxLZjIrJfsCuqMtu3mAJyuo
	BDysjwWcRK5BXYAIATo9V5xixg8GJxh+LO9on6224BPHLFx1x+wx1PnV4Cf4T99I
	hPx34rDSfaVqxZozhtyds1AXqADwuE0W6PGrcdGhEjl66SuWc4wplZVlvs4T0a38
	6eOVIGrVyUFCrgk/eDPVUknnxNU82SGSj22P38C7RSw9G/QBc/XiCWZwUrCAfBp9
	yUBIU6TPB3lWjh1Pgogj7JsvkGtVIyupU7JJyCMvSfayCg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YXCLwgnd2ozt; Tue, 19 Aug 2025 19:28:13 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c603t2Rf9zlgqxv;
	Tue, 19 Aug 2025 19:28:09 +0000 (UTC)
Message-ID: <115db9fd-b67b-4cc1-8cc7-563582c92bf8@acm.org>
Date: Tue, 19 Aug 2025 12:28:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/8] scsi: Explicitly specify .ascq = 0x00 for ASC
 0x28/0x29 scsi_failures
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, dlemoal@kernel.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-2-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250815211525.1524254-2-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/25 2:15 PM, Ewan D. Milne wrote:
> This does not change any behavior (since .ascq was initialized to 0 by
> the compiler) but makes explicit that the entry in the scsi_failures
> array does not handle cases where ASCQ is nonzero, consistent with other
> usage.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
