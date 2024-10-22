Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F2F1A0BE1;
	Tue, 22 Oct 2024 16:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729615959; cv=none; b=i/rj81Hx09SNWsivWCuWe7lS/ZsHDVTs0ft3V2ww123Rq/lyIiwfLqJ/ndcTWGStO/DrcR6WbXosWXrxsTcg2oVNn8mo4P/FUs5deUIEImCj7Lko/L9zYIxTSGa+ybRQJv/0fbj83olfDK8OrPl6w0XF7oXi0FoY07r1HjGbej8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729615959; c=relaxed/simple;
	bh=cyc/ZiF5n6uYSYLfwn2PX1FXyF1iFS/NEFDK2UYNYkw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tP+q3OFHcQc9n63hqAeImnoFBOt1mFHoCdpDzz0L8JWIyx+UcxDQy65dmO5Syee3siPXc+s37YuMTOpmw/guKhXVkk8hO2aWxEywsywX/biJwjsiORvPPPQxCh3QwT6XeSJ9iqlUTgBW8n3dPZmLprncIjz86kI0FaYJ4DeKDhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4B1VtzAN; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4B1VtzAN"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XXysK1THvz6ClY9C;
	Tue, 22 Oct 2024 16:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729615955; x=1732207956; bh=cyc/ZiF5n6uYSYLfwn2PX1FX
	yF1iFS/NEFDK2UYNYkw=; b=4B1VtzAN+Vq026Ma2lpVXkEFF6AgAa6ghSHDCO+G
	47l81HbyBIS4OeWAOEhGr20rDPgHHcbytD69mw0Wo1OMtinMiztRJSPMONJwjTf+
	7Qy6qn0hS8fOBZIDs6zcQ1mioyaXnv5Ezc9s5uh0sLVl4zM9Y3jDAVU+4/ROixjs
	JdhlObBZE5jMSmyj/rvrAAtIqsFZTKNYKneWhA/md/NVvmLmRUEC/9X9IMCW4/15
	G51WWdDewsVOrjH3AL96urKbkO2F7yKsx8tfcdDR0scAk+ib81U54uXxg5F/tSLJ
	bqFwkUWLxu+ckBXXDDX1UO93MKnlYmWh+XP0lUf5aCrAQw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WdlDwu1m5XBl; Tue, 22 Oct 2024 16:52:35 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XXysG5Gjcz6ClY8w;
	Tue, 22 Oct 2024 16:52:34 +0000 (UTC)
Message-ID: <37bc724a-ea62-4d17-ba8b-a3c5cb1d9ae5@acm.org>
Date: Tue, 22 Oct 2024 09:52:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] scsi: ufs: core: Remove redundant host_lock calls
 around UTMRLCLR
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241022074319.512127-1-avri.altman@wdc.com>
 <20241022074319.512127-3-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241022074319.512127-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/24 12:43 AM, Avri Altman wrote:
> There is no need to serialize single read/write calls to the host
> controller registers. Remove the redundant host_lock calls that protect
> access to the task management request List cLear register: UTMRLCLR.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
