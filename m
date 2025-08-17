Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CD01DC9B1;
	Sun, 17 Aug 2025 09:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755422664; cv=none; b=ip3dREqhfE+OGzq4bWeBfyS44ue6/ZCHXmV/pNtF9hbpBgJ2pEeivmM7RVUhb/ZCzs966nWw9Xky3XNKNE9zl5oy33Qu0HT/WloE5+2xh+BA86IES1QHAs77OJeIbzPDAwX4LsuwgTw5Py8kU+C2auOICd9VAz7TW+gLJ+puPIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755422664; c=relaxed/simple;
	bh=bxGUxaFfcYllTCVPZ3iDWbg4M2a91UvbTyepv6B4fzA=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=poFPHoS7x6Pkq52BtyLCZhgaUxI1dcBjH2nVpgZ4T7eqiWu0rRCkNIKqZxPmg9UAkdIbRRGAQkRLQus1TUQpH2zvynhRz5OlGf0VajQD7Wr737p834xF3XdghfX2GtK8VW2yrR+iupVZ8H0VJUExECOtjrtWHc2YZqbNjDDxSic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=LWVO90LM; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="LWVO90LM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1755422301; x=1756027101; i=markus.elfring@web.de;
	bh=phJAi5yjyixKIANJKU0GjrdKrH5OHCZRY69wWVi+aLk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=LWVO90LM0judP68GlymvGHBRqNNIDpF7t0zUWb9UMPtaYbi5XfkGaBe3/6leDE0d
	 tBl2/opqKl5tLu1ukBSJgeqqjAeHfi2E2fhIGGg2s2ai3mudkQgLVDb/duzhuwOLE
	 1ljv2mucWsWBOSbLYP8ktOP/l8+R+a4dk9p3SGNq2zM6Vn4v9nUviq4zQq1Eu/1cy
	 dvM+IQqsE+4ufgB4XUp79gOZjbf3ZfD1ExgNXFMsviITomdcq6SdAiOopeGsNz7L7
	 SP3NBIKnFXvDuW1gMiBKVAOtvpJunleCrXG5811oACCFPvpevyuDZuXMPnaDfSfb1
	 BHvk0NZ3JMTbSZK2aA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.231]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MRk0k-1uzDIk3vly-00VWrt; Sun, 17
 Aug 2025 11:18:21 +0200
Message-ID: <039c1b2d-a241-47d9-bb3b-b0d3a822d69f@web.de>
Date: Sun, 17 Aug 2025 11:18:08 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: JiangJianJun <jiangjianjun3@h-partners.com>,
 Wenchao Hao <haowenchao2@huawei.com>, linux-scsi@vger.kernel.org,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Bart Van Assche
 <bvanassche@acm.org>, Bo Wu <wubo40@huawei.com>,
 Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>,
 hewenliang4@huawei.com, John Garry <john.g.garry@oracle.com>,
 Mike Christie <michael.christie@oracle.com>,
 Wenchao Hao <haowenchao22@gmail.com>, wuyifeng10@huawei.com,
 yangxingui@h-partners.com, yangyun50@huawei.com
References: <20250816112417.3581253-9-jiangjianjun3@huawei.com>
Subject: Re: [PATCH 08/14] scsi: scsi_error: Add a general LUN based error
 handler
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250816112417.3581253-9-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nO6v1zAx0rRc1rMWiAlOMVbTI+z1RRVykZaWGLQjsUa6Ce7YCZW
 LOc51W0sxUX77DoErwiLfxt+gDPxIRHim4LYRE5jXz83fUUwsUQzaMKHEGa5XH7rjmiAXAx
 ZlOQBE3kw7IkV7Cdxt+uyFi2vOFocwj1bByBts7DOHnR9jlaFbdND46CwIAR5OSvciOHefM
 B6A1d+ys1Sj7o9NBhfbAw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:XdBVCfVG/YI=;67VhSx6v/l1qGXNW3rxg8uSHH5G
 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
 TLkz44s=

=E2=80=A6
> +++ b/drivers/scsi/scsi_error.c
> @@ -2804,3 +2804,182 @@ bool scsi_get_sense_info_fld(const u8 *sense_buf=
fer, int sb_len,
=E2=80=A6
> +static void sdev_eh_add_cmnd(struct scsi_cmnd *scmd)
> +{
=E2=80=A6
> +	spin_lock_irqsave(&luneh->eh_lock, flags);
> +	list_add_tail(&scmd->eh_entry, &luneh->eh_cmd_q);
> +	luneh->eh_num++;
> +	spin_unlock_irqrestore(&luneh->eh_lock, flags);
> +}
=E2=80=A6

Under which circumstances would you become interested to apply a statement
like =E2=80=9Cguard(spinlock_irqsave)(&luneh->eh_lock);=E2=80=9D?
https://elixir.bootlin.com/linux/v6.17-rc1/source/include/linux/spinlock.h=
#L585-L588

Regards,
Markus
