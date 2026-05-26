Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412A12030A;
	Tue, 26 May 2026 19:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779825152; cv=none; b=WzFMLrlf6wz3rK3awRjKGmuOajjuoJzHl9rKmmfYcaN3aXT56PoSUVFEVWt8Q0olASSwYLNjtDaQ356Qpay5hPqjtMRannqkJ+nOmCM7PwJu1XWiINBISMdFv/4XnqA4CmqEt4VCD+VsdJPltHRl3++sYZneMiuvcJJpdDCnkdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779825152; c=relaxed/simple;
	bh=bfr4/gTpJ2BOAPyaIMWhiXQI+C4QsI+mzJKCf7JSwaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pw5B7DUw0wK/7d5HXyBOcdrGMXsOeM5LDh9JNNrotD8upNClCMWzxCNjQxSdvZF8DlRSuPz0DMRPE+kQHla2tJWzXSk4UlC5LAzVEnfxFOHGPHpwwp4wiDPGb2P1GVBkNmzCkoFMAVVnwr1fTeWhFc49OmhESSzYBd/+Gqo/swM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qwy9vBgg; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qwy9vBgg"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gQ3Lk64ppzlfvpK;
	Tue, 26 May 2026 19:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1779825147; x=1782417148; bh=coyMB8aYXBtH5Rpxf8hEAT2O
	iFnPT1eM8iJk/09nfRQ=; b=qwy9vBggAOQROF4cnmN0x8JWXGIJnQsGdEtQzGNz
	W2ezyf5TmBCyA60wFlkobSikuVergak3a1UvcLqx86fCMGKV1d9CHwmnGRUCIa8I
	syVqLG/8dFSCYfNTHV7TZL7/UCaU650xC7ZePFDNabsebDsaE/6NZ8mWJNm/qkfE
	nYVf2+bt/rP+FiCfxzs2DjH+jZgiqU1biaE24mGxb9+ZQ1ltbiIqTIJchw+Dmw6R
	SloYmPNGIgsARInb6HWTL8MHvOqT37d409jAv5KZyHViJyrJiMd8oOhDKCRjnwSa
	QOD/+dSwdvCGNsA6LKEkb//5ploFE+hn0/0lQJjfmqTb9A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ABNjhmHn6mnZ; Tue, 26 May 2026 19:52:27 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gQ3Ld4svJzlh1V6;
	Tue, 26 May 2026 19:52:25 +0000 (UTC)
Message-ID: <cd74d73e-0784-4e16-8de7-ff17df13c8c1@acm.org>
Date: Tue, 26 May 2026 12:52:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: pair EH runtime PM get/put
To: Hongjie Fang <hongjiefang@asrmicro.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 jgarzik@redhat.com, stern@rowland.harvard.edu, ming.m.lin@intel.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260525064556.1277177-1-hongjiefang@asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260525064556.1277177-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/24/26 11:45 PM, Hongjie Fang wrote:
> -		if (!shost->eh_noresume)
> +		if (autopm_get)
>   			scsi_autopm_put_host(shost);

Since this variable controls whether or not scsi_autopm_put_host() is
called, autopm_put is probably a better name for this variable.

Thanks,

Bart.
