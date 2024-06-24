Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45F2FC08
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jun 2024 17:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719250233; cv=none; b=IgvevWZiTgfF5D3EKjBftdCl6NZ1xGYSwpluKbYXudYwZfMZXHwkkY/bSgwGv+XaeYJkMUINfYq7sHAX7M4S9I/nt5aNibjE1+e1rObREH5YqGzGFTGGiWCVynNqR4wUvSMYnLILpPjt6/ZSTrLcfajkAyTiYSjzxNydTO3bVUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719250233; c=relaxed/simple;
	bh=ZNO4WPpt28LjS6z9k0CQ9Ui94qV9hFEpSY2iJuhuEwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MFptzTkSLi7arkNop4hERui31dZFi2NNu8pEw8AH7Dxw0xg6lfZbY6RKsGIDaJc/VH888hUww02iDkYpqYjgwcHt2J7XoqvilbVC5QGoWWAFdyO2q52sEaF6vLU5N7MVYU2AveS9TT/ecYt6y6T6BMTNusspAsnTrI+3wfHZfdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gft12Ysw; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gft12Ysw"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W7FNK40c5z6Cnk8y;
	Mon, 24 Jun 2024 17:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719250221; x=1721842222; bh=ZNO4WPpt28LjS6z9k0CQ9Ui9
	4qV9hFEpSY2iJuhuEwg=; b=gft12YswqbPwNaeADYud5mP6hNhtkGUNly8Tmgvr
	bw0jA1/Qh+eNQdzPFqD4cs0ncjYhDOpOsYx7l7BATgBx6E69txG3cT5388CTzZ1O
	aBIe558U5tVvM6IWjTIUV8Y5qCfR6fjXyVYN8Q9laTixI47CyM5c9ZDWq8A2Usvx
	9oUtBhkp60/n2uI09k4ao0f5gGPHUPS+vqHcK4yq23dHnmmqxNUhop+W8DK3PY4E
	QWwhAoKrhmk5ALPa58Yf6KM0to2HlJ/uSAlvhaPPXvSf0iAYTmY6049cxdbR5V2T
	G41WITckIPJaL4oNfjFhfbb/3LLwMkiPxwlylxrnFx2nFw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id C0Ol1RXTe2NP; Mon, 24 Jun 2024 17:30:21 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W7FN83Y8Dz6Cnk8t;
	Mon, 24 Jun 2024 17:30:16 +0000 (UTC)
Message-ID: <1378b9c7-bbaf-4ee7-9c13-2ebf5d710d93@acm.org>
Date: Mon, 24 Jun 2024 10:30:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] scsi: ufs: Make .get_hba_mac() optional
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
Cc: "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
 "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
 "yang.lee@linux.alibaba.com" <yang.lee@linux.alibaba.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-5-bvanassche@acm.org> <20240619071329.GD6056@thinkpad>
 <20240619075731.GB8089@thinkpad>
 <93539579c4eb5bacc9dc9afb726294f44cec7dc9.camel@mediatek.com>
 <20240623133324.GB58184@thinkpad>
 <016a1877dcd96b5a81a52d253cc6c9132e8d113f.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <016a1877dcd96b5a81a52d253cc6c9132e8d113f.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/24/24 1:39 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Sun, 2024-06-23 at 19:03 +0530, manivannan.sadhasivam@linaro.org
>> Perhaps we should use different masks?
>=20
> Yes, it is better use different mask with different mode.
I will introduce different masks for the SDB and MCQ modes.

Thanks,

Bart.
