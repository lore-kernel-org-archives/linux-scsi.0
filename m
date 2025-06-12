Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0613E2F4317
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 15:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749743758; cv=none; b=dcA9GIbAwKrlkTC7aQns8XC77Pqg1aE2G5pbhopLBTrbqgUq7Uj/RoNNME7yek3LL2xuwUBximlTCuhBtN+uNIjGiyIcBejMo8bxEzm6Tk+ibKd+JmznBQNy0RJf0ebNfFiAsO09LUZy6V6HVAo1/XI+KLMjj+kP2lK0GobyFXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749743758; c=relaxed/simple;
	bh=H+OIjNv5bB8O5Vx+hhxxv2o4PFifDbe0NsnL2FJgrwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mcD7PgdWRHf5veBPCfHa8yaedG+Mv6Ux8+A1Lvpm4YSbq+aJXm/t3VaurR0tgc2ew8sUL2XTYomIA7ylhtdIFZU0eyvFEP2NYrMUCAqkkvDJ7046grQrjZW2Fxlb+DshAMDYz20ZQ5Wk12tINAWhcoA0DP6FANjxBPp5ppgbem8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mxL+TUCj; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mxL+TUCj"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bJ6ZG5h5tzlgqVQ;
	Thu, 12 Jun 2025 15:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1749743749; x=1752335750; bh=mGTxq2EJmWRVAGkLL6fwWZml
	z7YieFeOCjV7EinfXS4=; b=mxL+TUCjpjBZijGSI6tLFRpZ6O2ZwBIsTQWGNYlJ
	OglcT4O3oZtY4zoJmkk5Ifumh5vDefHB1S54kZ0DI2rcdnwxOQ//bo5QPPPVurQZ
	Qq4CpGOdba/3aMw2BIw6wU7FcgaZTNHbCcqoSSMxMAv0hgO2/qe2Tk65JQyjJXfk
	6xU+D0/Hp1wKGO2QL1DgMOyXVWQbeFR+A6t2cVUu7JrJZl0Qhu4I9nEYrpzgo1bz
	vl63snoHOVWdAwj+55OMVwCtWstFIyuaRLdsRF12N/48E8VyMhGEvvZiWrUQ6xMW
	dtWuftFVlNmGuNbFujOsD8eKZbdoMKNmLtGH+8CwjNLTZg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TYMzZUtH4XtS; Thu, 12 Jun 2025 15:55:49 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bJ6ZC6rY0zlgqVN;
	Thu, 12 Jun 2025 15:55:46 +0000 (UTC)
Message-ID: <a1f8c56b-3cf4-49db-952b-49a6586bce9b@acm.org>
Date: Thu, 12 Jun 2025 08:55:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] scsi: sd: Set a default optimal IO size if one is
 not defined
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250612060211.1970933-1-dlemoal@kernel.org>
 <20250612060211.1970933-3-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250612060211.1970933-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 11:02 PM, Damien Le Moal wrote:
> Introduce the helper function sd_set_io_opt() to set a disk io_opt
> limit. This new way of setting this limit falls back to using the
> max_sectors limit if the host does not define an optimal sector limit
> and the device did not indicate an optimal transfer size (e.g. as is
> the case for ATA devices). io_opt calculation is done using a local
> 64-bits variable to avoid overflows. The final value is clamped to
> UINT_MAX aligned down to the device physical block size.
> 
> This fallback io_opt limit avoids setting up the disk with a zero
> io_opt limit, which result in the rather small 128 KB read_ahead_kb
> attribute. The larger read_ahead_kb value set with the default non-zero
> io_opt limit significantly improves buffered read performance with file
> systems without any intervention from the user.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
