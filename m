Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A5B3A1DB;
	Mon, 28 Oct 2024 20:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730146017; cv=none; b=gT51LMZK06DjIEiOZQ23TCq6e0qCQhkTBzP83Lb/W82J78t9vqv4kYaDfpFJO4F+niUrgdipYXTEtShK93c0z46PREg3Al61znst/ulxf7VvEMIZcerqcSl23PyCh1Ie0FyqCcSVq3kNV391sutIlwLwsVOCIEkAcuaOH82dg7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730146017; c=relaxed/simple;
	bh=HlB/2zIeFc4pguDyn8N1WEYOHhDDEfdi3zKcsZG+E5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=flR0EKImp8fcMb46vfwU/ReJGoYosejvldXGTl45eyh3TqXA494D2LTHmBwXBm6mDpvWisyAX4czERTFuCVl/FIBXzHDg70kSrjp2y9fNzmhp/IsIU1/LV+XWELJ1YfeE6eVYPjHShCHkMe7hO5ZrGSQpcde5xb6A+opZ3+zIGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=w6hiy+Ip; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="w6hiy+Ip"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Xcktl28bbz6Cnk9N;
	Mon, 28 Oct 2024 20:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730146013; x=1732738014; bh=Ah9/kAKvbOE61CwmmhwhwzCG
	vmVmUWpB7WXAV5UWlUA=; b=w6hiy+IpyzgU60hJhEN/f/zwpA549CpUyQ8Zy0UE
	Y2j2fgi/OJteKZRbVwDFKsQSgmZydJK/ZHuphmMMmJMHubHLRepL34YHqbHttWWu
	CxB+9cBRKz/fvQqWs7SR4xruHyR/6hCkVgnOSFVEoWTGuRSVT6yIugjUkPWtsjBo
	P1OajmgdIuOvZgqhDQXCO85d2uQSbu18eET994HyM+zLEfQ2ijkH+N4vcUYVyQvV
	qmkaT2KNpCpH5j6Kf3ny5ZM8Gz95n+3VmZ/3UyCWJYDdHMD7EK+hu1/AZqZTWiAt
	SkMn7gFwyZC4g1rfKAzr5PDYT4ICC0MIyDBVtmePxl9oNw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id V9Ynjs6fHekn; Mon, 28 Oct 2024 20:06:53 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Xckth4pWbz6Cnk9M;
	Mon, 28 Oct 2024 20:06:52 +0000 (UTC)
Message-ID: <e3defca3-dd73-4260-b18b-522b8ca38201@acm.org>
Date: Mon, 28 Oct 2024 13:06:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Introduce a new clock_scaling lock
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241027082519.576869-1-avri.altman@wdc.com>
 <20241027082519.576869-3-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241027082519.576869-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/24 1:25 AM, Avri Altman wrote:
> Introduce a new clock gating lock to seriliaze access to the clock
> scaling members instead of the host_lock.

Same feedback as for the previous patch: please fix the spelling of 
"seriliaze", please use guard() and scoped_guard() where appropriate and
please reorder the members of struct ufs_clk_scaling.

Thanks,

Bart.
