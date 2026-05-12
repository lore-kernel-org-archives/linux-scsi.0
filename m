Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A743A9623;
	Tue, 12 May 2026 20:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778616232; cv=none; b=lbV2omdOLKhs+2kq5QsE8ycd6frVPsSQtrIh9lkzYQqvnMmhLNTleJIV+tV2cRsA/DeU532zTxgm+UOCXlp5w1wn4zSkmvTz0L7571Qow94BAEWcbr/of3JRJ2TuaoAFF1upRAH2WZODse6/PpJX7B/nSl+HMwdWrqHX9b9tGXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778616232; c=relaxed/simple;
	bh=NZX5DnCOoIXZDvuD63idUoQUn01me/whw4xM3wB3370=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qBg75R4j5bUx4YNRwRRAwNpDqklU9++oz00lV6nE9nrSfe2L8+686wiHDAjCDEehf5Oo1f86KVN9HtMrf9AEMNl1Hl8UlbHioFLjWQI3kQ7mIJ2wPLb4zh6NwxILptYEfpDNIc0e7Nfg76gclymiGAxhoScqMyv6QP9/tVV9yfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gSV/AALP; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gSV/AALP"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gFSGF2Yq4z1XM5kD;
	Tue, 12 May 2026 20:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1778616224; x=1781208225; bh=F/BJAXVayTzFF+XZtt71lRE/
	BiWXgEbcbp0uVwE1oWk=; b=gSV/AALP6al23rCpX0/d9Dmdz8DKue1HTr9Jrmjp
	m3Pb8LYeSeXS2t4Z31DyO0FVLqrSa0/3wAKePMU2Y2u3T/gDa9pQgNZUnIIRlGaj
	tEZrI1k02NsZJfhxACabo78k3lD7/YSCUi0LFWfKHMEBXMVC+bhxoZlWq1STJABB
	8UIW1zIdmpUQvjK12eycy+acY3/IE3zgigd7HlY3+xej1LEpcDEUGOMcIilwpnPV
	6ke2bLDQv0Dq003RAW0dXJxLmJwjF+EiSD8RAyuQFmHXkhgFghMSp4XjUq1mGpuK
	aatuSt/w2h4Lwec12NUIHMXX21OeAnhq7W82Nl3nOEQwGA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FUNZUoeXEFm8; Tue, 12 May 2026 20:03:44 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gFSG50LvJz1XM5jn;
	Tue, 12 May 2026 20:03:40 +0000 (UTC)
Message-ID: <691169b9-9602-4443-976f-4a46d7b07e3f@acm.org>
Date: Tue, 12 May 2026 13:03:39 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ufs: tc-dwc-g210-pci: Simplify initialization of
 pci_device_id array
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?=
 <u.kleine-koenig@baylibre.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
 Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 Can Guo <can.guo@oss.qualcomm.com>, Archana Patni <archana.patni@intel.com>,
 Markus Schneider-Pargmann <msp@baylibre.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1777968942.git.u.kleine-koenig@baylibre.com>
 <ff015bf46ad395702f40c85c8359fd24957e7224.1777968942.git.u.kleine-koenig@baylibre.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ff015bf46ad395702f40c85c8359fd24957e7224.1777968942.git.u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/5/26 1:28 AM, Uwe Kleine-K=C3=B6nig (The Capable Hub) wrote:
> A list initializer is hard to parse for a human if they don't see or kn=
ow
> the order of the members of struct pci_devcie_id. So use the PCI_VDEVIC=
E
> macro which is much more ideomatic and skip assigning explicit zeros.
                            ^^^^^^^^^
                            idiomatic

Otherwise this patch looks good to me.

Thanks,

Bart.
