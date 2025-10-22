Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553BD2741DA
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 17:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153848; cv=none; b=tRAh8UePqSuQeIwCE6/hBjLzJVl+fxcrvVaqaKOFdVY5Gm9qReowQHTDEShlsWd7D0GH49VWxViMqmezDWJrtRGSTf6g8AdmFbYHRFiYRQkJ/kpCMNWAyIjT+Y41rzujRkGKyW/h5mbdrNGqlkuj2kgno7pnjmvoUP7+z0MiSOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153848; c=relaxed/simple;
	bh=ZgX55MY8OH+wNXtt6Q7HNwK1NhkBVQhLFJCtpe+GBg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bKxRh07xOIgQ9UVtGF23d3p1zwkbZ/23Tjs5Iw6fqtMKc2Hztqb64HmPBcXRyN5XKspbQbvAMgPQe5G1ZNVhNoOD8QCyN55Nc/JipS67P+CDrA3rS4tqR3dNQ66AmXy0uLZFtR4smCWASlKF/913YYH+WF2DhMsBVE/0LwqqqlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Y6QROqjs; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Y6QROqjs"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4csGH866mFzlrxry;
	Wed, 22 Oct 2025 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761153843; x=1763745844; bh=ZgX55MY8OH+wNXtt6Q7HNwK1
	NhkBVQhLFJCtpe+GBg0=; b=Y6QROqjs0bANOSm5KKEprLbnOsfG2JqoIxmGgAKS
	wH1C6PWKafmCTBGU5nmN7znxhSpX5qQD4REUhAhnw/nm1gYEhw3quMtJ4T8b8e9Z
	HOql3gsfic5sv0HDiezJHho177Q0pYzUYVHctw0vm7WuqkIeMd07+3PHVDhzHo0S
	Rvmcl6g9SLzK5w0PSgH3ExUm/5aV+qKc2kzuE6wPVSV3m8p5u/TPi5tT+w6whmZW
	IATbYwxAd2Tn2nuY5R+ikSJac0jySsuo+iAdfMjVp9DiCmHzJE8dy72/rPw6jQEa
	A42hOhpzM/1Gu/sxDKhifjPl/h/G2JlGR9lwPJqSJi0FQg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YIT6khLnUv1R; Wed, 22 Oct 2025 17:24:03 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4csGH20g07zlsxCl;
	Wed, 22 Oct 2025 17:23:56 +0000 (UTC)
Message-ID: <e241e5c1-a908-4d2f-8f66-82ac3fec937e@acm.org>
Date: Wed, 22 Oct 2025 10:23:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/28] scsi: core: Make the budget map optional
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251014201707.3396650-1-bvanassche@acm.org>
 <20251014201707.3396650-4-bvanassche@acm.org>
 <60f9a312-455a-4714-81fc-abbcf86715f5@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <60f9a312-455a-4714-81fc-abbcf86715f5@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/22/25 1:29 AM, John Garry wrote:
> On 14/10/2025 21:15, Bart Van Assche wrote:
>> @@ -1360,6 +1361,9 @@ static inline int scsi_dev_queue_ready(struct=20
>> request_queue *q,
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int token;
>> +=C2=A0=C2=A0=C2=A0 if (!sdev->budget_map.map)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return INT_MAX;
>=20
> For the record, I would not do things in this way.
>=20
> The shost psuedo sdev does not need a budget, as mentioned.
>=20
> However we complicate the code and add extra checks in the fastpath=20
> (like in this function) by treating this sdev as special and not having=
=20
> a budget.

Hi John,

The following patch series will be reposted after this patch series has
been merged: "[PATCH 0/3] Improve host-wide tag IOPS"
(https://lore.kernel.org/linux-scsi/20250910213254.1215318-1-bvanassche@a=
cm.org/).=20
Patch 3/3 from that series skips budget map
allocation if it is safe to do so. I don't think that it is possible to
skip budget map allocation in some cases without introducing an if-test.
In other words, the if-tests introduced by this patch will get more
users and will enable an important optimization for the fast path.

Thanks,

Bart.
