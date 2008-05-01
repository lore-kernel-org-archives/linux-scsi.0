From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/4] Use of new scsi_allocate_command
Date: Thu, 01 May 2008 21:14:21 +0300
Message-ID: <481A087D.10707@panasas.com>
References: <4819C9DB.60104@panasas.com>	 <1209651854.3067.8.camel@localhost.localdomain>	 <4819DA39.70505@panasas.com>	 <1209655360.3067.14.camel@localhost.localdomain>	 <4819E371.2040403@panasas.com>	 <1209656838.3067.16.camel@localhost.localdomain>	 <4819E8C7.3040808@panasas.com>	 <1209657731.3067.19.camel@localhost.localdomain>	 <4819EEEE.5030205@panasas.com>	 <1209659881.14864.4.camel@localhost.localdomain>	 <4819F894.6020009@panasas.com> <1209663229.14864.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1209663229.14864.18.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 01 2008 at 20:33 +0300, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Thu, 2008-05-01 at 20:06 +0300, Boaz Harrosh wrote:
>> On Thu, May 01 2008 at 19:38 +0300, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>> <snip> 
>>> Er, but
>>>
>>>      1. struct cmdinfo is stack allocated; you can't dma to stack
>>>      2. even if you fix this, the structure is packed and will have the
>>>         original ppc coherence issues
>>>      3. Finally, even on the stack, it's not necessarily reachable with
>>>         the DMA mask
>>>
>> Ho, thanks for the catch. I really goofed here.
>>
>>> The whole point of managing sense buffer allocations centrally is to
>>> prevent driver writers from falling into all these traps.  I really
>>> don't think going back to hand rolled bounce buffering imporves the
>>> situation.
>>>
>> We don't have a choice Andi is removing all this. ISA is becoming
>> ISA's driver private problem.
> 
> No he's not .. not if it's going to cause this type of grief.
> 
> But I think you misread his patch set.  He still has a flag equivalent
> of unchecked_isa_dma  it's just called sense_buffer_isa instead.  The
> shift in his patch set is 
> 
>      1. it removes the need to allocate commands in dma'able memory
>      2. it removes the need for the ULD request path to allocate in
>         dma'able memory (it uses the block bounce path instead)
>      3. it *can't* remove the need to dma to the sense buffer, hence the
>         flag.
> 
> So it looks like the re-rolled patch set (when Andi gets around to
> posting it) will use one pool for the cmd buffer, but separate isa and
> non-isa pools for the sense buffer.  Thus it should just work for gdth
> with scsi_allocate_command predicated on sense_buffer_isa.
> 
> James
> 

I know all about Andi's patches, since I offered to help him as I
have some experience with scsi drivers. And it will be me that will
post the next round of ISA patches.

I have the complete body of work here:
http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=shortlog;h=boaz_sense_effort

I planed to first submit up to the Remove-ISA-dma tag and only then RFC and try
to push the rest of the work.

In the new ISA patchset we got rid of the sense_buffer_isa and converted all ISA
drivers to take care of their own sense problems. Which is much more simple then
one might think. This is because of 2 reasons. 1 - because to support it in Andi's
new mask allocation scheme was an hack, and 2 because I wanted to get rid of them
anyway.

I apologize in advance for any grief the all effort might cause, and I try to take
it upon myself to do all the work, I will very much appreciate any review, thanks
for your help already.

Boaz

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
