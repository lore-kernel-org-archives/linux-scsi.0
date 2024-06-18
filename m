Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740CA1C69D
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 16:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718727342; cv=none; b=A4C+nbdFioR7m7EATo8CDB/2qweupz4DDX3zH/TH+IHeyyYLxQBEcfysUbqp9O47axPD3CcFnxoqPBVexqPpHEaryoSAYo0x3A8h1Dinj5S5U2egJdL2yO2OpC5gVoKkJrrtXLTyXsteqTSDEYmEFpleYkBQE88dNv0fCoToh/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718727342; c=relaxed/simple;
	bh=gPpJymRKz1jseA7naFCeenIT7cqwVB/XdhttTgEt+wk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pQaTBLFPCa13w0A51B/P0mPnfBfowN22+4+dGLqXDrpD2LQHN3azwTCs1uhfmeY/ySlVQkL1SfORvZyinHw+XwenlAaGBX0iDqBlJXN3o8zwmYhlfQ0Z7b8onoW6g2N72xmRYJSxft0MgEns+wFEwMctNNMVrmTbbkiXTxd8F7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uyMcA59O; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uyMcA59O"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W3X0q683VzlgMVS;
	Tue, 18 Jun 2024 16:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718727337; x=1721319338; bh=RaWLHQPuCim7CtEuATNKRBeK
	fQIkcxWXfWhwU9dnFEU=; b=uyMcA59OcQ3nMZqnD1hE6LC0wp2Nq0i6PaKb7AkE
	E5XGHcZYuIhrIpTapuCI9m4v0WbvMMCp+pYylsS1n53nwtqQiefegMo7tpHE5JK2
	Fj7QTJ6E1D1jH2R/ma10fwVVb2aVT5s257l3vfuNXvaDW9xEt9hG+eQeS0fuyDN/
	mYmRXhEsEq0ldz0lvnnnOXtggKcF9U/naVJZ8O5CVjlM32KxmxzR0P+hTJU19ZLc
	+3lRJCh0AjJJDWXL1B57vAiMpAPRv4TCSIoygi02llrQHj45juehM3UxzENbkJmE
	HbllfA5lXrHX6zJSSore85kilRB7mMtdj/NA2tiezpKfHQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id m2y84J6-MtbX; Tue, 18 Jun 2024 16:15:37 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W3X0k1JlBzlgMVR;
	Tue, 18 Jun 2024 16:15:33 +0000 (UTC)
Message-ID: <f3925d6c-d1c0-4829-8c36-33dde46d3fa3@acm.org>
Date: Tue, 18 Jun 2024 09:15:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] scsi: ufs: Initialize struct uic_command once
To: daejun7.park@samsung.com, "Martin K . Petersen"
 <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@wdc.com>, Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Bean Huo <beanhuo@micron.com>, Minwoo Im <minwoo.im@samsung.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Akinobu Mita <akinobu.mita@gmail.com>
References: <20240617210844.337476-2-bvanassche@acm.org>
 <20240617210844.337476-1-bvanassche@acm.org>
 <CGME20240617210921epcas2p157b0455482794b03d35185bdbfeac6d3@epcms2p8>
 <1891546521.01718675102603.JavaMail.epsvc@epcpadp3>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1891546521.01718675102603.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/17/24 6:25 PM, Daejun Park wrote:
>> @@ -4155,7 +4154,11 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_set_attr);
>> int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0u32 *mib_val, u8 peer)
>> {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {0};
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uic_command uic_cmd =3D {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.command =3D =
peer ? UIC_CMD_DME_PEER_GET : UIC_CMD_DME_GET,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.argument1 =3D=
 attr_sel,
>> +
> Empty line.

Thanks for the feedback. I will remove this empty line before I repost th=
is patch
series.

Bart.
