Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE594170A3D
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 23:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729553137; cv=none; b=WhTGPoZTNas1/gv6naJDwRI8hXjTAcvvELmda8G7WkKoQuockEHOaGA5A2HPgRJB5Fld9GMG2UhAuwwqt0DndZjJjrmRZ9Z73X3ofgDYxSY3/NYKAkGzyvVm/N5j6el/pkJaghiZ1z8c/BMvxOmMlw2BEH4QywTTcy6hm6/Ad18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729553137; c=relaxed/simple;
	bh=nn1HVOGR7RQfC3YqrEVw5Y7hDgWBSIFa/UH4AdtfWLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NXgLKujsttyKN3/fPTlZ8ALi583fLX0SRmfJayBgtF+SW48CS9fZ/hbBC8Xc+AlTCwWZK8Ehpu+mJPk0vgpclxInLRoGrDJfQQoah4kMtsleEpI7Ik3KwFjadjLLrpSv3AXlx/m6ye2w6LMPppaoUJZXJqQzFJaKYFgRHH+4ZTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=GC8lkVQU; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="GC8lkVQU"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XXWdC3D9tzlgMVX;
	Mon, 21 Oct 2024 23:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729553134; x=1732145135; bh=nn1HVOGR7RQfC3YqrEVw5Y7h
	DgWBSIFa/UH4AdtfWLU=; b=GC8lkVQUvlSPYAbccJPI0NW4E23X7uax+4lUJxfm
	qGxv9hUIK+ZxFoNUp24XmXHVW2H/0grw08FkSP0OBd5ALNQARrznt4N8AbfCL2Tg
	+xrenElJ/bahLVaIepxpdqlAu6ng6oLPIrNvRkRhjBi3n/mnqoBhY7UqrDCOzGM8
	BrO9RACVvCqn6nqplAjprCkU6S5SYScm1n2X+IdcoW9GBrq9ZCGESBEKip02RTu9
	wrx/7dK4y2qtTytqCvz+EtkBIZqvabYzCNNzsd/uxeSF7Na7tVZNFgvBahHTi0N+
	J3wLdFpx7oG97A201KvzYq0o1z1KJ3NuOsfHCWhquO/isg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id K6SqCmCrJjj8; Mon, 21 Oct 2024 23:25:34 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XXWd92BT8zlgMVW;
	Mon, 21 Oct 2024 23:25:32 +0000 (UTC)
Message-ID: <4693839e-b6cb-4926-81b4-2c40c1283f99@acm.org>
Date: Mon, 21 Oct 2024 16:25:31 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] scsi: ufs: core: Fix ufshcd_exception_event_handler()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "Avri.Altman@wdc.com" <Avri.Altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-5-bvanassche@acm.org>
 <DM6PR04MB6575DD9E354A70A9EA97E439FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
 <608f86d5-0f27-4c88-a2b2-6504348f2f18@acm.org>
 <DM6PR04MB6575010F498BC3F480EA198AFC402@DM6PR04MB6575.namprd04.prod.outlook.com>
 <793f958f-353e-453a-b2eb-288853a38dc2@acm.org>
 <efedf22012876b4a30f4cf71cf053d5e4bad9982.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <efedf22012876b4a30f4cf71cf053d5e4bad9982.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/21/24 1:59 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> This patch looks good to me as well.

Does this count as a Reviewed-by?

Thanks,

Bart.

