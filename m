From: John David Anglin <dave.anglin@bell.net>
Subject: Re: [BUG] "block: make generic_make_request handle arbitrarily sized
 bios" breaks boot on parisc-linux
Date: Wed, 9 Mar 2016 10:15:54 -0500
Message-ID: <56E03E2A.5020208@bell.net>
References: <227C05EC-5A1C-4FAF-89D8-4A45AF600EC4@bell.net>
 <CACVXFVOnff1sFfMH+zsoypuYwM4PokJkHeKhbxJYDDH6ZtVScg@mail.gmail.com>
 <56CE2266.6010909@gmx.de> <FC3214D0-6247-449F-8372-14BC4D0C3887@bell.net>
 <CACVXFVM5nLDFGcoo173sK4E3TC4k7c+=Fvin0eAxStAdwx8yXA@mail.gmail.com>
 <1457528111.2693.4.camel@HansenPartnership.com>
 <CACVXFVN4pj2fTrP7Lzqkw4QJHESuMBOYvg+0LbwXErSAy0yP=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from simcoe207srvr.owm.bell.net ([184.150.200.207]:6322 "EHLO
	torfep01.bell.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932651AbcCIPP4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2016 10:15:56 -0500
In-Reply-To: <CACVXFVN4pj2fTrP7Lzqkw4QJHESuMBOYvg+0LbwXErSAy0yP=g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Helge Deller <deller@gmx.de>, linux-block@vger.kernel.org, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-parisc List <linux-parisc@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>

On 2016-03-09 9:43 AM, Ming Lei wrote:
>> We've provided all the information you asked for, what's the next step
>> >on this, or do we have to unwind the bio splitting code with reverts
>> >until it starts working?
> John, Helge, and I did discuss the problem for a while privately, and looks
> it is related with compiler.  Last time, I sent one patch which can make the
> issue disappear, but the main change is just invovled with the below:
>
>   struct bio_vec {
>       struct page    *bv_page;
> -    unsigned int    bv_len;
> +    unsigned int    bv_seg:8;
> +    unsigned int    bv_len:24;
>       unsigned int    bv_offset;
>   };
>
> Maybe John and Helge have some update recently?
>
> The logic in blk_bio_segment_split() is correct, and it does respect the max
> segment size limit.
Helge has found that tagging blk_bio_segment_split() with "__attribute__ 
((optimize("O0")))"
makes the issue disappear.  The bug remains if one just adds bv_len to 
the struct without the
bit fields.  Maybe problem is evident from following output which I sent 
to Ming and Helge
last weekend?

blk_rq_map_sg: merge bug: 3 2, extra_len 0, dma_drain 0
check_bvec: dump bvec for 000000007e4efdc0(f:24490000, t:1)
             0: 0 4096 246503 000000007e4a4f00(0, 94208, 1)
             1: 0 4096 246504 000000007e4a4f00(0, 94208, 1)
             2: 0 4096 246505 000000007e4a4f00(0, 94208, 1)
             3: 0 4096 246506 000000007e4a4f00(0, 94208, 1)
             4: 0 4096 246538 000000007e4a4f00(0, 94208, 2)
             5: 0 4096 246539 000000007e4a4f00(0, 94208, 2)
             6: 0 4096 246540 000000007e4a4f00(0, 94208, 2)
             7: 0 4096 246541 000000007e4a4f00(0, 94208, 2)
             8: 0 4096 246542 000000007e4a4f00(0, 94208, 2)
             9: 0 4096 246543 000000007e4a4f00(0, 94208, 2)
            10: 0 4096 246544 000000007e4a4f00(0, 94208, 2)
            11: 0 4096 246545 000000007e4a4f00(0, 94208, 2)
            12: 0 4096 246546 000000007e4a4f00(0, 94208, 2)
            13: 0 4096 246547 000000007e4a4f00(0, 94208, 2)
            14: 0 4096 246548 000000007e4a4f00(0, 94208, 2)
            15: 0 4096 246549 000000007e4a4f00(0, 94208, 2)
            16: 0 4096 246550 000000007e4a4f00(0, 94208, 2)
            17: 0 4096 246551 000000007e4a4f00(0, 94208, 2)
            18: 0 4096 246552 000000007e4a4f00(0, 94208, 2)
            19: 0 4096 246553 000000007e4a4f00(0, 94208, 2)
            20: 0 4096 246554 000000007e4a4f00(0, 94208, 2)
            21: 0 4096 246555 000000007e4a4f00(0, 94208, 2)
            22: 0 4096 246556 000000007e4a4f00(0, 94208, 2)
Kernel panic - not syncing: bad block merge

It seems segment 1 is too small and segment 2 too big?

The general plan is to disable inlining (maybe move 
blk_bio_segment_split() to a separate
function) to try to figure out what is miscompiled.

As you say, this is probably a GCC bug.  However, it's likely a 
middle-end or optimization
bug in the common GCC code.

Dave

-- 
John David Anglin  dave.anglin@bell.net

