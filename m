Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0660A2EA75A;
	Wed, 18 Jun 2025 15:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750260391; cv=none; b=rqy3iD6M2H+BrQRxqTrp3DaL8itvc25Zmm3N+mRT8LFQn8OhadgLPhkMF/CJ135OQtQZrWQpYVysrAK70Vr2W3xgqpGgyfR3RumA1ZD+oogu2DdiT01Z+oW9B6Xq8GF/IgOL7UsJDzfi1sye5T0rpg00gVtYyrSpLocCkSOATKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750260391; c=relaxed/simple;
	bh=gXBtCZJn+/0MDXSt3IL6zfF19ZAzvlVfoaqXyMbqu68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZYBZaEGJLFOtXGzgJ79OyOsKNVBe8nCORDywi5FJk37Db0uzPIH/Z1SJa36cGMppwstwsOun2IIVt1/CZrqBEC8bYeBn00yPE6ECl8Al9i1bVlJkmA8vxZsVrk0PA7yJsBp/aZhOkuXtkWBypwLGeX+1v9wkIbvImrEa68vVvLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vK10M2Cw; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vK10M2Cw"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bMndW4RVVzlgqy3;
	Wed, 18 Jun 2025 15:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750260382; x=1752852383; bh=WCxYkDwQ1Z+2e4N8cfHv6foo
	BWEtwioWQeVmv2+6sWE=; b=vK10M2CwI6EJlu8wqqL6jPa64dfK9a0egT3xLcpX
	62qA+BxZLn36QFBCFIK5C2RPgn8TjiniJ6kshzItX/TOJqAFjRVEqHMOy/5bqmal
	fLDfI6xLehrcMPqwchthxT+2GIntKgCAIZ68BWL0dp5n5JmWEJQgDGO3hFpcgoUC
	dyV3NE1oKgARbmRZfy0GSk2Dvrzj0S3ruNU2rD7CvHWW7jwNT1VcBQh1iGKIbwkT
	qbBuiW+An63Vz7xBhBhjxxCKfOYxp0Qhw1jZTcgvx6yHKkvrZxknmrudJxLp8SpP
	5e7LGUdFWwLe2J0M/4TZZ8duuuVHq8+Kqj68ftvnbehvFQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id m5_91iT8yPGn; Wed, 18 Jun 2025 15:26:22 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bMndP5zqdzlgqVk;
	Wed, 18 Jun 2025 15:26:16 +0000 (UTC)
Message-ID: <dc972e6f-b846-4445-a347-c6fbf72ba429@acm.org>
Date: Wed, 18 Jun 2025 08:26:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fix out of bounds error in /drivers/scsi
To: jackysliu <1972843537@qq.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <07c4c84d-0c52-4843-b32d-6806e58892fe@acm.org>
 <tencent_D9A0F9052526AD09F7FF76DD5F2529FDDD05@qq.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <tencent_D9A0F9052526AD09F7FF76DD5F2529FDDD05@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/25 11:31 PM, jackysliu wrote:
> Can I know what kind of impact this vulnerability will have?

The worst possible impact I see is that the Linux kernel would decide 
that RSCS is supported although the device doesn't support it. This
could cause sd_read_io_hints() to print incorrect information. The
following message could be printed when it should not be printed:
"Unexpected: RSCS has been set and the permanent stream count is %u\n"

> And is it possible to get a cve number?

You are asking the wrong person. I don't know how to get a CVE number.

Bart.
