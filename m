From: "Badari Pulavarty" <badari@us.ibm.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Thu, 31 Oct 2002 09:57:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFEC523B9C.2F14772C-ON88256C63.00626B8B@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org



> Badari, I'm not so sure that Merlin's and your bug are the same. Is
> yours solved by the patch I sent out earlier? AFAICT, that should fix
> the segment miscounting.

Jens,

Yes. Your patch did fix my problem. But still I think BIOVEC_VIRT_MERGEABLE
() is not doing
the correct thing for x86. (It is returning FALSE for everything).

#define BIOVEC_VIRT_MERGEABLE(vec1, vec2)       \
        ((((bvec_to_phys((vec1)) + (vec1)->bv_len) | bvec_to_phys((vec2)))
& (BIO_VMERGE_BOUNDARY -1)) == 0)

I think BIO_VMERGE_BOUNDARY should be set to "1" instead of "0" for the
archs where this is not needed.
That will force it to return TRUE always.

And also, I was wondering for x86, where do we check to see if the
IO/segment crossing 4GB boundary.
(something similar to 2.4 BH_PHYS_4G()). Don't we need this for drivers
which  can't handle
IO crossing 4GB boundary ?

Thanks,
Badari



