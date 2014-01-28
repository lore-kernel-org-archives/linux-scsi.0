From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux rdma 3.14 merge plans
Date: Tue, 28 Jan 2014 23:02:23 +0200
Message-ID: <CAJZOPZLBECYXrpp0GY0uUvyf+XbiLHhXdVukniPXD4AWZObymg@mail.gmail.com>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>
	<CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>
	<52CD1C68.4050406@mellanox.com>
	<1389645171.5567.459.camel@haakon3.risingtidesystems.com>
	<1389820541.5567.543.camel@haakon3.risingtidesystems.com>
	<CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>
	<1389906852.5567.668.camel@haakon3.risingtidesystems.com>
	<CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com>
	<1390102949.5567.749.camel@haakon3.risingtidesystems.com>
	<52DBB4F1.4020400@mellanox.com>
	<CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com>
	<CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com>
	<CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>
	<52DF93D3.6030509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52DF93D3.6030509-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 22, 2014, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 1/22/2014 2:43 AM, Roland Dreier wrote:
>> On Tue, Jan 21, 2014, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>>> Roland, ping! the signature patches were posted > three months ago. We
>>> deserve a response from the maintainer that goes beyond "I need to
>>> think on that". Responsiveness was stated by Linus to be the #1 requirement
>>> from kernel maintainers.

> Hi Roland, I'll try to respond here. removing LKML and adding Linux-scsi.

Sorry, it seems we will not getting responses unless coping LKML, so
lets do that again -- Roland, below is the detailed response Sagi
wrote you following your "adds a bunch of complexity to support a
feature no one really cares about" comment, can we get you to respond
on that?

>> Or, I'm not sure what response you're after from me.  Linus has also
>> said that maintainers should say "no" a lot more
>> (http://lwn.net/Articles/571995/) so maybe you want me to say, "No, I
>> won't merge this patch set, since it adds a bunch of complexity to
>> support a feature no one really cares about."

> 1. I disagree about no-one cares about DIF/DIX. We are witnessing growing
> interests in this especially for RDMA.
> 2. We put a lot of efforts to avoid complexity here and plug-in as simple as
> possible.
> Application that will choose to use DIF will implement only 3 steps:
> a. allocate signature enabled MR.
> b. register signature enabled MR with DIF attributes (via post_send) and
> then do RDMA.
> c. check MR status after transaction is completed (_lightweight_ verb that
> can be called from interrupt context).

>> Is that it?  (And yes I am skeptical about this stuff -- I work at an enterprise
>> storage company and even here it's hard to find anyone who cares about
>> DIF/DIX, especially offload features that stop it from being end-to-end)


> 1. RDMA verbs are _NOT_ stopping DIF from being end-to-end.
> OS (or SCSI in our specific case) passes LLD 2 scatterlists: data {block1,
> block2, block3,...}, and protection {DIF1, DIF2, DIF3}.
> LLD is required to verify the data integrity (block guards) and to
> interleave over the wire {block1, DIF1, block2, DIF2....}.
> You must support that in HW, you rather iSER/SRP will use giant copy's to
> interleave by itself? or in case OS asked LLD
> to INSERT DIF iSER/SRP will compute CRC for each data-block? RDMA storage
> ULPs are transports - they should have no business with
> data processing.

> 2. HW DIF offload also gives you protection across the PCI. the
> data-validation is done (hopefully offloaded) also
> when data+protection are written to the back-end device. end-to-end is
> preserved.

> 3. SAS & FC have T10-PI offload. This is just adding RDMA into the game.
> With this set of verbs iSER, SRP, FCoE Initiators and targets will be able
> to support T10-PI.


>> I'm sure you're not expecting me to say, "Sure, I'll merge it without
>> understanding the problem it's solving

> Problem: T10-PI offload support for RDMA based initiators. Supporting
> end-to-end data integrity while sustaining high RDMA performance.


>>   or how it's doing that,"

> How it's doing that:
> - We introduce a new type of memory region that posses protection attributes
> suited for data integrity offload.
> - We Introduce a new fast registration method that can bind all the relevant
> info for verify/generate of protection information:
>   * describe if/how to interleave data with protection.
>   * describe what method of data integrity is used (DIF type X, CRC, XOR...)
> and the seeds that HW should start calculation from.
>   * describe how to verify the data.
> - We Introduce a new lightweight check of the data-integrity status to check
> if there were any integrity errors and get information on them.

> Note: We made MR allocation routine generic enough to lay a framework to
> unite all MR allocation
> methods (get_dma_mr, alloc_fast_reg_mr, reg_phys, reg_user_mr, fmrs, and
> probably more in the future...).
> We defined ib_create_mr that can actually get mr_init_attr which can be
> easily extended as opposed to the specific calls exists today.
> So I would say this even reduces complexity.

> Hope this helps,
> Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
