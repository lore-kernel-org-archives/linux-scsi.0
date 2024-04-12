Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81D754F87
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 16:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712940629; cv=none; b=ViVRejxMLxERq31L7r1kv2A3IkjKOVD9fxY90P/0A9UWxxBmlwqmjvQNiAh9F3hlFW5a0oNLCLtBKx93kVtYd26k6NsG3ehjSYzGwlLBzin4gPWY1WK8klQRvUICnnxNJkmGdMHqeK67htfgLoCneYqnCg/QQIIvrVV2zxs29R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712940629; c=relaxed/simple;
	bh=NnMOUxcM9fIXRwnP26AT4V/SGoB0iPHubpyCqb7qirc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pdljtRA7terVcO3a1FW/QtFl63tyC0RydJQVWBXsityxtySvQG5OkO/nfQgZKVF+VM3h3U4T3w8TJtGxWES3r7eQtECcN3/wNqm/SYTLPzLQ/Q/l3MxLgA+hBcboL7VSdzLwtm8py+6ZDyeJeAEMNyP+mv1RRKb0JH/qnQ8KrxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=04SSVb9i; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="04SSVb9i"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VGMxv0m0Wz6Cnk8t;
	Fri, 12 Apr 2024 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712940623; x=1715532624; bh=kSdsRnHu9V/5ovP8hTztp+GW
	FU/ThoOUYc6LNpKGoHA=; b=04SSVb9i66siMUzhZQbwQ2foDfvAneQcQn9a1Y3u
	HjIMKjSczpowVMek5Ptz8dThCa4lEUQfNZEaT9K/nSRN0Y46SviFAxC/kQTA6W9L
	/M2oOLzEAc7xJdnoseyfDXeVaoRdaHGvb1IbROQwNnr//KQLcyxYgEjDncIUKYTx
	5Ip0S0Jycpu64CvI9HlAeFiaFwsjqBrSU0KRV+Qb76ltuFWNsunD5kgd8+eK+go9
	Y3MVDapQT9Ka4B9VjLfkjx11ttZ+fhcQWuD/2EyqViQtoY70KPI5DfBI87OvL4Zd
	vhMn/9DiiVWOEm6okzh/nzuh/+BIPdO/ctFXPUDP3ePrgg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 18mZ304B3sdW; Fri, 12 Apr 2024 16:50:23 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VGMxp5sv5z6Cnk8m;
	Fri, 12 Apr 2024 16:50:22 +0000 (UTC)
Message-ID: <e182fa55-9a4b-4ada-ab1e-097a58bc57dc@acm.org>
Date: Fri, 12 Apr 2024 09:50:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] scsi: ufs: Check for completion from the timeout
 handler
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>
References: <20240412000246.1167600-1-bvanassche@acm.org>
 <20240412000246.1167600-5-bvanassche@acm.org>
 <10541ba3421bf6d6228add4d87a682abd56e7e35.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <10541ba3421bf6d6228add4d87a682abd56e7e35.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/12/24 02:34, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
>> +if (is_mcq_enabled(hba)) {
>> +struct ufs_hw_queue *hwq =3D
>> +ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(scmd));
>> +
>> +ufshcd_mcq_poll_cqe_lock(hba, hwq, &cmd2);
>> +} else {
>> +__ufshcd_poll(hba->host, UFSHCD_POLL_FROM_INTERRUPT_CONTEXT,
>> +      &cmd2);
>=20
> may need check __ufshcd_poll return value?
I don't think we should do that. __ufshcd_poll() returns a value > 0 if
it has completed any SCSI command and may complete commands other than
@scmd. In this function we need to know whether or not @scmd has been
completed.

Thanks,

Bart.
