Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004292877FA
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 17:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763055985; cv=none; b=iQP1m6mIuMWKJ2BbirUYR2M2zSCAQZXxmrI1U1LUOFFNTeHb3l35FlDEyremg2JCkcPiry2589xU3sloi2K7t2iiFE7a4pthxRcq+ytPJnTUBZh8p/ckeD+0rWYDfNe9w3fEVYs6nTJdfifTBa6w71G2jNLF1xOI0uMEC2jm/lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763055985; c=relaxed/simple;
	bh=lj6+ZjQ2kHe4i8cwdb/5vzD3ED1uV1+2p+tahelFKyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EMOyoi1fc3nZjIg3NEsBX4AJzwLEtzaEKcTATQ9iq2uxmW2oEfbcGz5yG/qnZDceLXRYm7IPKXdTtdKN0cVvKx+f5hKvmtCNPZfgkzepiY7BbJGdpnDgmXxeSAvV5zOSpIFpkegB3c+j1cj6KZOb1Srk4Ex9qopJJB9K30T0MRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rEwRej0r; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rEwRej0r"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d6nkk73NMzlv5js;
	Thu, 13 Nov 2025 17:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763055981; x=1765647982; bh=vB1eQIA0oYdKjiAn9jOdU1xp
	oAsYrZymSd1a3rWa28w=; b=rEwRej0rtA67g8EuE8HPcJmbKBV5DxuZzTUReMSG
	/qOIrEEAqe51pO1rHpQRN4/dPQ/OFjCfRJDgWbd8TJEZDMOrEkzTVjjN6YyquKg7
	D4XC4dtNnLQaynS3GlFqNroK9CzDltIz/Xoskx8Rf+XdYQEO7Fd9KAHpQVjdDD/5
	GEfpyQC8g+qZ/5Dc44b4/FwZFDzT2SlEtMzSSx7VWSbV3wpSmGfKSOlwg8cNx6/b
	Mh8fIzfhkFM4aEnimzW4dEdIltI8RqXSNbyFR+EpPbcNomL/XZxO9wpzYD64DEvI
	ICc06YH/t77xCXpnqMfpS71hXL3N64uw3fGbihmgvns/BQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MFiVSG2k-3iH; Thu, 13 Nov 2025 17:46:21 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d6nkf5YXXzltwNJ;
	Thu, 13 Nov 2025 17:46:17 +0000 (UTC)
Message-ID: <9e3540ab-3f80-44a4-8d84-b8ec0598e681@acm.org>
Date: Thu, 13 Nov 2025 09:46:16 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] scsi: scsi_debug: Drop NULL scsi_cmnd check in
 sdebug_q_cmd_complete()
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, jiangjianjun3@huawei.com
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
 <20251113133645.2898748-4-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251113133645.2898748-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/25 5:36 AM, John Garry wrote:
> The scp pointer cannot be NULL, as it is evaludated from container_of()
                                            ^^^^^^^^^^
                                            evaluated

Otherwise this patch looks good to me.

Thanks,

Bart.
