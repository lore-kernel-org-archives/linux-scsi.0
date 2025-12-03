Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9A0482EB
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 21:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764797576; cv=none; b=fF3YAW4P4dlBuFYOMt01obA9U5CKvZr3+OEWiwNgCyfTNsLNOEvP9EQar4KeJryjwZx4qTk0vdfL3NMYQS1ACHXfVmmxCrUEP25NqoOIsgi+/PD6cGsITObTI5I9HybCZt2QXwOlTQQGI2gNY+LDqSVxBF4amh8u6UYR9lnoP28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764797576; c=relaxed/simple;
	bh=WAk91XP7wvjrxqsZoc5nkGmWZi0y77dJSEvPGcKjTsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jat9bMYK1/S3exgXtme29vNNUlkCpkv2OJ5Fuh71PIBgDah/6e0aCxohsZm2w8BEyo8soM6QhB3MVuMC5GchVw/Etr0f32vl4EggfgR1eeds559qvSEFhbVrOnMioOxcqRpftkUR89uaNaDQTgV4rrfiMAWfVuAW+LUVn4kMglM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tmtGK+kW; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tmtGK+kW"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dM9pm68lNzljbX7;
	Wed,  3 Dec 2025 21:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764797567; x=1767389568; bh=kjAXJUhthcj9BbicKKb5Xu3m
	I4ByUvHhZxes/OBrziI=; b=tmtGK+kW/ySk4p49hOI5pPGJgKgqV2Yc2XBQfB8R
	Msmzkv/NM2Kmxa+GiZFaAVVcNRmhVg3y8BND6hkIIl4bPia22me6aKag7k0je63F
	lhnzm8gUBOK9xKLIzCPc1yF/+4YVi3XJiNdzdb/S0o9LL+yYCQqk3Rm4mZ9BeFP5
	awbZv4qQi+QB6EGwNqr1mmTWn+zK0ov/x16kYvJ7t03dd4P468TaV41lmnHEP0Rm
	KTAnrHbQNVB8+7JvUhJ3nS+HoU/OQ8KhlM6vRadE2c1LA8jx9XmmGZfW9ueptPI/
	4P0e5DZmni7FbXIpHt2OkZfI/1fmuMVMObh3BXPEWenbrA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id s0rjriZ3soY6; Wed,  3 Dec 2025 21:32:47 +0000 (UTC)
Received: from [10.25.100.213] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dM9ph0ZtLzlfdCs;
	Wed,  3 Dec 2025 21:32:43 +0000 (UTC)
Message-ID: <fb4489cb-224f-4616-ad27-4d02bedb1d06@acm.org>
Date: Wed, 3 Dec 2025 11:32:41 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Roger Shimizu <rosh@debian.org>
Cc: Nitin Rawat <quic_nitirawa@quicinc.com>,
 Manivannan Sadhasivam <mani@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Nitin Rawat <nitin.rawat@oss.qualcomm.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
 <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>
 <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
 <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>
 <CAEQ9gEkz=Y1ksXL0wCumb7zbqXTREqJ6Vn29P-7FWS_e=iuuVQ@mail.gmail.com>
 <84b00b56-e775-43e6-a829-85e5da43508e@acm.org>
 <462fb80d-7614-41b5-aac6-2492845d7468@quicinc.com>
 <250c9b6d-dc2a-4ad6-b3b7-e29e9a2c4798@acm.org>
 <CAEQ9gEmnBj-ofj9VtZ1O04M9g4hHLA3yP=Y2QZjc8vUX+Sxy-w@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAEQ9gEmnBj-ofj9VtZ1O04M9g4hHLA3yP=Y2QZjc8vUX+Sxy-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 9:43 AM, Roger Shimizu wrote:
> Yes, this patch fixed the boot issue on my RUBIK Pi 3 (QCS6490). Thank you!
> 
> Tested-by: Roger Shimizu <rosh@debian.org>

Thanks Roger for having tested this patch!

Bart.
