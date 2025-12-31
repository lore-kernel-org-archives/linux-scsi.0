Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD13327B343;
	Wed, 31 Dec 2025 16:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767198344; cv=none; b=Gm1Q30oz+CKPsYkC3mj5Q0G1z5wl4Meh1wY+RsY/rwnDszQDg++KDLNmJuJkyfmbU4+DgDqMHjV1vLG1j9zhSZNXxEoLdToiVISrZOywOe3Qdv+F2NjRPhPk0gE7ezgU57macdyZ9Esm4XZLzIHEI6J98gG+fvCZs3k7jCG249Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767198344; c=relaxed/simple;
	bh=/B7DGf2IwU7r6b5Oy1ifUc0S1ImAmp2a7YVHP3UY+38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aVMSRLhBvjddq2SggrMEQAHM6fnGhWqrOPyaOv/IZiacLM7xuUVQ8lx4g6IPAqHuATUKsGl/K4g+udR1fz9tUomIkvX9lPBgivzEajVtgHFSuRJu4aYeWobCvlJ7lUd51sh7S3+fVliz6VIQ/Ob/uhzgvccV9c10qL4KSQIG7Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=uUPX/JGE; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="uUPX/JGE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1767198334; x=1767803134; i=markus.elfring@web.de;
	bh=NNscqT6MqP/DHSOV4jotIi2mSwM64MdeFYNhy5AlnPk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=uUPX/JGEzn+nnnrvWLZ4m4+xbckFmq44Xb/0+wkHT6+dJYU0qXamFYIDEsRCI4xv
	 gip6N05YWB3adc2XrGT1XMc7fL3PM7CpHeLk54FhvPp8C4RoXKe4S4bxQ0xwaCvmK
	 C3hyqXdV1PYF7PJ5b8fwvRpSsKz8SkIwi50D6EEyt0mwuvnnGIt/z28fCANYCgNqU
	 VQg1jOMyEjnjd9+372BsX33HOEmT4Rs0Wx3PLDaSt6B4dEC8dW3GlZhZH2krrBAZM
	 SVwyrHvx1KCwKi0jnB/U6og7CfoHcY9ctzyUtK3e2lG06+FAXiUrkxvbROHxVQttN
	 6+OHrwAAUWqPd+VOEQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.230]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MActe-1vm0Yf3t9s-004Aa5; Wed, 31
 Dec 2025 17:25:33 +0100
Message-ID: <c8571456-7306-4ada-bccb-ba5bd38625eb@web.de>
Date: Wed, 31 Dec 2025 17:25:23 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: hpsa: Fix memory leak in
 hpsa_undo_allocations_after_kdump_soft_reset()
To: Jianhao Xu <jianhao.xu@seu.edu.cn>, Zilin Guan <zilin@seu.edu.cn>,
 linux-scsi@vger.kernel.org, storagedev@microchip.com,
 Don Brace <don.brace@microchip.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20251231145937.354593-1-zilin@seu.edu.cn>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251231145937.354593-1-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gwj0mhbuNgNcX68HtZIOJYBu2sO60QZ0G0DLT6rRcgu9RBGJfVh
 p1QvaIji88PL+qjI5KwQQ/QanN9sIOcyTNFwE/jTPT7egIWyB5WKlR91RoVJF4g5eknsIrR
 7Nx4vnejPaHnXMbRvRWyAcKb2IAXU/sDC1foPZCh5zQG1OiR6a2k0WvD3eXyaftjaogXZlX
 16ds+DaWQ7zuxk9ksTOEA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:lz3Co4vpIRM=;XNjqw2JqHRuk7WL+9ezGma4QHyl
 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

=E2=80=A6
> +++ b/drivers/scsi/hpsa.c
> @@ -8212,6 +8212,7 @@ static void hpsa_undo_allocations_after_kdump_soft=
_reset(struct ctlr_info *h)
>  		h->monitor_ctlr_wq =3D NULL;
>  	}
> =20
> +	kfree(h->reply_map);		/* init_one 1 */
>  	kfree(h);				/* init_one 1 */
>  }

I wonder about the alignment and relevance for these code comments.

Regards,
Markus
