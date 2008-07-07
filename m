From: "Grant Grundler" <grundler@google.com>
Subject: Re: [PATCH] sym53c8xx: Fix bogus sym_que_entry re-implementation of container_of
Date: Sun, 6 Jul 2008 23:35:21 -0700
Message-ID: <da824cf30807062335q5057a816wf4071bbec3052093@mail.gmail.com>
References: <20080707005030.503A3DDE08@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:31364 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYGGGf1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2008 02:35:27 -0400
Received: from spaceape10.eur.corp.google.com (spaceape10.eur.corp.google.com [172.28.16.144])
	by smtp-out.google.com with ESMTP id m676ZMcw020962
	for <linux-scsi@vger.kernel.org>; Mon, 7 Jul 2008 07:35:22 +0100
Received: from wf-out-1314.google.com (wfd26.prod.google.com [10.142.4.26])
	by spaceape10.eur.corp.google.com with ESMTP id m676ZIeV007409
	for <linux-scsi@vger.kernel.org>; Mon, 7 Jul 2008 07:35:21 +0100
Received: by wf-out-1314.google.com with SMTP id 26so2408234wfd.1
        for <linux-scsi@vger.kernel.org>; Sun, 06 Jul 2008 23:35:21 -0700 (PDT)
In-Reply-To: <20080707005030.503A3DDE08@ozlabs.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Matthew Wilcox <matthew@wil.cx>

{+ willy]

On Sun, Jul 6, 2008 at 5:50 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> The sym53c8xx driver, for some reason, seems to mostly re-implement
> linux/list.h with added bogosity. The main one is it's implementation
> of sym_que_entry which spits warnings with recent gcc's on some
> 64 bits architectures.

Yup - the implementation doesn't look so good to me either.

>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>
> Can somebody with that HW test the patch in case I did something
> stupid? I don't have a symbios controller at hand, it's just that
> this driver is part of our defconfig :-)

If willy can't test this soon, I can give it a shot.

>  drivers/scsi/sym53c8xx_2/sym_misc.h |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> --- linux-work.orig/drivers/scsi/sym53c8xx_2/sym_misc.h 2008-07-07 10:42:03.000000000 +1000
> +++ linux-work/drivers/scsi/sym53c8xx_2/sym_misc.h      2008-07-07 10:44:41.000000000 +1000
> @@ -121,9 +121,7 @@ static __inline void sym_que_move(struct
>        }
>  }
>
> -#define sym_que_entry(ptr, type, member) \
> -       ((type *)((char *)(ptr)-(unsigned int)(&((type *)0)->member)))
> -
> +#define sym_que_entry(ptr, type, member) container_of(ptr, type, member)

There are 11 uses of sym_que_entry() macro. Is that too many to
completely remove it's use?
(question for willy to decide I guess).

cheers,
grant

>
>  #define sym_insque(new, pos)           __sym_que_add(new, pos, (pos)->flink)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
