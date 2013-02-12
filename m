From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi_debug: Fix endianess in partition table
Date: Tue, 12 Feb 2013 10:03:57 +0100
Message-ID: <1360659837.11990.9.camel@br8ggx07.de.ibm.com>
References: <1360604094.24863.1.camel@br8ggx07.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:43816 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab3BLJFh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2013 04:05:37 -0500
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mpeschke@linux.vnet.ibm.com>;
	Tue, 12 Feb 2013 02:05:36 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 658523E4003F
	for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2013 02:04:41 -0700 (MST)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r1C94lu4298062
	for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2013 02:04:47 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r1C940pv010861
	for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2013 02:04:00 -0700
Received: from [9.152.224.73] (dyn-9-152-224-73.boeblingen.de.ibm.com [9.152.224.73])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id r1C93wvf010500
	for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2013 02:03:58 -0700
In-Reply-To: <1360604094.24863.1.camel@br8ggx07.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2013-02-11 at 18:34 +0100, Martin Peschke wrote:
> Both start_sect and nr_sects in struct partition are __le32 and
> require cpu_to_le32() on assignment.

Steffen Maier has pointed me at:

block/partitions/msdos.c:	return
(sector_t)get_unaligned_le32(&p->start_sect);

Unfortunately, both get_unaligned_le32() and le32_to_cpu() appear to be
in use for start_sect and nr_sects.

Any one who would argue for changing my patch from cpu_to_le32 to
put_unaligned_le32()?

Thanks,
Martin



> 
> Without this fix tools like fdisk show an invalid partition table
> for SCSI devices emulated by scsi_debug on big-endian architectures,
> like s390x. Besides a kernel message like this was emitted:
> 
> sda: p1 start 536870912 is beyond EOD, enabling native capacity
> sda: p1 start 536870912 is beyond EOD, truncated
> 
> For verification 'xxd -l 512 /dev/sda' has been used to make sure
> that this fix makes scsi_debug generated partition tables on s390x
> look like the ones generated on my laptop.
> 
> Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
> Reviewed-by: Steffen Maier <maier@linux.vnet.ibm.com>
> 
> ---
>  drivers/scsi/scsi_debug.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -2662,8 +2662,8 @@ static void __init sdebug_build_parts(un
>  			       / sdebug_sectors_per;
>  		pp->end_sector = (end_sec % sdebug_sectors_per) + 1;
> 
> -		pp->start_sect = start_sec;
> -		pp->nr_sects = end_sec - start_sec + 1;
> +		pp->start_sect = cpu_to_le32(start_sec);
> +		pp->nr_sects = cpu_to_le32(end_sec - start_sec + 1);
>  		pp->sys_ind = 0x83;	/* plain Linux partition */
>  	}
>  }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


