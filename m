Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71482385D82
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 22:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786142930; cv=none; b=d2jUyiSJGReUiLm9EehS2sdIZ3GGp8cLlYR5hFxaOywMvz+1Hi1BwuVQ8qSZfS1vlrITsRlz0vvuKUaRGbnO3/+Qso2uAyDAMBAV42wgq5KWFv3wgOJHiZnRcrpfchbAorvBcce3jjev33Zle4Gvv9azIZ3LRTxX4HInImSwRs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786142930; c=relaxed/simple;
	bh=iOSBP7UqhXkMFUUGhDGlGOBM8KVtfuDUik2R8N5ty5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2QLfEd+G/wndILuluu9JsATO/vRn1VWayqrmIhIJ+R/3AIczphLjKFEyzo8LCH6j/tmEsUS9GiUNXLpHm18JQCwP4biNDj2M9MG1ZwJEXJ6XXVGj61Au0kQ+LBPaXCrKuRH+VyYD2lA0/3ULrNA9gxS0rK31FVipigoUKwJn6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1UcxH71E; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1UcxH71E"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hGzpS6wPwzlfvq8;
	Fri,  7 Aug 2026 22:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786142927; x=1788734928; bh=iOSBP7UqhXkMFUUGhDGlGOBM
	8KVtfuDUik2R8N5ty5M=; b=1UcxH71EG0G4xKIliiPFjz+YT5ebGSFwAR6qCbn3
	jdUX67xUpXkW3BFZl5wLPvSiPOmSCgN7QaaUAue41RspgnHAur/ecsUi0GbKZEvX
	QjzRfm347WZcMMeBpD9LA+pa5LxoN/jeJnxGed/eSOdLdiMjwZij9IcggbZCWnLh
	V2WNI7AnLEnjfPhWnD5TZEjAydYGt8KhBVxbyxxy+z8VGFfFho5TRaKIXU+c3GFn
	VoZFKvhOAhoDBm7x0VxsuyIJqFm6FJbMr2yr0I6wMmJ81ytt8+CheteFsX22Ibgh
	GcqVVmxHniX+2TvjrXW7Hs/bEXE5m/05lx59XRCJpJO5Mg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JPsDedoqU-rv; Fri,  7 Aug 2026 22:48:47 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hGzpQ17mJzlfvq0;
	Fri,  7 Aug 2026 22:48:45 +0000 (UTC)
Message-ID: <62c8f377-1a95-40d0-9fc5-2f8238c612d1@acm.org>
Date: Fri, 7 Aug 2026 15:48:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] Enable context analysis in the SCSI core and UFS
 driver
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>, Marco Elver <elver@google.com>,
 linux-scsi@vger.kernel.org
References: <cover.1786140825.git.bvanassche@acm.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cover.1786140825.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/26 3:44 PM, Bart Van Assche wrote:
> [ ... ]

Please ignore this version - there are two versions of patch 2 in this
series.

Bart.
