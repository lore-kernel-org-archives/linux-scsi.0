From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain backward compatibility
Date: Thu, 10 Apr 2003 16:16:40 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200304101616.40617.pbadari@us.ibm.com>
References: <UTC200304102309.h3AN9EV07692.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <UTC200304102309.h3AN9EV07692.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 10 April 2003 04:09 pm, Andries.Brouwer@cwi.nl wrote:
>     > A different way out, especially when we use 32+32, is to kill this
>     > sd_index_bits[] array, and give each disk a new number: replace
>     > 	index = find_first_zero_bit(sd_index_bits, SD_DISKS);
>     > by
>     > 	index = next_index++;
>
>     I wish it is that simple. We use sd_index_bits[] since we could
>     sd_detach() and then sd_attach()  few disks. We will end up with
>     holes, name slippage without this. We need to know what disks are
>     currently being in use.
>
> It is that simple. (At least with 64-bit dev_t.)
> Look at the use of sd_index_bits[]. It is static in sd.c.
> There is the definition, the first free bit is found (and set)
> in sd_attach() to provide our disk with a number, this bit is
> cleared again in sd_detach().
>
> That is all. In other words, a mechanism to give an unused number
> to each disk for which sd_attach() is called.
>
> Now suppose we do nothing in sd_detach().
> Then we don't know which disks have disappeared. Pity.
> If the number space is infinite then
> 	index = next_index++;
> gives a new number each time we need one.

Yes !! I agree. I am not worried about running out them.
I am more worried about names slipping. I atleast hope
to see device names not changing by just doing
rmmod/insmod. 

Thanks,
Badari
