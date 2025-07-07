Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2522135CE
	for <linux-scsi@vger.kernel.org>; Mon,  7 Jul 2025 19:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751917242; cv=none; b=cPwjlfdKmy3RX9kGVORAi3WSM2zRloEfZ/KhFFWXM4T53yI+0tXuVKSeDA8GXwZtVbNNtNTV+ez2pgVSuKVKKhx6R5Ki+VN57ChE/qCFqmgIc7Sxq2vZGEiNtyyRFRv5OOpKu7R0nAP7AF14G2NehrI6mCrez9oM6X4+hx5Jzwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751917242; c=relaxed/simple;
	bh=uaTTM1GwBgo27xvcXAh4ccs3BIjtJh+os/umd6QUhvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ll7WI5cFo1fqcWqadW2UcgvaftJjOLsBeL882LxoMG2Risj/e+TFd3zfQEjvVZBg84Xtb42b9n7cVB3Rg1tOiWAzQBLMMxDEJN7HnYOFxxwJvtQz07No6bsmqJwJPdsrkNAbD32FBSJNUM7N3jdNnZxvXLTMwZv30DaNph2WoeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NQTFNfHw; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NQTFNfHw"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bbZN33X9NzlgqVj;
	Mon,  7 Jul 2025 19:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751917232; x=1754509233; bh=74sB6Ky3Pic6Kj1Zg2sxR0+C
	9mOjuevdzGnFfM6wWZg=; b=NQTFNfHwJBvaNfBLIAJcpHm9HH+Bdd0FdE146nu4
	N8657c1UhCGOoJAzdC39K6qcdfkz4EPZCUpZfMSp8BiVSmwPUCY4UrhjPHczWa7L
	eBtGfMlpdaBXMvWTm83lOqKKGR0c/FGzFxzPdqF5Brhnbtdxrq2eFIpGuWBkDQzF
	RMAD+JenBIqTQK5HdJcpZutw6Aw1uCr+VILgeP97n0gT11x/4shjhE6UQ6YJ5KKA
	ndcf0MbQF8g2rFqajz7YmKKby9Pr9rzXRhkLLaBqT2g3Ch2yqjux+H8ugiWWxsSS
	7N9y2Y2MEa8A2MTfwSrAr5yaUxpPv8kUyCHzdqrgfHIRXw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kZmSS1NjlpL3; Mon,  7 Jul 2025 19:40:32 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bbZMs0zw9zlgqVf;
	Mon,  7 Jul 2025 19:40:23 +0000 (UTC)
Message-ID: <7dc658a7-5951-48ea-bf3f-9264f0383f19@acm.org>
Date: Mon, 7 Jul 2025 12:40:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Make ufshcd_clock_scaling_prepare() compatible
 with MCQ
To: Ziqi Chen <quic_ziqichen@quicinc.com>
Cc: linux-scsi@vger.kernel.org, Can Guo <quic_cang@quicinc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 Manivannan Sadhasivam <mani@kernel.org>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Stanley Jhu <chu.stanley@gmail.com>, Asutosh Das
 <quic_asutoshd@quicinc.com>, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20250624201252.396941-1-bvanassche@acm.org>
 <f8c6ea60-7e39-483e-b850-e658eb8fb13c@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f8c6ea60-7e39-483e-b850-e658eb8fb13c@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 7/3/25 1:29 AM, Ziqi Chen wrote:
> Although patch functional is OK, but I found this patch will increase
> the latency of ufshcd_clock_scaling_prepare():
>=20
> MTP 8550 (upstream kernel):
> Original:
>  =C2=A0spent: 226302 ns, avg: 2135214 ns, count: 200, total:427042923 n=
s
> with patch:
>  =C2=A0spent: 1213333 ns, avg: 4583551 ns, count: 200, total:916710316 =
ns
>=20
> MTP 8650 (upstream kernel):
> Original:
>  =C2=A0spent: 2013386 ns, avg: 1464596 ns, count: 150, total:219689530 =
ns
> with patch:
>  =C2=A0spent: 2718802 ns, avg: 4329696 ns, count: 150, total:649454539 =
ns
>=20
> MTP8850 (downstream kernel)
> Original:
>  =C2=A0spent: 144323 ns, avg: 1080332 ns, count: 2005, total:2166066242=
 ns
> with patch:
>  =C2=A0spent: 2530208 ns, avg: 1307159 ns, count: 2005, total:262085503=
3 ns

That's unfortunate ...

> I think this increament is come from you replaced blk_mq_quiesce_queue(=
)
> with blk_freeze_queue(), as my understading , the blk_mq_quiesce_queue(=
)
> just only block new IO be dispatched to hardware queue but the
> blk_freeze_queue() will freeze whole queue and wait all IOs get
> complete.

Hmm ... both blk_freeze_queue() and the loop that calls
ufshcd_pending_cmds() should wait for all pending commands to finish. So
the latency increase probably comes from the synchronize_rcu_expedited()
call.

> I am not understand you said "ufshcd_wait_for_doorbell_clr() supports
> the legacy doorbell mode but not MCQ". In ufshcd_wait_for_doorbell_clr(=
)
> , tr_pending =3D ufshcd_pending_cmds(hba) is counted from budget_map, n=
ot
> read from legacy doorbell, it is used to get inflight cmds for MCQ mode=
.

That was a misunderstanding from my side. Since the current code already
supports MCQ and my patch doesn't improve the clock scaling latency,
let's drop this patch.

Thanks,

Bart.

