Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1CF2EBB89
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 21:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765314016; cv=none; b=sZ1cPn+IEjIFJplcoJnpfZeSRgp8OFGedHPdFL/LrSzb2ynotuZv/KwFJCwpsuIORrCpIFLrTHw4g8FxCe+jX4WWD6MosNW55Whd0b4mctuoG7f5ZPNKoJgynpIWACf/Vb2tSvCDOD3vtUpbGjJx/rE+ulx4KoNfXT5A078dQ+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765314016; c=relaxed/simple;
	bh=vf9vpDavFEdz8ikvgGvJUYAOwehyjuskeyYxcalyK6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kQyzPvmE5jC5I21S/c43EmF5UwrkaIFfVOWTGgcklt3BEUxz44cUryrf9HiASmAs1GSXdnZtlVIPiNkxsK8ThKyBQyFgJcaSdHx1D/K1jWdGx02QVevtNPpqtZt/yj1opqs404M3Qy+lEmXUo4xjmxghnfEkwth67CadkkFQOYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ga3un9FD; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ga3un9FD"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dQrpH6DvMz1XLyhj;
	Tue,  9 Dec 2025 21:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1765314006; x=1767906007; bh=vf9vpDavFEdz8ikvgGvJUYAO
	wehyjuskeyYxcalyK6g=; b=ga3un9FDD0kGQmNX9nlszaM/goPk5f6IjHYqQBcD
	CsrGLYKsoylX9cLnlR9lLAkt+NWm3/sZMenvMnkZ4n66/8VAznn+ecNF9slXzXU4
	QyOlb30/l/IOkSkIYU33vTtxxQjT5NbBzaWlCLhVMDW/5Hn+PLZkrigxLX2LFaUd
	m3Zs6Qwyr6JjBI+Od+sKRf5tQhkJJwQ1iUquzA464R4Fj7Nh8u4jxgpgY1ly3H2O
	h6qNvhom2697MxxlNSnh3fdhHKOdCUwbXuXM2r8YeWFGzpoyzDK7H30TF/Y5cRqo
	jObAZ6GEpwgX4gHJc2uMu1CvNF6/ApnO7vu6MUwQA41twQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rVB2GbRGNbfn; Tue,  9 Dec 2025 21:00:06 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dQrpF0trmz1XM6J5;
	Tue,  9 Dec 2025 21:00:04 +0000 (UTC)
Message-ID: <818c2c48-6962-46bb-8268-d377eaed3083@acm.org>
Date: Tue, 9 Dec 2025 13:00:03 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] scsi: Make use of bus callbacks
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
 <59b408f6d89d402457a23564302afcbb334bc9dd.1765312062.git.u.kleine-koenig@baylibre.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <59b408f6d89d402457a23564302afcbb334bc9dd.1765312062.git.u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12/9/25 12:45 PM, Uwe Kleine-K=C3=B6nig wrote:
> The objective is to get rid of users of struct device_driver callbacks
> .probe(), .remove() and .shutdown() to eventually remove these. Until
> all scsi drivers are converted this results in a runtime warning about
> the drivers needing an update because there is a bus probe function and
> a driver probe function. The in-tree drivers are fixed by the following
> commits.
Which runtime warning? Has that runtime warning perhaps been introduced
by a patch series that has not yet been merged?

Thanks,

Bart.
