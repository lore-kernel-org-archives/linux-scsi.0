From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH] ata: do not hard code limit in ata_set_lba_range_entries()
Date: Tue, 23 Aug 2016 09:36:27 +0000
Message-ID: <CAGnHSE=Lsb-L-nd8OHQpVPDe1JkURjnXoA26ZQ7bH1GBEPAAtA@mail.gmail.com>
References: <e35afc461c9a79f568f2bcd4ef2cd1e07fb50082.1471890326.git.tom.ty89@gmail.com>
 <CAJ48U8UsFFD=fb6WQEVAam9-9RajVjLNrgiKmXCXvkCFOg2JnQ@mail.gmail.com>
 <CAGnHSE=Laj5kpFNJ-EqdN-NTUQJyOmwYtjWM7iLqGxDRqMSoxA@mail.gmail.com>
 <CAJVOszC2sp0=GA02ZB00s46F84XfU7DvzNSravyhbjxY651ozQ@mail.gmail.com>
 <CAGnHSEm18o-8ZRhyFnyQ22rUm+gJLWwJyxoA-iSJnkM3k4oHHQ@mail.gmail.com>
 <CAJ48U8XDb7S2WPSDBtn+VUoRb70u6SmgbPFhm-NC2jx6CmE2mw@mail.gmail.com>
 <CAGnHSEn470B0ecDdMSY29W4Or3jD_NPoUAku_09o=X9Tn6vSpw@mail.gmail.com> <CAJVOszB7cyUcE+A_EUw0OnvdO3iGFW9sG45R2Ng1Ea_Q7YxaQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36671 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbcHWJhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Aug 2016 05:37:22 -0400
In-Reply-To: <CAJVOszB7cyUcE+A_EUw0OnvdO3iGFW9sG45R2Ng1Ea_Q7YxaQA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, Tejun Heo <tj@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 23 August 2016 at 09:18, Shaun Tancheff <shaun.tancheff@seagate.com> wrote:
> On Tue, Aug 23, 2016 at 3:37 AM, Tom Yan <tom.ty89@gmail.com> wrote:
>> On 23 August 2016 at 07:30, Shaun Tancheff <shaun@tancheff.com> wrote:
>
>> If we really want/need to avoid hitting some real buffer limit (e.g.
>> maximum length of scatter/gather list?), then we should in some way
>> check n_block against that. If it is too large we then return
>> used_bytes = 0 (optionally with some follow-up to add a response to
>> such return value or so).
>
> Yes there is a real buffer limit, I can think of these two options:
> 1- Assume the setups from sd_setup_discard_cmnd() and/
>    or sd_setup_write_same_cmnd() are providing an sglist of
>    sdp->sector_size via scsi_init_io()

That sounds completely wrong. The scatter/gather list we are talking
about here has nothing to do with the SCSI or block layer anymore. The
SATL has _already_ parsed the SCSI Write Same (16) command and is
packing ranges/payload according to that in this stage. If there is
any limit it would probably the max_segment allowed by the host driver
(e.g. ahci).

It doesn't seem to make sense to me either that we would need to
prevent sglist overflow in such level. Doesn't that mean we would need
to do the same checking (specifically, as in hard coding checks in all
kinds of procedures) in every use of scatter/gather list? That doesn't
sound right at all.

>
> 2- Find (or write) a suitable sg_get_size(sgl, nents) to walk the
>     sglist and calculate the available buffer size.
>
> #2 sounds like more fun but I'm not sure it's what people would prefer to see.

No idea if such thing exists / makes sense at all.

>
> --
> Shaun
