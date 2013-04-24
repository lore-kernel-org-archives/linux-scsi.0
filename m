From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/6] scsi_debug: fix logical block provisioning support
Date: Wed, 24 Apr 2013 19:39:52 -0400
Message-ID: <51786D48.3060709@interlog.com>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33092 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758563Ab3DXXkK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 19:40:10 -0400
In-Reply-To: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 13-04-16 09:11 AM, Akinobu Mita wrote:
> I tried testing the logical block provisioning support in scsi_debug,
> but it didn't work as I expected.
>
> For example, load scsi_debug module with UNMAP command supported
> and fill the storage with random data.
>
> 	# modprobe scsi_debug lbpu=1
> 	# dd if=/dev/urandom of=/dev/sdb
>
> Then, try to unmap LBA 0, but Get LBA status reports:
>
> 	# sg_unmap --lba=0 --num=1 /dev/sdb
> 	# sg_get_lba_status --lba=0 /dev/sdb
> 	descriptor LBA: 0x0000000000000000  blocks: 16384  mapped
>
> This is unexpected result.  Because UNMAP command to LBA 0 finished
> without any errors, but Get LBA status shows that LBA 0 is still mapped.
>
> I looked around the logical block provisioning support in scsi_debug,
> and I found several problems there.  This patch series tries to fix
> these problems and it is broken into small patches as much as possible
> for ease of review.
>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
>
> Akinobu Mita (6):
>    scsi_debug: call map_region() and unmap_region() only when needed
>    scsi_debug: prohibit scsi_debug_unmap_granularity ==
>      scsi_debug_unmap_alignment
>    scsi_debug: clear correct memory region when LBPRZ is enabled
>    scsi_debug: add translation functions between LBA and index of
>      provisioning map
>    scsi_debug: fix initialization of provisioning map
>    scsi_debug: fix logical block provisioning support
>

I'd like to see some feedback from Martin Petersen on this
set of patches. For my part, for this patch series (1/6
fo 6/6):

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

