From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain backward compatibility
Date: Thu, 10 Apr 2003 15:22:41 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200304101522.41236.pbadari@us.ibm.com>
References: <UTC200304102209.h3AM9pf11795.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <UTC200304102209.h3AM9pf11795.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 10 April 2003 03:09 pm, Andries.Brouwer@cwi.nl wrote:

>
> I try to make sure there are no assumptions about the
> size or structure of device numbers anywhere outside kdev_t.h.
> In particular I object to the use of KDEV_MINOR_BITS.
>
> Apart from this formal point, there is also the practical point:
> suppose 64 = 32+32 is used, so that KDEV_MINOR_BITS equals 32.
> Then LAST_MAJOR_DISKS is 2^28 and sd_index_bits[] would be 32 MB array.
> Unreasonable.

agreed !! (I mentioned this ealier in my previous postings - sd_index_bits[]
array size)

>
> The conclusion is that the easy way out is to define MAX_NR_DISKS.

Unfortunately, MAX_NR_DISK will be dependent on KDEV_MINOR_BITS.
We can't set MAX_NR_DISKS to arbitrary value and if there are not
enought MINOR bits, it won't work. Only way to make this work is
to do dynamic major allocation and update /dev/ entries for them.

> A different way out, especially when we use 32+32, is to kill this
> sd_index_bits[] array, and give each disk a new number: replace
> 	index = find_first_zero_bit(sd_index_bits, SD_DISKS);
> by
> 	index = next_index++;
>
I wish it is that simple. We use sd_index_bits[] since we could
sd_detach() and then sd_attach()  few disks. We will end up with
holes, name slippage without this. We need to know what disks are 
currently being in use.

Thanks,
Badari
