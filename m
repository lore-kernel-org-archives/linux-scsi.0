From: "jack wang" <jack_wang@usish.com>
Subject: Re: [PATCH Resend 2/3] pm8001:enhance IOMB process modules
Date: Thu, 5 Nov 2009 09:03:50 +0800
Message-ID: <909B326367A94F2AA36433626E3FCFE9@usish.com.cn>
References: <200910281755.n9SHtGrV004494@hera.kernel.org> , <200910302144471408205@usish.com>  <200910302152552653057@usish.com> <1257355960.10416.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:40595 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZKEBDu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 20:03:50 -0500
In-Reply-To: <1257355960.10416.5.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@suse.de>
Cc: 'linux-scsi' <linux-scsi@vger.kernel.org>

Just for future reference, git doesn't like patches in this format.
What it's expecting is the change log in the actual email and the patch
as an attachment.
[Jack] Sorry James
I will re-diff the patches and send them later today.
 
On Fri, 2009-10-30 at 21:53 +0800, jack_wang wrote:
> @@ -1342,34 +1360,43 @@ static u32 mpi_msg_consume(struct pm8001_hba_info
*pm8001_ha,
>                                         *pBC = (u8)((msgHeader_tmp >> 24)
&
>                                                 0x1f);
>                                         PM8001_IO_DBG(pm8001_ha,
> -
pm8001_printk("mpi_msg_consume"
> -                                               ": CI=%d PI=%d
msgHeader=%x\n",
> +                                               pm8001_printk(": CI=%d
PI=%d "
> +                                               "msgHeader=%x\n",
>                                                 circularQ->consumer_idx,
>                                                 circularQ->producer_index,
>                                                 msgHeader_tmp));
>                                         return MPI_IO_STATUS_SUCCESS;
>                                 } else {
> -                                       u32 producer_index;
> -                                       void *pi_virt =
circularQ->pi_virt;
> -                                       /* free the circular queue buffer
> -                                       elements associated with the
message*/
>                                         circularQ->consumer_idx =
>                                                 (circularQ->consumer_idx +
> -                                               ((msgHeader_tmp >> 24) &
0x1f))
> -                                               % 256;
> +                                               ((msgHeader_tmp >> 24) &
0x1f))
> +                                               % 256;
> +                                       msgHeader_tmp = 0;
> +                                       pm8001_write_32(msgHeader, 0, 0);
>                                         /* update the CI of outbound queue
*/
>                                         pm8001_cw32(pm8001_ha,
>                                                 circularQ->ci_pci_bar,
>                                                 circularQ->ci_offset,
>                                                 circularQ->consumer_idx);
> -                                       /* Update the producer index from
SPC */
> -                                       producer_index =
> -                                               pm8001_read_32(pi_virt);
> -                                       circularQ->producer_index =
> -
cpu_to_le32(producer_index);
> +
>                                 }
> -                       } else
> +                       } else {
> +                               circularQ->consumer_idx =
> +                                       (circularQ->consumer_idx +
> +                                       ((msgHeader_tmp >> 24) & 0x1f)) %
256;
> +                               msgHeader_tmp = 0;
> +                               pm8001_write_32(msgHeader, 0, 0);
> +                               /* update the CI of outbound queue */
> +                               pm8001_cw32(pm8001_ha,
circularQ->ci_pci_bar,
> +                                       circularQ->ci_offset,
> +                                       circularQ->consumer_idx);
>                                 return MPI_IO_STATUS_FAIL;
> +                       }
> +               } else {
> +                       u32 producer_index;
> +                       void *pi_virt = circularQ->pi_virt;
> +                       /* Update the producer index from SPC */
> +                       producer_index = pm8001_read_32(pi_virt);
> +                       circularQ->producer_index =
cpu_to_le32(producer_index);
>                 }
>         } while (circularQ->producer_index != circularQ->consumer_idx);
>         /* while we don't have any more not-yet-delivered message */

This hunk is refusing to apply:

patching file drivers/scsi/pm8001/pm8001_hwi.c
patch: **** malformed patch at line 164:        /* while we don't have
any more not-yet-delivered message */

The problem seems to be that the header promises there will be 43 lines
after patching and there are actually 44 ... did you edit this patch
after generating the diff?

James

[Jack] Yes ,sorry , I modify the patch directly because the checkpatch
error.
I will re-diff it .

