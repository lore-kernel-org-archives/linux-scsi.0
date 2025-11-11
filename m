Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143B126A0C7;
	Tue, 11 Nov 2025 16:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762879127; cv=none; b=ZZD8OMfj66SklhWFcmpuFlz6ee9pazU2e/xnEoToFfkGSs+pLzT8SR462ALUjrZWxfnzntQ1/M2fyo8EJn8jObX30EW7u0ZBiJHIs7LAJWErkZKT382uXEZ+/sUf1ToU+1j4ZMhUeiiNHqRb147hU1+jLsITDRzYDVPHfA+7r+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762879127; c=relaxed/simple;
	bh=WeZF0bR2aaIUY2TSMFnLen1JJjH7doVUB12Z5g9qkN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JEMc51zIJGiqMiFEG+qzHmX+egJNBHx/e88+PUIQ96sPF7T6K8t/WxdlPYwDZpJagj25G1+N/2EkAzFC9Gr/N1ujI286GeG4Lt5kyhfpK+d5VN8/4d/CzIz0dCGXpVdhGbedau/Pgts9B1Fei8YWpMPD+8L1Fs3bCsPmg4Gs64A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=s6aQOsUf; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="s6aQOsUf"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d5XKd0JGWzltMW0;
	Tue, 11 Nov 2025 16:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1762879123; x=1765471124; bh=WeZF0bR2aaIUY2TSMFnLen1J
	JjH7doVUB12Z5g9qkN8=; b=s6aQOsUfA6lKJj1FgeO/7K0H/5vVj70QFyJSbWwa
	W6bvZPUi0OBBkibBRqYl3v3vrZ6ZhnSpsGJj/g5RXvKUALbZW2nG6a9OZELw8hwV
	gZoJqSB0m9Q6qL88iouwGbShQ5LdtRDugw5YCW/D6vOOP4K/MhCvgdj04iQtIO02
	rwxIaCtymm0RPtUdGv5abVpCj/2Anek1WDiedRakXXoarXgrNe+LuBpeTKnTY8lq
	g3iaMhjE2QC0ykhQR7DZ24CblnRrtb+oLcOQZs6BLUtO+LO5xwUGBM81KTUmg43H
	Qnp2/lxC0LwyrK65Kp7xE7nFX6UNA9VrOBKCGEiThzaWFg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 37B7QlRuUsE6; Tue, 11 Nov 2025 16:38:43 +0000 (UTC)
Received: from [10.111.50.167] (191.sub-174-194-195.myvzw.com [174.194.195.191])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d5XKN0Z7hzltMRG;
	Tue, 11 Nov 2025 16:38:31 +0000 (UTC)
Message-ID: <4395dab0-155a-4c9f-9f56-534068845b12@acm.org>
Date: Tue, 11 Nov 2025 08:38:26 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] UFS: Make TM command timeout configurable from host side
To: Seunghui Lee <sh043.lee@samsung.com>, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com,
 adrian.hunter@intel.com, storage.sec@samsung.com
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
 <20251106012654.4094-1-sh043.lee@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251106012654.4094-1-sh043.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/25 5:26 PM, Seunghui Lee wrote:
> Currently, UFS driver uses hardcoded TM_CMD_TIMEOUT (100ms) for all
> Task Management commands, which may not be optimal for different UFS
> devices and use cases.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

