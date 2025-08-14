Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932AF23ABBD
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 15:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755186550; cv=none; b=f3ALOuN17LvDj7+tDEyle5cJR+wCjhE10+4PQTiuqMKiYRMEhoJUCPw0Ols5x69It85er/RdlRuXzfB6bBeOFwgUyo/FBL+V6TbWeKeTzCYpaGDjkWQfvZvzUu7f+V8fshI6tF1lOn3+yxbo4SFg4ViByRKjHECfocP/dve7FXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755186550; c=relaxed/simple;
	bh=Pdf2/nDirS7slQhATf6Zgh0eqL9uWrpXSUP+eRBVYYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pZKseTE7UCSF21BAeLOYY2IFw7AHLzbA/3prwarNE5NBa4hv8JR+LGr7w+KNNn75fK7Y03ZpikAaJ0/7ZKMFIYtoYpV4wjVmAsuTsRNmNEuiYtLAMk29DFAeYlhEB3R4SyyDhkt8qtHmMz+D+1Yal73Rpy7YefSRiGnxSLbNDKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=E7q/R0yD; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="E7q/R0yD"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c2qRR2tj9zlvWhc;
	Thu, 14 Aug 2025 15:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755186545; x=1757778546; bh=Pdf2/nDirS7slQhATf6Zgh0e
	qL9uWrpXSUP+eRBVYYA=; b=E7q/R0yD6xTZFc/h3i4mHiZyz6WpF7WpCL7/3ioE
	G1nqI7Y+BNxoz0MtaSqNYmOzec2d4rzygFX5TV66j8Z8JFtniih2h9dBysGrKIBz
	ucWnavy0eY2Sj3P5M1MZdsKm/mp5ahB5Hnf3aX62fuT75hPZKn6X1+fqHN5VVYKN
	MfW3iMxaWmF32UtCLMJ2x9kH5DxZKXlG1QtWdGV/QPN5oUYQ6Z9fGDkkWoPsa4JO
	1/izsC3G0Nxfg6D3g9gZ6E5CK0pTDDkbuRohwaWJAwXdU7/biaRQy0ORMz/omTPy
	NCyKhjOlgumc/UFNlzxdIRW+54psQiYVVNI65wWdh6670A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id O4uLpe5BGgAn; Thu, 14 Aug 2025 15:49:05 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c2qRH1939zltH7H;
	Thu, 14 Aug 2025 15:48:58 +0000 (UTC)
Message-ID: <bf5ee29b-bd7c-4fd6-a558-eba0b9c09fa4@acm.org>
Date: Thu, 14 Aug 2025 08:48:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Improve IOPS
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
 <mani@kernel.org>, "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>
References: <20250813171049.3399387-1-bvanassche@acm.org>
 <6413b3a930b073440793f2dd1578dd2ec8bd7b18.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6413b3a930b073440793f2dd1578dd2ec8bd7b18.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/14/25 1:28 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Although this may not cause any errors, it is clearly a
> coding defect that impacts performance.
> Have you considered adding a "Fixes" and "Cc" tag to
> address this issue?

Hi Peter,

My understanding is that the "Fixes" tag is reserved for bug fixes and
also that it should not be used for performance improvements unless if
the patch fixes a performance regression. I think this patch is a
performance improvement and not a performance regression fix. Hence, the
"Fixes" tag should not be used. However, if someone wants to submit this
patch for inclusion in an Android kernel, I will be happy to support
that effort.

Bart.
