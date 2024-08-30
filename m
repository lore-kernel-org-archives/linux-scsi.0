Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC5818E372
	for <linux-scsi@vger.kernel.org>; Fri, 30 Aug 2024 12:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725020149; cv=none; b=TuhCPqNOcK8H0gTXRyyjRS7ShoN6hahbdCertHpL7QgSJaCPaGSI0LlouOZlN84H3b+Ry1+NgFQAIkswYOz6qYzlTipVL/02mBQD1DnhyCJNiR2Uqltq3DU8u3uVrmIEyWdslUKLYHNATA5LhdGEJAn5n49SXOHEuzepzsMjBXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725020149; c=relaxed/simple;
	bh=g/gjJxWp/x3AdWljYAHwWMyOUfzoZr8FNtyiOzL56nY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iMzK43gI/tKbDcIgz3KpwP1svsmnHk5yLExnH/dyXzAPfJGxNIGoAOQmuKA4PZZmlFUStw6gcVe5EFrleaeSRCbdNadebh522h7blqp8HWmFPu+bIbvBGKd8VBK+610fMmI7SucCztslVCagcahCPKRBhFwV1dqdP+o7vDfpCyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Lo8xllsn; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Lo8xllsn"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WwHDD72kpzlgMVf;
	Fri, 30 Aug 2024 12:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725020140; x=1727612141; bh=g/gjJxWp/x3AdWljYAHwWMyO
	UfzoZr8FNtyiOzL56nY=; b=Lo8xllsngOQYSEn0+E0owNVpPia6PBBn2a8dorJS
	puJUUaTM6/MwTo2KqQIFiARcL0oyghz/hYg5zrv/JjxmV76xMIJAH4ti60D2n36L
	3u1tCGTes0o9j58CuQDf6f9LbwYvsq2CD0DfK+IXcJ/E8fF9jH26zTgw6TPaR9ef
	z9CrNmDgATC5ZfvFwcNOflE7aHL1vJMEaxh8pf93o9xBf4yhhMDBQbsYct03//Bp
	WpMoRnrV+usvmC8aflh+mECSjhDlC6T6qgdUFZ673eB0P66onpxmUk/bN1XWgrWt
	NhxQkNBEaaIKIxKt+M7CAxpImJEjE3c9BxK37Q3VvuQkOg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YLFWjpeMLcrY; Fri, 30 Aug 2024 12:15:40 +0000 (UTC)
Received: from [10.254.113.103] (unknown [207.164.135.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WwHDC1VMTzlgMVb;
	Fri, 30 Aug 2024 12:15:38 +0000 (UTC)
Message-ID: <9d6afca1-a874-4c38-af78-9aa57b13135b@acm.org>
Date: Fri, 30 Aug 2024 08:15:36 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] ufs: core: fix the issue of ICU failure
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org
Cc: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20240830074426.21968-1-peter.wang@mediatek.com>
 <20240830074426.21968-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240830074426.21968-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/30/24 3:44 AM, peter.wang@mediatek.com wrote:
> Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")

Bao, please help with reviewing this patch series.

Thanks,

Bart.

