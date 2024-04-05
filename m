Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB49173327;
	Fri,  5 Apr 2024 19:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712345772; cv=none; b=Y6b0bGLlqXuL2ghn6WqH5QVzIAeJ25aVUNoXo3pxIJd0DHGjqjHc2BwTvRhVKv46uhmjNjo/LlHt1DoLIKW/agbttPAaJXkFVfzo8VRYs/ma/aHRwIzHommBXhUmR0aUrMKNHqaoV228S4oDLYmmj2EBEwbtKj4xx8fDoxDbElU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712345772; c=relaxed/simple;
	bh=zvc+ACztENO0G0Yh85cZ30RDwZ6Rn/5jkzqfAEyzlXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jDcf0VU/eajJFds3Z/UxBRqE5uy733UOe8MYYZZyCp2RTezwzmYGmOQpOmsdC4LxtCAjpc150zPRbgnHDdDxF6SqLzGARHuUmJZ0hs10OWBc03IO2skK+QzzmrTtAbB4onz3qcox9+Z2z3yM8X74KiTCy6vC+ivn8alKUnuley4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tf5SI6tw; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tf5SI6tw"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VB7yK6WGcz6ChQlw;
	Fri,  5 Apr 2024 19:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712345768; x=1714937769; bh=zvc+ACztENO0G0Yh85cZ30RD
	wZ6Rn/5jkzqfAEyzlXk=; b=tf5SI6tw6mgs4oNJoJmXefhhSpxdrzj9fSlrtVt0
	PqkcOVPrOcvg04atl7GeqP38aMrp4AcJkUP5K2Vihl9cuMR7vyhS2f1GG8aRyDZv
	wrfBhgzwDFYFjp08e8khp8YH0ldkt67cvee/oOBRcZeoE77Rnr/vvP5TXAZHsWt7
	hSYoaM20iBhw3NNp3Nss0ccG/yDBXbLB5wJoqaPodVtTMA3m3mrNo6pfY3ZmZ2o6
	HmKSJJsNJQeEL9dra5I42mRy2bOaX1Tvx3IRMwyAEh2Roi2qq/xyJsTD14Yc64Dv
	Z6JxLjTkBxLreQDpV41y+6bh6GmDNOogN0QhGBdKrmUVfA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Lp0zSrb2ltv1; Fri,  5 Apr 2024 19:36:08 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VB7yJ2vz4z6CkhrH;
	Fri,  5 Apr 2024 19:36:08 +0000 (UTC)
Message-ID: <028352c6-7e34-4267-bbff-10c93d3596d3@acm.org>
Date: Fri, 5 Apr 2024 12:36:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Broken Domain Validation in 6.1.84+
Content-Language: en-US
To: John David Anglin <dave.anglin@bell.net>,
 linux-parisc <linux-parisc@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org
References: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
 <d1fc0b8d-4858-4234-8b66-c8980f612ea2@acm.org>
 <db784080-2268-4e6d-84bd-b33055a3331b@bell.net>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <db784080-2268-4e6d-84bd-b33055a3331b@bell.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/4/24 13:07, John David Anglin wrote:
> On 2024-04-04 12:32 p.m., Bart Van Assche wrote:
>> Can=C2=A0you=C2=A0please=C2=A0help=C2=A0with=C2=A0verifying=C2=A0wheth=
er=C2=A0this=C2=A0kernel=C2=A0warning=C2=A0is=C2=A0only
>> triggered=C2=A0by=C2=A0the=C2=A06.1=C2=A0stable=C2=A0kernel=C2=A0serie=
s=C2=A0or=C2=A0whether=C2=A0it=C2=A0is=C2=A0also
>> triggered=C2=A0by=C2=A0a=C2=A0vanilla=C2=A0kernel,=C2=A0e.g.=C2=A0kern=
el=C2=A0v6.8?=C2=A0That=C2=A0will=C2=A0tell=C2=A0us
>> whether=C2=A0we=C2=A0need=C2=A0to=C2=A0review=C2=A0the=C2=A0upstream=C2=
=A0changes=C2=A0or=C2=A0the=C2=A0backports=C2=A0on=C2=A0the
>> v6.1=C2=A0branch.
>
> Stable kernel v6.8.3 is okay.

Would it be possible to bisect this issue on the linux-6.1.y branch?
That probably will be faster than reviewing all backports of SCSI
patches on that branch.

Thanks,

Bart.


