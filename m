Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4BA21ADBA
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 19:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744399834; cv=none; b=SWc40elk3APOAesRQ3pmavN9UNWpPvkXAKrBYTgJ/xmNGZ9OpBCIeXRBygHKx3966dbDa82xc4kPEqvOcxEnbYKtxx3f+lcVrazJWgafsW8zonwrXyB7jvpx277r5n/0RPVHWfvUdXMUeOK0MgtZZyw/eHQwMWf+EPhAzNBhlcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744399834; c=relaxed/simple;
	bh=Z7dzgcU2EBJ+OCOdxgY9BUD9RlegHJaDtebR8gbNl6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eQ1WZt2n14mP/N19byISDMDXelsU7rp05fReqGujsNrBMHToBkhq8O7FB3DarJNa/qNwvh/Z6mKAFwzXQxxJataoCB2v+LJHQS15ZQzlB/Ya9uinDOCexVf+Qilzvqobs+a4KLXQwcXPVGMbS4n82UqEdBzPDj8/igxeuMahPOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1mwXlAh1; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1mwXlAh1"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZZ6GS5TWBzlyPLm;
	Fri, 11 Apr 2025 19:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744399823; x=1746991824; bh=8XADgH4CrTHHfAkjvZpmQDbS
	twyfmXwMZhd7EHSbs6w=; b=1mwXlAh1O133y9Z1yFgpZxbHJokfzBkPK7U/IJS+
	4W/Ev4mq3OPVtIS+qGhJKZ2/EyjYxdTmYfU4THzxAJHvlMEjSvfwrqNJKf3sp4dJ
	gZZ5PXl99LMYz799SQD/YGThxI7YUufuY+ZdsEXoUBjeFWQsGIoxNE1Yvb5Qtgr/
	iJO1hbDhrqJfK+vE83IWG0uzdHLQRhuK0etFdD0PefugZ323cyJA34adh6eSuPUr
	oGeMVF6IbchORqZDIGbIAOpL7RXjoPVySHBSq3Xi9LQbbBxH2j7sW0ifQCkjLvfX
	M9RaBjGpRVfiJjnQrqnOyRLnbXfNWWQO6BYeMDEEDFsNxg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qS4s4FwB5_nE; Fri, 11 Apr 2025 19:30:23 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZZ6GM1hNzzm0ysx;
	Fri, 11 Apr 2025 19:30:18 +0000 (UTC)
Message-ID: <04ccb1a0-e29e-41b7-ad3d-6e12f66ceff9@acm.org>
Date: Fri, 11 Apr 2025 12:30:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11] ufs: core: Add WB buffer resize support
To: Huan Tang <tanghuan@vivo.com>
Cc: huobean@gmail.com, cang@qti.qualcomm.com, linux-scsi@vger.kernel.org,
 opensource.kernel@vivo.com, richardp@quicinc.com, luhongfei@vivo.com
References: <5588fc82-888e-4be8-b28a-5ab2a69d2ce9@acm.org>
 <20250411092924.1116-1-tanghuan@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250411092924.1116-1-tanghuan@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/25 2:29 AM, Huan Tang wrote:
> Follow JESD220G, Support WB buffer resize function through sysfs,
> the host can obtain resize hint and resize status, and enable the
> resize operation. To achieve this goals, three sysfs nodes have
> been added:
> 	1. wb_resize_enable
> 	2. wb_resize_hint
> 	3. wb_resize_status
> The detailed definition of the three nodes can be found in the sysfs
> documentation.

Please do not use the git send-email --in-reply-to option when posting a
new version of a patch or a new version of a patch series - this may
cause patches to be overlooked. Since this patch looks fine to me:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
