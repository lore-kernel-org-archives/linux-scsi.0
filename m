Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48B91DB34C;
	Mon, 16 Mar 2026 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773680127; cv=none; b=kTnJBHH1Ry4bpwEdbctnINzKMkBSv4/Ie5WlWWjknPA0bnraV9P2k8UMgwZQmaaX8OMp0j1p7NmCiTmxCc9xz3BR0pS81Sgo26u6rN32cCGogI4WiI9uG6+h4ThcpyIocBPwOX7it5JlFlr6XTMqVzOIZ4lfe/SNfWQSUqrj9+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773680127; c=relaxed/simple;
	bh=86/oiW96a2oRxea6IqDn4waOy3HNSwpXJd9luCb/3BU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CCX7Q/QKM86q6TZLtw2o6RvY6XdEpqy4LzaF95rwEXgWOiLD5IwmW1ZmhxN9ghZRYa7Fu7Flc6mZPUoNT7KkKx95NlB0OpBnzPB667WZcW3nqpX4OG45uS68Z4GyjwR2EXn05+nvKSVBZEwGpJyh3tzTBxNlII4uV38+MF7Jkh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IhwZ6kYP; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IhwZ6kYP"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fZLn93225z1XM6Jf;
	Mon, 16 Mar 2026 16:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773680119; x=1776272120; bh=N5xJV1auUKLqK1aiwXrFseGv
	yE58Sv385xx9JF9x9SU=; b=IhwZ6kYPF6oPkrJ8S02lZgUfT/ym2FDiCh4chKvn
	57lyWzw7q0LtbTz11RmtM3t8lj7TzCbbuj0UgAWGQpeWybcf+gJe7N9h7cu6LJ1f
	ovhU0vxJnr31XCybvxmqitWTZx5wNiBAISDNQ81C3zgj1HiVdoTBHCzabZplcOJE
	K3AnOgcJnVLd255p7M2YRY5Wfdn+yhDjTLq2//K8Db2wqJl5UDNu0fEWS3DYJdgg
	iym9MJf6TuZErjdV42qMHqMWTSOf/jKG5xWOXEJVHmyN7m5Gnu78VAZYp4q1ICWN
	xZIqXswB2Kw5RBJl6z90vQ99yMCteQXQnV9iXCIBrk9l5A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GlluTZhepq_e; Mon, 16 Mar 2026 16:55:19 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fZLn009Jjz1XM6Hv;
	Mon, 16 Mar 2026 16:55:15 +0000 (UTC)
Message-ID: <16e4ee41-c156-4f09-80cb-e0e7918c87bf@acm.org>
Date: Mon, 16 Mar 2026 09:55:15 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/12] scsi: ufs: core: Add support for TX Equalization
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-5-can.guo@oss.qualcomm.com>
 <c44cc56f-513e-457b-96de-203d4b534496@acm.org>
 <f88d9fc6-4227-4cd3-a124-0e93122e1d85@oss.qualcomm.com>
 <6e07208c-a94b-44dc-8f7e-ccbb0ff8840e@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6e07208c-a94b-44dc-8f7e-ccbb0ff8840e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/14/26 2:33 AM, Can Guo wrote:
>=20
>=20
> On 3/14/2026 4:19 PM, Can Guo wrote:
>>
>>
>> On 3/14/2026 6:19 AM, Bart Van Assche wrote:
>>> On 3/8/26 8:14 AM, Can Guo wrote:
>>>> +static int txeq_gear_set(const char *val, const struct kernel_param=
=20
>>>> *kp)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0 return param_set_uint_minmax(val, kp, UFS_HS_G1,=
 UFS_HS_G6);
>>>> +}
>>>
>>> Why UFS_HS_G6 instead of UFS_HS_GEAR_MAX?
>> I will use 'UFS_HS_GEAR_MAX - 1' in next version.
> On second thought, to make the code more readable and scalable, I will=20
> use UFS_HS_GEAR_MAX
> here. To achieve so, I am going to tweak the code like below:
>=20
> enum ufs_hs_gear_tag {
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 UFS_HS_DONT_CHANGE,=C2=A0 =C2=A0 =C2=A0/* =
Don't change Gear */
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 UFS_HS_G1,=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 /* HS Gear 1 (default for reset) */
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 UFS_HS_G2,=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 /* HS Gear 2 */
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 UFS_HS_G3,=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 /* HS Gear 3 */
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 UFS_HS_G4,=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 /* HS Gear 4 */
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 UFS_HS_G5,=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 /* HS Gear 5 */
> +=C2=A0 =C2=A0 =C2=A0 UFS_HS_G6,=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 /* HS Gear 6 */
> +=C2=A0 =C2=A0 =C2=A0 UFS_HS_GEAR_MAX_INVALID,
> };
> +
> + #define UFS_HS_GEAR_MAX=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UFS_HS_GEAR_=
MAX_INVALID - 1
Will UFS_HS_GEAR_MAX_INVALID be used anywhere? If not, please leave it
out and add the following past UFS_HS_G6 instead of just
"UFS_HS_GEAR_MAX":

	UFS_HS_GEAR_MAX =3D UFS_HS_G6,

Thanks,

Bart.
