Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB58337F00A;
	Wed, 27 May 2026 16:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897647; cv=none; b=R1YgHBea05IdxT3/iWRYUWGJC3v29O8uMCVu164MtyhrInvsb0ZqBf9k7HwJUuNv9s+pCBnITE/aD4UasGJfUMo0k1mLcb89izCJJ6syr9W7nEv0jTx3o2sLT8rQ/aDj3+fy+RFtyGZs9OciVX3jrzM1tWm2R0x6d8FEaLZDOcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897647; c=relaxed/simple;
	bh=c9dy1M5sIsed3LGOpfz6vnSt4R7OD3Vr0aGHYLDoSyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BNwTzx6CsTQW+ZnA7Xky1ETADoUDaRZHm+VEFsy+zUwGRWAqJWey1mNbkJ09UyvdHUBCaXRTqMiRAZD97NvURVeHgR+eqaqxcUDNELg1BtCKBuSuuT32xCqGni99TEMvTtrP5f3KjFMUkhzDhbgapyLJzmgh7iM63BepmMnL+Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=w9H134uA; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="w9H134uA"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gQZ8l359Pz1XM6Jf;
	Wed, 27 May 2026 16:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1779897632; x=1782489633; bh=7WoVdBo0t0XhXNi86gxpId0P
	QQqR//ykUwNCS3Iazpk=; b=w9H134uAH7WtzwBF/95fBonQzjacEgSI1B+m4uzR
	lqZIAh1nBkLbHf+vS+dc5ybW8lmvwqg4NmGG4F2LHqeVUismRXxtpJd2mYuRifJk
	9719V8BX7AMGZi4WgimytWR9bgqDL70YSzcg5t1FQ3RoNXUajQ24o/OmzR8p8QWd
	o8oXnUQugD2TxFHfyel3acbWWrmWD4XVnL7GEi255fWxBqs0Ik5k1ftGng2f6pIX
	PBMbYXzEWgL3+Ywex9HfIEVNNcTM71ADAORzCX1nYEfKzvDBgFnzUCMN3IBZgvaG
	96YT2cy0KLOmnu2+vzUCZrSjymyt3zTVd7cxz60/h+vJXw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id O34w5Pp2A7sR; Wed, 27 May 2026 16:00:32 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gQZ8Y22vSz1XM5kt;
	Wed, 27 May 2026 16:00:28 +0000 (UTC)
Message-ID: <ea55f8cc-1366-478e-8a18-66256c98acfc@acm.org>
Date: Wed, 27 May 2026 09:00:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: complete wl runtime resume after SCSI EH
To: =?UTF-8?B?RmFuZyBIb25namllKOaWuea0quadsCk=?= <hongjiefang@asrmicro.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260526114941.667477-1-hongjiefang@asrmicro.com>
 <606c4c21-bcf2-4ed5-9434-e7c70f541d7a@acm.org>
 <20e284b3ce2f4de78ed2ad9804b5910f@exch02.asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20e284b3ce2f4de78ed2ad9804b5910f@exch02.asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/27/26 4:23 AM, Fang Hongjie(=E6=96=B9=E6=B4=AA=E6=9D=B0) wrote:
> I looked closer at the direct ufshcd_link_recovery() approach from
> ufshcd_eh_timed_out(). There is one detail that I think needs to be
> handled.
>=20
> For the legacy single-doorbell path, force_compl=3Dtrue currently
> still calls ufshcd_transfer_req_compl(), which only completes requests =
for
> which the doorbell bit has already been cleared:
>    completed_reqs =3D ~tr_doorbell & hba->outstanding_reqs;
>=20
> So if the timed-out SSU is still marked in both hba->outstanding_reqs a=
nd
> the transfer request doorbell after ufshcd_hba_stop(), it will not be
> completed by ufshcd_complete_requests(hba, true). Returning
> SCSI_EH_RESET_TIMER in that state would only restart the request timer =
and
> would not wake the blk_execute_rq() waiter.

Feel free to add force_compl support to the legacy single doorbell code
path.

Thanks,

Bart.
