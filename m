From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: Add discard flag to blkdev_issue_zeroout() function
Date: Wed, 21 Jan 2015 10:42:19 -0700
Message-ID: <54BFE4FB.5090406@kernel.dk>
References: <1421802390-7380-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1421802390-7380-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/20/2015 06:06 PM, Martin K. Petersen wrote:
> blkdev_issue_discard() will zero a given block range. This is done by
> way of explicit writing, thus provisioning or allocating the blocks on
> disk.
>
> There are use cases where the desired behavior is to zero the blocks but
> unprovision them if possible. The blocks must deterministically contain
> zeroes when they are subsequently read back.
>
> This patch adds a flag to blkdev_issue_zeroout() that provides this
> variant. If the discard flag is set and a block device guarantees
> discard_zeroes_data we will use REQ_DISCARD to clear the block range. If
> the device does not support discard_zeroes_data or if the discard
> request fails we will fall back to first REQ_WRITE_SAME and then a
> regular REQ_WRITE.
>
> Also update the callers of blkdev_issue_zero() to reflect the new flag
> and make sb_issue_zeroout() prefer the discard approach.

Applied for 3.20, thanks.

-- 
Jens Axboe

