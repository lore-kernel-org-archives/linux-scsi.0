Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0060F21265D
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 23:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728428449; cv=none; b=cilWWVELqew7uEad5gz7D6VfSyTQmuIOZk+/KjbaFJmt/MRoi8NxlEGLMJhGPrFNjpXbVgyUBDbd2OdECl+LaI9ixGJPrt+djCBcGYp6vQyUZJC+6RJqJ7ufLakCRplAeIrKQwkMCvRXArCl7pdD0oeHvH/+8LVuq1xl7znjW/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728428449; c=relaxed/simple;
	bh=4jrUAb3LP4p4t+ReHkDckDLvJFfc/3MwRk/QYaEPp6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gm2ZwCg35F7MooxZdwViWLPeZKWkehJGZLLSrI5lfHI1k0rIBf5CYlz6T13k3DqF8IEE7zNEIl9xBfwiUie8KomX0peBpElU/+nVyomfmai5XfAtVbRg18a1hylziK6uOMiZZcb75pHJ/tuDBSChdSZGcbhxdg0UhXmKDIxijc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mGh6NCR1; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mGh6NCR1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=vT29Ak/u0KJrqeNlVBCeCplP/uyIIDzGm+nCpo+64v8=; b=mGh6NCR1y0faiWuTSeiMl2WV06
	xb3V95lUdqIg1oFs7ECcCM7yFunRAkFU3lJR0AFSfLvKVzlqaJ++yeqUWLdu5Zo3BLj11tLlBzUxK
	8znFMykyxESSKfIHTpgrcPFSM3y0KX+QN+pOU52y8Bt/SJVVrR9bR2i/pOJzMJfmwgQ41W7NAfDDA
	5sF+Ecy8iehMUFtxSnWJsJAo9OfokDAx7NcmFUn7w8yeL9uKOl8L8Yqt5Cy+VUmGJO5T5ck2gIwNm
	vlBrLqc4J5q7bA1x01aZf1q08IA/U+zuUCGRU27TRI/IlHRpYsrs+hUTIxwjS427/+SEH8rWmQKSI
	cq8yHmoQ==;
Received: from [50.53.2.24] (helo=[192.168.254.17])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1syJC2-00000004k0w-2hQJ;
	Tue, 08 Oct 2024 23:00:39 +0000
Message-ID: <ba58a12b-9745-4fb0-8be0-199bd8827201@infradead.org>
Date: Tue, 8 Oct 2024 16:00:31 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: core: Rename .slave_alloc() and
 .slave_destroy() in the documentation
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>
References: <20241008205139.3743722-1-bvanassche@acm.org>
 <20241008205139.3743722-3-bvanassche@acm.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20241008205139.3743722-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/8/24 1:50 PM, Bart Van Assche wrote:
> Update the SCSI documentation such that it uses the new names for these
> methods.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  Documentation/scsi/scsi_mid_low_api.rst | 50 ++++++++++++-------------
>  1 file changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 2df29b92e196..1330cfb6eaaf 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst

Hi Bart,

It sure would be nice to know what changed between v2 and v3 of your patches
(or vN .. vN+1 any time).

thanks.

-- 
~Randy
