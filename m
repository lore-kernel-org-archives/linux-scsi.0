From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 3w-xxxx: additional ata->sense codes, avoid driver lockup
Date: Wed, 13 Nov 2002 18:53:29 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3DD2E5F9.A5594DCB@splentec.com>
References: <A1964EDB64C8094DA12D2271C04B812672C86A@tabby>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Adam Radford <aradford@3WARE.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Adam Radford wrote:
> 
> While there may need to be a fix so you don't loop on status=c1,flags=0x11,
> you should know that:
>
> command_packet->status is not a scsi or ATA register value at all.
> 
> (0xC1 == BSY|DRDY|ERR).
> ^^^^^^^^^^^^^^^^^^^^^^^^ this is not true.

Really? Last time I checked the ATA spec, C1h comes
out to BSY=80h | DRDY=40h | ERR=1h.

I was *merely* trying to fix the loop on status=C1h, flags=11h.

By the use of flags (error register) and status's bits, I concluded
that while status is not *the* ATA status register, it's bits
are pretty close. For this reason I used the C1h *mask* to make
everyone happy.

Yes, I did assume that it is massaged by the controller,
but with a closed hardware spec and a bug, I had to start
somewhere.

-- 
Luben
