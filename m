Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C4C47A6F;
	Wed, 13 Mar 2024 16:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710348270; cv=none; b=uC+sDhtU45Q83UGB8XGJpLBb/vIVCU8waUSyYOKPHY3jppgglZifZV5ZQnI0O+gUKEl3rfa92ipkllZhI/sIX7TLKOf2J3stmQw9uWX4bN4vzCFuE+NEiLlDLNIdBZnOPMKI/1oZOZA3E/H4pfnIbe+8Vqhgn9+QQAMiNZ8eCmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710348270; c=relaxed/simple;
	bh=+j4MnK8yhYNXo+bM95kvafS7T8rM0IDGcmMjawvqJlA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TAfdHgXdMqdAXqdBzGuf7MSKv6WK4NjAQdAy6SpJw5zIiCA5LhQsNSPCIqM0QJhGOBRxveslRgxlignkD/QPrx1AACZpp9GPUjK5VOxnXX9SIPIVtRycJSpM1XV5vTJaKtr9QZrK0L1FVVailAAToxGIUQLZB8habfVPQb0RDiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CN8A/RbA; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CN8A/RbA"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4TvxDk1mczzlgVnY;
	Wed, 13 Mar 2024 16:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710348258; x=1712940259; bh=+j4MnK8yhYNXo+bM95kvafS7
	T8rM0IDGcmMjawvqJlA=; b=CN8A/RbAmz+zbf0DpgisXuF0mIn5y25apVnP6Sq2
	A8lmrxn1JsWRUV/o1c0x2MTLuqvU37Ar5Sd6Xl2GlwXBuQcZsg1imEwjaIoHH6d9
	GlYR6VY67QuF+W0o6IJ9gIOwN3NbJYxtKil7aRzVfGjCBGxC2b8bhdS8Iha0gy+C
	P/hiQ73bjRRrcm9LCcUa7u4xf0dDylJgUFkliwchl1r+43HjqkxHAE/gavrK7XEq
	eEjhVMnpICnTwaTX1bGwLaQRrurO+cX4SB2LlvxdM3NUUsQABsGA0fT3glZWUSsX
	nLMdvbJWqIplWtY6tf5Ke2riXG2Bt7yX9m/vNQm38SzHiw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VLYf3Jaka_yc; Wed, 13 Mar 2024 16:44:18 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4TvxDb2X9XzlgVnW;
	Wed, 13 Mar 2024 16:44:14 +0000 (UTC)
Message-ID: <c8683449-1545-4372-b937-dbd0e023c22d@acm.org>
Date: Wed, 13 Mar 2024 09:44:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix unremoved procfs host directory
 regression
Content-Language: en-US
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>, linux-scsi@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com,
 stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net, kernel-dev@igalia.com,
 kernel@gpiccoli.net, syzbot+c645abf505ed21f931b5@syzkaller.appspotmail.com,
 stable@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <20240313113006.2834799-1-gpiccoli@igalia.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240313113006.2834799-1-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/24 04:21, Guilherme G. Piccoli wrote:
> The proper fix seems to still call scsi_proc_hostdir_rm() on dev_release(),
> but guard that with the state check for SHOST_CREATED; there is even a
> comment in scsi_host_dev_release() detailing that: such conditional is
> meant for cases where the SCSI host was allocated but there was no calls
> to {add,remove}_host(), like the usb-storage case.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

