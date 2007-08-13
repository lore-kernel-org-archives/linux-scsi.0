From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 4/6][RESEND] Emulex FC HBA driver: fix overflow of statically
 allocated array
Date: Mon, 13 Aug 2007 09:10:38 -0400
Message-ID: <46C0584E.5060906@emulex.com>
References: <200708130016.11281.jesper.juhl@gmail.com>	 <200708130021.07068.jesper.juhl@gmail.com>	 <46C038E3.5090204@emulex.com> <9a8748490708130415j790d6e49y6ae12ca8dad780f2@mail.gmail.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59150 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030820AbXHMNKy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2007 09:10:54 -0400
In-Reply-To: <9a8748490708130415j790d6e49y6ae12ca8dad780f2@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Ok.... here's what happened,

- We changed the define so that it matched what we are using. We never configure
   more than 4 HBQ, thus the index will never be beyond 0-3. The if-check is actually
   innoculous. Given that the change wasn't your patch, we didn't include you as
   the author.

- Coding-wise, you are right, we still didn't fix the range check.

Since this really is just something to keep the tools happy - I'll recind the NACK.
I'll worry about simply removing this if-check later...

James/Andrew, accept this patch - ACK.

-- james s

Jesper Juhl wrote:
> On 13/08/07, James Smart <James.Smart@emulex.com> wrote:
>> NACK
>>
>> The fix is contained in our 8.2.2 sources recently posted and pushed by James
>> as part of his last scsi fixes.
>>
> 
> I actually did look for it, but couldn't find any lpfc commits with me
> listed as author, so I assumed it had not been merged.
> I just looked again, at the source this time, up-to-date mainline git
> tree, and I still see
> 
>         hbqno = tag >> 16;
>         if (hbqno > LPFC_MAX_HBQS)
>                 return NULL;
> 
> in drivers/scsi/lpfc/lpfc_sli.c
> 
> ???
> 
> 
>> -- james s
>>
>> Jesper Juhl wrote:
>>> (previously send on 09-Aug-2007 20:47)
>>>
>>> Hi,
>>>
>>> The Coverity checker noticed that we may overrun a statically allocated
>>> array in drivers/scsi/lpfc/lpfc_sli.c::lpfc_sli_hbqbuf_find().
> ...
> 
