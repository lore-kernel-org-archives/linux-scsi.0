Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2551C148313;
	Thu, 16 May 2024 14:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715868211; cv=none; b=jodC8k3AbozKzoBCJX5/0svN1gA/MEI44IpkDKi0oggT4ej7uDrmmvo8hJhB3/xzv4sBnmaANEcrGI6ihLkavfTGoOjMktDQQetVeBI6K/LMbGXA2PUR7ltZgrl2BbiI8O95ykfIsic3CpigvixP8cSic6TbZKZWxOOvgJ2ByY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715868211; c=relaxed/simple;
	bh=soUCs+Ynzrht+xTT+a3fzCUc3Y0OPkm3Wqv3CuReEpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XdwtLnOWTLzvCMS08XOfQg2rvVJeEZf+OgH44dcxK1TW+fc15DkbGPaJOHm4M5iUEOuEp7MJj+RDTREzaxpawWSEsq9nP5D+hDDuXbRJSMCTTkBeBqlyg9+ScZuH50bPvdFo3NnGUDGrNAIMuHyqomF5YIALDlml5gN0OJYgyoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kiThjHP3; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kiThjHP3"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VgBdR09gQz6Cnk8t;
	Thu, 16 May 2024 14:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715868199; x=1718460200; bh=5amq6jdvuhesyzf8Nwr6Lq4U
	r87XslGywG9bcT3i8DQ=; b=kiThjHP39CcN3G8bDjY2IBd4uOmKfEXt2+aP9mOp
	elg3SiDjzQLCLwABf6vzFdtSUd72WUzfHtmCG4O5ogr+ml7p6zdwQMjJqQRx4fN2
	G8oorDuoc74C7ITuig9pv0uJiRdeW24jf2yslYxdYSCfPvvm/2KVALQunmDeV7Jm
	tM7sk7zrFain77QnzVU3Jb7jkdzaNR26w40V9Qgom6vTxIoF7pC2lRl+/hDlKDVv
	4+G9IXjTE3hgB1y6Zpj6/6wOizqeTPh+wkJbOGWnwjoUzIHZtTbtU1BDapkUoU81
	La7gUE65GHgPgMiJ35sBtQSOk6wFmntQWytCzviIaf4YQA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jaPseyPbmWHq; Thu, 16 May 2024 14:03:19 +0000 (UTC)
Received: from [172.20.0.79] (unknown [8.9.45.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VgBdL4R0yz6Cnk8s;
	Thu, 16 May 2024 14:03:18 +0000 (UTC)
Message-ID: <2450470c-b449-48a7-9fb7-aa363cbe885b@acm.org>
Date: Thu, 16 May 2024 08:03:17 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: mcq: Fix missing argument 'hba' in MCQ_OPR_OFFSET_n
To: Minwoo Im <minwoo.im@samsung.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Joel Granados <j.granados@samsung.com>, gost.dev@samsung.com,
 Asutosh Das <quic_asutoshd@quicinc.com>
References: <CGME20240516032553epcas2p3b8f34d03f32cccccc628027fbe1e8356@epcas2p3.samsung.com>
 <20240516031405.586706-1-minwoo.im@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240516031405.586706-1-minwoo.im@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/24 21:14, Minwoo Im wrote:
>   /* Operation and runtime registers configuration */
>   #define MCQ_CFG_n(r, i)	((r) + MCQ_QCFG_SIZE * (i))
> -#define MCQ_OPR_OFFSET_n(p, i) \
> +#define MCQ_OPR_OFFSET_n(hba, p, i) \
>   	(hba->mcq_opr[(p)].offset + hba->mcq_opr[(p)].stride * (i))
Since inline functions are preferred over macros, please convert the
MCQ_OPR_OFFSET_n() macro into an inline function.

Thanks,

Bart.
