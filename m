Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C584F9F5
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2024 18:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718042907; cv=none; b=QehfFBLdTQLg9djeZCeZ/UIW3uEmKZt9v763fBq3FPv97IX62OSFLZI++1xvquJJQzenIOiDRcaKAdRIAZ+7PWHGs5rGE9lsT5lzDzny1bux0/njZlXpcSb55+O7j1NuK++bh+h19R1VY034660fnjVYGFwv5Ny97BvhDQiZ/iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718042907; c=relaxed/simple;
	bh=6f2BIsGgV1Qx9URYG0TdIvT6+xbx6I13xbTSA5YsIcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HZAdTaAWiuq1Qm64Z584F4tmTdmtISc3q1qYcWMtIYgAOtz5mnxS4IaLJWUrc6AzqHqVXYWowcBgGLXH6vOdI/H1vW6Ly6zHhtFYIldDwjZQ80H0IoeGhpcVUfEtt63hG1ELRNkzhV7DadwTNp/O9dU6nWQbkwY3DdgCeCrQM6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AjXKu9La; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AjXKu9La"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VyftW53rrzlgMVN;
	Mon, 10 Jun 2024 18:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718042897; x=1720634898; bh=ag00UAezSyua9u8oWHpfYabC
	YqCuf7aTQffBXkNssmY=; b=AjXKu9LabqU2lO4U2g4zJx3882ROT1hoCKbHkfCl
	N3Ybf32xuBIGfO1pAD2DY6vZqBiFqIY63RQTf4rLXFAnK9twurtM9wTlHIiO3MnQ
	zPfG3jwndeQ7cR3AosA+hZwxbiv9oZe2QKpq6nxSDu0k3dctrjU0WO8Syrv2W+Gy
	+Ak0i+GagZDUO7Skx9y5XDsL9GHplTfg4Cd7YMN7iWpZcMBiXWSp7/rxIfpojahO
	RdrNLCyzbhGBn1Pbo82tiRdEgwEK0phDIugmzAIXgDF1CJnwcHSujmGmPuxL0Spz
	YPvtSbcgU5ASYL7eGL+jcvfay5OZDbV9BlBp7Wrd1da25g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qQZ-W5kkz-jg; Mon, 10 Jun 2024 18:08:17 +0000 (UTC)
Received: from [172.16.0.221] (unknown [50.205.20.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VyftT1rQLzlgMVP;
	Mon, 10 Jun 2024 18:08:17 +0000 (UTC)
Message-ID: <8dff4945-97fb-4ab7-8e7d-065e9755a3f0@acm.org>
Date: Mon, 10 Jun 2024 11:08:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Remove an incorrect comment
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Avri Altman <Avri.Altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
References: <20240607213553.1743087-1-bvanassche@acm.org>
 <ZmPrGSJvofIjA2fb@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZmPrGSJvofIjA2fb@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/24 22:24, Christoph Hellwig wrote:
> On Fri, Jun 07, 2024 at 02:35:53PM -0700, Bart Van Assche wrote:
>> The comment that scsi_static_device_list would go away was added more than
>> 18 years ago. Today, that list is still there and 84 additional entries have
>> been added. This shows that the comment is incorrect. Hence remove that
>> comment.
> 
> I agree that the comment as-is is bogus.  But it would be good to state
> that quirks should go into the LLDs if they aren't for devices on a
> physical bus like SAS, Fibre Channel or parallel SCSI.  Most quirks
> theses days are for unusually buggy consumer devices like UFS or
> usb-storage/uas and are better placed there instead of in the core
> scsi code.

How about changing the comment above scsi_static_device_list[] into this?

/*
  * scsi_static_device_list: list of devices that require settings that differ
  * from the default, includes black-listed (broken) devices. The entries here
  * are added to the tail of scsi_dev_info_list via scsi_dev_info_list_init.
  *
  * If possible, set the BLIST_* flags from inside the SCSI LLD rather than
  * adding an entry to this list.
  */

Thanks,

Bart.
