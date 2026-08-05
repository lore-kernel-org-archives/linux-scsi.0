Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22303F39C2
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 22:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785967531; cv=none; b=fA9YAqgDqo8n7JhslaEienZKeR+Cnajo9YCBcChW8PjNKxJYgOy4eTrBmw3vR2vII47KnosXjQ9oupwZl5JOzIS8n9IHUzd8vVEIWWBZhD+CY2w0+z/+u5XxI7LivIfoJK0VeHynZRNfxas9qqfkIqg4i3V4MlEuWqj1613nsus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785967531; c=relaxed/simple;
	bh=QbrUBumwFkx99uAV93N8bQz783eilACD+PzwAhADY8g=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=SpfT/4WrbkjiO5J49XlV35AR1xz9MXHQi3PK8+6NfBz0YhNtvODcQbkMKm9LT16Yj78MrGtqsjgOFnnvwpYcm/bUgoLLK09f+srK3zcZel721yFhFGwgqPD0otfqOrkyUivh/DA1XMyL8VMG+/lv1QkkqcgXQoHFeg8i8d63VII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=iBPar4jl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XJm2cbZF; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="iBPar4jl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XJm2cbZF"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.stl.internal (Postfix) with ESMTP id 13EEB1D00139;
	Wed,  5 Aug 2026 18:05:27 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Wed, 05 Aug 2026 18:05:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1785967527;
	 x=1786053927; bh=jPfzNralGnojkVjsUQspg7ljr2JI05RMDZHMiRutgBo=; b=
	iBPar4jlqgaOfw4Xq2c+Va1W5LdcfcEPiq2J1SnAq2Kpny22e1WXc9viL8lCcGhL
	se51SGbcSRDhdys1HTttEnxsBvuojE4S252QzE/t1hK5wRnDI4rN7vVTQR3IiBXM
	Zf0fPzIOqRHp3qeozGrpIY3XwPMhl/scvjW8IP/eAoiRyIQB4kb+ebG+0VPNjLjK
	1XKtsNyB/jQyPTItFt7aP7zmD0uVYI2xeG/LoDjH12Gkj7EZnTe/KWTPaaLFpYEC
	ZHxv67+sdCR+k7cMxFMTsgGh6vknva3V6VMRcgFjpfT/ys1jYQ+K1szeKUVfdiaM
	x8QYhPYbWNp1wwtTfzDQRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1785967527; x=
	1786053927; bh=jPfzNralGnojkVjsUQspg7ljr2JI05RMDZHMiRutgBo=; b=X
	Jm2cbZFyz/+sQhnwbIFMTyRiqwSC9YobrzljPZKUCFCIQWriz5AqP5Jr6Cs6w7kN
	uTdtczcvNZZeiSbFoXkMUJlwaDglpvCiBhqWDxlSIHIf9h7d+Pn8qMiesf9RgHfd
	ZCewCd6Q+ubes9pBOR0s3vjBYQ8yJzVgShSLsNtzwhCPzN9fMSSM/LI7/gkdIyEw
	TqqkCkL4iFNh2bdzEcvtDSAzn5AvKiwleMFrfC7Tt9zrF2gcbwwsJfT+2srp+PzM
	9h3kPTbbvznUsX888qFYoeQFP0laLaaHrgbc+ELrTdvPvz1rlyq1vn3roR5saQBw
	qIyhFV2rdd3Mx0u4gMHmA==
X-ME-Sender: <xms:obNzalL7B6c_F91fEhHeRhyrgOUHAk9y192beOUWeGnBG_hQ_freTg>
    <xme:obNzar-BWPHdpJowXt7PWwPeqPaLrjK1dz8bww9dos4inDrarpphgNttEgdkzaEeE
    JzWK5kh55H8lO7bHLqHnZmAAK77XcZn3eALW-LJKiYKv-ELxgOg7co>
