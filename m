From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] Fix return code for ioctl( BLKRRPART ) if device
 is down
Date: Tue, 24 Mar 2015 11:34:47 +0100
Message-ID: <55113DC7.7080002@redhat.com>
References: <1427192175-23802-1-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427192175-23802-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 24/03/2015 11:16, Fam Zheng wrote:
> If issued right after link down, "blockdev --rereadpt" will be stuck for a
> while and then return normally. Although the underlying capacity and partition
> table are not correctly updated. And it means that userspace can't detect the
> error at all.
> 
> Fix this by propargating the error of "read capacity" command through the
> stack, so that the ioctl could fail with -EIO.
> 
> Fam Zheng (3):
>   block: Return error in rescan_partitions if revalidating disk failed
>   sd: Return error in sd_revalidate_disk if read capacity failed
>   sd: Return -EIO if read capacity failed
> 
>  block/partition-generic.c |  6 +++---
>  drivers/scsi/sd.c         | 22 +++++++++++++---------
>  2 files changed, 16 insertions(+), 12 deletions(-)
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Though patch 3 could be seen as a change in userspace ABI, so I'm less
sure about it.

Paolo
