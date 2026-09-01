Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C67367B6E;
	Tue,  1 Sep 2026 14:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271381; cv=none; b=FfpINJ5XDXtOC3sg6JGCptMM/O7r8EekFNP2dIeB6TMNiYeYJMQgSx7FeplNg8rxhX6D0wXAWKvDgJQ0xopcpcjP+TiAaQJ+K0pAP4RTOuHO1mSD3B65Tq4ivRiNsbfAOdOXufzcaQJbk5ARjyiPPQjqIHjU+Ayl3Xxt1e+ngDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271381; c=relaxed/simple;
	bh=jPZ01+rb7mljLUxX40w8DG5H+CC+i3TzhhRaHa7YAWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ERxXe1OXSbKLJFQixy2Rhb33Byp9CDf1+9NuZlC13kxpKrWielEcSzKugx8+tVFjXeDEVwOkiZu0LW0ZNcSHxXlg3XPzY2SZcOB0EgJDXYAcSIoz7I4r46uJ3W2XgXkenwtYt5/9dad1DKm9iCuZUIgo3RyzL9YHk2QLyOJvf40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ayeav+1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ayeav+1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593511F000E9;
	Tue,  1 Sep 2026 14:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271380;
	bh=MKemib+A90Yyi/0o2sYe3BoQDFeH6318s3f7nIMLnwQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ayeav+1cL3WlPsJuHOUBGxG5nG5lFl65dzKAELeDfJFeeVnMw+mFCAIIT46P5DNWn
	 1O7kmI+NvRD1RycBh8k/GQEMCIwpLNL1XREsz6TWdahkcz0W5iDI6vPQMHftZoD+r0
	 4UsOYwJb3kqiuD1bDFuUAc5ACTBuFuwtixsoFGDAE8wH4uTlfMItdl0Dmiqz7CKjYZ
	 7S2PR3Xv0JLtZKzN1eDYoNqY9OpDUxO7Tn7+v4onW1f1ubZpQuLWBSxVkCl9fMQSUT
	 /bQ95fvuEuy4SjrEDyZ3EDZq2gpFVT8xEJQmEwu7qzv4v6gLpckH1swQipb5OBuqux
	 KRAoH3N+2lWfQ==
Message-ID: <ff869d8a-85d1-4148-b19d-af3a70fcc904@kernel.org>
Date: Tue, 1 Sep 2026 16:02:48 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 11/11] scsi: ufs: ufs-qcom: support ICE keyslot
 partitioning for guest VMs
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>, ebiggers@kernel.org,
 axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
 linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
 devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
 mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
 bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
 stefanha@redhat.com, pbonzini@redhat.com, eperezma@redhat.com,
 xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-12-linlin.zhang@oss.qualcomm.com>
 <046e4b62-6d25-40fc-baa3-2978eb96eb70@kernel.org>
 <b571ea8a-4434-45e0-958f-20b2f83ced24@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <b571ea8a-4434-45e0-958f-20b2f83ced24@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/09/2026 12:54, Linlin Zhang wrote:
>>> +		u32 off, max;
>>> +
>>> +		if (of_property_read_u32(child, "qcom,ice-slot-offset", &off) ||
>>> +		    of_property_read_u32(child, "qcom,max-ice-slots", &max))
>>
>> No, there is no such ABI.
>>
> 
> ACK
> 
> This is submitted for visibility. It may be revised in a future version to use
> a TZ SCM query interface if current out-of-band key operation in the guest is
> approved.

Don't submit downstream code for visibility. It just clutters review and
wastes our time.

Such code IS NOT ACCEPTED to upstream, thus posting it is absolutely
pointless.

Best regards,
Krzysztof
