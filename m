From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 3w-xxxx: additional ata->sense codes, avoid driver lockup
Date: Wed, 13 Nov 2002 17:24:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD2D110.C122D161@splentec.com>
References: <A1964EDB64C8094DA12D2271C04B812672C867@tabby>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@3WARE.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Adam Radford wrote:
> 
> Luben,
> 
> Thanks for submitting the patch, however, it appears part of it is wrong:
> 
> -               if ((command->status == 0xc7) || (command->status == 0xcb))
> {
> +               if (command->status & 0xC1) {
> 
> What makes you think you should not check for c7 or cb, and only check c1?

Hi Adam,

I don't really ``only'' check for 0xc1, it just shows which bits I'm
interested in (0xc1 is a mask anded with the status).

In fact, I'm only interested in the error bit (ERR), but saw what you did
and decided to stay as close to 0xc7 and 0xcb, both of whom are in the 
subset of status & 0xC1, (0xC1 == BSY|DRDY|ERR). So in effect 0xC7 and 0xCB
still match.

Anyway, if you are throwing away

	if (command->status & 0xC1)

then you might as well throw away flags 0x11 from tw_sense_table[]
and then we're back at ``square 1'' -- this is exactly when the
driver gets into an inf. loop and eventually locks up the machine
and the serial console prints ... 
3w-xxxx: scsiX: Command failed:	status = 0xc1, flags = 0x11, unit #Y.
... ad infinitum.

I was just trying to avoid this deadlock.

-- 
Luben
