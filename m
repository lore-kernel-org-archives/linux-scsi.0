From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] kill obsolete typedefs and wrappers from tmscsim
Date: Fri, 25 Jun 2004 21:42:47 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0406252022400.3953@poirot.grange>
References: <20040624081510.GA7950@lst.de> <Pine.LNX.4.60.0406242247500.4258@poirot.grange>
 <20040625095022.GA28822@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:53697 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265537AbUFYTup (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2004 15:50:45 -0400
In-Reply-To: <20040625095022.GA28822@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 25 Jun 2004, Christoph Hellwig wrote:

> On Fri, Jun 25, 2004 at 12:44:56AM +0200, Guennadi Liakhovetski wrote:
>> Why don't we remove all UCHAR / USHORT / UINT / ULONG... types altogether?
>
> One thing at a time, the patch is already huge enough.

Well, I thought, it was inconsistent to leave UCHAR, removing PUCHAR, thus 
allowing
 	UCHAR c;
 	u8 *pc = &c;
and, since we are already at it...

>> PUCHAR == (UCHAR*), and you replace PUCHAR with (u8*), although it is not
>> obvious, that UCHAR == u8... I know, many scsi (at least) drivers use
>> them, and each of them defines them itself, but... As well as all those
>> PACB, PSRB, PDCB,...
>
> That'll happen sooner or later :)

So, why not now?:-)

>>> -    ptr = (PSCSI_INQDATA) (pcmd->request_buffer);
>>> -    if( pcmd->use_sg )
>>> -	ptr = (PSCSI_INQDATA) (page_address(((PSGL) ptr)->page) + ((PSGL)
>>> ptr)->offset);
>>> +    if (pcmd->use_sg) {
>>> +	    ptr2 = (struct scatterlist *) ptr;
>>> +	    ptr = (PSCSI_INQDATA) (page_address(ptr2->page) + ptr2->offset);
>>> +    } else
>>> +	    ptr = (PSCSI_INQDATA) (pcmd->request_buffer);
>>>
>>>    DEBUG0(printk (" SRBdone (%02x,%08x), SRB %p, pid %li\n", status,
>>>    pcmd->result,\
>>> 		pSRB, pcmd->pid));
>>
>> This seems a typo (ptr uninitialised).
>
> Indeed, thanks.  I wonder why gcc didn't spit a warning.

Mine did (3.3.2). Otherwise, how would I find it?:-)

>> Attaching a new, extended, and, hopefully, fixed version of your patch.
>> Please, have a look. I think, it is better to push all this cleanup as a
>> single patch, even though it looks horribly big... It compiles, will
>> run-test tomorrow (well, already today, but in about 20 hours).
>
> We hsould probably call the types dc390_acb and dc390_dcb instead of the
> shouting names?  Or maybe even better dc390_hba and dc390_lun so the
> names are descriptive?

Sure, that's easy!:-) I kept capitals initially, because all functions are 
called like FindDCB, DoingSRB_Done, etc. But if we rename dc390_dcb into 
dc390_lun, we would have to rename all respective functions, but that's 
a bit too much, I think. So, is it ok to just "smallify" the types, going 
the Middle Way?:-) If you don't object, I'll send tomorrow a new version 
of the patch with the only chenge: s/dc390_ACB/dc390_acb/g, 
s/dc390_DCB/dc390_dcb/g, s/dc390_SRB/dc390_srb/g.

Do you want to rediff your 3rd patch yourself or should I do it? 
Essentially, as you know, up to now the "old" EH code was used by tmscsim. 
Switching to the "new" one seems a pretty essential change. Is there a way 
I could test it a bit? I can now boot and run from IDE, loading tmscsim as 
a module, to which I have a disk and a CD-ROM connected. How can I 
exercise eh-paths a bit without destroying the hardware?:-)

Thanks
Guennadi
---
Guennadi Liakhovetski

