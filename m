Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D66F17ADF8;
	Fri, 28 Mar 2025 14:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743170578; cv=none; b=CEz4xeWqnwvmwkZELpXVyOmiR7S8zFIIeuVp0gTJOWCb7Q1iJOsCQUKBo+MsPL/zHDYIICPvH2CFGclxFlBcSYC5lk3N4n/KLbZnlvJVfReAIHugzzRTikJv9SimxMwiTokX8iMu03kQBVVPIXeGkN4ujen/rPjiQE7/VTCck/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743170578; c=relaxed/simple;
	bh=tgkhCEu66EM4U20BZKjbGKWUYJC5YhAx4A0W/FToCX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OPmLZUr3LcTcRn3Ei8eCiHeLJDR0te8uYsl8I7OE8Yj4Y7KTY14KHdQgHtaCUVzAZUml0rXpbmqEs1VvpU13bJGXwe3mpO4J42Qir0pndnv2aA1NuvXrZ6pPqvqwtluLbGBRdJeenXg2YRl/zGz54NXFwPqnIOGhm4SZO/aOCzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UPm1J3mp; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UPm1J3mp"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZPMfw4yNVznsPmg;
	Fri, 28 Mar 2025 14:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1743170565; x=1745762566; bh=4ZE+cd4BF6DxUBAmY/OkkgML
	45nE3/ZZOvYLMZAwwYc=; b=UPm1J3mpblKfQc0YCZUMmcge9Fp2Hef+73/B73p/
	+KPKKDSby43MhHWq8epDKk3NYStHZ1OtKRT2+Uy2GUKG3KmayPt0HQ2zTr3YoX9X
	Mhmuyla+B676KGjl9r1BkBgGM1KIxXrtFqC66hhgh41Mu9FEZ2Oj7SzQSaSqTliY
	VWaUxxFFSTaNVCpLA9arQbDnjYmHQ9ymBJ1/gxoczCX+jDZt3741OPKPpJzxWz2g
	tWMT4et2zzF+4M/b9fZhBrMTpFdN8yW9GhqN/ZAHfhUvAWJNJp6pnT0TZ3rwIHQa
	TskXsuvMcSpf0/Z3Jk7cN/6vV/e0n57/z9uq3n59JLigWg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QSa-olsH7qKs; Fri, 28 Mar 2025 14:02:45 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZPMfR3GjYzm0ytY;
	Fri, 28 Mar 2025 14:02:21 +0000 (UTC)
Message-ID: <989e695e-e6a4-4427-9041-e39ecf5b5674@acm.org>
Date: Fri, 28 Mar 2025 07:02:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: add device level exception
 support
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Arthur Simchaev <Arthur.Simchaev@sandisk.com>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
 "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Bean Huo <beanhuo@micron.com>, Keoseong Park <keosung.park@samsung.com>,
 Ziqi Chen <quic_ziqichen@quicinc.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Gwendal Grignou <gwendal@chromium.org>, Eric Biggers <ebiggers@google.com>,
 open list <linux-kernel@vger.kernel.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-arm-kernel@lists.infradead.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
References: <4370b3a3b5a5675bb3e75aaa48a273674c159339.1742526978.git.quic_nguyenb@quicinc.com>
 <SA2PR16MB4251229744D717821D3D8353F4A72@SA2PR16MB4251.namprd16.prod.outlook.com>
 <c5ab13ec-f650-ea10-5cb8-d6a2ddf1e825@quicinc.com>
 <0a68d437-5d6a-42aa-ae4e-6f5d89cfcaf3@acm.org>
 <ad246ef4-7429-63bb-0279-90738736f6e3@quicinc.com>
 <3d7b543c-1165-42e0-8471-25b04c7572ac@acm.org>
 <4cb20c80-9bb0-e147-e3c0-467f4c8828ba@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4cb20c80-9bb0-e147-e3c0-467f4c8828ba@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/27/25 5:45 PM, Bao D. Nguyen wrote:
> Thanks Bart. How about we change the current utp_upiu_query_v4_0 to
>=20
> struct utp_upiu_query_v4_0 {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u8 opcode;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u8 idn;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u8 index;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u8 selector;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u8 cmd_specifics[8];
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* private: */
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __be32 reserved;
> };
>=20
> Depending on the opcode/transaction, the cmd_specifics[] can be type=20
> casted to access the LENGTH, FLAG_VALUE, VALUE[0:63] fields of the QUER=
Y=20
> UPIU. The __u8 array[8] would also prevent the compiler padding to the=20
> data.

Are there any user space applications that use the osf3/4/5/6/7 member
names? Has it been considered to preserve these by introducing a union?

Thanks,

Bart.
