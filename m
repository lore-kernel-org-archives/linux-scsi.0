Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B689404BE9;
	Tue, 13 Oct 2026 15:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904990; cv=none; b=n1Bv8a0ILAxu/s4DDNO71aR+xS254R97PcNQ86enalqfR6gSloWL6oZ6y2jFIDa0ir67D1rVfOrNupV51O13pszNXrzWe3wiioFGZGRQxVaV7qq/UWx7VscCuZzQqABJ/Qf6n3lehE3v1/KDIEQ6+WMS82+/c8H+FlJaPSOasVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904990; c=relaxed/simple;
	bh=FeLrzmexsRmfrToQgkJfwU8h6OCDT+AJrtkO1ZcrUKE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IlNHGs540ozaaHqYLhBuhXZhyvRmKaIdmCqUZwFWUKI0A7WUeF/Mm+fMwo9bmCX7hvXbYzs0LH693IIveNbRt7QiX6UMlcJaO8e4VfBRPsopOK8xSYaA72wzxRdIh+eqWMgwiXP2XbVGbtxZcohuFiRfY+pMZU435ttJpWDxNwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Y4E6dTkP; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Y4E6dTkP"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j3ylB3cHwzlfvpn;
	Tue, 13 Oct 2026 15:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1791904975; x=1794496976; bh=b91r9jQmFKJ4zQ1mNy101uUz
	jObi7ERuqBR8BecRt/A=; b=Y4E6dTkP5bl1THRMqAa04D9X7EHouCXGFzeutP7K
	1wpRuYMkMRXkvqzWcjLAPuWIptAJ30hPTuaGIP7ul9OIEvdLL8Omo8LliXP1MbEg
	tNMgG8OSSt6QQHltWqnTDteet+fZkYHUE3IV9wIgHaPp9keRyg3MywMlX04TEKuS
	UpLTvKm1DrLoq4DyoMluM6eU81F/gfvLiWuajQRdHOWst6bX7ygx/juPJ1U/ETGp
	elOT6HT1ycLkSHj5pYeFV20Elb3gmrVeUPeEFfTnsEHFbUrpGTcuBRwKIAjLUnrw
	RRu26EpQco8x+auJM6zrZpKw4KXIGaU1UzHciCBDzWHNSw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0xx5WMOl1eAS; Tue, 13 Oct 2026 15:22:55 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j3yl24l0nzlfvpb;
	Tue, 13 Oct 2026 15:22:54 +0000 (UTC)
Message-ID: <9c28fbe7-089f-4d72-86be-5805bfebb213@acm.org>
Date: Tue, 13 Oct 2026 08:22:53 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIIHY1IDEvMl0gc2NzaTogc2Q6IG1hcmsg?=
 =?UTF-8?Q?disk_dead_on_surprise_host_removal_to_avoid_I/O_hang?=
To: =?UTF-8?B?6IOh6L+e5Yuk?= <hulianqin@vivo.com>,
 Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
 Hannes Reinecke <hare@suse.de>, Mike Christie <michael.christie@oracle.com>,
 Damien Le Moal <dlemoal@kernel.org>, John Garry <john.g.garry@oracle.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "usb-storage@lists.one-eyed-alien.net"
 <usb-storage@lists.one-eyed-alien.net>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <TYUPR06MB6217DD31B1B3CD09E431CC12D2922@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <20261012144923.GA10852@lst.de>
 <TYUPR06MB62172FD04314EFE34D8091EAD29E2@TYUPR06MB6217.apcprd06.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <TYUPR06MB62172FD04314EFE34D8091EAD29E2@TYUPR06MB6217.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/12/26 7:14 PM, =E8=83=A1=E8=BF=9E=E5=8B=A4 wrote:
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index 064c7fc8e368..3a5a0cac2b78 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -930,6 +930,9 @@ static void quiesce_and_remove_host(struct us_data =
*us)
>   	if (us->pusb_dev->state =3D=3D USB_STATE_NOTATTACHED) {
>   		set_bit(US_FLIDX_DISCONNECTING, &us->dflags);
>   		wake_up(&us->delay_wait);
> +
> +		/* Device is physically gone, cannot handle I/O */
> +		set_bit(SHOST_SURPRISE_REMOVAL, &host->flags);
>   	}
Why is a new member variable introduced in struct Scsi_Host instead of
e.g. changing the state of all SCSI devices that are associated with the
host to SDEV_OFFLINE?

Thanks,

Bart.