X-ME-Proxy-Cause: dmFkZTF7DhDzGCN9a+Wb3w37p1zA0JaxKMM5oQ3cnG9E9bv7B0Ca5jW7FNf4XD9KE0tr63
    Lbtyf4i6/t8XOla9y3lQ2CrTEQnvxBN2K9eGFa4MJyPpExmEuTxlSBilDjiWmOiAST6aQg
    Y8ILGCimEueWHNTd5Ys6XzU66YBAvWEtdsZ8XKid+7n6jw9PuLtYgpSYb4Onm0a/1HPB7D
    2URwqy+SNnXDpcnoiEVW/WddLu9YUSbbMYK+yQIw445ZpiOFx39CAoh6Ro9mC160k640r4
    XGHffpFT2iKzxBgDs0B+80n+CLbw4QKfxdtDa7sBvybfVu0sFK0Ma24GXPUC8IFdO6HHZo
    VuSy9A8Eb4Q6TaSEKIIGu07ZbgexNy+6UkxTO6ZyV6JKl0lUZEKUZanAgqtdkPbmx/nLT/
    rbbE5HNZ0/cZqOlC1p8baIStzUTXN9LYicb25Hqu/sR1rXXeaOsPCWv8adid9bQWeknIZu
    kdatXyVYpz52Lbjy63ioM0XC2RZfPk1zbz6O9juCeiiJ9Vk+6H3u7J22vsrk7S/KPt35J3
    JbfgRZQkh5b8ZEnKsJ7rMiqw+WwPkKONb3mo00v/ZtEm3E0/pUdWo5fTuBh3PpPHEK73z4
    sUyNiQ1pxMlH3vs3Bf2NsfpZoP6rZLVhTmOvYOseZoyN9jfoALXDRSwVluXg
X-ME-Proxy: <xmx:o7NzahIeScZdN_K8_p3fu0XaF75ksypB09nztgXLO-SRjJxrjm7n7g>
    <xmx:o7NzapL3dVMAaoGOWtGwg5oazImGlIGD2F0oI9zSgQfVv1OLbuiF0A>
    <xmx:o7Nzar7lAt_eHmiB4LqQ_5StNlRUYh39rkLofR9zgHRnpdOsRpj6iA>
    <xmx:o7NzajdmgFDeFD4t28oQ7rQn1WNfguABmwBOW-iFtCRrF4QOXm5zlg>
    <xmx:p7NzavUDaDKavy4fCQJFRwkNaMNxYzKJEm0hxy55YCctj7oSFQiCVaUv>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 15CE432A0062; Wed,  5 Aug 2026 18:05:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AJpFeNx-kIXV
Date: Thu, 06 Aug 2026 00:04:59 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Bart Van Assche" <bvanassche@acm.org>,
 "John Garry" <john.g.garry@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "Christoph Hellwig" <hch@lst.de>,
 "John Garry" <john.garry@linux.dev>, "Russell King" <linux@armlinux.org.uk>
Message-Id: <eb0c2ccf-08d7-4c4d-a649-db767ddda457@app.fastmail.com>
In-Reply-To: <559552b3-1336-4fbd-b0cb-6a96ae57b3c3@acm.org>
References: <20260804113436.2373404-1-john.g.garry@oracle.com>
 <efff8e1d-0eb9-47eb-ba20-6bdbeeea15e1@acm.org>
 <7ab3dca8-83f3-4ec7-8bb4-e9c3508a5c59@oracle.com>
 <9a4ed570-5b19-44ca-9d22-41ab37d21014@acm.org>
 <18de6750-7668-4855-b24d-515760a31032@oracle.com>
 <559552b3-1336-4fbd-b0cb-6a96ae57b3c3@acm.org>
Subject: Re: [RFC PATCH] scsi: core: Drop Scsi_Host.default_lock
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Aug 5, 2026, at 23:47, Bart Van Assche wrote:
> On 8/5/26 6:45 AM, John Garry wrote:
>> I do have to question why we maintain support on modern kernels for such 
>> obsolete HW. The maintenance burden is not zero, as we see here ...
>
> (+Arnd)

(+Russell)

> Agreed. From
> https://lore.kernel.org/all/20241204102904.1863796-15-arnd@kernel.org/:
> "ARM: mark RiscPC as deprecated [ ... ] Since there is little hope of
> this being maintainable much longer, plan to remove it in early 2025
> while it is still expected to mostly work."
>
> Arnd, is removal of Acorn RiscPC still planned? That platform relies on
> several SCSI drivers. API changes for the SCSI core, although rare,
> would be easier if we wouldn't have to support the Acorn RiscPC anymore.

I resent my series to deprecate almost all board files recently, and
that is now in linux-next. Unless Russell has any last minute objections,
I would now expect that we can remove all the deprecated files after
7.3-LTS is out, and that includes the drivers/scsi/arm/ directory.

My original plan was to do this all two years earlier, but since we are
close to another LTS kernel, I think it makes sense to wait for that
before removing any code that potentially still works.

      Arnd
