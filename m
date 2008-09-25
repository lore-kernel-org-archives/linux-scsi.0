From: James Smart <James.Smart@Emulex.Com>
Subject: Re: lpfc warnings on sparc64
Date: Thu, 25 Sep 2008 12:14:56 -0400
Message-ID: <48DBB900.3000903@emulex.com>
References: <Pine.SOC.4.64.0809251006540.6342@math.ut.ee> <1222357008.3610.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61552 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYIYQPO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2008 12:15:14 -0400
In-Reply-To: <1222357008.3610.12.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Meelis Roos <mroos@linux.ee>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Interesting:
   Here's the code lines:
      ...
      irsp->un.ulpWord[5],
      *(((uint32_t *)irsp) + 6),
      ...

it's not tripping on the ulpWord[5] line - which is what you would
think, but rather the "+6" line.  Given that the structure size for
irsp is certainly big enough, this has to be some loss of "object"
context in the compiler.

E.g:  it wouldn't surprise me if there's a base register that
   contains the address of irsp (%reg) and that the un.ulpWord[5]
   results in a displacement on the pointer (e.g. "20(%reg)" ),
   and that the ptr+6 also results in something similar
   (e.g. "24(%reg)") - and the range checking code assumed the
   context un.ulpWord meant ?(%reg), and lost track of the type
   or object difference between the next instruction that happened
   to have a ? that was too big for the array.

-- james s


James Bottomley wrote:
> On Thu, 2008-09-25 at 11:14 +0300, Meelis Roos wrote:
>> Noticed this wgile compiling 2.6.27-rc7+git on sparc64 - maybe it is of
>> interest.
>>
>>   CC [M]  drivers/scsi/lpfc/lpfc_sli.o
>> drivers/scsi/lpfc/lpfc_sli.c: In function 'lpfc_sli_poll_fcp_ring':
>> drivers/scsi/lpfc/lpfc_sli.c:1365: warning: array subscript is above array bounds
>> drivers/scsi/lpfc/lpfc_sli.c:1365: warning: array subscript is above array bounds
>> drivers/scsi/lpfc/lpfc_sli.c: In function 'lpfc_sli_handle_fast_ring_event':
>> drivers/scsi/lpfc/lpfc_sli.c:1541: warning: array subscript is above array bounds
>> drivers/scsi/lpfc/lpfc_sli.c:1541: warning: array subscript is above array bounds
> 
> As best I can tell this is a bogus warning ... it triggers on x86 as
> well, but I can't find any reason gcc should think there's an array
> bounds error.
> 
> James
> 
> 
> 
