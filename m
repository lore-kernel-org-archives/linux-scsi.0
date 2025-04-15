Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1066C253935
	for <linux-scsi@vger.kernel.org>; Tue, 15 Apr 2025 20:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744747825; cv=none; b=GcRc7H8krQjJAaf0imvUoEPX2vv3J247y4ajTIh/hfnx9DXeImEn5+7B0blHVr+URBjI+sattXX1WTmRaYj5hP8WvVO0Mh2y1Di6DF36JwQnDvthzHq9UwEy/RBH4twzUg7u2PZcO2T/SzHiLJpz5z/sJde+qlqa/Z0m0Kee6DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744747825; c=relaxed/simple;
	bh=oGCMT0kqUKQJofuc9A6mgcTpya2lWuYD6gpLHNvIf/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c0ZcgPYZ8J3Y7GAwM7mv43LYDepjfTUGDaTaBmkhyKV3xAXXKEGlMEQBdyVNqc+p0Q1fUWPL7xMIXHU/FQteyZDqb4I3j/y3GSJO4tdMRaAJdRb0YnEdBQSXkeA579+IOl0bdaikAldv/hcof/u0sBVJhk7vrc2GVrJEJ9Hl6dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sLI8y4O2; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sLI8y4O2"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZcZyj5f7vzlvm7k;
	Tue, 15 Apr 2025 20:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744747820; x=1747339821; bh=oGCMT0kqUKQJofuc9A6mgcTp
	ya2lWuYD6gpLHNvIf/o=; b=sLI8y4O2rBVCYnc2+oADNK40mh6uoadoG8z1/eam
	8t3V0n5k/Z3MlG7MTQ2TAsnq3Jxx0YejhJnp4/n1qHhOoOnjBQGc6po/4wl+k36r
	2UtEgwcC3b/iHgIO0N3uc6VWP0U2PGUzyGB/f1dZGI9znhyhXhDZ8wMbpYe+sr+2
	BeK8y3BBxL1lMdxPlnzI0/iHUuD2GjMTVpeF7SFledVC2aaTz3UfzlyUFOA1+5dy
	N424X8FAk9opY/QoK0bX1t3jhP/mID4k+kmvVRfcSdK/TtQUWB2CfAqX0tIi7XW+
	lf+rCcT1x9g9lz+tpb8Ct8JB4EbutzLNkJonV7RZyJJ73g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id w3q9WyJ90Kaj; Tue, 15 Apr 2025 20:10:20 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZcZyb6qqWzlvfn8;
	Tue, 15 Apr 2025 20:10:14 +0000 (UTC)
Message-ID: <7081331c-82e8-4026-bda8-be6bb7ccba57@acm.org>
Date: Tue, 15 Apr 2025 13:10:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/24] scsi: ufs: core: Change the monitor function
 argument types
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-12-bvanassche@acm.org>
 <41a87716bb67cc0360108ea86fd380f0bde01273.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <41a87716bb67cc0360108ea86fd380f0bde01273.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/15/25 12:37 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Thu, 2025-04-03 at 14:17 -0700, Bart Van Assche wrote:
>>=20
>>=20
>> @@ -5562,8 +5565,8 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba,
>> int task_tag,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lrbp->compl_time_stamp_loca=
l_clock =3D local_clock();
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cmd =3D lrbp->cmd;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cmd) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (unlikely(ufshcd_should_inform_monitor(hba,
>> lrbp)))
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_up=
date_monitor(hba, lrbp);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (unlikely(ufshcd_should_inform_monitor(hba, lrbp-
>> >cmd)))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_up=
date_monitor(hba, lrbp->cmd);
>=20
> Here could use "cmd" instead "lrbp->cmd"?
Hi Peter,

Sure, I will include these changes in this patch.

Thanks,

Bart.
