Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA29E1E52C;
	Fri, 24 May 2024 13:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716559090; cv=none; b=mrEx2YIgVrCQGV4R2pLN4L5ye2z+Ca8k3Y2C1dbCPAQnL0MvoYePlNYaCPZH1RnDG1PNfSdfeUnvQ5BXz1CMwZSK2JblBfADOLQlajlwfPApT98FPFFh7Q+1inaLMWdp7FSWp5Ug1/2pD6dW6JEG4PwSiwGdL865QVRuDVdPtuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716559090; c=relaxed/simple;
	bh=My46v/q3vuGUyzhpBjk8iJOci71XYAlSL0dzslvRT94=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XN4I8g+QCMfGv0ialZ8U0ecmnbb3D5e//q4pkTmbOPo2xvrdQWTkmI/95glH5VDXln/ZYmYn7vK3yP/JQxuPBYf6k6iWmJKoI4FdZ+z995XZYHguDDT7bKwsazqpO0k1+hi7aUXgpkbfxtQsw+dX3GoNw1C0vJNvwX2jPRYT/Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=e7V9Lm77; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="e7V9Lm77"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vm67h2CkLz6Cnk98;
	Fri, 24 May 2024 13:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1716559085; x=1719151086; bh=YSAvrSBYQ1N+WHlYWnVL/esX
	HnHkzq/h8R3JKbIoeoA=; b=e7V9Lm77kIZf29EMMJzHB/H3dvp5vL3WtxOauLqu
	PalH564fnUrroI7IyvU+lTJ55USND8R+tPxNtffRIhxXKhlpDMkGqiIShm6VRaP9
	xp7QUpJMW5IjO47eUSo9gibNdKiDcmt30r+lxDSzw+4hvyLWldSypa7zn2Orgm8j
	/rDHoQ7gzXfNTFt7D6Xy/xBB8I8alp3f76m14RCF3V1++94RPGkatpr3Sx5Kjpi/
	MY9n0LGK/k4MqZ/EjcKxbdBtQwxc5ofiVlHFsUGGa4MZYfiRB4kNlBIbkdPMpEJv
	gywL83Zx+F7kxU4FUrTYVtjc60v0p3EEgJy+YuQdzdEp8w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id L21v3LBY9ndt; Fri, 24 May 2024 13:58:05 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vm67Z6ZL0z6Cnk94;
	Fri, 24 May 2024 13:58:02 +0000 (UTC)
Message-ID: <396e5a4f-b9a1-4d82-bfc7-9264dd741a00@acm.org>
Date: Fri, 24 May 2024 06:58:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs:mcq:Fixing Error Output and cleanup for
 ufshcd_mcq_abort
To: Chanwoo Lee <cw9316.lee@samsung.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, quic_nguyenb@quicinc.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20240524015907epcas1p2598a2ba8a81529b6639cff007fe9106b@epcas1p2.samsung.com>
 <20240524015904.1116005-1-cw9316.lee@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240524015904.1116005-1-cw9316.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 18:59, Chanwoo Lee wrote:
> An error unrelated to ufshcd_try_to_abort_task is being output and
> can cause confusion. So, I modified it to output the result of abort
> fail.
>    * dev_err(hba->dev, "%s: device abort failed %d\n", __func__, err);
> 
> And for readability,I modified it to return immediately instead of 'goto'.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
