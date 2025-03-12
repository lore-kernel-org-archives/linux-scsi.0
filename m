Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E3E2505B7
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2025 14:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741789538; cv=none; b=nNJky382wBPDeFQnIV0XKqID/IuS86630lUU93VX6+Bv71orjjw3KqAJfYZPcGw2JOGjkvaeQgUnLXjjpkG9LXr8VOA+hlbnIuRxWyTvxexMZGKmjhCcHYtxDMBYae0Yhwd9/fs4JKvWNzRDnDnDXDkJ9/g9knN1NFkAIJl7Zlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741789538; c=relaxed/simple;
	bh=1tnbl36FJCs/+m9FFiIXPYYFQ46LTlCx/Vfm3KqcNtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mkGcgVMFWHSLt/mt7XjxMH7qVx5Hm+WMwka31F97ZD7SMt3/Sf7Hoim+WLX47IJAaMTBYnBDlr1Muchs6DHKQtuwpHSqYrPfB5sGs++hGO7vrkqqnlnEEfYZg6QdsYLvyes/o7ehEhk93FreJRmNggoZCmjxB2grUg9EKD9QG6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ertHF2tp; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ertHF2tp"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZCXwb5GRDzm1Hby;
	Wed, 12 Mar 2025 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741789533; x=1744381534; bh=psmoSKfJPmv0g4N1uFxC3F61
	+pEbIvVTuRlKWU/MYfo=; b=ertHF2tp3jKTD1fXOYKGlttxPox5VKEZl2gJa7g+
	s+Eed3WH0Pnc8DJ1CADFlR04McbZ6ZunBda1901om70E+Kwn/v99yOoDGgTWV5So
	y6MEXbrBZwxrXECRek75LCIvslhJpG9GgrlRgNfwSZOiMXTXx/Iu/ni4cybrfdXB
	zj8/lzRxZQ7BG9Vpt9l+no+5J6kzgAaH6InFOgkROnQrceAFWTG3tf364X1F6Ufb
	II2VqKC1Q0tNPceoOtsc7JEoCLURWz40JKX/sc3CB1e0hEGATdE216EKJOn4j/ki
	SX0vUpVDpj/B9LFvc7xNQLNb8pG9vqzK0NtvLZjgTUoSQQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id P068QyDKvJgz; Wed, 12 Mar 2025 14:25:33 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZCXwL3LWSzm0XBZ;
	Wed, 12 Mar 2025 14:25:21 +0000 (UTC)
Message-ID: <d0d80bb3-5421-4d97-aa5d-0ed006e80c64@acm.org>
Date: Wed, 12 Mar 2025 07:25:19 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Fix a race condition related to device
 commands
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "ebiggers@google.com" <ebiggers@google.com>,
 "santoshsy@gmail.com" <santoshsy@gmail.com>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20250311195340.2358368-1-bvanassche@acm.org>
 <4a09a365e5724c3262b5622b679449a0d18f22c0.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4a09a365e5724c3262b5622b679449a0d18f22c0.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/12/25 12:40 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Tue, 2025-03-11 at 12:53 -0700, Bart Van Assche wrote:
>>
>> @@ -3272,13 +3261,10 @@ static void ufshcd_dev_man_unlock(struct
>> ufs_hba *hba)
>>  =C2=A0static int ufshcd_issue_dev_cmd(struct ufs_hba *hba, struct
>> ufshcd_lrb *lrbp,
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 const u32 tag, int timeout)
>>  =C2=A0{
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DECLARE_COMPLETION_ONSTACK(wait)=
;
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int err;
>>
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hba->dev_cmd.complete =3D &wait;
>> -
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_add_query_upiu_trac=
e(hba, UFS_QUERY_SEND, lrbp-
>>> ucd_req_ptr);
>> -
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 init_completion(&hba->dev_cmd.co=
mplete);
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_send_command(hba, t=
ag, hba->dev_cmd_queue);
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D ufshcd_wait_for_de=
v_cmd(hba, lrbp, timeout);
>>
>=20
> Hi Bart,
>=20
> This could calling init_completion on the same completion twice?

Hi Peter,

My patch will cause init_completion() to be called as many times as
device management commands are submitted. As far as I know the following
sequence is allowed and does not trigger any race conditions:

Thread 1                                  Thread 2
--------                                  --------
init_completion()
wait_for_completion_timeout() is called
                                           complete()
wait_for_completion_timeout() returns

init_completion()
wait_for_completion_timeout() is called
                                           complete()
wait_for_completion_timeout() returns

[ ... ]

Thanks,

Bart.
