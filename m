From: "jack wang" <jack_wang@usish.com>
Subject: Re: [RFC][PATCH v2]Add pm8001 SAS/SATA HBA driver
Date: Mon, 12 Oct 2009 10:37:14 +0800
Message-ID: <35E1BAFA1C27408E83F6BE905DD882DF@usish.com.cn>
References: <9A9AF0C219C5433DB5A8D61D4914C599@usish.com.cn> <9510C503D9D946EDB9AD0B61044881EF@usish.com.cn> <da824cf30910091937l761e1b8bo311dc2a0bbf1c115@mail.gmail.com> <200910102127.17843.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:39832 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZJLChv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Oct 2009 22:37:51 -0400
In-Reply-To: <200910102127.17843.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Rolf Eike Beer' <eike-kernel@sf-tec.de>, 'Grant Grundler' <grundler@google.com>
Cc: 'James Bottomley' <James.Bottomley@suse.de>, 'lindar_liu' <lindar_liu@usish.com>, matthew@wil.cx, linux-scsi@vger.kernel.org, tom_peng@usish.com, 'aoqingy' <aoqingyun@usish.com>, roy_wang@usish.com


Grant Grundler wrote:

> Later in the patch I see:
> +       pm8001_ha->tags = kmalloc(sizeof(unsigned
long)*PM8001_MAX_DEVICES,
> +               GFP_KERNEL);
> 
> What are we limiting to 1024 devices? LUNS?
> I noticed the constant was also used in an initialization loop too.

There are some other things that I find suspicious at this point:

-for allocations of array kcalloc() is usually the way to go as it does 
overflow checks for the multiplication result (not needed here with the 
current values, but doesn't really hurt in init path either)
-using sizeof(*pm8001_ha->tags) would make sure it's the correct size no 
matter what type this will ever be, because ...
-unsigned long has different size on 32 and 64 bit, I don't know if that
makes 
sense here. AFAICT this is sort of bitmap here so this probably doesn't need

to double it's size on 64 bit.
[Jack] Will use sizeof(*pm8001_ha->tags) instead. Thanks Eike.
Greetings,

Eike


