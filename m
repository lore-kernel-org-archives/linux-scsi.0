Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9259C219A7A
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 13:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761659200; cv=none; b=W1r9I1vBpymZpcukAfE6Mz2WW78XEfEPPAEMuWGAJWbk/K5ZLGHoA2mWPIQ1LNwJF47hPqDJ+bfc4/hTho2x90gjPpsMgomGWm9ibQprrfeAxKbCKB+tE33wuWfWxXOaUNYwwklKTWYZC6/f9jiWQYljBZNjqdBoC3psCvWjBvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761659200; c=relaxed/simple;
	bh=NJztJ8aXc/Cp07g4Z+D3SUPAYRe9i1027WDFXojnTsU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S9ynsNTx4oF1us9qZ/nJfneGGfv6cJ2s5PusJL6aKVNaowWGbdvFDvvuXN1u/8jcJsxUYutj1e/v8jhK7GgT3yMBIgXj3pvwuTvREB+Ta4WtJbHomuRQQlJtK02C+AFCpMLJhtfz6deAUzl0XYeUQd1eRZMDJCUfRuMbhWWVSzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mYLeIr3n; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mYLeIr3n"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cws9T2gppzlgqym;
	Tue, 28 Oct 2025 13:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761659195; x=1764251196; bh=NJztJ8aXc/Cp07g4Z+D3SUPA
	YRe9i1027WDFXojnTsU=; b=mYLeIr3nLCL9qghVBLuOTF8Wjjsmost0+tmyP6J6
	H6y+SCVhgem+aJigs5EfaAs+rYy1UoRLNDRFKb3Gi0/rBCeqdA7dgq7BwVrA5iiD
	HOEgpCNGn6AAqdtnaK9TKcbenD7PaTC5wX4O/VPg9WsUBtDlyBhaJ0+fv551TxRH
	0bR484+O8AibDP3GIAydYp/u2NE8h7b4Pl/xeyK2zg15d3aRLj9/sjiHqwgZdaDZ
	F0T/2kxYY48LMLUA3373KLQ7zML2u8sbp0zSon8Q4fZcw9Xkx0vQGWo6tohdxYjT
	fvXDImYkb1VSRepMKBgV9VtRRTqOsprfLoGI3OGb00WFww==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LBvTyGwl2xhY; Tue, 28 Oct 2025 13:46:35 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cws9F3HVBzlvhyY;
	Tue, 28 Oct 2025 13:46:24 +0000 (UTC)
Message-ID: <37a7d14c-5e6f-4fb4-a850-af3ca322ae99@acm.org>
Date: Tue, 28 Oct 2025 06:46:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Fix the UFSHCD_QUIRK_MCQ_BROKEN_RTC
 implementation
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "chenyuan0y@gmail.com" <chenyuan0y@gmail.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "ping.gao@samsung.com" <ping.gao@samsung.com>,
 "mani@kernel.org" <mani@kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20251027154437.2394817-1-bvanassche@acm.org>
 <dae8ac46abd89f4d48e649cee0a6b301504bcdac.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <dae8ac46abd89f4d48e649cee0a6b301504bcdac.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/28/25 6:05 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Mon, 2025-10-27 at 08:44 -0700, Bart Van Assche wrote:
>> ufshcd_mcq_sq_cleanup() must return 0 if the command with tag
>> 'task_tag'
>> is no longer in a submission queue. Check whether or not a command is
>> still pending by calling ufshcd_mcq_sqe_search().
>=20
> Hi Bart,
>=20
> What if the tag is not in the submission queue, but the
> completion queue is still waiting for the tag's response?
> If we return 0, it may cause ufshcd_abort to think it
> succeeded, even though the tag is still in an error state?

ufshcd_mcq_sqe_search() only searches the submission queue. Examining
completion queues is not something ufshcd_mcq_sqe_search() must do.

The UFSHCI driver is based on the assumption that the UFSHCI controller
works correctly and hence passes completions quickly to the host. The
SCSI core only tries to abort a SCSI command after the SCSI timeout has
expired. The smallest SCSI timeout that can be configured is one second.
This is several orders of magnitude larger than the typical time for
passing a completion from the UFSHCI to the host. Hence, I think it is
very unlikely that a completion is present in the host controller and
has not yet reached the host by the time the SCSI core aborts a SCSI
command.

Bart.
