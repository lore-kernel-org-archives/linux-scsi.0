Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792588918;
	b=kVg/wO9vO63Nwdmps1w/JDNqebEgQOi4OUP3TxBR9Wy4rwKfHlaDJQnoRwJKgXh8oBRP
	 GVoLbziUnEv3G4SRKjRZ40cotPjaf494DDnK1S3gciddBnB2u+SUhX6TeshGYQflZ+mOc
	 VkGpXV5hvnsrqr1HyytTa7YL1YaGByYE1lQXMZIliC+TV3kYK9H92bI7ssfl+BzIvmR/A
	 1aFbzQkwoRZNJwkOzWtvCxFsAva9fUn7Tgvlt6WVC8o5sYR+YgW4Et1eoVvqp4xdj3k8o
	 2f/WccpRiL1aFTbgX+0axgYtnqE0npcOUEMW9+ZYJsZIJCLTjuoiz/ZzaCb3VHbHdQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792588918;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=8XmY3cO1g5ot0NieKBVNe3aaY4v6Wew3vwXK9tzvmM4=;
	b=sKK79T/j4oXzNAKHmDrvKImQOWvWTw0cRysDcHbsNPKofMWsxKIZjUnojwNHvDAALZ5K
	 dn0D8ZEd9qLh0SMzGdYgtOWNLz/PQKcwn0VSSc5eydQurbaqZgeYLFDcg6GDlD3fqgOB9
	 ZYRWwpk+FroJ8QbCRPDqgwk1HWhXC0kvVzP/BTsmZWcbQtgnzbwesWGaJIOTfDVkjxrJb
	 8EOBjvW1ggZaqcx9MesjozEi9Y29UiSPyh/GaerkPjqWtmiFRY6y8oLQCj/vA5AF9uPWY
	 a1nOIByw8XH03WZcaHN3nQTHxp5kAg4rV7WTQaHbRhv805Vr5eW7lovhRPWT6NTwmvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=efQsKQrN;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED2B606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 13:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9ED2B606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=efQsKQrN
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j8qgm6z1wz1XM4Tn;
	Wed, 21 Oct 2026 13:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792588913; x=1795180914; bh=8XmY3cO1g5ot0NieKBVNe3aa
	Y4v6Wew3vwXK9tzvmM4=; b=efQsKQrNwePkI5QM+3AMCINxE/zPCvVc3T3FyaCj
	F5kM10cqu1BlnvMmT66k+qmHW1ZQkaT5Efh7H/l7KZtfEipdSRG9xkpSBhzjSAnb
	T7gut8h0mOiK+P/O6fHXwqZvpSG8N1JZr9qtmNrrV1OdlIyVACizd7mrXYPLmI9t
	5O/YTYJeY9IwGlLJHsME0dBMVJIUD2qkZeZbf8wsGhdiJ/3oj/djc/LYRns0OyaT
	Me7XOk9k39Ogp0R7e3JTYH4O3IQXFxUz6S/Jen3eBGrLnkXO05oXeeOcSLI8fdBB
	Ck4MIpJZoduutamd3ZbAmDpfLIyqpLC8ykGlh5BJ8rlvyA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0h0VKGdJLSvk; Wed, 21 Oct 2026 13:21:53 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j8qgj384kz1XM4Tl;
	Wed, 21 Oct 2026 13:21:53 +0000 (UTC)
Message-ID: <8742585a-25cf-4ccc-b4fc-fab3b4db35d9@acm.org>
Date: Wed, 21 Oct 2026 06:21:52 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
To: Hannes Reinecke <hare@suse.de>, Brian Bunker <brian@purestorage.com>,
 linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 James.Bottomley@HansenPartnership.com, krishna.kant@purestorage.com
References: <120fc95e-432a-4f05-aa87-54873363ed9f@acm.org>
 <20261020171748.7207-1-brian@purestorage.com>
 <b4ea3aa9-7db5-4af9-a893-ae2af3c05eed@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b4ea3aa9-7db5-4af9-a893-ae2af3c05eed@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/26 3:45 AM, Hannes Reinecke wrote:
> Aw. The mysteries of SPC. Can't you simply use 'Standby' state?
> That would not require all this weird rescanning.

+1 for switching to active/standby. Ten years ago I learned that
Windows SCSI ALUA initiator support for the "unavailable" mode was not
working reliably. This forced us to change the storage array
implementation from active/unavailable to active/standby. I haven't
checked since then whether the Windows SCSI ALUA implementation has
improved.

Bart.
