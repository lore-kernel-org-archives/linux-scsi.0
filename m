Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7799379EF0;
	Mon, 20 Apr 2026 17:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776704487; cv=none; b=YcOhywhtesOSt627fme1hk4u3Dmn+0EDkobK7MrytRPz0C4CPUcQ6iNOYjvCvxlHPrhs0kXlZFKP9Iq4aU9Te5egDWUWzykWZ+AF1LXittJvcyfA3xB7Syo3wE6QHSzX3FoGCn/kE6ekF+JB2JuUPxB3FwVAfO1+yxYGKr3QC4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776704487; c=relaxed/simple;
	bh=mkG93AHaQNaLk2PQNnLgIp0L+M/meNjGCG4XpokupGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eWr9vBwPZAVcAyU/FJBXz3WF44lrt6BHwKEdrWByapPrevDYs8BBhZbdXdBraA+xPGu/pWX6ELzyRHWu/yZ+1YoJyFHuWZQoW879INU5ot8B+iLdQnfW7ceDQi5w3ZonXjw6q9CP+3qVxhNNNCbyayCnHCL/6g4TOxfi27vBbzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=v1XAmVYT; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="v1XAmVYT"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fzsFy122FzlgyGW;
	Mon, 20 Apr 2026 17:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776704479; x=1779296480; bh=JzMHStaXvxrZojd2ODI2E2o9
	i6bEEDLPNxjEvLI1VbY=; b=v1XAmVYTrJC8JCbDHM7L+FFclZYko44g0WqjsqbR
	iSSHzkIXEoUrSk8sXD4ON9EzG2A1jjiGuvvnV+OLzUwWL4Rpc6iTD6gpFOUUBIMv
	LqYp0GSWbIRE7EGt57M4nS8JrPjDPst0mNBe/fqFG5S7yIug8Ju8MMbtuoSHQrYy
	AkuUlrm2+lsX7kcnNw6FoJFZ+DLUp3nwoU7dLXYZtvGjcXDnTwOxiMlPQzH07xFx
	QiEx7Ys+kHoCZudbZLJ26I3vUreSMqdhF8UE0T5rOBOv3sPIi3jX2vxQoji0fY7a
	uvqkBZUvL6VB1DoDTerQjILTPR/+huAThbU8n+S7qMfzzw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tBaPy0tePyAt; Mon, 20 Apr 2026 17:01:19 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fzsFk1YG3zlgtd3;
	Mon, 20 Apr 2026 17:01:13 +0000 (UTC)
Message-ID: <7daff6c5-a0b6-4d52-a115-98cbb1d9abd9@acm.org>
Date: Mon, 20 Apr 2026 10:01:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support to retrieve and store TX
 Equalization settings
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, peter.wang@mediatek.com, martin.petersen@oracle.com,
 mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 vamshi gajjela <vamshigajjela@google.com>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260419135229.1036926-1-can.guo@oss.qualcomm.com>
 <20260419135229.1036926-3-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260419135229.1036926-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/26 6:52 AM, Can Guo wrote:
> +#define TX_EQ_DEVICE_PRESHOOT_DECODE(eq, lane) \
> +	(((eq) >> ((lane) * TX_HS_PRESHOOT_SHIFT)) & TX_EQ_SETTING_MASK)
> +#define TX_EQ_DEVICE_DEEMPHASIS_DECODE(eq, lane) \
> +	(((eq) >> ((lane) * TX_HS_DEEMPHASIS_SHIFT + 16)) & TX_EQ_SETTING_MASK)

Please convert these two macros and also all the other new macros in
this patch that accept arguments into inline functions.

Thanks,

Bart.
