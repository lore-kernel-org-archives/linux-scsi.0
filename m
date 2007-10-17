From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [Bug 3680] sym53c8xx_2 SMP deadlock on driver load
Date: Wed, 17 Oct 2007 11:44:08 -0400
Message-ID: <47162DC8.5050700@cybernetics.com>
References: <20071017013045.A19ED108036@picon.linux-foundation.org> <471621D2.5080806@cybernetics.com> <20071017152019.GA1871@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:2229 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762035AbXJQPoG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 11:44:06 -0400
In-Reply-To: <20071017152019.GA1871@1wt.eu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, protasnb@gmail.com, bugme-daemon@bugzilla.kernel.org

Willy Tarreau wrote:
> On Wed, Oct 17, 2007 at 10:53:06AM -0400, Tony Battersby wrote:
>   
>>> So we should unconditionally drop the lock (and re-enable
>>> interrupts) and re-acquire it.
>>>       
>> After looking at it carefully, this is true of pci_map_mem, but not
>> pci_unmap_mem.  pci_unmap_mem can be called from both ->detect and
>> ->release.  io_request_lock is held in ->detect but not in ->release.
>> So, your patch locks up the system on module unload.
>>
>> I have put together and tested a new patch which does it correctly,
>> while still trying to make only minimal changes.
>> If you approve, this can go into the next 2.4.x release.
>>     
>
> (...)
>
>   
>> -static void __init pci_unmap_mem(u_long vaddr, u_long size)
>> -{
>> -	if (vaddr)
>> +static void __init pci_unmap_mem(u_long vaddr,
>> +                                 u_long size,
>> +                                 int holding_io_request_lock)
>>     
>
> This is marked __init, and pci_unmap_mem() is called from
> sym_free_resources(), which in turn is called from sym_detach(),
> called from sym53c8xx_release() when unloading module. So the section
> may not be there anymore upon unload. I wonder how this can work right
> now. I'm surely missing something :-/
>
> Willy
>   
In 2.4, include/linux/init.h has the following:

#ifndef MODULE
#define __init          __attribute__ ((__section__ (".text.init")))
#else
#define __init
#endif

So __init has an effect only if it is built-in.  Apparently 2.6 also
discards __init sections in modules after loading, but 2.4 doesn't.  Of
course, it is still a bug.

Do you want me to redo the patch with __init taken out?

Tony

