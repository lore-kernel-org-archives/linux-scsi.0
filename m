Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4004EC653;
	Mon, 28 Sep 2026 17:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617009; cv=none; b=OL3MS7IAYloP9Ye5qtakpxsBfv5ee4FdlUJTFO4ZRXumcAo/fAbO0ocIIOA659+sqaOhwN1Je36L0v0RrcnoWePoQykn7bqKUgA6F0zZFHhT51F3RNSWiW5S6xHONxZUaU7E9nv7Ai+3i/zOuDuwiVWHTqJaOYDoJfxA7JiD6eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617009; c=relaxed/simple;
	bh=mWiDXp9cBL2bV3GI3t1gQgk/lSAycgALIomUQLzG9Fg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=br2N4wFOQjf/RtAN13jsKAMSx6tjwLWTkiHvoY5o277ZcT8qInzKokD+kg1lFh+CBizCnmPUAxL4cLWigSlyAbQ2bMQmKci1PwqOcFekmfrjllYTFsvCbMn4bQpUBKRzN6QGEGwfzIz+WDb9KE5tYU/E705DO5KsandvT6JMJBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DsuOKrL4; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DsuOKrL4"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4htpQR4MdLz1XM4TB;
	Mon, 28 Sep 2026 17:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790617002; x=1793209003; bh=mWiDXp9cBL2bV3GI3t1gQgk/
	lSAycgALIomUQLzG9Fg=; b=DsuOKrL4tCvJ6BdYwGNj+70yh64TRLaVuOf+HGwC
	keIf9tAuxCFGbE+YTHKYv9hpn7uQSlbTGpZKvaKTtvtq7EmN1GB/fI0olmEkost5
	iqOrc5+/euh8b1/q6AhoQS+0xuFeA6FOSHe87gXy11Z2EZnGZNK0TeunBO7UYKaF
	Zi1v6vzr+3HfVLg0d7sQYMtpeKnmYP8KyDnCV6Fhrcjz5vgzfVjlZIcBIa2GC5br
	NqT/0YFtXEq/+I7zqr+dwlcemYvQ0FllJUo2TgAXsFfx2WRX6pj4FqJKnDw198fV
	IP6HgN0mpGFm1Mrjr0pg7UJW2cFIaLw2g0kj5yhCoGH0sA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kPp6LyesfQg7; Mon, 28 Sep 2026 17:36:42 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4htpQH08Jwz1XM4Sx;
	Mon, 28 Sep 2026 17:36:38 +0000 (UTC)
Message-ID: <9c6ab443-051a-47dd-80c7-3b023cc29d68@acm.org>
Date: Mon, 28 Sep 2026 10:36:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] scsi: bfa: Use snprintf() in
 bfa_fcs_fabric_nsymb_init()
To: Mariia Nikitash <nikitash.mariiaw@gmail.com>, anil.gurumurthy@qlogic.com,
 sudarsana.kalluru@qlogic.com, James.Bottomley@HansenPartnership.com,
 mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org, morbo@google.com, kees@kernel.org,
 justinstitt@google.com, codemender-patching+linux@google.com
References: <20260928090031.712418-1-nikitash.mariiaw@gmail.com>
 <20260928090031.712418-2-nikitash.mariiaw@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260928090031.712418-2-nikitash.mariiaw@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/28/26 2:00 AM, Mariia Nikitash wrote:
> In preparation for removing the deprecated strlcat() API[1], replace the
> chained string copies with a single snprintf() call.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
