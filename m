Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F86F4689
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 00:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755043475; cv=none; b=oxEX3IpE3TJWcsPrrAYBZE18O+FosOfbSZX8Zb27Azwnmx43wF36JpGxidgkIaPfYm75DKCF+sZqmEf6QEKf3xKo98EYiyCLdv9EoE2fV/wgFBkvWfKvUhdh0w/qsgHSgYU716XlCmlu5loFF71LUiNkaoRuaGwofAPoWUqHtVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755043475; c=relaxed/simple;
	bh=eujWa4eTOz6ZuwAKHZpeN8HEBdUpAGlH2J+Tmyg4wyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i0YmfCBHyIlspZDUAFHx8stBG8qFHyS/pS0f1QtK+Mrzrz9LtlP7ALwWy0x1rztpQ6YSzE6ovCPSETvrrQJgqAKjmOKzLWvHGIpiCtfFd76w/W7bULoEJ4cZmuUodRMR3OT/hecg8EKNMWebBnWxOtY+mBgoTsVy5J54aNCG2zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OXIV2IlT; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OXIV2IlT"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c1pX04D8szlgqxf;
	Wed, 13 Aug 2025 00:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755043469; x=1757635470; bh=eujWa4eTOz6ZuwAKHZpeN8HE
	BdUpAGlH2J+Tmyg4wyY=; b=OXIV2IlT58U3HsUYrxk8gGRtLh5Gyol+iKB+wbuX
	jLUXLLFiAvvgMaCJ6y2N++S83sHjkcBhieicaNd+wrjAfEy98McX/PW4z9Hza2Uw
	3dKK5+1lpRcRnzHtxDxgL1qt5Ny6Viq2+d5LNCHY4LMYeniZihqQDkialYSuHd54
	7s+NnzOW7G3ygsuZUGBM9DjveZx+D2DJ+euztWEYo/MfgVYJO2gSpZtL1VDg9MCU
	manm/hZbjQXA6pUh2IHLV9HBnlRTpIm4bXO0TIHEvn9Uo+Md4P0K1k2WzYFyIuY0
	jNw7Jz6Y+DctwAr0OIkp2Tt78jZDTpznyGX0tIRDOC/2eg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nBOnk9VIy-T0; Wed, 13 Aug 2025 00:04:29 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c1pWt1YZNzlgqVs;
	Wed, 13 Aug 2025 00:04:25 +0000 (UTC)
Message-ID: <8fc0fa2c-7e3f-4e3e-a3ef-17a14d5beb54@acm.org>
Date: Tue, 12 Aug 2025 17:04:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] scsi: sd: Remove checks for -EOVERFLOW in
 sd_read_capacity()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250716184833.67055-1-emilne@redhat.com>
 <20250716184833.67055-4-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250716184833.67055-4-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/25 11:48 AM, Ewan D. Milne wrote:
> Remove checks for -EOVERFLOW in sd_read_capacity() because this value has not
> been returned to it since commit 72deb455b5ec ("block: remove CONFIG_LBDAF").
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
