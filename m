Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4D7390CA3;
	Wed, 30 Sep 2026 07:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754427; cv=none; b=U2V6SzSSyBMV5Ze2EK+eFJpB8Xw8sPnvJ55kiEZuIDGvc9n/AGmhI5kV/zNQQGklc+jD+lDy7g12U2+FbrY4b8Z6qTS5w7Prs/MjZh+Z2zC+kUxIpKeMckWqwWLn/tYwQ2mY/GmENsn4pWyLgjgE5tMeI0Tq5ZMdX1EGyyh6dJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754427; c=relaxed/simple;
	bh=FLwtlMrbl4DI2pcOnvjkELq7W3bzPtiYhSTQywS4u1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dD+7fWvuJVARlxy1NhhNZRltgjlUZCFsNM77QePl28m7+aY/OR94r2ccJU1M3LVQ0Ph4bg+V1qKNYTAmfKHexrCBBQJmxE72FDxo55mHa3dbCH2DgukvWMUyL9xBghRQe+u9RF00bPjzJHW7ZSTDN3UxzKYgH5RI/isZQmyfrl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tr3kXbk4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tr3kXbk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BD61F000FF;
	Wed, 30 Sep 2026 07:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790754425;
	bh=lASCXHAeb0f1EuCQ/4i9L4svM9xUZ4kBEdC4K5oyiMM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Tr3kXbk4OC9VFcXPLKBUMnSvIZ0JA+MW9C3ok3Q2XVMJlTmhYOfo58wbVZXJI7Vmj
	 6ssIpSoiOVUnIuAiHjVm0wAeeH3lCrB99Tup++99meZ0F2yCIkzM3IE7+XWU4DZLGf
	 i6Vs7aON1W9L52y1UTrf38xyGd/lyK1xcaAFumhFP5Vvt3xvU8L25y9X7eTWWTvVZ8
	 LF83ke90baC0S86NueV9sXTrY+Oja1wkiSsZzCHU2ogQzvDcP5cRmdXPgY9BHb/i4a
	 y0+Oz42uQklGczHbX/SsrJdyWZ7waFgcQaakxGA0hg8QevbL5q5yyOwey7kGQ+Kd9j
	 lhCGinTpprqNA==
Message-ID: <526a3cd3-d4ae-4102-be41-ed2340eb4670@kernel.org>
Date: Wed, 30 Sep 2026 09:46:59 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: rpmb: Fix power-on UNIT ATTENTION retry
To: Stanley Jhu <stanleyjhu@google.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Bean Huo <beanhuo@micron.com>,
 Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260929031352.1355691-1-stanleyjhu@google.com>
 <20260929140806.2859367-1-stanleyjhu@google.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260929140806.2859367-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/29 16:08, Stanley Jhu wrote:
> A merge conflict resolution dropped SCMD_FAILURE_ASCQ_ANY from the
> retry added by commit a8a34238e5e6 ("scsi: ufs: rpmb: Retry power-on
> UNIT ATTENTION on the RPMB WLUN"), so only 29h/00h is retried, not
> the other 29h ASCQs.
> 
> Link: https://lore.kernel.org/linux-scsi/yq1jyo4onqe.fsf@mail.kernel.org/
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
