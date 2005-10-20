From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Improve code for detecting errors near the end of a CD
Date: Thu, 20 Oct 2005 12:04:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0510201159470.5676-100000@iolanthe.rowland.org>
References: <4357076E.2000006@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:20614 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932203AbVJTQEG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 12:04:06 -0400
In-Reply-To: <4357076E.2000006@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 20 Oct 2005, Douglas Gilbert wrote:

> Alan,
> Ouch.
> Here is the linux kernel version (scsi_error.c):
> 
>     case 0x70:
>     case 0x71:
>         if (sense_buffer[0] & 0x80) {
>             *info_out = (sense_buffer[3] << 24) +
>                         (sense_buffer[4] << 16) +
>                         (sense_buffer[5] << 8) +
>                         sense_buffer[6];
>             return 1;
>         } else
>             return 0;
> 
> and here is the sg3_utils version (sg_lib.c):
> 
>     case 0x70:
>     case 0x71:
>         if (info_outp)
>             *info_outp = (sensep[3] << 24) + (sensep[4] << 16) +
>                          (sensep[5] << 8) + sensep[6];
>         return (sensep[0] & 0x80) ? 1 : 0;
> 
> The latter implementation takes account of MMC devices.
> So I probably need to send a patch.

I can see that the newer version always stores an information value.  Are 
you suggesting that sr.c should ignore the return value and try to use 
info whenever it is nonzero and within the appropriate range?  Or should 
the decision to use info when the return value is 0 be based somehow on 
other information about the device?

Alan Stern

