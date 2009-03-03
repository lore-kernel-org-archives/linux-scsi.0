From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH 1/11] mpt2sas: mpt2sas_base sources
Date: Tue, 3 Mar 2009 14:37:24 -0800
Message-ID: <da824cf30903031437o6ac68313uf6b6d222926d45a3@mail.gmail.com>
References: <da824cf30902241600g121d2acfw937020a750a79a57@mail.gmail.com>
	 <660360F4F2570145BD872F298951B17A7673CB09@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:18381 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbZCCWh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2009 17:37:29 -0500
Received: from zps37.corp.google.com (zps37.corp.google.com [172.25.146.37])
	by smtp-out.google.com with ESMTP id n23MbQda014791
	for <linux-scsi@vger.kernel.org>; Tue, 3 Mar 2009 14:37:27 -0800
Received: from yw-out-1718.google.com (ywm5.prod.google.com [10.192.13.5])
	by zps37.corp.google.com with ESMTP id n23MbOSh005458
	for <linux-scsi@vger.kernel.org>; Tue, 3 Mar 2009 14:37:25 -0800
Received: by yw-out-1718.google.com with SMTP id 5so1839369ywm.6
        for <linux-scsi@vger.kernel.org>; Tue, 03 Mar 2009 14:37:24 -0800 (PST)
In-Reply-To: <660360F4F2570145BD872F298951B17A7673CB09@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I think of the issues was clarified...a few more are still open
(below) but shouldn't
preclude inclusion in scsi-misc and continue the dialog around that cod=
e.


On Wed, Feb 25, 2009 at 12:27 PM, Moore, Eric <Eric.Moore@lsi.com> wrot=
e:
=2E..
[ re _base_display_reply_info() function ]
> Also, this particular function needs to be called all the time becuas=
e at the end of it we are printing out the loginfos returned by control=
ler firmware. =C2=A0The loginfos are needed as a way to be informed whe=
n =C2=A0problems resonating below the driver in controller firmware.

Ok. The frequency this gets called will dictate if it's a problem or
not. The design choice makes sense though.

Diagnostic logging is something linux still sucks at but is getting
better (dev_printk is a good step).

