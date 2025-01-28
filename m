Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8E9192B85;
	Tue, 28 Jan 2025 18:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738090483; cv=none; b=CDZGt2tP+lfySa8TukUWpqsM0KLha/74dMZej+QeT06JhnQnXRgYto12oLeVsvMT72+NLEr6SzpVNuYb6GhyByhU4Up4EyBRyFFMFgXhxHqw2wDmjIu+sF12tv71JuXSJbEA334w/luJ/XzGtTznDdumUQW/s0exUx+32b6rM+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738090483; c=relaxed/simple;
	bh=GpOnNxR6oBDCjqB1lZOjJ4CkyOwckOcE4m7r3WI3Ni8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M1CDkxl1fi/h3yU7D4Nx5L7e7UzKJs+iASNKGyxPXF20nUaHA5XfuLIkv4Dy7qZzjQ/btfYMZawW3dXTBADxxsf8EDoD8a1PuloKu7tLtevxWd5uNrtBlMyJPnYX+u/0y07FX9+5+dnNohQ/4/6GVs1bdgJgzmJIquZ/QCNzboA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jd4OUNbj; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jd4OUNbj"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YjDwx2MmczlgMVb;
	Tue, 28 Jan 2025 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738090478; x=1740682479; bh=9FGGY9lCb4Aig6L9UK4XHp2n
	PqTL7erhaYVAMcM2Jag=; b=jd4OUNbjSB0ca/Uql8Eivl+GAppZjH3pFcLO1zx5
	fcCHSRQzAGenkv3lIwAWounFRrAR56KAGtGrMOCccrPinr9V9vKsnyfbXQu2iNjJ
	tmOTztiwMZRg+oZzIlb+a8dgLt0Csh1NTES3QMQxyfDXHT1KarcrILTJjr3STkCr
	0E8zO/0MP/YmYczmlPh3w+drA9/m+1YzQM390MaMHQK0mr6B/FDdpOKu2WETj8HP
	JBwnOovJbIjVXAU+5cVwH7u5WtflmYmkLYONO7jxrCkhBREHfZy2/n7vXxVe2sdh
	uzLi8UnF9rZnJ8istaST/Cn9ouAgFsJswo0gpGmXoxGcDA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FP7ZiwE_Abdw; Tue, 28 Jan 2025 18:54:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YjDws3ZN3zlgMVQ;
	Tue, 28 Jan 2025 18:54:37 +0000 (UTC)
Message-ID: <9a41bd69-d39f-47e3-85e8-1de09b1c897d@acm.org>
Date: Tue, 28 Jan 2025 10:54:36 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] Fixes for UFS clock gating initialization
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>
References: <20250128071207.75494-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250128071207.75494-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/27/25 11:12 PM, Avri Altman wrote:
> This patch series addresses two issues related to the UFS clock gating
> mechanism. The first patch ensures that the `clk_gating.lock` is used
> only after it has been properly initialized.
> 
> The second patch fixes an issue where `clk_gating.state` is toggled even
> if clock gating is not allowed, which can lead to crashes.

For both patches:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
