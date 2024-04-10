Received: from omta011.uswest2.a.cloudfilter.net (omta011.uswest2.a.cloudfilter.net [35.164.127.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8C515AAD6
	for <linux-scsi@vger.kernel.org>; Wed, 10 Apr 2024 21:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.164.127.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712783790; cv=none; b=SX7XkD5zbFboXetIc7+lz89jHNhIy6w1iH5lhX/BpGynEyHQ2+/60oVtPEW+kX6mjrZY9YcK7geZyOmEJkz+zd4vAC6Mq3NPWICkxXcDtKIVbsbif+oUCVkxWdtMzsdQZaTAP6la0Rm7q1ckRbiFUUsYzhSy371NevYqiq6lCtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712783790; c=relaxed/simple;
	bh=CaT36sSbg4LDExScuG9DOttWcPSlUb8E89zoa2jmlHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eVwcPd58uUWrrHzdLlSfDtRGX7dzUCyqNji/u5yMTtzu/1ix2X1BqbrjpCHp2wUQaMJ9TPKiCEyCfdwy9JVg9vpzmhK8OZiRrnBU/xrmr6QgVxv7vJHNp7ZYz4R2x0peFkDFtX/jaq6hmQHRBJ1bf4tZP+cbTQc4myzHaMNC7X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cox.net; spf=pass smtp.mailfrom=cox.net; dkim=pass (2048-bit key) header.d=cox.net header.i=@cox.net header.b=HwWuNPdf; arc=none smtp.client-ip=35.164.127.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cox.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cox.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cox.net header.i=@cox.net header.b="HwWuNPdf"
Received: from cxr.smtp.a.cloudfilter.net ([10.0.17.211])
	by cmsmtp with ESMTP
	id uYC1rrNl3sYF3ufHQrUCmk; Wed, 10 Apr 2024 21:14:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cox.net; s=c20240122;
	t=1712783692; bh=CaT36sSbg4LDExScuG9DOttWcPSlUb8E89zoa2jmlHQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HwWuNPdfIoFRP4BqbDysg+5MpxEpEjpx3d/qjRpl9pZUldi1czpgra1FwfSL0YBFy
	 +XgUtLNfZw599U9oUOT86pPFwVGtIh4GQZqjwhqghKmdBo3wwOKcN9Ri1yGWEqmbPE
	 J+55NtrrUS24oOc0DHWy4zuVFrGZp5V87uxoXVXXpbCvQofXge3jtl1RSrBIJp+kbW
	 dskyr2X3i1snMt2feB4lGXEhsNqAzSbf1z6TF7rGWvybkbHboTCpNm4/hSXvJHWUBS
	 sBYg5f2GQ2+HhQfxDapoB8dbNHrVZNz3AZbEI+sGRMai2ydCCUC6ZNPHg+wEm3wG/2
	 LRSfBJZwKiH5A==
Received: from [192.168.33.113] ([70.190.229.154])
	by cmsmtp with ESMTPSA
	id ufHIrPDy61WbsufHPrByy0; Wed, 10 Apr 2024 21:14:52 +0000
Authentication-Results: ; auth=pass (PLAIN) smtp.auth=cbertsch@cox.net
X-Authority-Analysis: v=2.4 cv=Mqzx6Hae c=1 sm=1 tr=0 ts=6617014c
 a=sEpYCS07hqR8Zql/TXGVUg==:117 a=sEpYCS07hqR8Zql/TXGVUg==:17
 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=cm27Pg_UAAAA:8 a=zid2hPHv1umveBVInocA:9
 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22 a=xmb-EsYY8bH0VWELuYED:22
Message-ID: <4eb3efc8-a5d5-4c5a-a0d8-a2a5377b72f1@cox.net>
Date: Wed, 10 Apr 2024 14:14:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
To: Justin Stitt <justinstitt@google.com>, Kees Cook <keescook@chromium.org>
Cc: linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net>
 <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
 <d45631ac-3ee6-45cc-8b5a-fab130ce39d7@cox.net>
 <CAFhGd8p=R4P6J9KoMGcXij=fN=9sixVzjuz95TLKP1TexnvV8Q@mail.gmail.com>
 <202404081602.1B1773256@keescook>
 <CAFhGd8pdTzJae4257o5fNBiJ+GdRUzoCDH3xe6cTMqBHcsR=AA@mail.gmail.com>
Content-Language: en-US
From: Charles Bertsch <cbertsch@cox.net>
In-Reply-To: <CAFhGd8pdTzJae4257o5fNBiJ+GdRUzoCDH3xe6cTMqBHcsR=AA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfMpq+9BMiitn944rQBfue+cXFmuiS5+2QzC2KH0lZuOs3qd6xgs8ZfpEsseeY8cxa6JsdovOXQyA3o5to9HaSKqNCYkO9uthsTDpQR3AksUSZqKtu+VF
 WiwsqggKyS9f08aW66HHd8qevP3KD6zBRax7941yXzD+G/ipUAImek6twudlxZ/gAkWuR6PmqgWPkxxve8wEjoXNkkSD/B1vIXVHBtmh1bN29NRGl3gY01MW
 oq9T7a3QDsLvTyJGn51+KGWKQRXoyxtipxhZ1EpvMp/eVOiDTsmi08yQHgfLX4+5IgxvpledOwLlypFKoeS4zL3YO1js3ZExFdL0jjtrFmg=

On 4/10/24 13:51, Justin Stitt wrote:
...
> 
> For visibility, Kees has a series [1] which introduces memtostr and
> also fixes up drivers/message/fusion/mptsas.c.
> 
> Charles, can you try out that series?
> 
>> --
>> Kees Cook
> 
> [1]: https://lore.kernel.org/all/20240410023155.2100422-2-keescook@chromium.org/
> 
> Thanks
> Justin

Success!

I was able to apply the patches for include/linux/string.h and for 
drivers/message/fusion/mptsas.c (as needed for this test hardware). 
Clean build, identified as 6.9.0-rc3_64+. System boots. scsi interface 
found, disks found, and some test scripts run successfully.

Thanks
Charles Bertsch



