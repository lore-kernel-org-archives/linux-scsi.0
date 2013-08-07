From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: Why does lpfc select GENERIC_CSUM?
Date: Wed, 07 Aug 2013 15:25:19 -0700
Message-ID: <5202C94F.5070701@infradead.org>
References: <20130805202017.651b6cfd@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48664 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab3HGW0U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 18:26:20 -0400
In-Reply-To: <20130805202017.651b6cfd@kryten>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com, JBottomley@parallels.com

On 08/05/13 03:20, Anton Blanchard wrote:
> 
> Hi Randy,
> 
> commit 6a7252fd ([SCSI] lpfc: fix up Kconfig dependencies) added a
> select of GENERIC_CSUM. This seems strange to me - it's an architecture
> specific detail if the checksum routines are implemented in assembly or
> if they pull in lib/checksum.c.
> 
> The networking code doesn't select GENERIC_CSUM, so I'm not sure why
> the lpfc driver needs to. Was there a real issue we hit here?
> 
> Regards,
> Anton
> 

Hi Anton,

I reported:
"""
on i386:
# CONFIG_CRC_T10DIF is not set


drivers/built-in.o: In function `lpfc_bg_crc':
(.text+0x3cb3c9): undefined reference to `crc_t10dif'
"""

and then James Bottomley provided the patch.
I don't know why he added GENERIC_CSUM to it.

-- 
~Randy
