From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
Subject: Re: Potential overflow of sdkp->capacity
Date: Wed, 31 Aug 2011 15:16:18 +0200
Message-ID: <04bccde59efaeba8b87780c2a2df5742.squirrel@webmail.sf-mail.de>
References: <20110831105215.GR10237@login.drsnuggles.stderr.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:33438 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346Ab1HaNQY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2011 09:16:24 -0400
In-Reply-To: <20110831105215.GR10237@login.drsnuggles.stderr.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthijs Kooijman <matthijs@stdin.nl>, linux-scsi@vger.kernel.org

> (Please CC me, I'm not on the list)
>
> Hi folks,
>
> while tracing a problem in an old kernel version regarding a big (3TB)
> disk, I suspect I found a potential overflow of the sdkp->capacity
> variable when disks with > 512 byte sectors are involved and support for
> large block devices is turned off.
>
> I haven't tested this on recent krenel versions, but from looking at the
> code in 3.1-rc4, it seems the overflow is still present.
>
> In sd_read_capacity(), the capacity is read from the disk, in sectors.
> This is done by  read_capacity_16() or read_capacity_10. Both of these
> functions check sizeof(sdkp->capacity) to see if the capacity would fit:
>
> 1789         if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
> 1790                 sd_printk(KERN_ERR, sdkp, "Too big for this kernel.
> Use a "
> 1791                         "kernel compiled with support for large block
> "
> 1792                         "devices.\n");
> 1793                 sdkp->capacity = 0;
> 1794                 return -EOVERFLOW;
> 1795         }
>
> Now, at the end of sd_read_capacity, the sdkp->capacity variable is
> normalized to 512-byte sectors:
>
> 1926         /* Rescale capacity to 512-byte units */
> 1927         if (sector_size == 4096)
> 1928                 sdkp->capacity <<= 3;
> 1929         else if (sector_size == 2048)
> 1930                 sdkp->capacity <<= 2;
> 1931         else if (sector_size == 1024)
> 1932                 sdkp->capacity <<= 1;
> 1933         else if (sector_size == 256)
> 1934                 sdkp->capacity >>= 1;

What about just doing:

sdkp->capacity /= 2;
sdkp->capacity *= sector_size;

This would get us rid of all the branching. Or just do a cast to unsigned
long long and properly divide by the sector size so we would fix at least
one point where we assume sector size is an exponent of 2 (520 byte sector
disks, anyone?).

And afterwards one could easily check if the result would fit into 32 bits.

Eike
