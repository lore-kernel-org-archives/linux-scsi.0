From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] Fix up scsi_test_unit_ready() to work correctly with
 CD-ROMs
Date: Fri, 10 Sep 2004 14:03:28 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41412790.70705@torque.net>
References: <1094738299.1837.2.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:45738 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S268000AbUIJEE2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2004 00:04:28 -0400
In-Reply-To: <1094738299.1837.2.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> Olaf Hering noticed that SG_IO was no-longer working correctly on some
> CD-ROMS.  The reason is a change in behaviour induced by switching to
> the new scsi_test_unit_ready() API.
> 
> Apparently the CD-ROM special case needs to ignore both UNIT_ATTENTION
> and NOT_READY for removable media.
> 
> James
> 
> ===== drivers/scsi/scsi_lib.c 1.133 vs edited =====
> --- 1.133/drivers/scsi/scsi_lib.c	Tue Sep  7 16:48:51 2004
> +++ edited/drivers/scsi/scsi_lib.c	Wed Sep  8 22:22:27 2004
> @@ -1585,11 +1585,12 @@
>  	if (!sreq)
>  		return -ENOMEM;
>  
> -		sreq->sr_data_direction = DMA_NONE;
> -        scsi_wait_req(sreq, cmd, NULL, 0, timeout, retries);
> +	sreq->sr_data_direction = DMA_NONE;
> +	scsi_wait_req(sreq, cmd, NULL, 0, timeout, retries);
>  
>  	if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) &&
> -	    (sreq->sr_sense_buffer[2] & 0x0f) == UNIT_ATTENTION &&
> +	    ((sreq->sr_sense_buffer[2] & 0x0f) == UNIT_ATTENTION ||
> +	     (sreq->sr_sense_buffer[2] & 0x0f) == NOT_READY) &&

James,
Is the "descriptor" sense data patch which Christoph and I
worked on likely to be accepted?

That way awkward and descriptor format unfriendly code like:
   sreq->sr_sense_buffer[2] & 0x0f) == UNIT_ATTENTION

could be replaced with something like (after a little overhead):
   sshd.sense_key == UNIT_ATTENTION

Doug Gilbert

