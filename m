Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6172411C83
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 17:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722014243; cv=none; b=tNc5yWoJY98q3wTz/qe2ahBGqVjtJPcW7Pb+kZoTZe4T5c2DfQxZohrRGjAps05EBFza9UxCP3aw5TEbjU0gPo/D88uOdn6xmK47m/OZosuGTvdP4erFIgfXoRmqnsDdXZlX6GtuHdbmXwy9v6GwGjKkZ/lLVN44et7wRW0Vqq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722014243; c=relaxed/simple;
	bh=5yeGIsPtkAmXaiZcBAKPbG5JrxoXLfHbnBsKxsmnDOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fh6SQaYEGd0pxIBe9WQb+Y89km0stsfi+krBwTBdgraJy5UQTpbRYz+RpJItMvY8uwCGnAjDXqt8MNSrCF03HOpgcBKKCiolw1RpdI0gVwXhUNZECvkFiCsaorIPLOYhfXEyOW9dq2facYvivqmPID98og3SO1pmWpMpvKZ6RRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EIXiGDBW; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EIXiGDBW"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WVvZM4KBbz6ClY99;
	Fri, 26 Jul 2024 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722014233; x=1724606234; bh=5yeGIsPtkAmXaiZcBAKPbG5J
	rxoXLfHbnBsKxsmnDOQ=; b=EIXiGDBWwCvb7I7dhZ7DGsa6Fs9+XM7l+QomZ5B2
	CK/h4CJxOD1L+ZlvyTABN3gKWmYx80wdw9/hyA1/OcjSw1KK5b8hB14DuxCydyJ9
	kCVW3yqiJPc585WO5MT/dkR0TTCe6GmwE7diGsKIUDZbpDuEcj+TjsLG9vU35icj
	0hL4bZ2gtcCwJYtRyFkrH5jI4vChJO9NMVUIu7EjdZoHDn9pJqgeDgz0zwJR7btR
	8O1d7p2XUn8uUcC8IGpd7uheqY4WrWWEsonoxBePY9GFtowr8DYUjhCeJFKhRrb7
	AXjY4hefAsdHAEsNpZI0EHo96kgpLe/L+RfDoUF82SpXJQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9uaJUlaWaFjp; Fri, 26 Jul 2024 17:17:13 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WVvZJ68vxz6ClY97;
	Fri, 26 Jul 2024 17:17:12 +0000 (UTC)
Message-ID: <cbece1b3-08ff-4fcf-8ed3-71dab06aafaf@acm.org>
Date: Fri, 26 Jul 2024 10:17:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_debug:Use min_t to replace min
To: xiaopeitux@foxmail.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, xiaopei01@kylinos.cn
References: <tencent_E821B8DA466472675139402A7A799C7CCC0A@qq.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <tencent_E821B8DA466472675139402A7A799C7CCC0A@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/26/24 1:55 AM, xiaopeitux@foxmail.com wrote:
> Use min_t to replace min, min_t is a bit fast because min use
> twice typeof.

Have you measured the difference in compilation speed? Is the difference
even measurable? Do we even care about the difference in compilation
speed in this case?

> And using min_t is cleaner here since the min/max macros
> do a typecheck while min_t()/max_t() to an explicit type cast.

In other words, this change makes the code WORSE. I prefer no casts
over explicit casts because introducing explicit casts makes it
impossible for the compiler to perform type checking.

> Fixes the below checkpatch warning:
> WARNING: min() should probably be min_t()

checkpatch is a tool for checking patches and should not be used to
check upstream code. Additionally, please fix checkpatch such that it
does not complain about the code touched by this patch. The code in
checkpatch that recommends to use min_t()/max_t() should only complain
about min()/max() calls that have explicit casts.

Bart.
