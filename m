From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Wed, 14 Jul 2004 11:59:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F55845.6040307@pobox.com>
References: <200407141216.i6ECGHxg008332@harpo.it.uu.se> <200407141757.48937.bzolnier@elka.pw.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:15524 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267423AbUGNP7O
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 11:59:14 -0400
In-Reply-To: <200407141757.48937.bzolnier@elka.pw.edu.pl>
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Cc: Mikael Pettersson <mikpe@csd.uu.se>, akpm@osdl.org, dgilbert@interlog.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> On Wednesday 14 of July 2004 14:16, Mikael Pettersson wrote:
> 
>>gcc-3.4.1 errors out in 2.6.8-rc1-mm1 at drivers/scsi/sg.c:
>>
>>drivers/scsi/sg.c: In function `sg_ioctl':
>>drivers/scsi/sg.c:209: sorry, unimplemented: inlining failed in call to
>>'sg_jif_to_ms': function body not available drivers/scsi/sg.c:930: sorry,
>>unimplemented: called from here
>>make[2]: *** [drivers/scsi/sg.o] Error 1
>>make[1]: *** [drivers/scsi] Error 2
>>make: *** [drivers] Error 2
>>
>>sg_jif_to_ms() is marked inline but used defore its function
>>body is available. Moving it nearer the top of sg.c (together
>>with sg_ms_to_jif() for consistency) fixes the problem.
> 
> 
> While your patch is perfectly fine I think we can do better.
> I think that we may try converting sg.c to use jiffies_to_msecs()
> and msecs_to_jiffies() from <linux/time.h>.


_Look_ at the patch.  It just moves code around for no reason.  Using 
static inline prototypes should work just fine.  This patch isn't needed.

	Jeff


