Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDFE1F1302
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 21:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207381; cv=none; b=XnYRbSBli+VgGa5tNFGN9OcXfzgne3Zb+I0meurjpDYDLaL/pOMIUadKtlOe6HYEzdqr0/QUcN6BYogufJ+9d+EKWdcfeh3C69mmSgth0iyNolWjSY92FAe1j61J1F8oACot7YNO9cirUbOG/bEHX8I92kidcWd1n6vzT4MxlNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207381; c=relaxed/simple;
	bh=3s2ub08JUyqG8KbRcaHY6w8nTEfuQBvEfhKV0x6d3aw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=deGJjX+vd/U3pgzCFv2gB5ZDakyjhfucLcnR/hmMpuQUr0KKsoAsQRwfQrFrDBYgT1bWdE5STJiiBWT7TQH77eOdYa+xRrtgrXzJ17GVP6Gu+MsHL7nO5qKUaxjM3sLwM/yVS1ZTB3YEYSSuV/2L3BxV9sT0NhvEf9XgMCt1USY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ebT6Ya/r; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ebT6Ya/r"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c2z830J7Xzm0xjs;
	Thu, 14 Aug 2025 21:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755207377; x=1757799378; bh=3s2ub08JUyqG8KbRcaHY6w8n
	TEfuQBvEfhKV0x6d3aw=; b=ebT6Ya/rfpT1sCNTXWSwyDnaiaHZ9G/0jN+h9Amc
	FDGcElqpnBvQzKxiZDoTZAxnwzNiaic8YNs8TJv1EHakbiorQswsRrIJT4vdgpnv
	h8mDI3uhPNVsYyumrka0IrHYsteg7796lG6pZ26I7/AicbqPSaVcWBWqgbcUoqLv
	MghbAs4LWpu4tR4cGYwjqhmIDAl0SCawRlFRVTflF9hhmjf/7RwRp1WRPV9SMjD3
	8ECS6znEQnwkpeBkCnIlWZ9oIiZCn8QX8OXxNzLLATJ6J3j4j/aDKfJIyvI70Enk
	fbL90q7mRlNH4/wkiX0+6dxz8PK7oHy0ZqgKB584GMSHcg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id t3NHQzhKouWm; Thu, 14 Aug 2025 21:36:17 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c2z7y6n9Nzm174F;
	Thu, 14 Aug 2025 21:36:14 +0000 (UTC)
Message-ID: <0b19501a-d57e-43a3-901c-56cc9c76d5ba@acm.org>
Date: Thu, 14 Aug 2025 14:36:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/9] scsi: sd: Remove checks for -EOVERFLOW in
 sd_read_capacity()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250814182907.1501213-1-emilne@redhat.com>
 <20250814182907.1501213-7-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250814182907.1501213-7-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/25 11:29 AM, Ewan D. Milne wrote:
> Remove checks for -EOVERFLOW in sd_read_capacity() because this value has not
> been returned to it since commit 72deb455b5ec ("block: remove CONFIG_LBDAF").
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

