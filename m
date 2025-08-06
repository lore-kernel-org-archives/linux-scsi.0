Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19307218AAB;
	Wed,  6 Aug 2025 15:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754493649; cv=none; b=tXkfJE/IgzdYZ40Ij/0HWHqQ//fnD0hMCN6o+wB2IEHHJgiOKw7ivlgWA/1eIMeU6eDEPLuBxhBe4XHKNVcxa2fOBZlgAvh2qTbal5LMqt77bz4hyS8Ze9EqRdvOkxIGbu7bI1JEvBGU26kyrt5/LSiTgabjqvCAcZKy/CpuLvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754493649; c=relaxed/simple;
	bh=XGQJb4LU654T55f4PGiolkbAuas2zj6x5h5p9HkoeM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=G3+qBgyKv6/fWJmtsVNWsyAIg14z9sxzvJdrml4qJN1HUlpNT0mS0ADHsJb5uIc9cVG9t0nnx2esUs5do6BaU0RXsvq6HMwGxhssyZowDR7khEzW/Tn3reuYQPcAjolGE5LZshG3nrt9mw5DPPYoIELe4ymuoTm+FsaWEpdg9dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=alU79TDB; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="alU79TDB"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bxvBQ6qSwzlgqxq;
	Wed,  6 Aug 2025 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1754493645; x=1757085646; bh=XGQJb4LU654T55f4PGiolkbA
	uas2zj6x5h5p9HkoeM8=; b=alU79TDB0IBqhtzlBLcut7X9seQVgixdKj+3Jkv/
	9B9rnsvGXy1aAdLuyN+CpTC1UCf99O+rMTJ3pGd9Ws39tBPUcqViTOJbuVU+mROz
	d5ATQPhXvpbvtDzBD6j7XXJh71wJWcrGf1K+d65RrrtB+tKznxoue1xDn4G+XrOg
	v2un0lTEvOjRGqYz/pKJNYyKQFKJLBCYsaof8uRCZXsN6N04KOWp4hx7kHlXja09
	AM3UEqAhA+O5wi3UXxSRv1KqzaRaarkJ8D479JBkBESJNMswEs5/CbUlt2aCSzvd
	U0Bj4arBYedt+8dsVopBrwtyuH5x7bbzB2eASfmQPMEb5g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dCEeOApnnWAy; Wed,  6 Aug 2025 15:20:45 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bxvBL0WXgzlgqTp;
	Wed,  6 Aug 2025 15:20:40 +0000 (UTC)
Message-ID: <331d2dcc-3c1b-4bb7-8fbc-4e7bff26cea2@acm.org>
Date: Wed, 6 Aug 2025 08:20:39 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] scsi: scsi_debug: use vcalloc to simplify code
To: Qianfeng Rong <rongqianfeng@vivo.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20250806124633.383426-1-rongqianfeng@vivo.com>
 <20250806124633.383426-3-rongqianfeng@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250806124633.383426-3-rongqianfeng@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/6/25 5:46 AM, Qianfeng Rong wrote:
> Use vcalloc() instead of vmalloc() followed by bitmap_zero() to simplify
> the function sdebug_add_store().
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
