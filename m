Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3532C23F296
	for <linux-scsi@vger.kernel.org>; Tue, 15 Apr 2025 20:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744748540; cv=none; b=AxnVBgIkQ80wHRALap12FWQz75wKLdvv9PY+80YNjEnD1NIAZnSpaefYTZyQ9UKpYKYJz682IPhuLtOsL2TpijoOzbI2BEkrW+DZpVofOC/8amXfvTn8QPMT2R4uTt5sH2hsFfV8+W2fWLNkYk5AgXwlzX1KMg6Vf72f0ccAnOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744748540; c=relaxed/simple;
	bh=R215ExsQbOy431UdApoQyvlg5GmopXIoWDZMHf21mWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P/gbjMpoQPQge1McurMiY7Ew8QndtfpNnVh4NcEDmV38kGK65CrXSj2Gbkd8XRw3GnTNsYv3ybDOUIYdLo37y04zDKImNEw9T1fmt5nz+t99HsbZzvDJV+R0Q7fKxg85Oui1R4+GI5EeD8tuha5HhxPC9h56P4Msu/GC1ZoCHXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=B1KOvMI3; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="B1KOvMI3"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZcbDV09Y5zm0yTm;
	Tue, 15 Apr 2025 20:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744748536; x=1747340537; bh=ekUE/fBviJM1rxdGoDEzm0qA
	r+Ezno7DYQ56TPGZvHw=; b=B1KOvMI3npE9tSqPyxHrOTUKa80jSXNKxOnWlTPk
	1rZN2QkYiPgchhI3sFTyXPuK1DEI8YJ9uDpfZ/4xEI4WwBcbB5uwtvx4s1BS/k0t
	ydzR0b6ZZ9MBg65XBJhsQ1DDE99/W1/orfaf41w0qAgRZoYqTdyEiD41KynxZTqu
	k8fW5tY3qLoHcjC9I9B0OZW3lzX0yeyosMx1Ub4BvZDSREBQoC25Jw/LuqokYSQp
	rsYGUarJRZLUNmjXH2RWs9k7yGKw0YoBUCs5L1mlbIHr/XeSZkLM3++lj170SdKR
	DsjR2PwF8dt2q9XCFC12mdqTlZ+cOwo9atzrYLJXXEnmtQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id C5PlzN_iNVEk; Tue, 15 Apr 2025 20:22:16 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZcbDM6rmJzm0yTN;
	Tue, 15 Apr 2025 20:22:10 +0000 (UTC)
Message-ID: <84d20bdc-fcd9-42e4-939f-a3ec0422e646@acm.org>
Date: Tue, 15 Apr 2025 13:22:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/24] scsi: ufs: core: Rework
 ufshcd_mcq_compl_pending_transfer()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-13-bvanassche@acm.org>
 <0390adb9d0ebed4ba4b386453d20175b1f3a0709.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0390adb9d0ebed4ba4b386453d20175b1f3a0709.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/15/25 1:00 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
>>  =C2=A0/**
>>  =C2=A0 * ufshcd_mcq_compl_pending_transfer - MCQ mode function. It is
>>  =C2=A0 * invoked from the error handler context or
>> ufshcd_host_reset_and_restore()
>> @@ -5665,38 +5703,10 @@ static int ufshcd_poll(struct Scsi_Host
>> *shost, unsigned int queue_num)
>>  =C2=A0static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *h=
ba,
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool force_compl)
>>  =C2=A0{
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ufs_hw_queue *hwq;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ufshcd_lrb *lrbp;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct scsi_cmnd *cmd;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long flags;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int tag;
>> -
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (tag =3D 0; tag < hba->nutrs=
; tag++) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 lrbp =3D &hba->lrb[tag];
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 cmd =3D lrbp->cmd;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (!ufshcd_cmd_inflight(cmd) ||
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 test_bit(SCMD_STATE_COMPLETE, &cm=
d->state))
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 continue;
>>
>=20
> Removing this check might cause racing issues?
> Leading to the possibility that the hwq in the subsequent function
> could be null?

Hi Peter,

The ufshcd_cmd_inflight() check has not been removed.
blk_mq_tagset_busy_iter() only calls the callback function that is=20
passed as second argument for requests that have been started. The
definition of ufshcd_cmd_inflight() is as follows:

bool ufshcd_cmd_inflight(struct scsi_cmnd *cmd)
{
	return cmd &&
	       blk_mq_rq_state(scsi_cmd_to_rq(cmd)) =3D=3D MQ_RQ_IN_FLIGHT;
}

 From the blk_mq_tagset_busy_iter() implementation:

	if (!(iter_data->flags & BT_TAG_ITER_STARTED) ||
	    blk_mq_request_started(rq))
		ret =3D iter_data->fn(rq, iter_data->data);

 From blk-mq.h:

static inline int blk_mq_request_started(struct request *rq)
{
	return blk_mq_rq_state(rq) !=3D MQ_RQ_IDLE;
}

In other words, if flag BT_TAG_ITER_STARTED has not been set,
blk_mq_tagset_busy_iter() only calls its callback function for requests
for which blk_mq_start_request() has been called and that have not yet
been freed.

Bart.
