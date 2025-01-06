Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2A71B4F17;
	Mon,  6 Jan 2025 18:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736187500; cv=none; b=j2sojYELCvv2REp36Xjjvv2FVRvvByW+drelQg8GjHY8+SjrYCpAPMGTl/KzxPcCrD8lWemdA7jWbCQ4s5sjNBZdjrf3bvgFJ5n6MUm5iQn5be6KOlowXA8EEtJD1vCYpZAIVCPtNn5Q6vQyh7Ke73yF0wEOLEX8HgRG0ePlT2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736187500; c=relaxed/simple;
	bh=OV03JzjA3Cc8V7ESCHvo9OEdamwOpvso7AtXD/HmKDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ayy3hSe+IeoIihjfPIpCy70bDDWR3XIKiPParCd9eVYFeOC0npuUh0vK9U53/awSjaWKQQIteNy1UIXg+rVgBkR6gfRalUNSTTx2ViL3ZHYzkxilb2qbMJBi6G29ipItbDN3AEVPjjEseBWLrDLUo2Nhn+zDYqUw50j+c5Wc3dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qBFPmZF+; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qBFPmZF+"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YRj8v09Mtz6ClbFS;
	Mon,  6 Jan 2025 18:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1736187484; x=1738779485; bh=I1qPDMIZVQgpfskE0eX3E2M+
	WPI73kJD6boY7a9WVFI=; b=qBFPmZF+q0W+rOUrbGUCzGXhoklOuCYPozFUOkw0
	5bMRIAONU3iVLoCs98U0+VQ0GDsFVVyhVVIm6liTn4m1/foCoNks1LIli3vAP1Oz
	XVTBm9fVgSPM09MUfrnYh7uxMBB2NDv1h6GB78lOb5et8yb3F/J1SuOheuIsUhWe
	PJffkGzRRJ9Iu6JN3M0rqFg11/zBL5T88JQwCNOy3FrjYO9WhNaw5d3obBwfYenD
	R4UX+h8D+SvrK28iBIT3PmfnocZemxFG5QWQBtnIUMseyzAovapLfqqsA7YEinZt
	YB20d9Txzz2xidomWgCFcbt7CNkWdX2aZjhXL1HUfWO2QQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id q5H2BvI4cy1E; Mon,  6 Jan 2025 18:18:04 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YRj8p0Y7bz6CmLxT;
	Mon,  6 Jan 2025 18:18:01 +0000 (UTC)
Message-ID: <174ece00-e296-4840-a13e-083de0d89dc4@acm.org>
Date: Mon, 6 Jan 2025 10:17:59 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] Revert "scsi: ufs: core: Probe for EXT_IID support"
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Can Guo <quic_cang@quicinc.com>, Asutosh Das <quic_asutoshd@quicinc.com>
References: <20250103080204.63951-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250103080204.63951-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/3/25 12:02 AM, Avri Altman wrote:
> This reverts commit 6e1d850acff9477ae4c18a73c19ef52841ac2010.
> 
> Although added a while ago, to date no one make use of ext_iid,
> specifically incorporates it in the upiu header.  Therefore, remove it
> as it is currently unused and not serving any purpose.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
