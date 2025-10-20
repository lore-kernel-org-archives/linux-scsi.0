Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC2525776
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 16:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760976627; cv=none; b=fEAPTa3Fw+ZdRyjPpKfcx6TJqTOhqzdKmLP1bugPKwOjcf43m2AZmU4J4dSiBsKowTor6IkZD/LFsfcIubdbMVbjBUXrcQyBLbxK1Zk4f9pmL+lLDpG5dCn5OkNurbJNWscV0mqamOhkBe3Os1UPePViLtaeRHOSv9gMzZc3UtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760976627; c=relaxed/simple;
	bh=Dm6UcC864Lal1JLeBXv+ijnY0LMZCijjaFI7VkFTEyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MJtzHah8Nj9Yxr97nHvjJcZB1x5MqT36AOoYW+1PSJ7rRFjXkOMTqUwDi6xOGxAo1m8kAYg4ohmpWAETPQgf3aPs5DAdAkc1QuWIm0X2ejmh6KdQsa3VNNS47RNw/kkExAtBSd84OdKrCekCUi08euZK7FoUgXBNZPr494GpIHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cZhFB/kO; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cZhFB/kO"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cr0l469tSzlh3sY;
	Mon, 20 Oct 2025 16:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760976623; x=1763568624; bh=stB5qUfqTFZYm313aUUJKTJl
	ygObZn8d7FSfQb5t9Io=; b=cZhFB/kO2ScyRDT8yZK4PJoAk/Q+HhK/tGHK9YM+
	hRjK8DXSdQjz5VrPKVIUGYcnuS2rddbd9COtC1ujqovyE3OWtctvv0RT4/EVqzva
	Q5mSsrgAh1z3keSpBQKlKz0AMNC1CGUbhgBPyHQXccxYG1QYW59bpgKMgi47xVYm
	Zh3M/M8yNAuoEe1yxKQQVXDPuyDbHShka8Z5MvpRVOKerpRRWL7eTB+7i/1GbfXL
	MR3RgzWeEKkwTYLxw+YE23hnx3DaJmMK3ZZOILZdr6m4zKrwdr6lfEJ4mpUSFIKQ
	Hgzl+RK403eF/H+HTLB8jgfF9ET9GkqTgP6iedgy711Y2g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JJStxq4655cK; Mon, 20 Oct 2025 16:10:23 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cr0kz5RvNzlgqTq;
	Mon, 20 Oct 2025 16:10:18 +0000 (UTC)
Message-ID: <856c9e92-a860-4e36-923b-ab47dc1fbdcc@acm.org>
Date: Mon, 20 Oct 2025 09:10:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/28] scsi: core: Support allocating a pseudo SCSI
 device
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251014201707.3396650-1-bvanassche@acm.org>
 <20251014201707.3396650-5-bvanassche@acm.org>
 <548939fa-90ea-47b5-9f75-3bcee3231e53@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <548939fa-90ea-47b5-9f75-3bcee3231e53@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 10/20/25 4:10 AM, John Garry wrote:
> On 14/10/2025 21:15, Bart Van Assche wrote:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (list->next !=3D &shost->__device=
s) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 next =3D list_e=
ntry(list->next, struct scsi_device, siblings);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* skip devices that we ca=
n't get a reference to */
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!scsi_device_get(next)=
)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Skip pseudo device=
s and also devices for which
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * scsi_device_get() =
fails.
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
 >> +        if (!scsi_device_is_pseudo_dev(next) &&=20
!scsi_device_get(next))
>=20
> maybe previously the comment had some value, but now it just tells what=
=20
> the code does (and not why)

I can change "for which scsi_device_get() fails" into "that we can't get
a reference to" if this is what you prefer. Either way, I think the
comment has value because of the double negation in the if-statement.
The expression in this if-statement controls when to break out of the
loop and hence says which devices not to skip.

>> + * scsi_get_pseudo_dev() - Attach a pseudo SCSI device to a SCSI host
>=20
> you could call it scsi_get_pseudo_sdev

That sounds good to me. I can rename this function if nobody objects.

Bart.
