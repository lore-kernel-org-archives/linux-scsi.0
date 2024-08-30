Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586E51384B3
	for <linux-scsi@vger.kernel.org>; Fri, 30 Aug 2024 12:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725020010; cv=none; b=g0jJynKYk1n36BQgxbW2orFj/LuIt1U6lAJ1Qx0lK259g1A4ehCvYsdeQGLZ8vxuwwGhN0RwBSjBSzMKmwpsoMCw7Fyk8Sk6+nC7Ee115DuLo8loC5TCYH6ON5pzq5TiFj1ibClMwSuDGjZ2RL/MBdgIa7PeAbu3vwq8rNmLa8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725020010; c=relaxed/simple;
	bh=W8Q0uvFYs5+MM+/ruP+qEuDbaR2corhKE5FK0l044U0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=awIy+5i9xIbio63sDt2RUuPsrZbIpWkFSadwXIZ90WmFJ3vpWc7B1NtSDOHbd9nRIlEkXIyPqWLHG+BtTxaFqsIIykMvPt4BQDjfHpLpgghJQ15lFU5BgTOjhg2iol4j9tbyxTJYtXAhd9tkh7IsAbiJwYcUopU+il90B07IQ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NCYb6w2p; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NCYb6w2p"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WwH9Y6wNjz6ClY9t;
	Fri, 30 Aug 2024 12:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725019999; x=1727612000; bh=XOkEuPXM7LRE1eyWpZ3In2Dq
	o6FpWHeR1sixCh6g0JQ=; b=NCYb6w2pH/nGi9V5idTVfSPw4PgidFCj4UYaq9Wi
	NFVfcmMjv35ooqQymNh+Ui2pIbfFaZ7R1yVmoVmHroh/uBsBbRiSZ/VmbKaG/qjI
	f2q0DYXRA6DY7XUE+85F/iMiGdDLCQqkyUa2eUZRjdtOfM38fbat7sIeU3YNkAml
	oXXC75VZml91XZR3mCtA7mvp7iGgWagB9ts00DhOEfjwDbbBc/f93s7t/PSG0EvL
	EbcB5nZ1/yY44GfhtrUwtNSGvWLUg4OikQznNUeOCQqUVqryxnb1BjCivd6FXRDU
	rXREs6AnvNxnDPqc70beFdA2HX5xSVT6rkHqDFgZfKLJxg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id g3LjLNODAc9m; Fri, 30 Aug 2024 12:13:19 +0000 (UTC)
Received: from [10.254.113.103] (unknown [207.164.135.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WwH9V3tdjz6ClY9Y;
	Fri, 30 Aug 2024 12:13:18 +0000 (UTC)
Message-ID: <bafcca6f-a23c-4c31-a982-b553a96c3dad@acm.org>
Date: Fri, 30 Aug 2024 08:13:15 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] scsi: qla2xxx: replace simple_strtoul to kstrtoul
To: Hongbo Li <lihongbo22@huawei.com>, njavali@marvell.com,
 GR-QLogic-Storage-Upstream@marvell.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
References: <20240830080505.3545641-1-lihongbo22@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240830080505.3545641-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/30/24 4:05 AM, Hongbo Li wrote:
> -	num_act_qp = simple_strtoul(buf, NULL, 0);
> +	if (kstrtoul(buf, 0, &num_act_qp)) {
> +		pr_err("host:%ld: fail to parse user buffer into number.",
> +		    vha->host_no);
> +		rc = -EINVAL;
> +		goto out_free;
> +	}

The message "fail to parse user buffer into number" is a bit long.
"failed to parse" is probably sufficient.

Additionally, has it been considered to assign the kstrtoul() return
value to rc instead of discarding the returned value?

Thanks,

Bart.