>
>
>> > +static void
>> > +_base_mask_interrupts(struct MPT2SAS_ADAPTER *ioc)
>> > +{
>> > + =C2=A0 =C2=A0 =C2=A0 u32 him_register;
>> > +
>> > + =C2=A0 =C2=A0 =C2=A0 ioc->mask_interrupts =3D 1;
>> > + =C2=A0 =C2=A0 =C2=A0 him_register =3D readl(&ioc->chip->HostInte=
rruptMask);
>> > + =C2=A0 =C2=A0 =C2=A0 him_register |=3D MPI2_HIM_DIM + MPI2_HIM_R=
IM +
>> MPI2_HIM_RESET_IRQ_MASK;
>> > + =C2=A0 =C2=A0 =C2=A0 writel(him_register, &ioc->chip->HostInterr=
uptMask);
>>
>> This is a posted write. Does it need to be flushed?
>> ie do other parts of the driver require this take effect immediately
>> or will they tolerate some late arriving interrupt?
>
>
> What are you suggesting? =C2=A0 Calling wmb()?

No. "Flushing" meant "readl()".


> I thought I was handling this case. =C2=A0 I'm setting the flag "ioc-=
>mask_interrupts". =C2=A0If there are any spurious interrupts that occu=
r following this calling this function, I will ignore them from the int=
errupt routine -> base_interrupt() where I have this sanity check.

No change required then. My preference would be to flush the writel in
base_mask_interrupts and avoid adding code to the interrupt routine.
But this will work too.

=2E..
>> > + =C2=A0 =C2=A0 =C2=A0 ioc->reply_post_host_index =3D post_index_n=
ext;
>> > + =C2=A0 =C2=A0 =C2=A0 writel(post_index_next, &ioc->chip->ReplyPo=
stHostIndex);
>> > + =C2=A0 =C2=A0 =C2=A0 wmb();
>>
>> What is the wmb() protecting here? Add a comment?
>>
>> My impression is the wmb() belongs in front of the writel()
>> and not behind it.
>> That is, we want to make sure the updates to ioc->reply_post_free[]
>> are visible before sending out the writel().
>>
>
> I'm doing is a 64bit write to pcie memory. On some systems this is br=
oken out to two 32bit writes. =C2=A0So I put the barrier there to insur=
e the entire 64bits was written out to the ReplyPostHostIndex register =
before another write was done.

Can you add a comment what the wmb() is protecting against?
The above explanation wasn't quite right and I still have the feeling
this wmb() is misplaced. FWIW, I expect this would only cause problems
on alpha/ia64 (machines which have weak memory ordering).


>> > +static int
>> > +_base_config_dma_addressing(struct MPT2SAS_ADAPTER *ioc,
=2E..
>> Interesting. I would have expected the dma_mask and
>> consistent_dma_mask  to not depend on each other.
>> ie set dma_mask to 64, if that fails, set dma_mask to 32-bit.
>> Rinse and repeat for consistent_dma_mask.
>
> I'm not clear what your point is. =C2=A0 My algorithm is to find out =
if the system has addressable memory above 32bit boundary, then set tha=
t mask for 64bit, else go for 32bit addressing.

Yeah, this ok. It's just a little more convoluted than other drivers
I've looked at in the past.

My preference would be the driver not try to optimize in this case
since the pci_set_dma_mask(DMA_64_MASK) could fail in the case where
32-BIT DMA mask would be sufficient. However, most drivers won't
change API because of this.

Again, this is an issue for future discussion and not something that
would block adoption of this driver.


=2E..
>> > +base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
=2E..
>> > + =C2=A0 =C2=A0 =C2=A0 /* get msix vector count */
>> > + =C2=A0 =C2=A0 =C2=A0 pci_read_config_word(ioc->pdev, base + 2, &=
message_control);
>> > + =C2=A0 =C2=A0 =C2=A0 ioc->msix_vector_count =3D (message_control=
 & 0x3FF) + 1;
>>
>>
>> Any comments on why the return value from pci_enable_msix()
>> isn't used here?
>
> I'm calling pci_enable_msix() from base_enable_msix(), and from that =
function I'm checking the return value. =C2=A0 I'm not clear what your =
point is.

My point is device drivers in general shouldn't need to frob MSI
config space. ioc->msix_vector_count should be set in the same
function that is calling pci_enable_msix(). But I haven't looked at
all of the code (including base_save_msix_table() mentioned below) and
will drop this part of the thread until I do.

>>
>> I wasn't expecting the drivers would need to read the MSIX
>> table directly.
>
> There is a bug in the hardware, where the msix table is cleared out d=
uring
> host reset. So the architects here at LSI decided to address this err=
ata by
> having all the device driver writters back and restore this table dur=
ing host reset.
>=C2=A0I made reference to this errata from the comments in base_save_m=
six_table().

Ah ok - I didn't see those (yet). Sounds good.

>
>> > +
>> > + =C2=A0 =C2=A0 =C2=A0 /* current HW implemention uses only one in=
terrupt
>> handler */
>>
>> Which implementation?
>> This comment sounds like it expects to be obsolete soon.
>> Specifying the implementation makes it clear even when other
>> implementations become available.
>>
>
> The explanation is currently we only map the first MSIX vector for al=
l interrupts

The "current implementation" has a name or revision. I'm just asking a =
specific
name or version be used instead of "current".

> =C2=A0 In future products we may have more expand to use more vectors=
, however
> that has not been decided upon yet. What I mean by more vectors is we=
 might
> map the 1st vector for initiator mode, and the 2nd for target mode, o=
r maybe in
> virtualization, each VF port is assigned its own handler.

Yup - reserving those for future use is fine. I think willy already poi=
nted out
if the driver knows only one is used, the driver should only allocate
one vector.

=2E..
>> MSI is never shared. IRQF_SHARED flag is still correct?
=2E..
> There are two drivers that currently implement MSIX in the scsi tree.=
 =C2=A0I found
> the emulex driver doing IRQF_SHARED, and qlogic is zero.

There are more in drivers/net:
grundler <2034>find -name \*.c | xargs fgrep -l pci_enable_msix |
xargs fgrep -l request_irq
=2E/bnx2.c
=2E/bnx2x_main.c
=2E/cxgb3/cxgb3_main.c
=2E/e1000e/netdev.c
=2E/enic/enic_main.c
=2E/forcedeth.c
=2E/igb/igb_main.c
=2E/ixgbe/ixgbe_main.c
=2E/myri10ge/myri10ge.c
=2E/netxen/netxen_nic_main.c
=2E/niu.c
=2E/qlge/qlge_main.c
=2E/s2io.c

But one has to manually check IRQF_SHARED usage. I don't know how to sc=
ript
something that verifies request_irq() is called in the MSI-X enabled ca=
se.



> Since we support shared interrupts, I set it up for that. =C2=A0I did=
n't know if it mattered, does it?

I don't think it's correct but I don't know if it matters either. I
doubt it does.
I was hoping someone else would "just know".

I hope that clarifies my concerns and apologies for not responding soon=
er.

thanks,
grant
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
