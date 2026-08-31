Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0974A0133;
	Mon, 31 Aug 2026 16:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194095; cv=none; b=JVHOkyUDQkgMm0PvMvJr1vrRhJO57w6hk3vD/X3OlQ2q8SXk5ggsjQq2q2/hP30HgBQHwZt2pH4lbopWL9+hnCA+24JqDkm3VPqrHuZZICXr6UONqcEA7Grue3IXDUvrkhnUZXsw1XXwSvu4OCiX/gMo29gO4hWjrOWzQO4T26M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194095; c=relaxed/simple;
	bh=lgCoZHIIMHoV0moUguW+p/nrHAa/1bjZoE2R+p37zyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M++3Z5wbTK+xnqZ2KQES3rQDRQ1PwKsdaTR6vZR2CluLETXd8XpWmJOixtu0/pbVq6zU0zGC9V9F1ieSSCrILhN35Y+g2EF4+AlOOYMS+cPXSRtVAt0kijt2NulyYWbLuBVosE2Q11GDwyLpAKJoJ5CiDzBayiyzFgUuSe/X4Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qPrrX9NC; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qPrrX9NC"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hYZMw3s3Mzlfvps;
	Mon, 31 Aug 2026 16:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788194087; x=1790786088; bh=lgCoZHIIMHoV0moUguW+p/nr
	HAa/1bjZoE2R+p37zyk=; b=qPrrX9NCFby35myPe7Cu21zwEKQ2qPnX46Ok6USx
	bHoaPc7/klv1oRXagRVzdxe+FCyynBj9VWJI6p+l//lL7JjjQPBNnTBrA4qqqGS2
	j6J2kOYPmSfa/as5AYpv6bjcdMGsvLUZV0CZdTzENrD+uYLTTFNtCktPI6hsNOpy
	a6toGqDhsneCR/8Wxv18t0chma3KNh92S0YPmmyIkFfWYNY1US0RADATrnnYEcTF
	pW7NOG3+VAeARh3KftqTN8RgPQgLayViQJOEP1u73yqWpC0G1gGar25fAnTJavZp
	czq+FP1P/AbGa0CC6gGads4xAX38Hc+JQ+toR1sE6dihmQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WkPBcNu41mxN; Mon, 31 Aug 2026 16:34:47 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:a104:ffdc:9983:687c] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hYZMm63R4zlfvpM;
	Mon, 31 Aug 2026 16:34:44 +0000 (UTC)
Message-ID: <6aefc443-b86b-491b-a9b3-363ac2c01b9f@acm.org>
Date: Mon, 31 Aug 2026 09:34:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: core: Drop Scsi_Host.default_lock
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
 Vasily Gorbik <gor@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org,
 linux-ide@vger.kernel.org, Christian Borntraeger
 <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org
References: <20260831095821.3486994-1-john.g.garry@oracle.com>
 <20260831102141.7FD301F000E9@smtp.kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260831102141.7FD301F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 3:21 AM, sashiko-bot@kernel.org wrote:
> - [High] Interrupt state corruption in `blogic_qcmd_lck` due to mismatched spinlock APIs.

Since this is a pre-existing issue it should not block adoption of this
patch. Anyway, I plan to post a patch soon that will fix this complaint.

Bart.
