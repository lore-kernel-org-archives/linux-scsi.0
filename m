Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997B4196D9C
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 15:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688900; cv=none; b=L+AZXHaJGrK2bYWa7OSYbVrHRvdqA+rJIaIo1d4d6klYiQMAfnNmzbdGRBJS60SC6DtOgRyrEu/WOLdmNzvYG2tqhbhfA6abvC+GKV7CRRgB12tAFv4RCJlT4wJaDSJklJiG1XZ4ZY50dU3mRk9bybzdPQvW2jGbldgTkBsUnHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688900; c=relaxed/simple;
	bh=h2Z+zun7URmqGTtqGHxLdDKelRvVlGMYMuttxfvRPSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dYwfOmtfh1tqyzq81lA3Pfzhml9446v3EaWj8BCVnceJ/VwgTgjsoO0F9MHcr8ehmzm0QDd3Kz6iuQL50fR8onvxay7WJNTTsPXP7VSgyObiVu2i5qRqaPSnll/DZGAU0ETZXJtjf8b+i5HcOsHxVYnIaauExBcDi8Fc7wzUK2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2/C2W/x5; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2/C2W/x5"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Vw7yh16LTzlgMVS;
	Thu,  6 Jun 2024 15:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717688890; x=1720280891; bh=h2Z+zun7URmqGTtqGHxLdDKe
	lRvVlGMYMuttxfvRPSA=; b=2/C2W/x5LdqZV9dr7ClwOLqmpzxyrVxyISLA6njJ
	n5qPjTwM5JJM0HJ38ozC24GyUuOURNYmPUuELYaN9bYsPDu2LQ9rUdhed/rXJBZi
	zMpNZTf8RCutKg/evd4D908Ljri6PsmR+N2rtyKoh/B5A63eBp9A1LsoXKqJ++jW
	Bn2G2ukyPUYYMZ3DlKBKU41RG67wv4p5b95Rk3geYfoqE3C5IkhudWwdvXYZLRsG
	Aw62fywSyuWyw7mOD07grMJBQqRUmFbStpMD++CZpS6V6DkwtDMRjx8cxvmqBM+h
	fLTDwpG0ID6TcLSO784gHCE6OXKW3MyRc96sYG9daPKBOA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mP-FBoiFpgEO; Thu,  6 Jun 2024 15:48:10 +0000 (UTC)
Received: from [172.20.24.239] (unknown [204.98.150.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Vw7yd6j5ZzlgMVQ;
	Thu,  6 Jun 2024 15:48:09 +0000 (UTC)
Message-ID: <03766042-bfa8-44bf-9684-44a912ad2c73@acm.org>
Date: Thu, 6 Jun 2024 09:48:08 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Disabe CDL by default
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc: Niklas Cassel <cassel@kernel.org>
References: <20240606054606.55624-1-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240606054606.55624-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/24 23:46, Damien Le Moal wrote:
> For scsi devices supporting the Command Duration Limits feature set, the
> user can enable/disable this feature use through the sysfs device
> attribute cdl_enable. This attribute modification triggers a call to
> scsi_cdl_enable() to enable and disable the feature for ATA devices and
> set the scsi device cdl_enable to the user provided bool value.

Do we really need to disable CDL by default? Has it been considered to
enable CDL by default if the Command Duration Limit mode pages that have
been defined in SPC-5 are supported?

Thanks,

Bart.
