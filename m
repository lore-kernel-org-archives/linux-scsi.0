Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C0133C9
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 18:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727375207; cv=none; b=DO7FwWk6EUzQ+mV503waPG2DzVJgo/TpSuUXJ2HOjZT1jbnTZbHhdkPnMxEv+resDUGsRW3ARoeS+3L1ufMr9kQ5a3+OEXkE6QRt6zYa3AUb9OEwh6RZU8am2mMcJj9Tbuwko2Bv4oi1BxdRjAfXgK1jI7euMtFhpJERZMsZ8sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727375207; c=relaxed/simple;
	bh=lSVjMSM3vzbu8AlMBHl7m6Hreu1xW5P//e3ZxicIWh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RXTpTwMQvv1Sewy35UCufZ3j2HYcvYosRkFd0ElPuM3kpS1pWQhMnQzd/MJtrgzWUiYwOoNUzNMOmFAveLG9j+p8Ordmw00P4QEs1tnU1iLZWLY8cmF2xcDDQ5SK9ZjlpCLYOh6dqUdjYUlaWHxXv9K6HfSjeuLLMC0U7yv8JCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dsLzhYiM; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dsLzhYiM"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XF29q24MZzlgVnN;
	Thu, 26 Sep 2024 18:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727375189; x=1729967190; bh=OYklb0bp4yN/e2qRJsDEQnLw
	8TXWnh2IpfNp7uNz9UE=; b=dsLzhYiMFmO7Ml6KbEKtZHDG5NeuFJIrsZI2ZeBT
	NWHdEsw5IcgfaHaMc6tRxMDzUIAWZsuWPemp5D4wdMrgYZC7SM7dx418aGB20A2E
	B7LUPIHbDzcxkBWAzruU3Qf2GknQHVO1eLnNIScS/+TG5lVC1Ig9jwC56Wq143X2
	UYPfmNreeKpmVidOs41M8I8KgpO6Nhl9dvmPORKLJq7eS9AtnYkS+4YkPLf1kd2r
	yvNoDaKwDBQffEWhBDju91W1FLdQbyaYbHcUp7mNDnCkm0A+Ke80AqML2B+h6mEU
	grbYoSh1dv85/ifPFDcPghlgwidn8HkMbrjsQwh+iOLzNg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TtPzkeKFogIk; Thu, 26 Sep 2024 18:26:29 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XF29X579FzlgVXv;
	Thu, 26 Sep 2024 18:26:24 +0000 (UTC)
Message-ID: <108a707e-1118-42f4-8cc9-c1bda9fab451@acm.org>
Date: Thu, 26 Sep 2024 11:26:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/3] ufs: core: fix error handler process for MCQ abort
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-mediatek@lists.infradead.org"
 <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
 <Powen.Kao@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>
References: <20240925095546.19492-1-peter.wang@mediatek.com>
 <20240925095546.19492-3-peter.wang@mediatek.com>
 <949fb86d-6b61-4a1a-bc04-c05bb30522b9@acm.org>
 <4bc08986190aecb394f07997b2ad31e301567496.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4bc08986190aecb394f07997b2ad31e301567496.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/25/24 8:45 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 24a32e2fd75e..06aa4ed1a9e6 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5417,10 +5417,12 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp,
>   		}
>   		break;
>   	case OCS_ABORTED:
> -		result |=3D DID_ABORT << 16;
> -		break;
>   	case OCS_INVALID_COMMAND_STATUS:
>   		result |=3D DID_REQUEUE << 16;
> +		dev_warn(hba->dev,
> +				"OCS %s from controller for tag %d\n",
> +				(ocs =3D=3D OCS_ABORTED? "aborted" :
> "invalid"),
> +				lrbp->task_tag);
>   		break;
>   	case OCS_INVALID_CMD_TABLE_ATTR:
>   	case OCS_INVALID_PRDT_ATTR:
> @@ -6466,26 +6468,12 @@ static bool ufshcd_abort_one(struct request
> *rq, void *priv)
>   	struct scsi_device *sdev =3D cmd->device;
>   	struct Scsi_Host *shost =3D sdev->host;
>   	struct ufs_hba *hba =3D shost_priv(shost);
> -	struct ufshcd_lrb *lrbp =3D &hba->lrb[tag];
> -	struct ufs_hw_queue *hwq;
> -	unsigned long flags;
>  =20
>   	*ret =3D ufshcd_try_to_abort_task(hba, tag);
>   	dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
>   		hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
>   		*ret ? "failed" : "succeeded");
>  =20
> -	/* Release cmd in MCQ mode if abort succeeds */
> -	if (hba->mcq_enabled && (*ret =3D=3D 0)) {
> -		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp-
>> cmd));
> -		if (!hwq)
> -			return 0;
> -		spin_lock_irqsave(&hwq->cq_lock, flags);
> -		if (ufshcd_cmd_inflight(lrbp->cmd))
> -			ufshcd_release_scsi_cmd(hba, lrbp);
> -		spin_unlock_irqrestore(&hwq->cq_lock, flags);
> -	}
> -
>   	return *ret =3D=3D 0;
>   }
>  =20
> ---------------------------------------------------------------------
>=20
>=20
> This patch has several advantages:
>=20
> 1. It makes the patch 'ufs: core: fix the issue of ICU failure'
>     seem valuable.
> 2. The patch is more concise.
> 3. There is no need to fetch OCS to determine OCS: ABORTED
>     on every CQ completion, which increases ISR time.
> 4. The err_handler flow for SDB and MCQ would be consistent.
> 5. There is no need for the MediaTek SDB quirk.
>=20
>=20
> What do you think?"

Hi Peter,

Is the above patch sufficient? In MCQ mode, aborting a command happens
as follows (simplified):
(1) Send the ABORT TASK TMF. If this TMF succeeds, no SQE will be
     generated. If this TMF succeeds it means that the SCSI command has
     reached the UFS device and hence is no longer present in any
     submission queue (SQ).
(2) If the command is still in a submission queue, nullify the SQE. In
     this case a CQE will be generated with status ABORTED.

It seems to me that the above patch handles (2) but not (1)?

Thanks,

Bart.
