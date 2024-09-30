Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F02B194096
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2024 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727717152; cv=none; b=p3Rlo+eLtLt38JLQVrPd3x1eWjeo1NHbqMaEvqj+klnvaduGwha6M1nbr+hvceKs9sWEGK4NllTuzEioLqoKY0QgGktbhNAL5IPHckNeU6ZWBChUpKu2dGoHwKepTibpSYtuE1w10LWZuLvR138Z2OkexAYF6GU4t9GDmEfKDuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727717152; c=relaxed/simple;
	bh=lOuGlJxswW8Gb6uaiyB0Rm9VJj1ZAt+Osgyk6mPioJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nFpnhKAcWePu4NmOd13Ama2Zq26uj7GXQCreQcpuMNHpMorjjDKPI2qzmwLFxkfYN2xEDgnSpal1FTdpDMzNyWDq0Y4UbZGVEIXuCr7nalfa994TwfP4O80OdIWvLOQ4Xe6jBVr+NljQunl+qAVGju6Q68yfvbALvyERfpWzQhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3ekG1f10; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3ekG1f10"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XHSdh03dcz6ClY9M;
	Mon, 30 Sep 2024 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727717142; x=1730309143; bh=5eCGGZdwJ3BU2QgJhKuxbTTX
	jM2f1qmKfmycIEYcugM=; b=3ekG1f103stt0Ueu5uOqRaxLsn4kXaLCvc0p6cpi
	Qq4WsY6sBbqthxtt7bzkVPqpwcZRvRh6lr/QZZzjhPmrg+DghvRjbf8A6UomopZ3
	v+bj4EszwQcIKqRPVfIy6M4czrHkLXPv8GQNj1LOSWlsVCmqFs3Qt8LtVi8WDyUL
	B45XCJFwqe/uPzpb0c5UxZUe96DfAxTlET4c6pad4YNxUqxsZ0Sucrvg2V4hN5Bh
	hliayannAwdXjl89yoRLTvXU0K0/1l4J5njfp9g5eqeFyFb2SRkMbirvxzGS4T+g
	uABdZ+oyoSoTRWFzaJdnhpu3cpEkPQzWwH1NgkMfSC0O8w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id J_HHsTHlfyBJ; Mon, 30 Sep 2024 17:25:42 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XHSdf3WKSz6CmLxY;
	Mon, 30 Sep 2024 17:25:42 +0000 (UTC)
Message-ID: <e934cba7-a4a3-4363-ab07-3b1a9350d9ad@acm.org>
Date: Mon, 30 Sep 2024 10:25:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/3] ufs: core: fix error handler process for MCQ abort
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20240925095546.19492-1-peter.wang@mediatek.com>
 <20240925095546.19492-3-peter.wang@mediatek.com>
 <949fb86d-6b61-4a1a-bc04-c05bb30522b9@acm.org>
 <4bc08986190aecb394f07997b2ad31e301567496.camel@mediatek.com>
 <108a707e-1118-42f4-8cc9-c1bda9fab451@acm.org>
 <134227055619610a781d5e46fb14e689f874b7d4.camel@mediatek.com>
 <c014f499-1a5d-4e3a-adc1-a95a38bbe2de@acm.org>
 <ad352469b3a1b6efd07506fba78c8f8f7f0295b0.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ad352469b3a1b6efd07506fba78c8f8f7f0295b0.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/29/24 11:45 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> I'm not quite sure what you mean. Are you suggesting that scsi_done()
> should not be called in the case of a SCSI Abort? This should be
> unrelated to OCS: ABORTED (MCQ), because in the case of OCS: INVALID
> (SDB), scsi_done() might also be called, and calling scsi_done()
> should
> not cause any issues. This is because it has already been aborted
> by the SCSI timeout, so the test bit(SCMD_STATE_COMPLETE) would
> directly return. Below is the call flow:
>=20
> scsi_done
>    scsi_done_internal
>      if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
>        return;

Hi Peter,

The purpose of the SCMD_STATE_COMPLETE bit is to prevent that the SCSI
core tries to abort a SCSI command concurrently with the SCSI LLD (UFS
driver in this case) calling scsi_done(). Making scsi_done() calls no-
ops while an .eh_abort_handler() implementation is in progress is an
undocumented side effect of this mechanism. But since it is unlikely
that this behavior will change in the SCSI core, I'm OK with relying on
this behavior.

ufshcd_abort_one() does not set the SCMD_STATE_COMPLETE bit before it
tries to abort a SCSI command. I think this is wrong because plenty of
code in ufshcd_try_to_abort_task() relies on the assumption that
scsi_done() is not called while that function is in progress. Do you
agree that SCMD_STATE_COMPLETE should be set by ufshcd_abort_one()
before it calls ufshcd_try_to_abort_task()? If this change is made, a
consequence is that the completion handler won't inform the SCSI core
anymore that abortion of a command by ufshcd_abort_one() has completed.
Hence, the cmd->result value won't matter anymore for commands aborted
by ufshcd_abort_one() and how ufshcd_transfer_rsp_status() translates
OCS_ABORTED won't matter anymore either.

Thanks,

Bart.
