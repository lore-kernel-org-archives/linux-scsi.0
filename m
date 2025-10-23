Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2FB26E6EB
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 16:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236399; cv=none; b=fBXIM9NEof5gvuQGq9W6q164DDSSUMARODmnHEFL0swmrQra23k3A1iAmNHKQkFq/RMyjKi7RPTmrlyzosRPLh6AOLC1RdQKjLrjKh+CGKoscYPQmpJ4jbxPoBfUqkGPadfbJTZ1oRSiD1s7y5MymWcWoJ5VQDSnu25cPKX1xpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236399; c=relaxed/simple;
	bh=ghqzIceY08cLqozG690fz0FQ6STGdHInr+gytHYV3DA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SdoUNbdebB5uxrTMVCLFtKavYwC/nvW/xWstGAE3SQ1AxP6DjRx5K4O2EFK8+NXovm3w5AOSLQ5J7VcMINJCgbB13EGuI7aL1BpnX5TMl1kngqRl1oyUNsh+Rb7Nn+nIOGJq+J2gTDHKfuG2jCazQm18Za+x7680QKUo4pKH16A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hz4ptgj0; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hz4ptgj0"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4csrpb36SDzlgqVJ;
	Thu, 23 Oct 2025 16:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761236390; x=1763828391; bh=ghqzIceY08cLqozG690fz0FQ
	6STGdHInr+gytHYV3DA=; b=hz4ptgj0BBp7m7WwLwXNxTjHnn2wt7pFnPAj7Th4
	ZaYQCeMokYU0GNmXbC773OeTDgDCLhVew3Sxv0BJollPkXpnjF3mADRu/iirQMTv
	fihoAE3eHTD8adZGJmbjS1A1mbM0n1zKK326GcsXfyXNXIJ0Y8H4VFN+W3ZzGtWH
	0q/E+xjyKjp6JbFJlH0Ky/OIeO37zeEfzxryLG/fcCYsgbRPfMJOkK/cds6YL+WY
	YIIEiuj0UiCtNOhqzHVORjEG3qxxRXYNPb3WFr7TzCO9FFzN5uoXdMYFptRzvGPv
	ODfDVciu0bH5DYXAnLmES3WfcYfPXm3Xj+ipVd0iVKex5Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 90NFhb9YwhTO; Thu, 23 Oct 2025 16:19:50 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4csrpW70xNzlgqVH;
	Thu, 23 Oct 2025 16:19:47 +0000 (UTC)
Message-ID: <d15d527d-1cd4-4fb4-9b98-0bae9a723f23@acm.org>
Date: Thu, 23 Oct 2025 09:19:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/28] scsi_debug: Abort SCSI commands via an internal
 command
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251014201707.3396650-1-bvanassche@acm.org>
 <20251014201707.3396650-8-bvanassche@acm.org>
 <0507fd03-b3b0-436e-9f5f-72f7a02484bb@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0507fd03-b3b0-436e-9f5f-72f7a02484bb@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/22/25 1:46 AM, John Garry wrote:
> Apart from some small comments,
>=20
> Reviewed-by: John Garry <john.g.garry@oracle.com>

Thanks!

>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scoped_guard(spinlock_irqs=
ave, &to_be_aborted_sdsc->lock)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
s =3D scsi_debug_stop_cmnd(to_be_aborted_scmd);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (res)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr=
_info("%s: aborted command with tag %#x\n",
>=20
> I think that it is better to print in decimal
>=20
> Or, if using hex, use 0x prefix

%#x causes printk() to emit a "0x" prefix. See also the SPECIAL flag and
the spec_flag() function in lib/vsnprintf.c. Anyway, I will change the
output format to decimal.

Bart.
