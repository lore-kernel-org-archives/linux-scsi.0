Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3653E2EA723;
	Thu, 24 Jul 2025 15:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753370699; cv=none; b=ZQ8exgehy8M6Hvnkq3QqXiU7kwhd1eesRKCA7kJmtt4aROD+XiQDUSOEE4UmY8JPSP/01CgoJL/FKZ8G4oWQ+2zWg4HO1+nMRw4EAStyDQzo68aqmRRFeDPLQX6soVbCIEe0sWhOHTP/HJgGKpRgLuxCITR46OzUyKt0R/a0BmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753370699; c=relaxed/simple;
	bh=cHGOOZLYJTIGAEtDcHr4dhtJfBk1cnXYgNfnHG3SUY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jwuO9tZE6qrteOk/VRItVh5fCixBBjQHfdTlMDSfnpl0MaSVcxGxTw5OJ2f2/8OrkksjcILqRziC3JVxqDJkqDvmUpGl8CUSvHSX7uRybZ0iKE5DEqJGb5sI5DAwxdb6nWm7j3x7ehLaVjouidrqHAM7EXC0oNeiYLbYVrO3688=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eneuJPws; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eneuJPws"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bnvvD1VYwzlgqxj;
	Thu, 24 Jul 2025 15:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753370694; x=1755962695; bh=cHGOOZLYJTIGAEtDcHr4dhtJ
	fBk1cnXYgNfnHG3SUY0=; b=eneuJPwsCf/5ZkhUd0t5DOS/Svg5Sv4+08z/OuEY
	80UcufChfhawAYcgWrkKvbzbUCqxUYiKCIY2ganRPE/p8X9nVaq59Qd399Tq5BiS
	dQV4ZvPvVQSiCmkVm4nkLyTA2RxvKy4DsOxK6UV0el1nP1RzyBe3e+IXxOv72j9Y
	mUeyPfD8nl7Xw4nNOv7chv3nhTGJPM3tWggUn6TKatEgPF1BxFgTItsNyT7QUf0u
	7Tsn897uQfH+YzbMT+qrjfAvgv0YQBdizzRrO+EnaV7vficVKY3aT8eWRpwmjWRg
	38CwPqrpb+3yrmx2rTtXHesK0/PIaHnLqi20FJt03k60qA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RjqInDAuY7gW; Thu, 24 Jul 2025 15:24:54 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bnvv52pHnzlsxCg;
	Thu, 24 Jul 2025 15:24:48 +0000 (UTC)
Message-ID: <45edee98-b720-4641-a1e8-77b1a96bb340@acm.org>
Date: Thu, 24 Jul 2025 08:24:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi:st.c replace snprintf() with sysfs_emit()
To: Rujra Bhatt <braker.noob.kernel@gmail.com>, Kai.Makisara@kolumbus.fi,
 James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, linux-kernel-mentees@lists.linux.dev
References: <CAG+54DbmHbw4MWUSF3x1qQC4bF7Uuu8mDD7aAZyBtbJ1D51MUw@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAG+54DbmHbw4MWUSF3x1qQC4bF7Uuu8mDD7aAZyBtbJ1D51MUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/25 5:58 PM, Rujra Bhatt wrote:
> replace snprintf() with sysfs_emit() or sysfs_emit_at() in st.c file to
> follow kernel's guidelines from Documentation/filesystems/sysfs.rst
> This improves safety, consistency and easier to maintain and update it
> in the future.

sysfs_emit() is for new code only. There is no requirement to convert
existing code to sysfs_emit() / sysfs_emit_at().

Bart.
