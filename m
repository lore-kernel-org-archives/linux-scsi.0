Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C75253F0E
	for <linux-scsi@vger.kernel.org>; Mon,  7 Apr 2025 19:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744052543; cv=none; b=P8s47lbvqAAVVrWdRHySUL0IfzK0GB1Wu9uOnQo9RqDA99toBuzqlf+DWj/6J0D4Ubri5o/h1AUzGkIvMhGSEZUiKzjXE0V57oqX3LpJQC86YsIa1Ug2moIDz3MqfZg2jtN6vl5scz7JwadQmxrktMSfPrAoRoaI7y/CzyA247Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744052543; c=relaxed/simple;
	bh=5p46mHbHYbgNmEFKQBrcT25druIMYBXTDi09U3Z07wM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=YoLOyUlZyLdZMK7VAtH+6RAMOQec4bJogurbMvd4cfzR/HThQ23lYJwRPOrMTK7ivlBD1s3P7nbU2v1wtYmRSAKK0XE8yB02tNm/Eiy7C2pPK5reZsBaLYJPMcArPDJRJZJ5lcUzR0IdV6WLsVZOtyKF8ZximT0Q/rjVkkDN2n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OMDR6KzA; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OMDR6KzA"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744052529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r9jGo2/h5oGHCzMdIv7e/mxRijM3ED9bWZOjvtDk/LE=;
	b=OMDR6KzAJpkeYOUOHNpIvfuRhmA+gZRzFJJ86oErTUJpx9c1RAxEXETBzDPmlKJo588BbS
	D6nUY33RWvQG37dUmhJuSC1KGUQCpeT6yzgIYmdOlornAJc1lEbXzbcHLbZAxl07GEZ5PY
	3wFRaCCA2Od07P4M2ScI7Ddxx5M2fV0=
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.2\))
Subject: Re: [PATCH] scsi: elx: sli4: Replace deprecated strncpy() with
 strscpy()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <202504071126.37117C5D@keescook>
Date: Mon, 7 Apr 2025 21:01:53 +0200
Cc: James Smart <james.smart@broadcom.com>,
 Ram Vegesna <ram.vegesna@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-hardening@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <67E5FE26-F258-4690-A466-236A7E7484E8@linux.dev>
References: <20250226185531.1092-2-thorsten.blum@linux.dev>
 <202504071126.37117C5D@keescook>
To: Kees Cook <kees@kernel.org>
X-Migadu-Flow: FLOW_OUT

On 7. Apr 2025, at 20:28, Kees Cook wrote:
> On Wed, Feb 26, 2025 at 07:55:26PM +0100, Thorsten Blum wrote:
>> strncpy() is deprecated for NUL-terminated destination buffers; use
>> strscpy() instead.
>> 
>> Compile-tested only.
>> 
>> Link: https://github.com/KSPP/linux/issues/90
>> Cc: linux-hardening@vger.kernel.org
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
> 
> Standard question for these kinds of conversions: Why is it safe that
> this is not NUL padded? I haven't found where this buffer is being
> zeroed out, but it probably is (given the "- 1" on the length), but
> without run-time testing, this needs much more careful analysis.

I think this was submitted before I started to explain this better.

'wr_obj' is the zeroed out 'buf' returned from sli_config_cmd_init().

I'll update the description and submit a v2.

Thanks,
Thorsten

