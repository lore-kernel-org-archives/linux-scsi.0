Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F8C161321
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2025 18:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736966082; cv=none; b=BEouwgPe3MEMKcOwjTjZcy2t81yrW5RD7PiaWYydRq9iw95xJT1H0pZhykEtbi5y/TXtO6qF5lDpHG5YPigPxJ8In/oo6DGcwSSkaY3MKZlvFUfp5GljO26Is0UdI5KZBOJKWzg2oxXjmeSYTzXt0RRoOyymNEOh5zxGlhFtLxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736966082; c=relaxed/simple;
	bh=BTYtQmQpw9WDAnGMd8O4BWfABvLqbB26BxE+Tq0aSKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=crLGLateMzXjFmszwVBUDt/f+bH9tEY8cVrUic7hgtxPTtsVcXPp4nAA/PCEmX/EbFfOE+5+AyZqBtdfSSj0ENgaWKTaTfKKc+3LZA6Op2prozIdVMOVxcC6VxObRyvTerlDXE61fK0pOGZvFnBhJq0YL4/XxRjXHUh+lmcgHK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OzPU0i8N; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OzPU0i8N"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YYF5r3BCyz6CmM6D;
	Wed, 15 Jan 2025 18:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1736966078; x=1739558079; bh=BTYtQmQpw9WDAnGMd8O4BWfA
	BvLqbB26BxE+Tq0aSKQ=; b=OzPU0i8NGV1P7pr+ahH56InY1mzlCf1uncPR/pFd
	C1N7dOiBQV+r3Bq0svShPFUYpUmtUk4nxIx/RQl+0cazB6S1gCf487ak3pH3nddf
	l5TQbS4lFzPLOEX+mVzyDtyAl1DltXzfm/n4duIjIL1FAOGpZ7LrkxIe9aNfTQvq
	g0/+x5Z1Hm2J6d6uXxsjx4ZWBAKO6rYggIIYjvpeasJtF3knfyTDLsia/XwM1Djr
	OKzUoPF7hVWLeBWCdFB9710tZI0IpTT1Tf8yL69YNxd0P/coty8+ptULCKPhczIO
	ae4wsUwyd6Df5SQUqMrbZFYlabEGur2EpseZx0FQIAfAqg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ud8XQU1HkPAj; Wed, 15 Jan 2025 18:34:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YYF5n0tVMz6CmQvG;
	Wed, 15 Jan 2025 18:34:36 +0000 (UTC)
Message-ID: <14899530-5419-4341-9add-b7ffa6d13a45@acm.org>
Date: Wed, 15 Jan 2025 10:34:35 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: Add passthrough tests for success and no
 failure definitions
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20250113180757.16691-1-michael.christie@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250113180757.16691-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/25 10:07 AM, Mike Christie wrote:
> This patch adds scsi_check_passthrough tests for the cases where a
> command completes successfully and when the command failed but the
> caller did not pass in a list of failures.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
