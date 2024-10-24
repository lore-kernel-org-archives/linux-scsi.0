Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE481F4FC2;
	Thu, 24 Oct 2024 16:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729788946; cv=none; b=tPQueoitVICtUzWgjWwTqnXshj3p59vVvyt4Ol9DxzTDZIir3d5cn5489A+n8grQyrakV3MbeEqz0ThNaTKJdIxoMxFFcWETi27+ae55cd63FceXmIH9OyLgrgWig4ysYVuJNNM9+E/UpqIUr7be6WAHZBg339moRmvM15zNrbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729788946; c=relaxed/simple;
	bh=drM0DMK3pHMCglOQSZDyX0yoq8NZa67xJxu+fcnJ7Ns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DhquZiqrIdUH7mvzl871IOzSfMNjcm7ueCO70Xv0DAjbzg4t5WE/Ii6NS6KukjLW8yckCWkwN43ZIh5ZmJhqCE8aFa3t/FXJK6ic/wJSGf1XmCNtH2bPd+XrAZvxl/8gN70fU+qbad9DRsREQtK4XI4P42I24XhNRnfem5rHcb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oh6mGL9d; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oh6mGL9d"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XZBqz50glz6ClY90;
	Thu, 24 Oct 2024 16:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729788940; x=1732380941; bh=9lnwlH1gvmn7sLw/ysbauuEU
	LqLiL524nQL5bu1Jjyc=; b=oh6mGL9dfm2zqTOpmUiID6BDR5XCSScPeHsy4r7F
	MUFoVy6BKthGaUqZo0qREgBh8ifoVryGWnE0p5UMGkli2phHG6bqzchkmyOnEmRs
	3UWqaSCg1MsWzQEYs06c8A5103BTSM8srov/eNY1O8mHlouV8qmDJgDUcTIOmyHC
	pGwV5bjTvk6RPLqItGxBshTC1ya9Tmltqp60WgnuD3AcIEcTb9qwKyl/mJb1KbBB
	mXnDxGzpGKoIBmfZn2b2THjd0b6lyEKKYpo1Z/Hcw8JqHfkh/Y/BQmD2ZdKYMOej
	J4m9aM6CphcAFqZAlnwdgxopMLo/B3sECnzdDMOFFYX8tg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CoMIQO6QCvsW; Thu, 24 Oct 2024 16:55:40 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e14:8:59a1:69e9:d92b:89d5] (unknown [104.135.204.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XZBqv0QfLz6ClY8y;
	Thu, 24 Oct 2024 16:55:38 +0000 (UTC)
Message-ID: <dfd36022-2397-486c-8499-454d31072a30@acm.org>
Date: Thu, 24 Oct 2024 09:55:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] scsi: gla2xxx: use flexible array member at the
 end of structures
To: Mirsad Todorovac <mtodorovac69@gmail.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20241023221700.220063-2-mtodorovac69@gmail.com>
 <9ca3fb4b-85d9-493c-8b90-5210f5530e7f@acm.org>
 <414ef7aa-a1a3-4c13-887b-25a51236f83e@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <414ef7aa-a1a3-4c13-887b-25a51236f83e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/24 9:22 PM, Mirsad Todorovac wrote:
>  From next-20241023, it seems to have passed compilation:
> 
>    INSTALL debian/linux-libc-dev/usr/include
> dpkg-deb: building package 'linux-image-6.12.0-rc4-next-20241023-00001-gdcf82889780d' in '../linux-image-6.12.0-rc4-next-20241023-00001-gdcf82889780d_6.12.0-rc4-00001-gdcf82889780d-4_amd64.deb'.
> dpkg-deb: building package 'linux-libc-dev' in '../linux-libc-dev_6.12.0-rc4-00001-gdcf82889780d-4_amd64.deb'.
>   dpkg-genbuildinfo --build=binary -O../linux-upstream_6.12.0-rc4-00001-gdcf82889780d-4_amd64.buildinfo
>   dpkg-genchanges --build=binary -O../linux-upstream_6.12.0-rc4-00001-gdcf82889780d-4_amd64.changes
> dpkg-genchanges: info: binary-only upload (no source code included)
>   dpkg-source --after-build .
> dpkg-buildpackage: info: binary-only upload (no source included)

What kernel config is used during that kernel build? Is the qla2xxx
driver enabled in that kernel config?

BTW, there is a typo in the subject of your email: gla2xxx should be
qla2xxx.

Bart.
