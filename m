Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4781DF96C
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2024 18:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730140667; cv=none; b=nFExmBGH/Z0jcNKzUC2q6ZiMHfOZJJSfXgWhEjtVU3ZuOqqadGpgEe1sk1D5ziNutZpnqtV/K+UQaNqk7mvMdlFV7ItNenLJ+PxaSPkljhFsd3JZOdz7jwur8ttcGoaBnV61P/Lz6O6CTY1v/oOyEHMeAszoqDtQGlDFS72gDXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730140667; c=relaxed/simple;
	bh=aORIYyRmfBVr7a9BgSPvWahcZlUMylbjuehvSWtGQ8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nRWMaQEl0aR0jkAxz1CX/XYUzQm+Jbg1bZzkO6PgBCyEFJCtd4d5t6UcuJq8xfzydAM2i0Yi6LC/SW/0AdFxjEiZ9xcCuF+80V2ZQD1tZHdcMs12fk60qGTiRoMfE1CwfGQPqm8vW3Fc8v7bLVkjHjzyelr1AcORAmckx41IOR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WDuX6KWq; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WDuX6KWq"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xchvq6vxfzlgTWR;
	Mon, 28 Oct 2024 18:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730140662; x=1732732663; bh=aORIYyRmfBVr7a9BgSPvWahc
	ZlUMylbjuehvSWtGQ8o=; b=WDuX6KWqeb4Qmni61bJjGB+q7bxUeyB1dYHSsfRX
	XELXgLMqB8xWWIffy7RT4xL882mzOBimztsYAbOdlJ/3du30Un2KJLbTdd/ItJa4
	fpcwZ6D6j6spg9sUSAsWdQzSqcZf3fFuJO4MTVEjryHXInAh0/mB2FRm/tiEs2UM
	KP/KPk1SUE1z5jUyuTaHqfpqJGSghifxlnEyC+y1nQ1TRyGOif9WdXjYPAgdAzYq
	IAhV/HbxQCQT3qmc7fYWA4fRrR0yEv3XV5B7C4LoIb3zrN7KmbrLr8fBDU6a4BgA
	WKUapRZfkQypazJaxURhAt8grd65nbFA6gZUjQsCkLAT9Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 33dWaaGF90uq; Mon, 28 Oct 2024 18:37:42 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xchvp25zLzlgTWM;
	Mon, 28 Oct 2024 18:37:41 +0000 (UTC)
Message-ID: <04e443d0-2968-4d63-b05e-ddb7b2aa5680@acm.org>
Date: Mon, 28 Oct 2024 11:37:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: Add WB buffer resize support
To: Bean Huo <huobean@gmail.com>, Huan Tang <tanghuan@vivo.com>,
 linux-scsi@vger.kernel.org
Cc: opensource.kernel@vivo.com
References: <20241026004423.135-1-tanghuan@vivo.com>
 <e992d83526fe722af8cef1b9ca737c8d0646417a.camel@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e992d83526fe722af8cef1b9ca737c8d0646417a.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/24 12:40 PM, Bean Huo wrote:
> I saw that "Both UFS 4.1 and UFS 5.0 are currently in development" have
> not been officially published yet. Are you keen to incorporate features
> based on an unpublished standard?

Hi Bean,

UFS WG members approved the WB buffer resize functionality through the
JEDEC voting process about one year ago. Isn't that sufficient to
implement this functionality in the kernel? See also the JC-64.1
December 7, 2023 meeting minutes.

Thanks,

Bart.

