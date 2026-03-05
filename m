Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6EC39E18E
	for <linux-scsi@vger.kernel.org>; Thu,  5 Mar 2026 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772713606; cv=none; b=Jui7hHOCcwe04x1Dwbodxq9S9gUkIvLMG2CW9Pet06sMOJdHX36prkgzugtQdBsOz165HZI5R5NIpjWKosO/w4ThhKe2h4nEdx8jUzAVpYPjVq2g+gbeKrcy9xB8cPLek2DrjXk21qZSqMQAlM1837EylssRBDt/odgsFfXuwOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772713606; c=relaxed/simple;
	bh=IIw4Oy+HPs+8aAazFDA28MQ4xZsBhfbBIfHPNIWK2po=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GcvGgr/rXARnd6M228FJgYiqPos++v8Dcgj95t3/fb82UzLvns2v0K3PctrkQJhnpDBvEV7tOVTmcc+htGP4+LciyQB9U4ASOUanl0vi+2FUd2hojfIj8Y5xEiTst9v842zADzESS8nHB1tbfGhl80XwXriXMyrBKEkIZvgoJa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SIzdnl/+; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SIzdnl/+"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fRTLD2yVhzlgqwD;
	Thu,  5 Mar 2026 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772713602; x=1775305603; bh=IZLcFikZRhJ6KIo67Bp3NX6h
	tpAt83paYK0VBOikk0s=; b=SIzdnl/+qEQqP0J3KLFNsWJEBmtTe4YxEty9FkhX
	LSxSPt0mEp4wiHlJmCHbqNfxzoVj36k+fG4NJz2iMWOYkyyTsZX7qHscZ6gAyz0A
	TNlksbD4S3jHHR9dNvi3IdfpTm3AlrtzN2KkjLCPF2L8HjMZn1UOxFSe5gF+2v19
	JmNQgleofFXfP/0EhITtUQFdohv3KlXVvbKRZRAZBLE4SBdchUi+8vDQ6qtJ/0QH
	OZP3m3ZaFXpoNuXitog+DuM3r0gqWm6Kq82SjMDc89YsalvSc4Q8bzePlFq0Ykix
	RxdespwZ7KYVNlxyL3OcLdNYbfWE5JBsuV4PXo+dsB64WQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id G0HnnpmXjK6C; Thu,  5 Mar 2026 12:26:42 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fRTL85C9bzlfdvh;
	Thu,  5 Mar 2026 12:26:40 +0000 (UTC)
Message-ID: <5f1a8fb4-37c1-40ad-aea7-b1cb6e07653c@acm.org>
Date: Thu, 5 Mar 2026 06:26:38 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/1] Add sysfs entries to facilitate UFS UniPro QoS
 monitoring
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
References: <20260305110856.959211-1-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260305110856.959211-1-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/26 5:08 AM, Can Guo wrote:
> v3 -> v4:
>    1. Updated 'Date' to March in Documentation/ABI/testing/sysfs-driver-ufs

Thanks for having updated the dates , but I don't think that anyone
cares if these dates are one month off :-)

Bart.
