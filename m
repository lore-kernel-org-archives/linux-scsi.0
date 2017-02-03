From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [REGRESSION v4.10-rc1] blkdev_issue_zeroout() returns -EREMOTEIO
 on the first call for SCSI device that doesn't support WRITE SAME
Date: Fri, 3 Feb 2017 08:21:31 -0700
Message-ID: <d360a634-2c95-2de5-8647-4e740e92e10a@kernel.dk>
References: <cc14c28a-0f0a-640a-b576-cdfbaee75dc5@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cc14c28a-0f0a-640a-b576-cdfbaee75dc5@ce.jp.nec.com>
Sender: linux-block-owner@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>
List-Id: linux-scsi@vger.kernel.org

On 02/03/2017 12:55 AM, Junichi Nomura wrote:
> I found following ext4 error occurs on a certain storage since v4.10-rc1:
>   EXT4-fs (sdc1): Delayed block allocation failed for inode 12 at logical offset 100 with max blocks 2 with error 121
>   EXT4-fs (sdc1): This should not happen!! Data will be lost
> 
> Error 121 (EREMOTEIO) was returned from blkdev_issue_zeroout().
> That came from sd driver because WRITE SAME was sent to the device
> which didn't support it.
> 
> The problem was introduced by commit e73c23ff736e ("block: add async
> variant of blkdev_issue_zeroout"). Before the commit, blkdev_issue_zeroout
> fell back to normal zero writing when WRITE SAME failed and it seems
> sd driver's heuristics depends on that behaviour.

CC Christoph and Chaitanya.

-- 
Jens Axboe

