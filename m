Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDA21B654C;
	Tue, 22 Oct 2024 16:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729615981; cv=none; b=knwc2QKWeMzwk6aLqy4s33EpL6kX0AJzRGzpx+kdnHQdETfR/Ev8tV1IrY7VHzWN8vbDqBQ8TKatIDuc/wtYTPDjQbhNm275C9R2jk3yWSpsXUPwsHnmQIjyr6EOa3fChxLLsn8z8nqhfJoBeEDGOybHSYCTZZDA6BM/aao9GLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729615981; c=relaxed/simple;
	bh=+pbl7QTuVmR5bfmDOQdUnagB7Gz+KbA/gbYnhuvWtkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XncGDLO9rES7UJIdeCaknGq5MHHvlqjNAC3oek1s7ycY+HFjp7IxM9Ai/6C6HHJ7bpahsWyhjOZR7ss8Ll6JL8uFGmRSfGVTUkFTRFBmQUQA8CRmHUhgdQ6bsZxG5r8jOJB6POpMrpTx4pqty4N3V0G0Mvvq0jnTAYck6vAR0GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PgYXvlMv; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PgYXvlMv"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XXysl04Bnz6ClY9G;
	Tue, 22 Oct 2024 16:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729615977; x=1732207978; bh=+pbl7QTuVmR5bfmDOQdUnagB
	7Gz+KbA/gbYnhuvWtkk=; b=PgYXvlMvyo0nb9fYmFUmoHbH1fNWHIE0Fysobr7g
	9mk7dZRejFtQFZpnlMUg6Px4eRLxKc1iiqj4RMQGoMiTCoDw1xudcdR/Dji0aABo
	QiCvN1FweeaiaXaM6fYdnaoYUpOWt3Y/kCop6dYCYX9P65O4DjBVFsnxN64cQNC9
	scQVTFkhnu6qW+wTUsTapWioAVR4xm0eKryGzDurJl9jgcY7gt9jGtb8anUhGV4+
	uhCR+sEdNhv4sfMIIdUOZMNzTyOKK5WSVaG/R7Yg8mV90fg4rY64GFRv25peZqcT
	esyL8r/+EzTxRyVCaJTzFKuDnty0oexVBnSBFUwZ3HRdOg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZQdIwHnze2qX; Tue, 22 Oct 2024 16:52:57 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XXysj1T7mz6ClY9C;
	Tue, 22 Oct 2024 16:52:57 +0000 (UTC)
Message-ID: <cc296443-0b9f-4125-b424-348887d2b858@acm.org>
Date: Tue, 22 Oct 2024 09:52:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Remove redundant host_lock calls
 around UTRLCLR.
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241022074319.512127-1-avri.altman@wdc.com>
 <20241022074319.512127-4-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241022074319.512127-4-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/24 12:43 AM, Avri Altman wrote:
> There is no need to serialize single read/write calls to the host
> controller registers. Remove the redundant host_lock calls that protect
> access to the request list cLear register: UTRLCLR.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

