Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4121047CA91
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 15:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786722118; cv=none; b=Uc5zW9v+FJJQy4KKQ/oU5trYJgP81ZnBw4DE+zqOrW8FhOUBndXUan0mRRvp48SRAayK2FoMdG/wEdrftxVf1LHVt25wy5D70kcFCI2PvB86PEWXtP0Oa+OtKGMplGWUfj4AY1tCbievCRU8yNCXCIVTbUDp6bYhgezwoTQ/5HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786722118; c=relaxed/simple;
	bh=+uw1buLuXFNG3sIiUBqfOujBD1Zh1Ut7dJ7UAULhGbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LJ9pvpTJfMxFXquvPHSCnR7LZJL1PFKqOJti6V0RBZ+ZQQSH4BnHZGZAI5R+6Vx5Qz6tRkSjSh9LcUrpW8DOOnIQZlktmreIVIsdhs5oHqc7dYio3z4ouOozzXBJTpbv36zi1BTYbMHW6eUUDoneUT83i2cne2ZKNVTjUjxPhz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=k4U9QS3G; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="k4U9QS3G"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hM60g6YnBzlfpM3;
	Fri, 14 Aug 2026 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786722108; x=1789314109; bh=AZRGVIDQId9MeaBOdvUN0tuk
	ouSK8TMWk1ss+YDc7ls=; b=k4U9QS3GNOuzrMqwB3R/g+j7pUy1Vdo5BcqIexde
	TQuHpUk3SgmHZF9YRTdFE34+i+V9Jg578EH95vXJt/Pa9oBk7wEkqN58VmXKSgBj
	546DRLruR7xVJ/GP44AXLH7YUbx82X4UVXD083tRf1tgE5GqHel9bqDtwRSz6zZA
	3UlQRo2jzM8Eq3xwhHyhqI7BQCiBkdLp+pqfFRzvJ8x3TmQm8o2JjqR+DX99Cshl
	qsQoW6w3pn3DmOeHCSVLPs7DElYLglLH7DKs7XXWjr4f3xbyEfuqK6tNEGVV7H6q
	gn17emXRRyA7dpmBgdIkGBRScxXwlcVwTeyOj3I1Rl0CjQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ajetJh8R0lPH; Fri, 14 Aug 2026 15:41:48 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hM60R2YjNzlfwgC;
	Fri, 14 Aug 2026 15:41:43 +0000 (UTC)
Message-ID: <f91c7df9-3534-4ec8-a6b6-417577bc22ad@acm.org>
Date: Fri, 14 Aug 2026 08:41:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/6] scsi: core: Protect host state changes with the
 host lock
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
 Jianzhou Zhao <luckd0g@163.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Dongdong Hao <doubled@leap-io-kernel.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>, Nilesh Javali
 <njavali@marvell.com>, Manish Rangankar <mrangankar@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com
References: <cover.1786142946.git.bvanassche@acm.org>
 <681e4a5260c182feb5fc1d96f0d43c62c21dc6c9.1786142946.git.bvanassche@acm.org>
 <3731591a-f495-488a-bbe6-96f4ec2acb78@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3731591a-f495-488a-bbe6-96f4ec2acb78@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/26 7:59 AM, John Garry wrote:
> with my changes in https://lore.kernel.org/linux-scsi/ 
> yq15x1dtp3r.fsf@mail.kernel.org/T/ 
> #m064c12513575565cc08afa15738215b98bcca142 on top of this series, I 
> notice that the following 2x forms of annotation are compliant for the 
> context analysis checking:
> 
> __must_hold(shost->host_lock)
> __must_hold(&shost->host_lock)

This is consistent with my observations - it seems like Clang accepts
both forms. Marco, do you perhaps know whether this is a bug or a
feature? I couldn't find the answer to this question in
https://clang.llvm.org/docs/ThreadSafetyAnalysis.html.

Thanks,

Bart.
