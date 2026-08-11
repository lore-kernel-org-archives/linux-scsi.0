Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492D53B27CF;
	Tue, 11 Aug 2026 21:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786485323; cv=none; b=gwIjFauR2pMVXPCwZX3tT2CDmP8sh5YTQP7hqPpdG3PcUKj0vGeBRVXHGwv2n5XpDsVTRfT161HZmR0ktydD7l/GvlasMnqkDnO1MeTKCRgVPtCRpfJuLXghzAeYsusWaMhmBWH/Hg+gx5Jzf9z/uCFnchxEHylxLnQK7OoBH/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786485323; c=relaxed/simple;
	bh=FlvKF0+l3LbP0gUKbOKGsDHn7KNMHgDpmUI9737erWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cudcebMe7CVIT1KsFMA+r4iKuXR+2DJ+9Grj93QkO+FOCmucdRPUB2sjVDm9aq034cgXL08m8ZOUheBhvYYkWAFE9/KFM4KRPjsHGjwZtLJCrIisOPtw3hEqbOMr7stlFOCi7f/InhKC4dG8KpDCUh8l360IwEkhrW48ieEkA0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ITXDmIkS; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ITXDmIkS"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hKQQx3F1QzlfvqM;
	Tue, 11 Aug 2026 21:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786485317; x=1789077318; bh=FlvKF0+l3LbP0gUKbOKGsDHn
	7KNMHgDpmUI9737erWs=; b=ITXDmIkSfggCG2ULczVKdx+4yZUerMfW/X9yisbz
	/8q9dYv1eHi3AqB+bx7c1kcihfMs162HO0AaelmPQOIv4CUOYJpOrG3dmJC1S4cg
	sjyzhtRBOLjQlubsQ6Zgt95g+2n2QYHlhmdmgUUtI1zCIo4VhIrEtC2QbgOD5d5F
	MQ+u3w0d8KFUBy5rK/yzGysmznujqaxni2qtT0c0bx61fZiJlY+nmyeX64pKc5N3
	Y/FgirxmJAeqj+wA9weI9g/RyQQfsbu8XDadynzhs9SXSs1+k/QBmMvfgok3uF2v
	gtxhpMEBwSvj9MuEnhkN6RcvtXIrOTv9xXcbQUCW7s0SXA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id doJIeSKQx48L; Tue, 11 Aug 2026 21:55:17 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hKQQq37LBzlfvpG;
	Tue, 11 Aug 2026 21:55:15 +0000 (UTC)
Message-ID: <db1a5cde-3803-4f7a-a1db-cbb4bc5b18e0@acm.org>
Date: Tue, 11 Aug 2026 14:55:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: qla2xxx: Fix size_t format specifier in
 qla29xx_process_rd_image()
To: Nathan Chancellor <nathan@kernel.org>, Nilesh Javali
 <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@kernel.org>,
 Manish Rangankar <mrangankar@marvell.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260811-scsi-qla2xxxx-qla_init-wformat-v1-1-50760021914f@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260811-scsi-qla2xxxx-qla_init-wformat-v1-1-50760021914f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/11/26 2:39 PM, Nathan Chancellor wrote:
> Use '%zx', the proper 'size_t' format specifier, to clear up the
> warning.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
