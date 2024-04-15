Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C854823CE
	for <linux-scsi@vger.kernel.org>; Mon, 15 Apr 2024 17:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713201549; cv=none; b=SKcdcXRbi92fiLvMmt1i9q+TH6Ry4XsTm3RNk2j3+hGbOMcrgMxyViXGbGUUF6mEhH7wccXbYxh62+G+eIDiTeKlAkwjAehYxfeuYcocTHnSHv+C0uhZRTSDNCd8JgpJbplHEfmalNdQdREE+mswKdwPS2Exn8WsFlcFQW21G8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713201549; c=relaxed/simple;
	bh=L/Z0t4xbqo0kLZf9sQAk1aj2FGkIBdw+L/mu7g+iIv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RU4Vn98VyOmOM9Ws4dgbzJm1xPHo+PKzDxh20xxtLYw9xxCb4wMUQofModp0AMSy52OZ6Ta2t8uStdj5uG+hh4QU2T2LGjeSZTQdogAjuPeGg5c+bzMJqz4qE/Xj42+k1v6MvCNZXprnbitlEW3COzJDjIT9IR2phMFcm1lNiRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VK4vBOH/; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VK4vBOH/"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VJDRT6t32zlgTHp;
	Mon, 15 Apr 2024 17:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1713201537; x=1715793538; bh=L/Z0t4xbqo0kLZf9sQAk1aj2
	FGkIBdw+L/mu7g+iIv0=; b=VK4vBOH/2wkjYcZbbgYXmkjbeQ26ayNXepnhysVN
	VH9xoB6oSMzBGu5+KkwV61jhPqqgiicUkBx+K7/OuUTvOJTFWX2dKcPcLE4k/EIp
	1V+FeVgYxecH/WsqLF6hMoQZs4dSLXIhHb0Fl7Y6MfW0lulxhjY+3TYPTgNb9F3d
	+LU/ZmMA004ni0425M1Dcq7A4+r7v6VYx+JUWNDJQWzSXxnJNlh29K/5P8995fts
	fwkKl7MVT5VHBJZgQL+A4uW+A6MGtxxaih5bnUCkoMvB0WnrqGQ71FLSK4yBp9sn
	JgI6iRXveniKgiK3qCwyJgz/OTeUuMghUB+NulmU5kocDg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UEjTvEUw7auz; Mon, 15 Apr 2024 17:18:57 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VJDRJ215zzlgTsK;
	Mon, 15 Apr 2024 17:18:51 +0000 (UTC)
Message-ID: <5802f03f-6ea9-445f-aaf0-2b7ce7298a6e@acm.org>
Date: Mon, 15 Apr 2024 10:18:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Remove .get_hba_mac()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "zhanghui31@xiaomi.com" <zhanghui31@xiaomi.com>,
 "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
 "keosung.park@samsung.com" <keosung.park@samsung.com>,
 "konrad.dybcio@linaro.org" <konrad.dybcio@linaro.org>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "andersson@kernel.org" <andersson@kernel.org>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
 "angelogioacchino.delregno@collabora.com"
 <angelogioacchino.delregno@collabora.com>,
 "yang.lee@linux.alibaba.com" <yang.lee@linux.alibaba.com>
References: <20240412174158.3050361-1-bvanassche@acm.org>
 <f3f07f6866c7c344f6c76316116f12c45de53e13.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f3f07f6866c7c344f6c76316116f12c45de53e13.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/15/24 00:22, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Mediatek some platform read nutrs in MCQ mode is 0x1F, not 0x3F.
> Which means we still need this ops to get correct MAC.
Hi Peter,

Thanks for the feedback. I will prepare a new version of this patch
that preserves the .get_hba_mac() callback.

Thanks,

Bart.
