From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: linux rdma 3.14 merge plans
Date: Wed, 22 Jan 2014 11:48:03 +0200
Message-ID: <52DF93D3.6030509@dev.mellanox.co.il>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com> <CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com> <52CD1C68.4050406@mellanox.com> <1389645171.5567.459.camel@haakon3.risingtidesystems.com> <1389820541.5567.543.camel@haakon3.risingtidesystems.com> <CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com> <1389906852.5567.668.camel@haakon3.risingtidesystems.com> <CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com> <1390102949.5567.749.camel@haakon3.risingtidesystems.com> <52DBB4F1.4020400@mellanox.com> <CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com> <CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com> <CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54401 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaAVJsI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2014 04:48:08 -0500
Received: by mail-wi0-f172.google.com with SMTP id ex4so5402836wid.11
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2014 01:48:06 -0800 (PST)
In-Reply-To: <CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Or Gerlitz <or.gerlitz@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hefty Sean <sean.hefty@intel.com>, linux-rdma <linux-rdma@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, target-devel <target-devel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, linux-scsi <linux-scsi@vger.kernel.org>, Oren Duer <oren@mellanox.com>

On 1/22/2014 2:43 AM, Roland Dreier wrote:
> On Tue, Jan 21, 2014 at 2:00 PM, Or Gerlitz <or.gerlitz@gmail.com> wr=
ote:
>> Roland, ping! the signature patches were posted > three months ago. =
We
>> deserve a response from the maintainer that goes beyond "I need to
>> think on that".
>>
>> Responsiveness was stated by Linus to be the #1 requirement from
>> kernel maintainers.

Hi Roland, I'll try to respond here.
removing LKML and adding Linux-scsi.

> Or, I'm not sure what response you're after from me.  Linus has also
> said that maintainers should say "no" a lot more
> (http://lwn.net/Articles/571995/) so maybe you want me to say, "No, I
> won't merge this patch set, since it adds a bunch of complexity to
> support a feature no one really cares about."

1. I disagree about no-one cares about DIF/DIX. We are witnessing growi=
ng
interests in this especially for RDMA.
2. We put a lot of efforts to avoid complexity here and plug-in as=20
simple as possible.
Application that will choose to use DIF will implement only 3 steps:
a. allocate signature enabled MR.
b. register signature enabled MR with DIF attributes (via post_send) an=
d=20
then do RDMA.
c. check MR status after transaction is completed (_lightweight_ verb=20
that can be called from interrupt context).

>    Is that it?  (And yes I
> am skeptical about this stuff =97 I work at an enterprise storage
> company and even here it's hard to find anyone who cares about
> DIF/DIX, especially offload features that stop it from being
> end-to-end)

1. RDMA verbs are _NOT_ stopping DIF from being end-to-end.
OS (or SCSI in our specific case) passes LLD 2 scatterlists: data=20
{block1, block2, block3,...}, and protection {DIF1, DIF2, DIF3}.
LLD is required to verify the data integrity (block guards) and to=20
interleave over the wire {block1, DIF1, block2, DIF2....}.
You must support that in HW, you rather iSER/SRP will use giant copy's=20
to interleave by itself? or in case OS asked LLD
to INSERT DIF iSER/SRP will compute CRC for each data-block? RDMA=20
storage ULPs are transports - they should have no business with
data processing.

2. HW DIF offload also gives you protection across the PCI. the=20
data-validation is done (hopefully offloaded) also
when data+protection are written to the back-end device. end-to-end is=20
preserved.

3. SAS & FC have T10-PI offload. This is just adding RDMA into the game=
=2E
With this set of verbs iSER, SRP, FCoE Initiators and targets will be a=
ble
to support T10-PI.

> I'm sure you're not expecting me to say, "Sure, I'll merge it without
> understanding the problem it's solving

Problem: T10-PI offload support for RDMA based initiators. Supporting=20
end-to-end data integrity
while sustaining high RDMA performance.

>   or how it's doing that,"

How it's doing that:
- We introduce a new type of memory region that posses protection=20
attributes suited for data integrity offload.
- We Introduce a new fast registration method that can bind all the=20
relevant info for verify/generate of protection information:
   * describe if/how to interleave data with protection.
   * describe what method of data integrity is used (DIF type X, CRC,=20
XOR...) and the seeds that HW should start calculation from.
   * describe how to verify the data.
- We Introduce a new lightweight check of the data-integrity status to=20
check if there were any integrity errors and get information on them.

Note: We made MR allocation routine generic enough to lay a framework t=
o=20
unite all MR allocation
methods (get_dma_mr, alloc_fast_reg_mr, reg_phys, reg_user_mr, fmrs, an=
d=20
probably more in the future...).
We defined ib_create_mr that can actually get mr_init_attr which can be=
=20
easily extended as opposed to the specific calls exists today.
So I would say this even reduces complexity.

Hope this helps,

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
