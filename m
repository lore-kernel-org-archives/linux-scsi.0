Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822A21A2387
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2025 17:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757523788; cv=none; b=HHXeT1OA0ZMteBPGF7yLaL631xaa8J64AeX7PsfAinvlaa44IZxd+HL4XG/M/U3sLCXJQWaWhBJmi2yVYWRYnov9AqvU8Tofj5UDt7X47F14REVhcKboj2tInf7lVIWrdzmDsD7cIPpnkhESJ3CLTzBCK8qa9alpoOoO/mfWnJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757523788; c=relaxed/simple;
	bh=tkOEy4ynbrTz0b59q93xQGoyNjEtAgwsn/1aJZW52Nc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vA8azty+HUS0ZI6FSi5u+gmAZvLlpm/slw1xrQLJ94nhyqXoYWKbmHJuzE4qcHh7JK4Gs9hqikwHn04itKZYk87rvv0z1Rpvb7SSOykI8H6BvtT2QiF+mjfesWPqjRQrThSyTy2bFVr3KO0e8sb8TE+84ISCHhxil3uT0I1qxAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1JBCOqw5; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1JBCOqw5"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cMRpJ3bbszlgqTx;
	Wed, 10 Sep 2025 17:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757523782; x=1760115783; bh=tkOEy4ynbrTz0b59q93xQGoy
	NjEtAgwsn/1aJZW52Nc=; b=1JBCOqw5qXYtzWzCDx6enCECNUZ0joPZtkwrGJPv
	Gf+cU6FqsqlItgM8L65tpgl04iREfx6KENifvMaObUAGu3vNzwmFNCrp+EW7Y2iq
	I92Nam2/G06Dpi++ZS2FdpvAfiHB7zRsPRrEqi5MzzkEHvitHCqt7PM8lAZRAft+
	oXR3fqjHuNK76cvKzKRtjet9mF5ODdoOBi/zEMZ0yNdwC2Qd17Q125IdGfaYUJ1M
	ktQCg5SyflPaNdESikOrn2GDhpQOXDISvOhK+vp2YiZDuveRNjh2Ro7PV1SWT3Cu
	3TIrWqPZEhneiJHtfER41YaIFJTD9cIzRGf0O0UJVxlIQg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id s-sQurorENQQ; Wed, 10 Sep 2025 17:03:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cMRp66Sd1zlrnQ4;
	Wed, 10 Sep 2025 17:02:54 +0000 (UTC)
Message-ID: <7f1aaa29-1c19-4a20-9422-92eef5b7fb8a@acm.org>
Date: Wed, 10 Sep 2025 10:02:53 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Disable timestamp functionality if not
 supported
To: Avri Altman <Avri.Altman@sandisk.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Manish Pandey <quic_mapa@quicinc.com>,
 Manivannan Sadhasivam <mani@kernel.org>
References: <20250909190614.3531435-1-bvanassche@acm.org>
 <PH7PR16MB619691B9CD2CF4E2027016DCE50EA@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <PH7PR16MB619691B9CD2CF4E2027016DCE50EA@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/25 12:51 AM, Avri Altman wrote:
>> Some Kioxia UFS 4 devices do not support the qTimestamp attribute.
>> Set the UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT for these devices
>> such
>> that no error messages appear in the kernel log about failures to set
>> the qTimestamp attribute.
 >
> Meanwhile maybe you can use rtc instead.

How about leaving it to the device manufacturer (Kioxia in this case) to
improve support for UFS devices that are not fully compliant with the
UFS 4.0 specification? Anyway, thanks for the review.

Bart.
