Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3AE2773C1
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2025 19:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755632422; cv=none; b=hWbqjtXfNAH91mWF/W5Qp3K6UodDyB63VvDcY1GiXdCoDh6dE/CS3IJ7GuFEsgq+1ugvnd+xgXOz0yc7T36frNkK9Fxn47ECMVwou30yKYtQFYwch2gHNR5KiTgNm1ui66TgAEwRuUL/i1jjl/9rEUPY8jkl0eV0eb/bdNubJCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755632422; c=relaxed/simple;
	bh=iVZkv4Ew0/7BWFtacuBEzqE4YwGAi8CZfdQu2e1aSP0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UX/OiZUXO0AqZvOGx3TX6Tl/ubWF70XBMiAG3T/QMDFQW7f1t5mcU/xXBfWVmqXLIb+E3XE7mfcECDSVl/C3ZwFIrvjcDW2cYegqHnGJIQFfixbSJkxLFy5WIeDIjMbfZi2LHwudeZWJ2WwLicWK64u/uPuR6FaIAuI5zOcXdgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MKhNPStO; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MKhNPStO"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c60Kw4s6xzlgqW2;
	Tue, 19 Aug 2025 19:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755632419; x=1758224420; bh=K5JlHC5gPhSYTJVg3jsoiBCD
	100TGy6o3NCnEzPwujw=; b=MKhNPStOsGXUfutS0Nl7YPTd/HfOSVq55V+g2Z/h
	e9bNodzwJgXy8mntOiNWox/vRXB/EpMeQekOjxLwkNxzjQKWB1A4da7euqDZq2yA
	Txjc7QS7mDVkdWcIQrFYOU7IM3lgUyg6kkyrLTpMU0ZON1b1TyqKjpxmeNbIrzmk
	2a+P2nHvqabm8YoMruRuldZLDfvQFAZUQ2hBbPsIyOLAUn18nMPhVh0I8vsG+3R/
	6lTjtBneNdK9n/keFR4+Nrgh7EgCNtcGvsCbZLJK8GG1IoM8YtKsMvX3RhGi1WlZ
	zG8m2PSzO4rR6hhbkvATq5ndVlz+bpzFIwshrl1ZoBgicQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 98I3KivmM_Cg; Tue, 19 Aug 2025 19:40:19 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c60Kq6b4czlgqVY;
	Tue, 19 Aug 2025 19:40:15 +0000 (UTC)
Message-ID: <e22a18ce-ef3c-4655-ae27-706106f24508@acm.org>
Date: Tue, 19 Aug 2025 12:40:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/8] scsi: sd: Check for and retry in case of
 READ_CAPCITY(10)/(16) returning no data
To: Damien Le Moal <dlemoal@kernel.org>, "Ewan D. Milne" <emilne@redhat.com>,
 linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-7-emilne@redhat.com>
 <65053b7d-6d73-40c4-90f0-29530861f204@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <65053b7d-6d73-40c4-90f0-29530861f204@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/25 5:53 PM, Damien Le Moal wrote:
>> +		if (the_result == 0 && resid == RC16_LEN) {
>> +			/*
>> +			 * if nothing was transferred, we try
>> +			 * again. It's a workaround for a broken
>> +			 * device.
>> +			 */
>> +			continue;
>> +		}
>> +		break;
> 
> Maybe reverse the condition to avoid this break and the continue ? E.g.:
> 
> 		/*
> 		 * If nothing was transferred, we try again. It is a workaround
> 		 * for some buggy devices or SAT which sometimes do not return
> 		 * data on the first try.
> 		 */
> 		if (the_result || resid != RC16_LEN)
> 			break;
> 
> I find this simpler and cleaner :)

+1

Bart.
