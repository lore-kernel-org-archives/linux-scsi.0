Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BD9439356
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 16:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783526828; cv=none; b=gf3eV+zFWCfRp+dAvMq4ex4qwHTxnu5yLrEFxMBIMidsd5cYBybr+mc0/C2uMz/hGfUzOVIewXIi7x+KB71Zm01lgZI1ZwCc5d8pzRGeeBHDG+2zgt5f+AlX3s976qrMmPYO3uUDqTQ7WgR1KQINZBt+VnrAJHlTA5JT30F6BuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783526828; c=relaxed/simple;
	bh=UFiEBVRS9PROgym+dqqynl7PXTinT+Dwdd8YzHJBk3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WP/g9Uobo+x1zRpHAOIQObfVCYLQZ444dzMzchr3bAt1AIOZcscLuDy7qds/zFA7d2EOcWVvULRX8XWbR9QkoWQsX0EsRFl5emosj4OMJn73KtmbPP4OFzEMyAZf+Fd+pa6TXUclsIIL0OtA7lleN1OE4GSSZNG1fW0LEcR9lIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SJzDUTvd; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SJzDUTvd"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gwNJp2Vhrz1XM6JZ;
	Wed,  8 Jul 2026 16:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783526823; x=1786118824; bh=UFiEBVRS9PROgym+dqqynl7P
	XTinT+Dwdd8YzHJBk3w=; b=SJzDUTvdKPeEkEkJJ8S493T0iEJUEQNTlOdG3CbR
	pGaJ0+UimrLqGE/Qr2O93Y+ABXfrCqqO/FniSZYyTRtFeOCCLi+5zI7msgOwgi8e
	FX8r8NBhWOO5ilPLboIWiEm07s+fGXgFDvPOh6ruD64WtGPhFzsggCIqX9WQPcNB
	oPC3Tcil+zgiU4VoasESkWmWvu+deJtR4mLHzu4AfqyC3Mx9SX0kr7/KDKt8vNU/
	4hqWYQVYRMYKWaNCyUT9U3zR8zoYYD5JArzMB9q386xlJC07w1zRiVongvGhiOm5
	ggQnVu/sCVVPNg8g+6OWxsnBkkPzvQyTzuyiA0Nleaqi0A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id H45zpPhacvQf; Wed,  8 Jul 2026 16:07:03 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gwNJk2SQbz1XM5kW;
	Wed,  8 Jul 2026 16:07:01 +0000 (UTC)
Message-ID: <6c176ccd-18df-4704-9082-1cb8de49cec9@acm.org>
Date: Wed, 8 Jul 2026 09:07:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] scsi: sd: fix sd_done() sense handling condition
To: Yang Xiuwei <yangxiuwei@kylinos.cn>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: dlemoal@kernel.org, linux-scsi@vger.kernel.org
References: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
 <20260707030333.22245-4-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260707030333.22245-4-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/6/26 8:03 PM, Yang Xiuwei wrote:
> Only enter the sense_key switch when the command returned CHECK
> CONDITION with valid, non-deferred sense. The old condition let
> deferred or invalid sense fall through and mis-handle the I/O.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
