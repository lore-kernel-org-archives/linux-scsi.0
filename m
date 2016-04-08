From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Cant write to max_sectors_kb on 4.5.0  SRP target
Date: Thu, 07 Apr 2016 23:00:16 -0400
Message-ID: <yq137qw6bzz.fsf@sermon.lab.mkp.net>
References: <302427900.27942894.1460063713447.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <302427900.27942894.1460063713447.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	(Laurence Oberman's message of "Thu, 7 Apr 2016 17:15:13 -0400 (EDT)")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Laurence" == Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

Laurence,

The target is reporting inconsistent values here:

> [root@srptest queue]# sg_inq --p 0xb0 /dev/sdb
> VPD INQUIRY: Block limits page (SBC)
>   Maximum compare and write length: 1 blocks
>   Optimal transfer length granularity: 256 blocks
>   Maximum transfer length: 256 blocks
>   Optimal transfer length: 768 blocks

OPTIMAL TRANSFER LENGTH GRANULARITY roughly translates to physical block
size or RAID chunk size. It's the smallest I/O unit that does not
require read-modify-write. It would typically be either 1 or 8 blocks
for a drive and maybe 64, 128 or 256 for a RAID5 array. io_min in
queue_limits.

OPTIMAL TRANSFER LENGTH indicates the stripe width and is a multiple of
OPTIMAL TRANSFER LENGTH GRANULARITY. io_opt in queue_limits.

MAXIMUM TRANSFER LENGTH indicates the biggest READ/WRITE command the
device can handle in a single command. In this case 256 blocks so that's
128K. max_dev_sectors in queue_limits.

>From SBC:

"A MAXIMUM TRANSFER LENGTH field set to a non-zero value indicates the
maximum transfer length in logical blocks that the device server accepts
for a single command shown in table 250. If a device server receives one
of these commands with a transfer size greater than this value, then the
device server shall terminate the command with CHECK CONDITION status
[...]"

So those reported values are off.

   logical block size <= physical block size <= OTLG <= OTL <= MTL

Or in terms of queue_limits:

   lbs <= pbs <= io_min <= io_opt <=
       min_not_zero(max_dev_sectors, max_hw_sectors, max_sectors)

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
